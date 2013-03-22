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

I ended up making [this font](https://github.com/neilk/nkCherokee). Click the buttons to see the difference.

<form class="btn-group" id="sample-form" style="text-align: center;">
  <input type="radio" name="sample" value="traditional" id="traditional-sample" checked="checked" /><label class="btn" for="traditional-sample">Traditional</label><input type="radio" name="sample" value="new" id="new-sample" /><label class="btn" for="new-sample"> nkCherokee</label>
</form>
<p style="text-align: center;">
  <img id="sample" src="/projects/cherokee/traditional-sample.png">
</p>
<script type="text/javascript">
  function bindImgLoader(imgId, name) {
    var $img = $('#' + imgId);
    if ($img[0]) {
      var optionName = name + '-' + imgId;
      var img = new Image; img.src = '/projects/cherokee/' + optionName + '.png';
      $('#' + optionName).click( function() {
        $img.attr('src', img.src);
      });
    }
  }
  function makeImgToggle(imgId) {
    bindImgLoader(imgId, 'traditional');
    bindImgLoader(imgId, 'new');
  }
  makeImgToggle('sample');
</script>

Ironically, although I thought I was bringing new usability principles to the syllabary, I eventually
found out that I was bringing the script closer to what it was intended to be all along.  The original genius of the inventor
of Cherokee script was finally coming through after all these years - both preserved, and obscured, by technology.

<!-- more -->

I am not a scholar of Cherokee, but here's the story as I understand it, from what research I can do online and from the
few books on the topic. \[[1](#fn1)\] This is just the story of one amateur typographer, working in 2002 and 2003.

## The traditional Cherokee font

Cherokee is unique in that it's a script for a Native American language invented indigenously, by a person not literate
in any language. [Sequoyah](http://en.wikipedia.org/wiki/Sequoyah) had seen the "talking leaves" used by Westerners, and
determined to bring the innovation to Cherokee. After a decade experimentation he created a "syllabary" (one glyph 
per syllable) which worked well for the language. This intellectual achievement is unprecedented in history. I don't 
know what kind of a crazy genius you have to be to accomplish this, sometimes against the prejudice of your neighbors,
who are worried this is some kind of witchcraft. But Sequoyah was that kind of person.

The Cherokee rapidly adopted the syllabary, and it was soon brought to hot metal type. Cherokee newspapers 
were created, and Bibles printed.

<div style="text-align: center; margin-bottom: 1em;">
<figure style="display: inline-block;">
<img class="center" style="margin-bottom: 0px;" src="/projects/cherokee/john316.jpg" alt="John 3:16 in Cherokee" />
<figcaption style="text-align:center">John 3:16</figcaption>
</figure>
</div>

Although Cherokee syllabary is used to this day, the Bible is still the longest text that most Cherokee have ever encountered
which uses the script. So the syllabary acquired a religious dimension as well; one needed to learn this not just to be 
true to one's culture, but to get closer to God.

The syllabary was copied, apparently from the original cuts in the 1800s, into various media until it finally landed in 
digital form in the font shown at the beginning of this article.

When I encountered it in 2002, the digital font offered by the Cherokee nation was clearly a copy of a copy of a copy.
The serifs were mere blobs. Some glyphs were quite distorted. 

Worse still, some (apparently) inherent flaws of the script seemed almost insurmountable.

- Certain glyphs are nearly identical, such as <img class="noborder" src="/projects/cherokee/e.png" title="Cherokee E" alt="Cherokee E"/> 
  and <img class="noborder" src="/projects/cherokee/nv.png" title="Cherokee NV" alt="Cherokee NV"/>.
  This was particularly nasty, and was apparently a common stumbling block for
  those learning the language. Unfortunately this difficulty was rationalized, and even cherished, as part of the arduous 
  task of getting to understand the word of God.
- Many glyphs are distinguished only by having certain kinds of serifs or terminals. It would be as if an W in Bodoni and a W from 
  Garamond were in the same character set, meaning different things.

And aesthetically, there were other unfortunate aspects:

- The typographic color was very uneven. Some glyphs were blacker than black, and others had hairline strokes.
- There seemed to be no logic behind the forms. We are used to scripts having a certain look, to combining a certain set of ideas, but Cherokee 
  gathered its forms from absolutely everywhere. Some were identical to Latin typography, others seemed almost scribal, and still others were chimeras.

For traditional, book typography, we aim for a harmony of ideas, a minimum of ideas, evenness and balance in color. Getting there seemed like 
it was going to be difficult indeed.

## My strategy

I'm a believer in the collective genius of people to eventually work around whatever problems technology imposes on us. So I reasoned that *handwritten*
Cherokee might have sanded away all of the difficulties of the official font. I asked Sean and the other linguists working with him for 
samples of handwritten Cherokee, which they supplied. For certain rare glyphs, I would write them myself, over and over, until I felt the 
basic forms of the glyphs emerged.

I decided the basic template would be Microsoft's [Verdana](http://www.microsoft.com/typography/fonts/family.aspx?FID=1), since it was a common 
font and worked online as well as offline. Making it compatible with a web-ready font would ensure that the basic forms were very, very clear. 
Also, this would give end users more options, since if it worked with Verdana, it would harmonize well with other free fonts available at the 
time from Microsoft. In 2002, high quality, online-ready fonts were a rarity.
 
And there were a few other rules. My philosophy of type design is that it's a system for distinguishing glyphs. Thus, how we achieve differences 
between glyphs is as important as how we make them similar. My rules for this font were as follows.

- Glyphs could not be distinguished by:
  - variations in weight
  - presence or absence of stroke terminal
  - type of terminal (ball versus serif)
  - anything too subtle to see in a font at reduced size
- All such decoration would be removed, until the form could be written with a monoline pen. 
- If this resulted in glyphs that were too similar, subtle differences between glyphs would be exaggerated until they were obvious.
- Serifs, if they were required, would be exaggerated into a cross. Ball terminals would be eliminated entirely.

But it wasn't all about change:

- Each glyph should be instantly recognizable to someone already familiar with the traditional Cherokee font.
- If, given the examples from handwritten Cherokee, certain aspects of these glyphs seem to be important to preserve, then they are preserved. 

I created an "affinity" chart to track my progress. Glyphs which used the same basic forms were grouped together visually, and particularly
hard-to-distinguish glyphs were highlighted in red:

<form class="btn-group" id="affinity-form" style="text-align: center;">
  <input type="radio" name="affinity" value="traditional" id="traditional-affinity" checked="checked" /><label class="btn" for="traditional-affinity">Traditional</label><input type="radio" name="affinity" value="new" id="new-affinity" /><label class="btn" for="new-affinity"> nkCherokee</label>
</form>
<p style="text-align: center;">
  <img id="affinity" style="padding: 1em;" src="/projects/cherokee/traditional-affinity.png">
</p>

<script type="text/javascript">
  makeImgToggle('affinity');
</script>

I made one last change to the font, which wasn't necessitated by any of my rules. The glyph *YE* is the only one in the entire syllabary which requires 
a descender. This seemed to be snatching defeat from the jaws of victory, as this would necessitate extra space between lines, only for this relatively
rare syllable. Signage and many other applications would be easier if every word in Cherokee fit neatly into a rectangle. So I made my *YE* exaggerate 
the stroke to the left, to highlight where strokes intersected, but it had no descender.

## Restoring, by innovating

It might seem a little bit arrogant for me, a Canadian with mixed Indian and Celtic heritage, to be meddling with one of the great cultural 
achivements of a Native American people. One of the flaws in this process was that I wasn't working directly with end users, other than 
non-Cherokee linguists, and getting some indirect feedback from end users. Others since then have done much better 
by [directly involving Cherokee community leaders](http://blogs.msdn.com/b/michkap/archive/2012/12/19/10379263.aspx).

But, there was one advantage of my isolation. I think an excess of reverential piety had kept the script from properly 
evolving for decades. I think someone like Sequoyah would have been shocked that we hadn't improved on his work more.

And in this case, by meditating on these glyph forms for a few months, I might have found a way *back* to what Sequoyah originally intended. 

When this font was almost finished, I had a revelation. Cherokee Syllabary wants to be scribal. It doesn't want to be a roman. It wants to be more like an italic.

Look at the glyphs reminiscent of *S* - when lines cross through them, like ~~S~~, it's hard to read, even a bit brutal. But it becomes graceful when
that *S* shape is elongated and at an angle, like an integration sign, that is, *~~&#x222b; ~~*. Same thing with *WI*, which resembles an O with a stair-step 
line inside. Translated to an italic, that stair-step would be a gentle wave.

It made me want to rip up what I did and start over, but the project was near completion so I shelved the idea. 

And then I found out this was more or less what Sequoyah originally designed.

{% img center /projects/cherokee/sequoyah-scribal.jpg %}

The above is a sample of Sequoyah's original design for Cherokee letters. He was working on these for a decade, presumably with ink and paper, so he'd naturally
created very flowing forms. You can see there is definitely some influence of Latin glyphs, so there is a little bit of bricolage, but the design makes so much
more sense.

That difficult distinction between <img class="noborder" src="/projects/cherokee/e.png" title="Traditional Cherokee E" alt="Traditional Cherokee E"/> and <img class="noborder" src="/projects/cherokee/nv.png" title="Traditional Cherokee NV" alt="Traditional Cherokee NV"/> just isn't there. Instead the 
<img class="noborder" src="/projects/cherokee/e-sequoyah.png" title="Sequoyah's original NV" alt="Sequoyah's original E"/> and <img class="noborder" src="/projects/cherokee/nv-sequoyah.png" title="Sequoyah's original NV" alt="Sequoyah's original NV"/> are easily distinguished by an upwards-curved short tail versus a straight tail that reaches the baseline.

Which is exactly what I came to after sweating over that design for weeks, <img class="noborder" src="/projects/cherokee/e-nk.png" title="nkCherokee E" alt="nkCherokee E"/> versus 
<img class="noborder" src="/projects/cherokee/nv-nk.png" title="nkCherokee NV" alt="nkCherokee NV"/>. It's eerie. It's like the glyphs somehow encoded that information, latently. 

<div style="text-align: center; margin-bottom: 1em;">
<figure style="display: inline-block;">
<img class="center" style="margin-bottom: 0px;" src="/projects/cherokee/process.png" alt="Evolution of Cherokee glyph HI" />
<figcaption style="text-align:center">The evolution of Cherokee glyph <em>HI</em>. From left to right: Sequoyah's original design; as it was rendered in metal type; a handwritten sample from a Cherokee speaker; and the glyph in the nkCherokee font.</figcaption>
</figure>
</div>

So how did Cherokee end up with a font that was so far from the original designs of Cherokee? 

I've not been able to find out exactly what happened between Sequoyah and [Samuel Worcester](http://www.cherokee.org/AboutTheNation/History/Biographies/24485/Information.aspx), the person 
who ultimately arranged to cast the Cherokee letters in metal. But I imagine the scene -- faced with these unfamiliar glyphs, that will be difficult to typeset, either Sequoyah or Worcester go 
hunting for existing sorts, combining one here, shaving a bit off another. Eventually assembling the font that became the official look of printed
Cherokee for the next century.

I wonder if Sequoyah was dismayed by some of the problems, or if he was pragmatic, and just happy to see his designs coming off a printing press and embraced by
his people. I guess we'll never know.

It's a curious fate that heralds some of the problems with creativity in the 20th and 21st century. Nowadays, we encounter every work of creativity in a form suitable
for mechanical reproduction. One downside is that the artifacts of this process, the accidents and mistakes, become a nearly immutable part of the work. The creak of a
piano bench becomes part of a Beatles song, forever. In previous ages, a design, a story, or a song was reproduced from person to person, possibly for centuries, before 
it was fixed in a form that is no longer shaped by human hands.

So the Latin-speaking countries perfected the design of their alphabets over two millenia. Someone like Sequoyah has to get it right the first time. Or, if he wanted to change
it, he would have to undertake the expense of labor and materials. And then his new vision would have to compete with the existing, mechanically reproducible works, already making
copies of themselves in the environment. 

Perhaps with digital technology, and movements like [open source licenses](http://opensource.org/), 
and [Creative Commons](http://creativecommons.org/), the balance of power is shifting, and we'll always think of such works as fluid and alterable. Technology will then 
obscure who exactly who created things, make it difficult to compensate creators. But neither 
will it preserve mistakes fixed by one moment in time.

## Reaction

Sean liked my font, which was enough for me. 

The book \[[2](#fn2)\] was released in 2003. It's not easy to buy or download, but I think academics still use it.

An academic review mentioned it:

> The typeface chosen for the syllabary is an easy-to-read sans serif
> font, much more inviting than the commonly used intricate characters
> derived from nineteenth-century models. Neil Kandalgaonkar, credited
> with designing the font, has done an admirable job.\[[3](#fn3)\]


## Future directions

nkCherokee was a drop-in replacement for the old official Cherokee nation typeface, which simply substituted glyphs onto the standard American 
typewriter keyboard. Since then, we're in a more enlightened age, and proper Unicode encodings are more common. Some very well-designed fonts have
since been produced for Cherokee and are in more common use.

I still think that some of these projects are missing out by hewing too closely to the traditional Cherokee font. Here's an example of one,
Aboriginal Sans, in which some of the mistakes and infelicities introduced by printing technology are still preserved.

{% img center /projects/cherokee/abosans-vs-nk.png %}

And there's still a great opportunity for some enterprising typographer who wants to try crafting a more scribal font for Cherokee.


## Notes

<p><a name="fn1"></a>1. Bender, Margaret. (2002) <em>Signs of Cherokee Culture: Sequoyah's Syllabary in Eastern Cherokee Life.</em>, University of North Carolina Press, 2002. ISBN 978-0-8078-2707-9, ISBN 978-0-8078-5376-4. <a href="http://uncpress.unc.edu/browse/page/208">UNC Press link</a></p>

<p><a name="fn2"></a>2. A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl), Tahlequah, Oklahoma: Cherokee Heritage Center, 2003. 
Pp 252. ISBN 0974281808. Search for it on <a href="http://www.worldcat.org/search?q=isbn%3A0974281808">WorldCat</a></p>

<p><a name="fn3"></a>3. <a href="http://www.press.uchicago.edu/ucp/journals/journal/ijal.html">International Journal of American Linguistics</a> - Volume 72, Issue 2, April 2006, pp. 285-287; 
A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl). <a href="http://www.jstor.org/stable/10.1086/507168">JSTOR archive link</a></p>


## Other sites

The nkCherokee font is available for download (or modifications) at this [Github repository](https://github.com/neilk/nkCherokee).

Roy Boney's [Illustrated timeline of Cherokee Syllabary](http://web.archive.org/web/20110922010441/http://indiancountrytodaymedianetwork.com/2011/09/exclusive-artist-roy-boneys-special-graphic-feature-on-the-cherokee-language/) (Internet Archive link; original seems to be down)

Notes on the design of Microsoft's [Gadugi font](http://blogs.msdn.com/b/michkap/archive/2012/12/19/10379263.aspx), which followed a similar process but with far more feedback with Cherokee authorities.
