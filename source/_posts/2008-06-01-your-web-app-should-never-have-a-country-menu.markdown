---
layout: post
title: "Your web app should never have a 'country' menu"
date: 2008-06-01 00:00
comments: true
categories: internationalization i18n
---
<figure class="right" style="display: inline-block;">
  <a title="By Diego Guti&eacute;rrez, Hieronymus Cock, Library of Congress (hdl.loc.gov/loc.gmd/g3290.ct000342) / Jaybear (File:1562 Americ&aesc;¦ Guti&eacute;rrez.JPG) [Public domain or Public domain], via Wikimedia Commons" href="http://commons.wikimedia.org/wiki/File%3A1562_Americae-Gutierrez_02_01hrs-mid_Badge-with-Monster-Fish-and-Ships.jpg"><img width="281" style="width: 281px; height: 240px;" alt="1562 Americae-Gutierrez 02 01hrs-mid Badge-with-Monster-Fish-and-Ships" src="//upload.wikimedia.org/wikipedia/commons/thumb/c/cb/1562_Americae-Gutierrez_02_01hrs-mid_Badge-with-Monster-Fish-and-Ships.jpg/563px-1562_Americae-Gutierrez_02_01hrs-mid_Badge-with-Monster-Fish-and-Ships.jpg"/></a>
  <figcaption style="text-align: center">
    Here be dragons. (Image via <a title="By Diego Guti&eacute;rrez, Hieronymus Cock, Library of Congress (hdl.loc.gov/loc.gmd/g3290.ct000342) / Jaybear (File:1562 Americ&aesc;¦ Guti&eacute;rrez.JPG) [Public domain or Public domain], via Wikimedia Commons" href="http://commons.wikimedia.org/wiki/File%3A1562_Americae-Gutierrez_02_01hrs-mid_Badge-with-Monster-Fish-and-Ships.jpg">Wikimedia Commons</a>)
  </figcaption>
</figure>

Programmers might assume there is a simple list of all the countries in the world. There isn't.

For example, China and Taiwan don't recognize each other as legitimate
governments. If, for instance, your organization were to
publish a list of "countries" which doesn't include Taiwan, you may
one day see Taiwanese activists with megaphones at your gates. If
they publish a list of countries which does include Taiwan, then
China might do something crazy like ban you otherwise hamper
you from doing business in the PRC. This [really does happen](http://news.bbc.co.uk/2/hi/asia-pacific/4308678.stm) to tech
companies. 

And it's why you should never label an [ISO-3166](http://www.iso.org/iso/country_codes)-derived
dropdown as "Country:". First of all, it's wrong, because Puerto
Rico is not a country, and secondly you have all these sensitive
political issues. Instead use "Location:", or don't even label the
damn menu at all.

ISO 3166 is a very useful standard because it just says it's a list
of "countries and their subdivisions". Quite deliberately, it doesn't
say what is really a country and what is just a subdivision.

----
*A version of this was [posted](http://www.reddit.com/r/programming/comments/6loob/firefox_is_used_in_more_countries_than_exist/c047ffq) 
to Reddit's r/programming.*
