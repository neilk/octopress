---
layout: post
title: "Abigail's regex to test for prime numbers"
date: 2000-06-01 16:16
comments: true
categories: perl regex prime math
---
The prolific Perl hacker who goes by "Abigail" was famous for posting enigmatic but ingenious one-liner scripts in her signatures on newsgroups. 

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

This was mind-blowing, because regular expressions are tools for testing if strings of characters match a certain specification. How could they do math?

I couldn't rest until I figured it out. So, here's how it works - with some obscure features of Perl explained as we go.

<!-- more -->

## How it works

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

The logical negation of `=~`, will succeed if the regex does NOT match. Since we are looking for
primes, the regex will should match all NON-primes.

## The regular expression

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

## Example


To see how it works let's consider the case of N = 9. This generates a string like this (here padded with spaces for clarity):

<pre>
 1 1 1 1 1 1 1 1 1
</pre>

The only reason why Abigail generated a string of `1`s was to make the regular expression confusing, since it also makes use of `\1`.
It could just as easily have been `x`s or any other character.

Anyway, let's follow along with the regular expression matching engine. First, the `^` in the regex will match the start of the string. 

<pre>
/<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em">^</span>(11+?)\1+$/

<span style="padding: 0.25em; border-radius: 4px; background: #d0ddd0; margin: 0.125em;"></span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1 1 1</span> 
</pre>


`(11+?)` will match two ones at the start.

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span>\1+$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1 1</span>
</pre>

Next, `\1+` matches one or more strings identical to the first matched grouping, which in this case is `1 1`.

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span>$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="padding: 0.25em; margin: 0.125em">1</span>
</pre>

Oops, but the string doesn't end there! 

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="color: #ff0000; padding: 0.25em; margin:0.125em;">1</span> 
</pre>

We'll have to backtrack. This doesn't work...

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1</span><span style="padding: 0.25em; margin: 0.125em"><span style="color: #ff0000">1</span> 1 1</span>
</pre>

Okay, we have nothing left to backtrack to. How about that `11+?`, let's try matching three ones, and calling that `\1`:

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span>\1+$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="padding: 0.25em; margin: 0.125em">1 1 1 1 1 1</span> 
</pre>

And let's match as many of these new `\1` as we can:

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span>$/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span>
</pre>

The end of string is next -- this matched!

<pre>
/<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">^</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background:#dddad0">(11+?)</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">\1+</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0">$</span>/

<span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #dddad0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #eeeae0">1 1 1</span><span style="margin: 0.125em; padding: 0.25em; border-radius: 4px; background: #d0ddd0"></span>
</pre>

So, you can see how this process is analogous to trying to divide a number by successively larger divisors, leaving no remainder. In the case of a prime number, this is never going to succeed.

## Notes on efficiency

This regex is made much more efficient due to the inclusion of a single character: `?`.

If that were not included, the regex would immediately match the entire string at `(11+)`. The question mark makes the match minimal, so it will start by trying to "divide" the number by 2, then 3, etc. It will reject 32000 instantly, and take somewhat longer to determine that 32003 is prime. A good reminder that backtracking doesn't always reduce the size of a matched portion; with minimal matches it will backtrack and try matching more.

There is still some inefficiency here - there are useless attempts to match fewer multiples of `\1`. Since Abigail first posted this, Perl added a special regular expression grouping 
that disallowed backtracking, `(?>)`. Benchmarking shows it is slightly faster that way.

<p></p>
----
_A version of this was originally posted to the [Montreal.pm.org](Montreal Perl Mongers) mailing list._
