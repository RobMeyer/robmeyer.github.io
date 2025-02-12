+++ 
draft = false
date = 2025-02-03
title = "Rolling my own icon library"
description = "Shortcodes for richer Hugo markdown-to-html rendering"
slug = ""
authors = []
tags = ["Hugo", "CSS", "SVG", "Font Awesome", "Icons"]
categories = []
externalLink = ""
series = []
+++

# Rolled my own SVG Icons
I removed Font Awesome from this Hugo-generated site but still wanted to use ~6 svg icons. I had a couple options for how to implement a replacement and I'm still not sure this was the best, but for simplicity I landed on a CSS mask-image with inlined url encoded svgs.

## Considerations
| Option considered                                             | Pros/Cons                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Running Font Awesome's files through a font subsetting tool   | 👎 Font Awesome doesn't have all the icons I need (like Thingiverse's logo) so subsetting alone doesn't solve all my problems.{{< br >}}👎 I'd need to explore available tools with no guarantee that anything is easy enough and works well.{{< br >}}👎 Over the years I'll likely need to add/remove other icons and each time I'll need to remember how to set up my local environment, or worse, spend more time building out a proper tool with documentation. |
| Generate my own icon font from SVGs                           | 👍 Has the advantage that I can supply my own arbitrary SVG content{{< br >}}👎 Still has other problems mentioned above.                                                                                                                                                                                                                                                                                                                                           |
| Drop svgs in a static folder and reference them with img tags | 🙃 I mean, that would work fine if I didn't want to dabble around and waste time that would be better spent doing something useful.                                                                                                                                                                                                                                                                                                                                |
| Inline data:image URL-encoded svgs in CSS                     | 👍 CSS will be loaded once and cached across all pages.{{< br >}}👍 I can split svg data out to its own CSS file(s) or include in my global styles, depending on what performance characteristics I want to optimize (fewest network requests, most pay-for-play page size, each page is the smallest it can be, etc.)                                                                                                                                              |

## Show me the code!

```css
.icon {
    display: inline-block;
    width: 1.8rem;
    height: 1.8rem;
    mask: var(--icon-url);
    mask-size: contain;
    mask-repeat: no-repeat;
    background-color: var(--fg-color);
    transition: background-color .2s linear;

    a:hover & {
        background-color: var(--link-color);
    }

    @media only screen and (max-width: 768px) {
        width: 1.4rem;
        height: 1.4rem;
    }

    &.icon-rss {
        --icon-url: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 448 512'%3E%3Cpath d='M0 64c0-18 14-32 32-32 230 0 416 186 416 416a32 32 0 1 1-64 0C384 254 226 96 32 96 14 96 0 82 0 64m0 352a64 64 0 1 1 128 0 64 64 0 1 1-128 0m32-256c159 0 288 129 288 288a32 32 0 1 1-64 0c0-124-100-224-224-224a32 32 0 1 1 0-64'/%3E%3C/svg%3E");
    }

    /* add more icons as needed */
}
```

## Usage
```html
<span class="icon icon-rss" aria-hidden="true"></span>
```

## Result
{{< rawhtml >}}
<span class="icon icon-rss" aria-hidden=true"></span>
{{</ rawhtml >}}

{{< aside type="tip" title="But wait, there's more!" innertype="markdown" >}}
* Don't forget to run your SVGs through [SVGOMG](https://svgomg.robmeyer.net).
* Easily encode SVG for CSS with [URL-encoder for SVG](https://yoksel.github.io/url-encoder/)
{{< /aside >}}