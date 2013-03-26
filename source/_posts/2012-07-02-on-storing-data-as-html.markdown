---
layout: post
title: "On avoiding cross-site-scripting, by storing data as HTML"
date: 2012-07-02 00:00
comments: true
categories: security html xss
---
{% flickr_image 2226419650 m right %}

To avoid [cross-site scripting](http://en.wikipedia.org/wiki/Cross-site_scripting), developers are sometimes advised to 
encode all incoming data into HTML, upon reception. The idea is that 
as long as it's encoded into HTML right in your database, if you
make a mistake later and dump that data back to the client, the 
worst thing that can happen is that they see encoded HTML. They won't 
get data which contains script tags or other nefarious stuff.

While I see the logic, I find the idea of storing user data in HTML almost offensive. 

<!-- more -->

For your main website, it helps with certain very naive mistakes, the kind
that tend to crop up when you don't use a proper framework. But it
is a continual annoyance otherwise.

I have worked for a few large web companies; they had different
approaches.

**The purple company** mandated that data be encoded into HTML upon reception.
This was consistent with their general philosophy that frontend developers
were definitely not as good as their backend developers.

First of all, this just shifts the problem to data imports. Those
are easier to get right, but one can still miss encoding there, or
double-encode. But the main absurdity is that your database almost
certainly does not have a native HTML type for strings, so string
manipulation or simple grepping in the database gets very hard.

Secondly, HTML doesn't even work for the web environment, entirely.
What if you want to put this value into a JSON API response, or as
an HTML tag attribute? You end up with absurdities like
`encodeAsAttr(decodeFromHtml(data))` everywhere. This encourages a
tension - in HTML development you can be a lazy bastard and concatenate
data directly into a print statement, but any other kind of output
needs special treatment. I find it easier to keep one set of rules
in my head, and I suspect others are the same.

All of these problems are better than a security vulnerability, but
I still find it a depressing state of affairs, and I think it can
be done better.

**The rainbow company** had a different approach. They assumed that every developer
was very smart (and hired accordingly).

So they wrote frameworks which required more effort, but which were a lot smarter - you
were not allowed to print things to the client. You had to use a
strict [XML-based templating system](https://code.google.com/p/gxp/), which could be checked for
correctness, and then compiled to a servlet. It even knew to encode things differently based on
whether they were embedded in HTML, HTML tag attributes, JavaScript,
and so on. This usually freed the programmer from having to think
about the problem, and if you needed to do a non-standard kind of
output, it was the kind of thing that people would easily notice
in code review. I much preferred this and I think it's probably
close to the security offered by the encode-everything-as-HTML way.

This approach isn't flawless either because while you might be able
to tightly control your own web-facing system, other systems you
work with might not be so good. Maybe your forum software is different
from your main site. Maybe your payment processor has an XSS vuln
in someplace innocuous like the mailing address field. The
encode-everything-as-HTML pattern does help with that problem - the
worst case scenario is that your partner may try to send physical
mail to someone named \&Eacute;tienne.

-----
*A version of this was [posted](http://www.reddit.com/r/netsec/comments/vbrzg/etsy_has_been_one_of_the_best_companies_ive/c538iif?context=3) 
to Reddit's r/netsec.*
