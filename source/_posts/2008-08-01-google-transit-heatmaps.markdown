---
layout: post
title: Google Transit Heatmap
subtitle: Or, way-too-data-driven-decisions
date: 2008-08-01 23:52
comments: true
categories: google flickr datavis map heatmap googlemaps kml
---
I'm a public transit user. I was moving back to San Francisco to work
for Flickr. I've read research that says that a short commute has a
surprisingly large impact on happiness. So, I wondered, what are my
options?

![Heatmap of San Francisco, colored by transit time to Flickr offices](/images/downtown-transit.png)

<!-- more -->

As you can see, being near light rail or BART really has an impact!

Average waiting times not considered. Multiple transit hops not
considered. Number is the average of the three trips Google Transit API
suggests if one wants to arrive at the Flickr offices by 9am, Monday
18th August 2008.

Somehow I messed up getting the extreme northern bound. It doesn't look
like it would be much different from the cells below.

Data copyright everybody but me. This is a mashup of the Google Transit
API and Google Earth.


Here are the KML files, which can be imported into Google Earth: [Downtown](/images/downtownTransit.kml), [East Bay](/images/eastbayTransit.kml). They are inefficient and not very clever. Barely different from the example KML files.

(By the way, I originally tried importing this as KML into Google Maps, but it had an aneurysm trying to display 350 polygons on FF3.0. I spent some time trying to figure out how to coalesce nodes of the same color when I realized that Google Earth would probably handle it just fine as-is. I guess that browser platform vision is still a little ways off.)

## Results

My [boss-to-be](http://www.flickr.com/photos/george/382926276/) saw this and proclaimed that he'd just hired either the right guy or the really wrong guy. I got [laid off](http://gigaom.com/2009/04/29/flickr-hit-hard-by-yahoo-layoffs/) eight months later, so I guess that's settled.

This map did have an impact on where I eventually got an apartment. I hadn't even considered the Inner Richmond / Laurel Heights area, since none of my friends live there. But it's very close to green spaces and has express buses that dropped me off right in front of the Flickr offices. I eventually did get a place there, and haven't regretted the unhip neighborhood (much).

## Followups

By request: the East Bay. Click for higher resolution.

![Heatmap of San Francisco, Oakland, and Berkeley, colored by transit time to Flickr offices](/images/downtown-transit-eastbay.png)

