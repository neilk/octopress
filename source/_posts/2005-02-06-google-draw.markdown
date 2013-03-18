---
layout: post
title: "Google Draw"
date: 2005-02-06 00:00
comments: true
categories: map obsolete hack
---
<div class="alert">This code is ancient and does not work with current Google Maps. Historical interest only.</div> 

{% img center /projects/google-draw/linedraw-sample.png sample of line drawing on a Google Map %}

[Google Maps](http://maps.google.com/) has a very clever system to draw
lines onto its maps, such as when you want driving directions. Unlike
just about every other system, Google Maps does not draw the line
directly on the map itself. It gets your browser to do that, using
various tricks.

This means you can play a trick of your own: get Google to draw lines of
your choosing. Here's a perl script that demonstrates how:
[google-draw.pl](/projects/google-draw/google-draw-pl.txt).

<!-- more -->
## How Google Maps' path-drawing works

First Google calculates some path -- a series of (*x,y*) coordinates.

    (10,10),(30,30),(5,20),(10,10)

Then it turns that into a string of characters:

    SSg@g@p@RIR}oR

(Read [google-draw.pl](/projects/google-draw/google-draw-pl.txt) for the details.)

Then Google Maps sends this string to your browser along with all the
scripts that make the page so dynamic. Those scripts do different things
depending on whether you are running Internet Explorer or another
browser. When it's Internet Explorer, the line will be rendered right in
the browser, via a little-used vector graphics technology that's built
into IE, called [VML](http://www.w3.org/TR/1998/NOTE-VML-19980513).

There's no similar technology built into Firefox or other browsers. So
the scripts will instead request a transparent PNG from the server,
using a URL like this:

    http://www.google.com/maplinedraw?width=40&height=40&path=SSg@g@p@RIR}oR

For instance, here's a [a circle](http://www.google.com/maplinedraw?width=260&height=259&path=sNkH@G?I@I?IBI@IBI@GBIDGBIDGDGDGDGFEFGDEFEFEHCFEHCFCHAHCHAHAFAH?H?F?H?H?H@H@H@HBHBFBHBFBFDFDFDFDFDDFFFDFDFBFDFBHBFBH@HBH@F?H@H?H?F?H?HAHAHAHAHCHCFCHCFEFCHEFGFEDEFGDGDGDGDGDIBGBIBIBI@G@I@I@I?I?G?I?I?IAIAICIAGCICGCIEGCGEGEGEEGGGEEEGEGEICGCICGCICIAGAIAI?I?I}oR).
And a [12-pointed star](http://www.google.com/maplinedraw?width=220&height=220&path={EcLcBtJpGqGuJbBtJbBqGqGbBtJbBuJqGpGtJcBuJcBpGpGcBuJ}oR).

## Feedback

Initial reactions were mixed:

> *[Jamie Zawinski](http://www.jwz.org/blog/2005/02/how-google-maps-works/):*
> *I am experiencing a strange kind of cognitive dissonance here. One
> the one hand, that's really cool, and on the other, I can't think of a
> single thing to do with it. I mean, it's less useful than ringing the
> bell on a teletype. It's pulling my brain apart.*

At the time, I agreed -- but since then. the code's been used as a sort
of guide for others to do some pretty cool things. The obvious
application (which I totally missed at the time!) is to annotate your
own maps.

[Jon Udell](http://weblog.infoworld.com/udell/) used the code to do a
[walking tour](http://weblog.infoworld.com/udell/2005/02/25.html#a1185)
of his home town.

Adrian Holovaty used it to [draw ZIP code maps](http://www.holovaty.com/blog/archive/2005/05/31/0225) at
[chicagocrime.org](http://chicagocrime.org) -- for example, here's
[60614](http://www.chicagocrime.org/zipcodes/60614/).

## More info

-   The
    [GoogleMapsHackingWiki](http://69.90.152.144/collab/GoogleMapsHacking)
    wiki collects lore, at least in early 2005.
-   Joel Webber posted some dissections of Google Maps
    ([1](http://jgwebber.blogspot.com/2005/02/mapping-google.html),
    [2](http://jgwebber.blogspot.com/2005/04/more-maps.html))
-   Chris Smoak wrote a tool to [draw polygons](http://www.andrew.cmu.edu/user/csmoak/blueshape/draw.html)
    with mouse clicks. Using Google Maps as the renderer is inspiringly
    useless, but the code to draw the polygons has many applications.
    (Firefox only).

## Future

It's a rather neat hack to replace VML with a PNG. However, Firefox 1.1,
due out sometime soon, will also have vector graphics built-in, in a
more powerful and more standardized form --
[SVG](http://www.mozilla.org/projects/svg/). So things here may get
rather interesting.
