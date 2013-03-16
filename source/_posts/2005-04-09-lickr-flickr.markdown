---
layout: post
title: "Lickr: Flickr, without the Flash"
date: 2005-04-09 22:37
comments: true
categories: flickr javascript
---

[Flickr](http://flickr.com/) is a popular photo hosting service that uses embedded [Flash](http://www.macromedia.com/software/flash) files as part of their interface. On every page, there will be a little delay while a new Flash file loads.

_Lickr_ removes the need for Flash. It runs within the web browser Firefox, stripping the Flash before the user can even see it, and replacing it with an equivalent interface in pure HTML and Javascript.

{% flickr_set 72157633003368091 m nodesc %}

Lickr combines [Flickr](http://flickr.com/), [Greasemonkey](http://greasemonkey.mozdev.org/), and [Ajax](http://www.adaptivepath.com/publications/essays/archives/000385.php), and is worth triple points in buzzword bingo.

<!-- more -->

## How to install

Flickr is for Firefox only and requires that you have Greasemonkey
installed. Greasemonkey is an extension for Firefox that allows you
to modify pages with  "user scripts".

Obligatory warning: In principle, using Greasemonkey and Lickr could
harm your data. Please make sure you have backups of your photos.
Use this at your own risk. (I've been using various incarnations
of Lickr for about a month, and I have had no problems so far.)

1. Save [`lickr.user.js`](/images/lickr.user.js) to your computer.
2. Get [Firefox](http://www.mozilla.org/firefox/).
3. Install [Greasemonkey](http://greasemonkey.mozdev.org/) into Firefox.
4. Restart Firefox.
5. Open your saved copy of `lickr.user.js` in Firefox.
6. Select the menu item Tools : Install User Script.
7. Try viewing individual photo pages on Flickr, like [this one](http://flickr.com/photos/brevity/8869128/). The first time, you may see the Flash file load a bit before it gets replaced.  Look at different photos after that and it should work seamlessly.

Possible breakage in the future: Lickr depends on Flickr and
Greasemonkey staying more or less the same. However, both of them
are being actively developed.



## Why?

So what's wrong with Flickr's perfectly good Flash interface? Nothing. But maybe:

- ...you wish Flickr were a bit faster.
- ...you often use operating systems where Flash doesn't work, or doesn't work well.
- ...using Flickr beta isn't extreme enough for you. You want to run some amateur code, triggered by a brand new framework, in an alternative browser, that tries to modify an often-changing beta interface.


So, in March, I wrote a simple Greasemonkey user script to replace the Flash file with a simple HTML image. It kind of snowballed from there.

I originally thought I was just writing something for me and maybe five other people, but the response to Lickr has been tremendous. People mostly like it because it speeds things up, but I also get email from people who love it for reasons which surprise me. One guy likes to use his spell-checker, and he can't easily do that in a Flash interface.

Dear designers: if you could read my in-box, you'd see how overjoyed people are to get control back again. This experience has made me much less tolerant of balkanizing technologies like Flash.

The further I went, the more I asked myself, how far can the users push a website? How much can it be made to be a thing of almost mutual ownership? Here's a new feature I added in version 0.22.

{% flickr_image 10744176 z center %}

The thumbnail is a link to that photo's page. Other URLs in notes are also [turned into hyperlinks](http://flickr.com/photos/brevity/10826112/).

{% flickr_image 10826112 m center %}

I hope it will inspire some creative uses. Given all that we know about the web, any sort of linking ought to be a win... and this has a lot of visual appeal.

And, um, regular Flickr users? They can at least see the URLs, but unfortunately, they can't copy it into their browser bar. I guess they could _retype_ it.


## OMG Flickr should totally use this!

Slow down there, hypothetically overenthusiastic reader!

This is a hack that works in just one browser, Firefox. Developing cross-platform DHTML is _much_ more painful. Flash is attractive, especially for businesses, for a lot of reasons.

Anyway, if Flickr ever wanted to use this code, they can, since it's under the BSD license.

Lickr contains a simple Javascript Flickr API, which might be a good starting point for other browser-based projects.




## Techniques

Alert Flickr API geeks will notice that Lickr does two things with Flickr that aren't documented: using the API securely based on session ids, and deleting photos.

I simply observed the communication between the Flickr's Flash file and their website, and for the most part copied it. Some of Lickr's interactions with the website are actually more efficient than Flickr's.


## What next?

It's up to you! Which is a way of saying "Don't hold your breath waiting for updates."

I just started a new job, so we'll see how much time I have for fundamentally useless projects.

Greasemonkey is supposed to be a framework for little link re-writers, not entire applications. Lickr is getting rather hefty and should probably be its own Mozilla extension.


## Known Bugs

I know of no bugs that will corrupt your data.

Undesirable behaviours:

- A narrow image will "dance" a bit in size. The problem here is that I can't glean the width of an image narrower than the Flash toolbar. Rather than delaying insertion until we make a Flickr API call to get the width, I just let Firefox sort it out.
- The image will blink once when updating notes. I don't know why; it is not being modified.
- If a note is hanging over the right edge of a photo, it may appear to be underneath the navigation links for 'prev' and 'next' in the right column. Those navigation links are generated in an odd way. I haven't figured out a workaround.

Other interface quirks and differences from the Flickr Flash interface

- The toolbar is at the bottom, not the top. I just liked it better without stuff in between the title and the image.
- The toolbar does not use images. This is deliberate -- for various reasons, partially to do with security, convenience, and my desire not to contaminate the Flickr interface with elements designed elsewhere.
- You can only rotate 90 degrees clockwise. Rotating something 90 degrees counterclockwise takes three operations.
- There is no rotation preview.
- The notes don't have that slick "fading out" action. I tried emulating this with Mozilla's opacity, but it was slow and jerky.
- The interface is not locked down when updating elements. In principle it's all asynchronous, so you could change two things at once. In practice, this could bollix up the on-screen interface, although I've never seen this happen myself. If this ever happens, just reload the page.


## Updates

### May 13, 2005

Flickr has moved to a
[non-Flash interface](http://blog.flickr.com/flickrblog/2005/05/from_flash_to_a.html). 
That was Lickr's main purpose, so this project is
essentially obsolete. I may continue with other Flickr/Greasemonkey
hacks but they probably won't be called Lickr.

As far as I know, Lickr users will not have any problems - it will
just step aside and do nothing. (By design.) But you probably want
to disable or uninstall it from the _Tools: Manage User Scripts..._
menuitem.

As for the Lickr innovations like transforming links into photo
thumbnails and so on, read what Eric Costello of Flickr
[said](http://blog.flickr.com/flickrblog/2005/05/from_flash_to_a.html):

> (And we'll soon be adding some more cool auto-linking features
when the links point to Flickr pages.)

Sound familiar? I've been talking with Eric, and no, this isn't a
coincidence. I think they had ideas in this direction already, but
Lickr made it more concrete for them.

If this gets released, I think it will be the first instance of a
Greasemonkey customization being adopted by the original site.

### October 21, 2009

[People in Photos](http://blog.flickr.net/en/2009/10/21/people-in-photos/) 
has finally launched, thanks to fantastic efforts by the
whole Flickr team, particularly [Simon Batistoni](http://hitherto.net/) 
on the coding side. People in Photos is a very comprehensive
feature that is present in almost every aspect of Flickr now --
it's almost like a whole other dimension to the site. But Lickr
included the first crude attempt at something like that, way back
in 2005.


## Version history

(Also see the [Github repo](http://github.com/neilk/lickr).)

- **0.25** Add to Set toolbar link added.
- **0.24** 2005-04-30 buddyicon-in-notes feature much more efficient (and friendly to Flickr's bandwidth.)
- **0.23** 2005-04-27 note texts linger for a little while before disappearing. This is more forgiving when moving the pointer to click a link.
- **0.22** 2005-04-24 various bugs fixed, prettier notes, and Lickr-only photo-note + other linkifications.
- **0.21** 2005-04-16 fixed for case where Flash not detected.
- **0.2** 2005-04-09 initial release.


