---
layout: post
title: "Early Facebook users in order"
date: 2012-05-02 09:54
comments: true
categories: hack facebook
---
Facebook's API allows you to look up a user by their account number (id), with a very simple URL scheme. 

Usually Facebook IDs aren't well known so this is not a huge security issue. However, in the early days of Facebook, 
the ID was a simple auto-incrementing number. Famously, [Mark Zuckerberg's ID is 4](http://graph.facebook.com/4) - 
he made three test accounts which were later deleted, presumably.

This leads to a hack which fits in a [tweet](https://developers.facebook.com/docs/reference/api/user/):

``` sh
perl -le 'while(++$i){$_=`curl -s https://graph.facebook.com/$i `;print "$i ", $_=~/name":"([^""]+)/}'
```

<!-- more -->
You can try it yourself right away on Mac or Unix machines. (Windows machines probably won't have `perl` or `curl`.) 
You'll get something like this:

``` 
1 
2 
3 
4 Mark Zuckerberg
5 Chris Hughes
6 Dustin Moskovitz
7 Arie Hasit
8 
9 
10 Marcel Laverdet
11 Soleio
12 
13 Chris Putnam
...
```

And so on, for as long as you want. 

Some of those names are already recognizable as early Facebook employees who've gone on to other things.

You're only getting public information, so it's mostly harmless, and could be of interest
to researchers looking into the early history of the social network. 

Fun fact: Eduardo Saverin doesn't appear until #41.
