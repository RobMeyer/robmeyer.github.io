+++ 
draft = false
date = 2025-01-28
title = "CSS View Transitions"
description = ""
slug = ""
authors = []
tags = []
categories = []
externalLink = ""
series = []
+++

- [Overview](#overview)
- [Progressively customizable](#progressively-customizable)
  - [Quick opt-in for cross-fade](#quick-opt-in-for-cross-fade)
  - [Refine by connecting elements for continuity](#refine-by-connecting-elements-for-continuity)
  - [Customizing Transitions](#customizing-transitions)
    - [Background](#background)
    - [Common Recipes](#common-recipes)
      - [Fixing aspect ratio issues](#fixing-aspect-ratio-issues)
      - [Changing animation properties (duration, timing-function, etc.)](#changing-animation-properties-duration-timing-function-etc)
      - [Customizing transition when view-transition-pair only contains one child](#customizing-transition-when-view-transition-pair-only-contains-one-child)
- [Resources](#resources)

# Overview 
I've been playing around with [view-transitions](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API) and I'm smitten. There's just so much to love 😍
* Perfect example of a progressive enhancement
* Supported in both cross-document and same-document environments
* No JavaScript needed for cross-document (aka page navigation) animations
* Comes with great defaults, [progressively customizable](#progressively-customizable)
  * One-liner to [opt-in](#quick-opt-in-for-cross-fade) to the default (cross-fade) transition
  * Two-liner to [refine by connecting elements for continuity](#refine-by-connecting-elements-for-continuity)
  * [Tweak or fully customize](#customizing-transitions) the animation
* More awesomeness to come. View transitions are being actively developed. 
  * Safari and Firefox support are in the works. All the animations on this site worked great on Safari Technology Preview Release 212. No ETA from Firefox, but here's the [Bugzilla ticket](https://bugzilla.mozilla.org/show_bug.cgi?id=1823896).
  * No promises here, but [view-transitions-2](https://drafts.csswg.org/css-view-transitions-2/) may include scoped transitions (`element.startViewTransition` instead of `document.startViewTransition`), cross-origin transitions, naming snapshots, and more. 
  * Additionally, other CSS features such as advanced `attr` support can simplify setting `view-transition-name` in some cases.

## Support <!-- omit in toc -->
{{< baseline-status featureId="view-transitions" >}}

# Progressively customizable
View Transitions have what I like to think of as "progressively enhanced DX". In the same way that a proper progressive enhancement guarantees essential behavior [to the end-user] while providing the best possible experience as supported capabilities become available, the View Transition API can be incrementally adopted for more refined experience. The Developer Experience follows a gradual curve where you can put in as much or as little effort as required to refine the end result. The subsections below explore this continuum.

## Quick opt-in for cross-fade
To opt-in to the default cross-fade during page navigation, add the following to your CSS. This rule will have to be present in both the source and target pages for the browser to use it.
```
@view-transition {
	navigation: auto;
}
```

Here's what a simple cross-fade looks like:

{{< rawhtml >}}
<video style="width: 100%; max-width: 600px; max-height: min(600px, 100svh)" controls src="ViewTransitionCrossFade.mp4" type="video/mp4"></video>
{{< /rawhtml >}}

## Refine by connecting elements for continuity
When there's content common to two frequently navigated-between pages, you "connect" them by giving both elements the same `view-transition-name`.

The [`<custom-ident>`](https://developer.mozilla.org/en-US/docs/Web/CSS/custom-ident) CSS data type is an arbitrary user-defined string. For a singleton element such as a nav menu's current page indicator, you could use a name like `--active-nav-link`. However, items that are part of a collection, such as the titles of blog posts, need more uniqueness, e.g. `--post-title-5d23d49f4ba3acd8`.

{{< aside type="tip" title="URLs are Unique" >}}
If you don't already have a unique id readily accessible, using a URL is a good choice since it already uniquely identifies your navigatable-content.
{{< /aside >}}

{{< aside type="best-practice" title="Clearly user-defined" >}}
Prefix your &lt;custom-ident&gt; values with a double-hyphen to make it abundantly clear that the identifier is user-defined.
{{< /aside >}}

For example, this is great for navigation between an index and subpage. This could be a photographer's gallery, navigating between thumbnail and full views, an e-commerce site navigating between search results and an item page, or navigating the articles on a blog. Running with that last example, let's see some example code.

Article index page:
```
<ul class="list">
  <li>
    <span class="date">January 28, 2025</span>
    <a href="/posts/2" class="title" style="view-transition-name: --article-title-2">CSS View Transitions</a>
  </li>
  <li>
    <span class="date">January 24, 2025</span>
    <a href="/posts/1" class="title" style="view-transition-name: --article-title-1">Web Dev Reference</a>
  </li>
  <li>
    <span class="date">January 24, 2025</span>
    <a href="/posts/1" class="title" style="view-transition-name: --article-title-1">Coming soon, perhaps</a>
  </li>
</ul>
```

Article itself:
```
<h1 style="view-transition-name: --article-title-1">CSS View Transitions</h2>
```

And the result:

{{< rawhtml >}}
<video style="width: 100%; max-width: 600px; max-height: min(600px, 100svh)" controls src="ViewTransitionPostTitle.mp4" type="video/mp4"></video>
{{< /rawhtml >}}

Illustrating another example, to get the creative juices flowing: Site nav menu indicating the current page with an underline 

{{< rawhtml >}}
<video style="width: 100%; max-width: 600px; max-height: min(600px, 100svh)" controls src="ViewTransitionCurrentNavIndicator.mp4" type="video/mp4"></video>
{{< /rawhtml >}}

## Customizing Transitions
When the user agent provided default animation isn't too your liking, you can supply your own. This breaks down into a few categories. 

### Background
But first, it's helpful to solidify your mental model of what's happening behind the scenes. Head over to [Using the View Transition API (MDN)](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API/Using), download it into your brain, then come back here.

As you venture beyond the default user-agent transitions, it'll become important to know the structure of the view transition pseudo-element tree:
```
::view-transition
└─ ::view-transition-group(root)
  └─ ::view-transition-image-pair(root)
      ├─ ::view-transition-old(root)
      └─ ::view-transition-new(root)
```

And its helpful to know the default styling so you can reason about your changes. Here's a handy reference of those user-agent styles.
```
html::view-transition {
  position: fixed;
  inset: 0;
}

html::view-transition-group(*) {
  position: absolute;
  top: 0;
  left: 0;

  animation-duration: 0.25s;
  animation-fill-mode: both;
}

:root::view-transition-old(*),
:root::view-transition-new(*) {
  position: absolute;
  inset-block-start: 0;
  inline-size: 100%;
  block-size: auto;

  animation-duration: inherit;
  animation-fill-mode: inherit;
  animation-delay: inherit;
}

/* Keyframes for blending when there are 2 images */
@keyframes -ua-mix-blend-mode-plus-lighter {
  from {
    mix-blend-mode: plus-lighter;
  }
  to {
    mix-blend-mode: plus-lighter;
  }
}

@keyframes -ua-view-transition-fade-out {
  to {
    opacity: 0;
  }
}
```

Additionally, the browser dynamically generates and adds view transition styles to `::view-transition-old`. For the very curious reader (or one who's been hitting their head against the wall and needs to look behind the curtain), here the specification straight from the source: [Setup transition pseudo elements](https://drafts.csswg.org/css-view-transitions-1/#setup-transition-pseudo-elements) and [Update pseudo element styles](https://drafts.csswg.org/css-view-transitions-1/#update-pseudo-element-styles).

**TLDR;**
  * There's one ::view-transition-group for each unique view-transition-name (in either the old, new, or both snapshots).
  * The ::view-transition-pair may have 1 or 2 children.
  * By default (from the user-agent styles), each `::view-transition-old(<custom-ident>)` and `::view-transition-new(<custom-ident>)` are each set up with their own animations that run concurrently.

### Common Recipes

#### Fixing aspect ratio issues
As Jack Archibald covered in [View transitions: Handling aspect ratio changes](https://jakearchibald.com/2024/view-transitions-handling-aspect-ratio-changes/), when the aspect ratios don't match up, the default translate-and-scale transform animation produces visuals where you can clearly see both elements at the same time, not even close to matching up.

Continuing with Jack Archibald's example, here's a visual of the old and new snapshots overlaid so you can see what we're trying to animate.
{{< captioned-image 
src="HandlingDifferentAspectRatios-1.jpg"
alt="Document render with old 'Hello!' heading text in the top left with a red border depicting the bounding box and -new 'Hello!' regular text in the bottom right with a blue border."
caption="The element with a red border is the old heading text with block display, while the element with the blue border is -new inline text. Block display causes the old heading text's bounding rectangle to include excess space to the right of the text."
>}}

The first frame of the transition would look something like this: , the first frame of the transition would look something like the following (ignoring the fact that I'm forcing new's opacity to 1 so you can see it)
{{< captioned-image 
src="HandlingDifferentAspectRatios-2.jpg"
alt="Misaligned and different-scale text elements resulting in a a buggy sort of double-vision visual. The old element outlined in red is shown in its initial with unchanged position and scale, while the new element has been translated such that its top-left lines up with old's top-left, and it is scaled to fill old's bounding box, resulting in it being scaled to nearly twice the height of the old element."
caption="Due to differing aspect ratios, the new element needs to be scaled much larger in order to fill the old element's bounding box"
>}}

The fix is simple, set `width: fit-content` on the heading text to ensure its width is determined by the width of the text, not by the width of the line in the layout flow.
{{< captioned-image 
src="HandlingDifferentAspectRatios-3.jpg"
alt="Properly aligned old and new elements in first frame of transition"
caption="With the same aspect ratio, the scale-and-translate cross-fade animation will line up."
>}}

#### Changing animation properties (duration, timing-function, etc.)
Each `::view-transition-old(<custom-ident>)` and `::view-transition-new(<custom-ident>)` animate concurrently, but as we see from the user-agent styles above, the `animation-duration` and `animation-fill-mode` are set on the `::view-transition-group` and inherited by the -old and -new pseudo elements. In most cases, each should have the same duration, so you can apply your own duration to the group.

```
::view-transition-group(*) {
  animation-duration: .5s;
}
```

But, for some effects you may need more granularity of control. You can apply different styles (animation or otherwise) to each of the `::view-transition-old(<custom-ident>)` and `::view-transition-new(<custom-ident>)` pseudo elements. 

Here's an example where page navigation looks like a 3d card flip. 
* The `perspective` style needs to be set on the parent of the node with Y-rotation applied in order for it to look right. With our newfound understanding of the view-transition pseudo-element tree, we know that `::view-transition-image-pair(<custom-ident>)` is the right place.
* The -old and -new pseudo elements also need different `animation-name` values, because we want the old content to start in view and rotate out of view to the left, while the new content starts on the right side of the cube and rotates into view.
* The -old content needs to be top of the z-order to start, then switch to the bottom after 50%.

```
@view-transition {
    navigation: auto;
}

::view-transition-image-pair(--vt-content) {
    --duration: .7s;
    --timing-function: linear;
    --transform-origin: center center;
    perspective: 200vw;
}

::view-transition-old(--vt-content) {
    animation: var(--duration) card-flip-exit var(--timing-function);
    transform-origin: var(--transform-origin);
}

::view-transition-new(--vt-content) {
    animation: var(--duration) card-flip-enter var(--timing-function);
    transform-origin: var(--transform-origin);
}

@keyframes card-flip-exit {
    0% {
        transform: rotateY(0);
        z-index: 1;
    }

    50% {
        transform: rotateY(-90deg);
        z-index: 1;
    }

    51% {
        z-index: 0;
    }

    100% {
        transform: rotateY(-180deg);
    }
}

@keyframes card-flip-enter {
    0% {
        transform: rotateY(180deg);
    }

    100% {
        transform: rotateY(0deg);
    }
}
```

{{< rawhtml >}}
<video style="width: 100%; max-width: 600px; max-height: min(600px, 100svh)" controls src="ViewTransitionCardFlip.mp4" type="video/mp4"></video>
{{< /rawhtml >}}

#### Customizing transition when view-transition-pair only contains one child
`::view-transition-pair` is the parent of `::view-transition-new`, `::view-transition-old`, or both. In some cases, you may want completely different animations for each case.

By default, if a view-transition-name appears in both the old and new snapshot, it will cross-fade with a translate transform. If it appears in the old snapshot and not in the new snapshot, it will receive a fade-in animation. And conversely, if it appears in the -new snapshot and not the old snapshot, it will fade-out.

But what if you want to target a specific case to supply your own customizations? The view-transition-new/old selector can special-case for `only-child`. For example:

```
::view-transition-new()
```

# Resources
I've only put a few hours into playing with this (and most of that time was spent fiddling with and learning about Hugo), so allow me to point you to the experts. They've already done a better job covering this topic than I would.

* [Using the View Transition API (MDN)](https://developer.mozilla.org/en-US/docs/Web/API/View_Transition_API/Using)
* [View Transition API (Daniel Schulz)](https://iamschulz.com/view-transition-api/)
* [Smooth transitions with the View Transition API (Chrome Dev Team)](https://developer.chrome.com/docs/web-platform/view-transitions/)
* [View transitions: Handling aspect ratio changes (Jake Archibald)](https://jakearchibald.com/2024/view-transitions-handling-aspect-ratio-changes/) - This one is pure gold 💯. Walks through step-by-step how to achieve perfect alignment of view-transition-old and view-transition-new elements when the aspect ratios aren't the same. Working through the iterations gives a solid understanding of how view transitions work behind the scenes. 
* [CSS attr() gets an upgrade](https://www.bram.us/2025/01/20/css-attr-gets-an-upgrade/)
* [Easing Wizard](https://easingwizard.com/) - Good timing functions make all the difference. This tool makes it easy to tweak inputs, visualize the animation, and copy the CSS to clipboard.
