---
layout: post
title: "Abigail's regex to test for prime numbers"
date: 2000-06-01 16:16
comments: true
categories: perl regex prime math
---
The prolific Perl hacker [Abigail](http://abigail.be/) is famous for posting enigmatic but ingenious one-liner scripts in her signatures on newsgroups. 

Here's one that blew my mind, from [comp.lang.perl.misc](http://diswww.mit.edu/bloom-picayune.mit.edu/perl/10138):

``` sh 
perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' [number]
```

It does exactly what it says on the tin - it tests numbers to see if they are prime!

``` sh
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 18
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 19
Prime
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 20
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 21
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 22
$ perl -wle 'print "Prime" if (1 x shift) !~ /^1?$|^(11+?)\1+$/' 23
Prime
```

But regular expressions are tools for testing if strings of characters match a certain specification. How could they do math?

I couldn't rest until I figured it out. So, here's how it works - along with some obscure features of Perl, and the hidden true nature of regular expressions.

<!-- more -->

## How it works

I'll explain things as we go, but you should have a basic familiarity with Perl and regular expressions before we start.

First, let's unwrap the slightly convoluted Perl one-liner.

``` perl
STATEMENT if CONDITION
```

A quirk of Perl syntax; a statement may have 'modifiers' at the end like this. This is identical to `if CONDITION { STATEMENT }`. 
See [`man perlsyn`](http://perldoc.perl.org/perlsyn.html).

``` perl
shift
```

`shift` normally removes the first element of an array and returns that element, like
popping from the beginning. Since we are in file scope, shift without array is magically interpreted
to mean `shift @ARGV`, which means the number we fed in as an argument. 
See [`perldoc -tf shift`](http://perldoc.perl.org/functions/shift.html).

``` perl
1 x shift
```

`x` is the repetition operator. In this context, `1` is treated as a string `"1"`. If the number was
`9`, `"1" x 9` yields `"111111111"`. (see [`man perlop`](http://perldoc.perl.org/perlop.html), grep for 'repetition operator'.)

``` perl
!~
```

The logical negation of `=~`, will succeed if the regex does *not* match. Since we are looking for
primes, the regex will match all *non*-primes.

So, this one-liner is saying:

{% blockquote %}
Give us a number. We will then make a string that is all "1"s, as long as the number you gave us. 
Then we match that string against a complicated regular expression. 
If the expression doesn't match, print "Prime" to the console.
{% endblockquote %}

## The regular expression

Here's what the regular expression is saying:

``` perl
/
  ^1?$   # matches beginning, optional 1, ending.
         # thus matches the empty string and "1".
         # this matches the cases where N was 0 and 1
         # and since it matches, will not flag those as prime.
|   # or...
  ^                # match beginning of string
    (              # begin first stored group
     1             # match a one
      1+?          # then match one or more ones, minimally.
    )              # end storing first group
    \1+            # match the first group, repeated one or more times.
  $                # match end of string.
/x
```

To see how it works let's consider the case of N = 9. This generates a string like this (here padded with spaces for clarity):

<pre>
 1 1 1 1 1 1 1 1 1
</pre>

The only reason why Abigail generated a string of `1`s was to make the regular expression confusing, since it also makes use of `\1`.
It could just as easily have been `a`s or `b`s or any other character.

Anyway, let's follow along with the regular expression matching engine. 

The first big division in the regex occurs at the `|`. This means the regex matches if (everything before matches) or (everything after).

### First part 

So let's look at the first part. This just deals with the trivial cases, where the number was zero or one. 

First, the `^` in the regex will *anchor* the match to the start of the string. It can't match this anywhere in the middle.

<pre>
/<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span>1?$|^(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1 1 1</span> 
</pre>

The next part is `1?`, an optional one, so it actually can match nothing. 

<pre>
/<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">1?</span>$|^(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0"></span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1 1 1</span> 
</pre>

The next part of the regex is another anchor, `$`, which wants to match the end of the string. But our string doesn't end there, so it fails, here represented by red.

<pre>
/<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">1?</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>|^(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0"></span><span style="color: #ff0000; padding: 0.25em; margin:0.125em;">1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1 1</span> 
</pre>

Now what? Well, our regular expression has failed, so it looks back to see if there were any other possibilities that it hasn't tried yet. This is called *backtracking*. It
remembers that there was that optional one. What happens if it tries matching a real one?

<pre>
/<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">1?</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>|^(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">1</span><span style="color: #ff0000; padding: 0.25em; margin:0.125em;">1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1</span> 
</pre>

Nope, that didn't work out.

So, we see with the trivial first part, if the string had been just `""` or `"1"` it would have worked. And that corresponds to the case of *n = 0* or *n = 1*.

We've also seen how a regular expression engine works. If you give it a specification like `/match.*me/`, humans intuitively think about it as "match, then some other stuff, then me". But
regular expressions are actually descriptions of *state machines*. They are really a miniature programming language, which just happen to kind of *look* like the strings they 
match. But they really describe a program for consuming a string, piece by piece, looping over some bits, skipping over others, and even how to backtrack and try multiple options.

The second part of the regex exploits this "state machine" aspect of regular expressions, to make them do computation.

### Second part 

We start again by anchoring to the beginning of the string.

<pre>
/^1?$|<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span>(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1 1 1</span> 
</pre>


`(11+?)` will match two ones at the start. Because these are in parentheses, this is a *grouping*; the value of what they match is captured into the *backreference* `\1`. Note that in this case `\1` just means "the first thing in parentheses". It doesn't have to do with the literal `"1"`s in the string.

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span>\1+$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1</span>
</pre>

Next, `\1+` matches one or more strings identical to the first matched grouping, which in this case is `1 1`.

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span>$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="padding: 0.25em; margin: 0.125em">1</span>
</pre>

Oops, but the string doesn't end there! 

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="color: #ff0000; padding: 0.25em; margin:0.125em;">1</span> 
</pre>

We'll have to backtrack. This doesn't work...

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="padding: 0.25em; margin: 0.125em"><span style="color: #ff0000">1</span> 1 1</span>
</pre>

Okay, we have nothing left to backtrack to. How about that `11+?`, let's try matching three ones, and calling that `\1`:

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span>\1+$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1</span> 
</pre>

And let's match as many of these new `\1` as we can:

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span>$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span>
</pre>

The end of string is next -- this matched!

<pre>
/^1?$|<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span>
</pre>

So, you can see how this process is analogous to trying to divide a number by successively larger divisors, leaving no remainder. For *n = 9* it tried 2, and that failed, and then 3, which succeeded. But in the case of a prime number, this is never going to succeed.

## Epilogue

This regex is made much more efficient due to the inclusion of a single character: `?`.

If that were not included, the regex would immediately match the entire string at `(11+)`. The question mark makes the match minimal, so it will start by trying to "divide" the number by 2, then 3, etc. It will reject 32000 instantly, and take somewhat longer to determine that 32003 is prime. A good reminder that backtracking doesn't always reduce the size of a matched portion; with minimal matches it will backtrack and try matching more.

There is still some inefficiency here - there are useless attempts to match fewer multiples of `\1`. Since Abigail first posted this, Perl added a special regular expression grouping 
that disallowed backtracking, `(?>)`. Benchmarking shows it is slightly faster that way.

And even the dumbest prime-finding function shouldn't bother to check numbers greater than the square root of the length. There's no point in checking if 32003 can be divided by 25123. Nor should it check if the string is divisible by 4 when if we already know it isn't divisible by 2. So this is hardly a practical technique. 

But it's great because it illuminates the hidden "state machine" nature of regular expressions. Naive programmers often flounder when trying to debug regular expressions, but if you think of them as state machines, you can make them do exactly what you want.

<p><br/></p>
----
_A version of this was originally posted to the [Montreal.pm.org](Montreal Perl Mongers) mailing list._
