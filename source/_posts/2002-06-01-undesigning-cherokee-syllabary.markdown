---
layout: post
title: "Undesigning Cherokee Syllabary"
subtitle: Improving the usability of a Native American writing system
date: 2002-06-01 00:00
comments: true
categories: typography font cherokee design
---
My linguist friend [Sean M. Burke](http://interglacial.com/) goes around North America saving Native American languages from extinction, or at least,
documenting them before the native speakers pass . This month,
he was working 


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

- liberties taken
  - simplifying
  - eliminated the one descender in the syllabary

- feedback!!

![various versions of Cherokee: original writing by Sequoyah, traditional typeface, modern handwriting, and Uyanvhi](/projects/cherokee/process.png)

<form id="sample-form">
  <input type="radio" name="sample" value="traditional" id="traditional-sample" checked="checked" />
  <label for="traditional-sample">Traditional</label>
  <input type="radio" name="sample" value="new" id="new-sample" />
  <label for="new-sample"> New</label>
</form>
<img id="sample" src="/projects/cherokee/traditional-sample.png">


<form class="btn-group" id="affinity-form">
  <input type="radio" name="affinity" value="traditional" id="traditional-affinity" checked="checked" /><label class="btn" for="traditional-affinity">Traditional</label><input type="radio" name="affinity" value="new" id="new-affinity" /><label class="btn" for="new-affinity"> New</label>
</form>
<img id="affinity" style="padding: 1em;" src="/projects/cherokee/traditional-affinity.png">
<script type="text/javascript">
  function bindImgLoader(imgId, name) {
    var $img = $('#' + imgId);
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
  makeImgToggle('affinity');
  makeImgToggle('sample');
</script>

[![Traditional Cherokee syllabary organized by design affinity](/projects/cherokee/traditional-affinity-preview.png)](/projects/cherokee/traditional-affinity.png)

[![New Cherokee syllabary organized by design affinity](/projects/cherokee/new-affinity-preview.png)](/projects/cherokee/new-affinity.png)

![](/projects/cherokee/abosans-vs-nk.png)

## Reaction

A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl), Tahlequah, Oklahoma: CHerokee Heritage Center, 2003. Pp 252

> The typeface chosen for the syllabary is an easy-to-read sans serif
> font, much more inviting than the commonly used intricate characters
> derived from nineteenth-century models. Neil Kandalgaonkar, credited
> with designing the font, has done an admirable job.

-- International Journal of American Linguistics - 72(2):pp. 285-287; A Handbook of the Cherokee Verb: A Preliminary Study (Feeling, Kopris, Lachler, and van Tuyl)
