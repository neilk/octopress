---
layout: post
title: "Undesigning Cherokee syllabary"
subtitle: Restoring the usability of a Native American writing system
date: 2002-06-01 00:00
comments: true
categories: typography font cherokee design
---
My friend [Sean M. Burke](http://interglacial.com/) was complaining on IRC about how this font he was reading was hurting his eyes. 
As a linguist and programmer specializing in Native American languages, he was used to his share of unusual scripts, but he couldn't
abide this one. He had a point.

{% img center /projects/cherokee/cherokee-old.png %} 

Knowing that I was a bit of a typography geek, Sean asked if I could do anything to help. He was working on a book of Cherokee verbs, 
and was not looking forward to months of staring at the above font. 

I ended up making this font, which broke with more than a hundred years of Cherokee typographic tradition. Click the buttons to see the difference.

<form class="btn-group" id="sample-form" style="text-align: center;">
  <input type="radio" name="sample" value="traditional" id="traditional-sample" checked="checked" /><label class="btn" for="traditional-sample">Traditional</label><input type="radio" name="sample" value="new" id="new-sample" /><label class="btn" for="new-sample"> nkCherokee</label>
</form>
<p style="text-align: center;">
  <img id="sample" src="/projects/cherokee/traditional-sample.png">
</p>
<script type="text/javascript">
  function bindImgLoader(imgId, name) {
    var $img = $('#' + imgId);
    if ($img[0])
    var optionName = name + '-' + imgId;
    var src = '/projects/cherokee/' + optionName + '.png';
    $('#' + optionName).click( function() {
      $img.attr('src', src);
    });
  }
  function makeImgToggle(imgId) {
    bindImgLoader(imgId, 'traditional');
    bindImgLoader(imgId, 'new');
  }
  makeImgToggle('sample');
</script>

Ironically, although I thought I was bringing new usability principles to an outmoded technology, I eventually
found out that I was bringing the script closer to what it was intended to be all along. It wasn't that some
Western dudes were coming along and fixing a usability problem. It was that the original genius of the inventor
of Cherokee script was finally coming through after all these years - both preserved, and obscured, by technology.

<!-- more -->


## The traditional Cherokee font

I am not a scholar of Cherokee, but here's the story as I understand it, from what research I can do online and from the
few books on the topic. \[[1](#fn-1)\]

Cherokee is unique in that it's a script for a Native American language invented indigenously, by a person not literate
in any language. [Sequoyah](http://en.wikipedia.org/wiki/Sequoyah) had seen the "talking leaves" used by Westerners, and
determined to bring the innovation to Cherokee. After a decade experimentation he created a "syllabary" (one character 
per syllable) which worked well for the language, and soon afterwards it was brought to hot metal type. Cherokee newspapers
were created, and Bibles printed.

{% img center /projects/cherokee/john316.jpg John 3:16 in Cherokee %}
<p style="text-align:center">John 3:16</p>

Although Cherokee syllabary is used to this day, the Bible is still the longest text that most Cherokee have ever encountered
which uses the script. So the syllabary acquired a religious dimension as well; one needed to learn this not just to be 
true to one's culture, but to get closer to God.

The syllabary was copied, apparently from the original cuts in the 1800s, into various media until it finally landed in 
digital form in the font shown above.

Jumping back to 2002 - when I encountered it, the digital font offered by the Cherokee nation was clearly a copy of a copy of a copy.
The serifs were mere blobs. Some letters were quite distorted. 

Worse still, some (apparently) inherent flaws of the script seemed almost insurmountable.

- Certain characters are nearly identical, such as ![Cherokee E](/projects/cherokee/e.png) and ![Cherokee NV](/projects/cherokee/nv.png). 
  This was particularly nasty, and was apparently a common stumbling block for
  those learning the language. Unfortunately this difficulty was rationalized, and even cherished, as part of the arduous 
  task of getting to understand the word of God.
- Many characters are distinguished only by having certain kinds of serifs or terminals. It would be as if an W in Bodoni and a W from 
  Garamond were in the same character set, meaning different things.

And aesthetically, there were other unfortunate aspects:

- The typographic color was very uneven. Some letters were blacker than black, and others had hairline strokes.
- There seemed to be no logic behind the forms. We are used to scripts having a certain look, to combining a certain set of ideas, but Cherokee 
  gathered its forms from absolutely everywhere. Some were identical to Latin typography, others seemed almost scribal, and still others  
  were chimeras.

For traditional, book typography, we aim for a harmony of ideas, a minimum of ideas, evenness and balance in color. Getting there seemed like 
it was going to be difficult indeed.


- in medias res
- motivation

- what the problem is -- example of cherokee

- the result!
You can also follow the project [on Github](http://github.com/neilk/nkCherokee).

- WHY did this happen?

- interactive tool to flip between them

- the story

- my method -- look at how people actually use it, handwritten, relying on the genius of everyday people to "rationalize" the letters.
- mention the book 
- religious concerns

show the 4 examples

- verdana
- go back to Sequoyah -- what happened, he had cursive forms, rendered immediately into mechanical forms
[Sequoyah's original syllabary](http://www.intertribal.net/nat/cherokee/webpgcc1/original.htm)

[Illustrated timeline of Cherokee Syllabary](http://web.archive.org/web/20110922010441/http://indiancountrytodaymedianetwork.com/2011/09/exclusive-artist-roy-boneys-special-graphic-feature-on-the-cherokee-language/)


- liberties taken
  - simplifying
  - eliminated the one descender in the syllabary

- feedback!!

![various versions of Cherokee: original writing by Sequoyah, traditional typeface, modern handwriting, and Uyanvhi](/projects/cherokee/process.png)



<form class="btn-group" id="affinity-form" style="text-align: center;">
  <input type="radio" name="affinity" value="traditional" id="traditional-affinity" checked="checked" /><label class="btn" for="traditional-affinity">Traditional</label><input type="radio" name="affinity" value="new" id="new-affinity" /><label class="btn" for="new-affinity"> nkCherokee</label>
</form>
<p style="text-align: center;">
  <img id="affinity" style="padding: 1em;" src="/projects/cherokee/traditional-affinity.png">
</p>

<script type="text/javascript">
  makeImgToggle('affinity');
</script>

![](/projects/cherokee/abosans-vs-nk.png)

## Reaction

A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl), Tahlequah, Oklahoma: Cherokee Heritage Center, 2003. Pp 252

> The typeface chosen for the syllabary is an easy-to-read sans serif
> font, much more inviting than the commonly used intricate characters
> derived from nineteenth-century models. Neil Kandalgaonkar, credited
> with designing the font, has done an admirable job.

-- _[International Journal of American Linguistics](http://www.press.uchicago.edu/ucp/journals/journal/ijal.html)_ - Volume 72, Issue 2, April 2006, pp. 285-287; 
A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl). [JSTOR archive link](http://www.jstor.org/stable/10.1086/507168)


## Bibliography

<p><a name="#fn1">1.</a> Bender, Margaret. (2002) Signs of Cherokee Culture: Sequoyah's Syllabary in Eastern Cherokee Life.</a></p>
