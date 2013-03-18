---
layout: post
title: "Re: 'hacking' the anchor tag"
date: 2013-03-17 12:14
comments: true
categories: security javascript
---

{% flickr_image 4076036402 m right credit %}

A person going by "Bilaw.al Hameed" [sounded the alarm](http://bilaw.al/2013/03/17/hacking-the-a-tag-in-100-characters.html) over the possibility that the href of an anchor tag could be changed by
clicking on it. He felt this opened up a security hole and the feature should be disabled.

This is not a new trick. This is how Google's search results page works. 

Inspect the results for a [typical search](https://www.google.com/?q=test#hl=en&safe=off&output=search&sclient=psy-ab&q=test&oq=test); you'll see that they look like this:

    <a 
      href="http://en.wikipedia.org/wiki/Test_cricket"
      class="l"
      onmousedown="return rwt(this,'','','','2','AFQjCNGPXOKClui7vHgzV25lOsr4nAq50g','','0CDgQFjAB','','',event)">
        <em>Test</em> cricket - Wikipedia, the free encyclopedia
    </a>

The `rwt` there probably means _rewrite_, as in, rewrite the URL. Hold the mouse down on the element and watch it change to: 

    <a 
      href="/url?sa=t&amp;rct=j&amp;q=&amp;esrc=s&amp;source=web&amp;cd=2&amp;ved=0CDgQFjAB&amp;url=http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FTest_cricket&amp;ei=BBlGUZXbLdLSqAHKkoDQBQ&amp;usg=AFQjCNGPXOKClui7vHgzV25lOsr4nAq50g"
      class="l"
      onmousedown="return rwt(this,'','','','2','AFQjCNGPXOKClui7vHgzV25lOsr4nAq50g','','0CDgQFjAB','','',event)">
        <em>Test</em> cricket - Wikipedia, the free encyclopedia
    </a>

And that's why, when you hover, the link-preview appears to show you that you're going to `en.wikipedia.org`, but if you click you are actually going to a Google page which redirects you to what you wanted. They do this to track the effectiveness of their search results (with the side effect of learning what you clicked on).

If an attacker can inject JavaScript into your page you are basically doomed anyway. I don't think there's a reason to disable this feature, which also has some common uses like the above.

_A version of this was [posted](http://www.reddit.com/r/netsec/comments/1ah2gq/hacking_the_a_tag_in_100_characters_deviously/c8xcw4l) to Reddit's /r/netsec._
