---
layout: post
title: "letterpwn part I"
date: 2013-03-28 16:22
comments: true
categories: game nodejs hack
---

Letterpress is a word game for iOS. I wrote a solver for it in Node.JS. Depending how it is configured, it 
can search through about 100,000 possible moves per second. Without further ado, here is LetterPwn:






I didn't do this just to ruin Letterpress forever - mostly it was an experiment to teach myself Node.JS. I couldn't
decide if I loved this framework or hated it. It had so many virtues, but it has so many quirks - just making sure 
that things happen after one another in sequence requires that you pick a *framework*. And the fact that it 
depends on an IO event to serve the next request means that, curiously for a programming language, people advise 
you not to try... *computing*... in this computer language. 

So I decided to sail straight into the winds, and try to develop a computation-heavy service in Node, just to see
how bad it would be. It turned out to be very educational. I've split this into two parts. 

In this part, I'll discuss LetterPwn's approach to rapidly computing the best possible move for any given board.

In Part II, I'll discuss all the difficulties of making this service able to serve many users concurrently (especially given 
the limited options available with Node.JS combined with my $0.00 budget). My final solution shows an interesting 
possibility for scaling Node.JS where for certain applications you can simply move computation from the server to client as 
needed.


## The rules of Letterpress

Letterpress is addictive. It combines two different kinds of games in one. Given a 25-letter square board, players take 
turns discovering words. The letters of that word then change to the player's color (usually red versus blue). When the board 
is completely colored, the player with the most colored letters wins. 

The twist is that merely using a letter in a word doesn't capture it for all time. You need to completely surround it, or your 
opponent can steal it back. This changes it from a simple word-finding game to a territory-capturing game where your vocabulary
is just a tool to discover the right move to capture the most territory (while also ruining your opponent's plans).

## Rapidly discovering all the possible words on the board

This is such a simple problem it's often posed in software interviews. I didn't do anything all that special here. 

There is a dictionary file out there which purports to be the word list that Letterpress uses.

The trick relies on building a mapping of each word to the letters in that word, sorted in some canonical order. I used alphabetical:

    needle  -> deeeln
    needful -> deeflu
    needy   -> deeny

Then, we sort the board in the same way:

    hayst
    acken
    delqu    ->   aaaaccddeeehhkklnqssttuyy
    ehays
    tackd

Then it's a simple matter of finding all the characters in `deeln` in `aaaaccddeeehhkklnqssttuyy`. Using a canonical order it makes it easy because then you can 
just scan or skip over letters as they match:

``` js
    /**
     * Given two canonically sorted strings, determine if 2nd is subset of 1st
     * @param {String} iStr set to search
     * @param {String} jStr subset to find
     * @return {Boolean}
     */
    isSubset: function(iStr, jStr) {
      for (var i = 0,
               j = 0,
               iLength = iStr.length,
               jLength = jStr.length;
           i < iLength && j < jLength;
           i++ ) {
        var ic = iStr.substr(i, 1), jc = jStr.substr(j, 1);
        if (ic === jc) {
          j++;
        } else if (ic > jc) {
          break;
        }
      }
      return j == jLength;
    }
```

You might have noticed that this function isn't quite the classic way to solve this problem - for one, we're stuck in JavaScript, so 
while it would be nice, and hella fast, to do this with pointers, we have to use `substr` to obtain characters in a string. A `while` loop might be more
elegant, but it was slightly slower.

Also, this function would be more efficient at iterating through arrays, but the string representation was more convenient for other reasons (more on that
later).

Many Letterpress solver apps stop right here. They just give you the longest word that fits on the board. 

Do we stop there? Of course not. The longest word is rarely the most *strategic* word to play. To do that we're going to have to examine board state and 
all the possible ways to play words.

## Board state

Let's say the game looks like this: 


We need some way of representing that board state.

It's easy enough to represent the board, with just a 25-letter string:

And as for the colors? Let's look at just the blue squares for now.

We note that each square can either be colored or not. So we could say each square was on, or off. 

Which immediately suggests a binary number, to represent the entire board. 

Conveniently, we can now represent board state for a single color by a simple decimal number. 

And that's how LetterPwn currently stores and transmits board state, with these three values:

    board: msgzxcbjlqblmgeppjxmjynxs
    oursBitMask: 3310592
    theirsBitMask: 17180

Note that in this example, `oursBitMask` might seem much larger, but that just means that we've captured squares on the lower part of the board.

### Evaluating board state

I chose the bitmap representation just for its compactness but it turns out to be very valuable for computing various properties of board states.

A lot of Letterpress is about adjacency - enemy squares that sidle up to yours make you vulnerable. And you protect squares by surrounding them with your own

We could do this with some complicated `getAdjacent` function, but it turns out to be possible to do all the above with simple bitmap operations. 

The main trick here is to have an "adjacency map" of which squares are next to each other. For instance, to the right of square 0, we have square 1. And right
below square 0, we have square 5.

If we combine adjacent squares together:

    square 0 -> square 1 | square 5
    2**0 -> 2**1 | 2**5
    0 -> 2 | 32

Which in binary, would look like this. Since each square occupies its own bit, we can `bitwise-or` them together to get the combined positions.

    0000000000000000000000000 -> 0000000000000000000000001
                                 0000000000000000000100000
    
    0000000000000000000000000 -> 0000000000000000000100001

Converted back into decimal:
 
    0 -> 34

Now that we have a simple mapping of which squares are adjacent to which, we can easily calculate, for instance, which squares we've surrounded. 

    if (oursBitMask | 1) && (oursBitMask | 34) {
      // square 1 is a protected square
    }

I also made up a 'vulnerability' score, which is calculated like this:

``` js
function getVulnerability(bitMask) {                                                                                                                                                                   
  var vulnerability = 0;
  lpBitMask.adjacent.forEach(function(a) {
    if (a[0] & bitMask) {
      vulnerability += countBits(a[1] & ~bitMask);
    }
  });
  return vulnerability;
}
```

It's a bit complicated, but it's saying this: if a current square is used, then count up all the squares which are adjacent which we don't own. 
Add up this value for all squares. This is how "vulnerable" that position is. This is how LetterPwn knows how to avoid recommending moves which
just scatter all your letters all over the board; it will tend to recommend moves which result in compact, well protected positions. I didn't even
have to tell LetterPwn about the common strategy to grab a corner first; it does that naturally as a consequence of finding a less vulnerable position.

Bitwise operations are insanely fast, and as you can see it's easy to use them to make calculations about the entire state of the board, so this is 
a big reason why LetterPwn can rank moves so quickly.

## Determining all the ways to play words  
