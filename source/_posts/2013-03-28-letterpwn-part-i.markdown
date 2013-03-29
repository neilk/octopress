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


