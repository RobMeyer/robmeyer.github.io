+++ 
draft = false
date = 2025-02-02
title = "Hugo Shortcodes"
description = "Shortcodes for richer Hugo markdown-to-html rendering"
slug = ""
authors = []
tags = ["Hugo"]
categories = []
externalLink = ""
series = []
+++

- [aside shortcode](#aside-shortcode)
- [baseline-status shortcode](#baseline-status-shortcode)
- [captioned-image shortcode](#captioned-image-shortcode)
- [code shortcode](#code-shortcode)
- [br shortcode](#br-shortcode)
- [rawhtml shortcode](#rawhtml-shortcode)


Default markdown is fine for text and images, but for web frontend heavy articles, I'd like to have interactive code snippets and demos. It's also important to me that the site layout is responsive to small and large screens, offering the best experience int both. Hugo shortcodes are potentially a clean way to do this, as I can maintain the HTML and CSS for each custom-markdown feature separate from the content of blog posts.

So far, I'm using these shortcodes
* [aside](#aside-shortcode) - A visually emphasized block of text with an icon, header, and body text. Currently the three types of asides are "tip", "best-practice", and "none" (a sort of catch-all for any tangential thought I want to share, or use to break up large swaths of text.)
* [baseline-status](#baseline-status-shortcode) - A quick and easy way to embed [baseline-status](https://github.com/web-platform-dx/baseline-status).
* [captioned-image](#captioned-image-shortcode)
* [code](#code-shortcode) - At the moment I'm using this as a way to wrap a code block in HTML `<details>` and `<summary>` tags with some custom styling for animated expand/collapse. Eventually, I'd like a "copy to clipboard" button, custom JS to colorize hex color constants, optionally include a filename or language type in a header section, optionally show line numbers, tabs to toggle between the code and a demo/screenshot/video, support for multiple code file tabs (e.g. it's fairly common to share an example that has an HTML, CSS, and JavaScript file), and more.
* [br](#br-shortcode) - This one's pretty silly but it solved my problem in 30 seconds and I'm not looking back until it warrants more investigation.
* [rawhtml](#rawhtml-shortcode) - As an escape hatch, I can embed arbitrary html from markdown in the statically generated html. I try not to use this because it could quickly get out of hand with dozens of slightly-different variants of a given component that I have to maintain against years of posts.

## aside shortcode

### aside.html <!-- omit in toc -->
```twig
{{ if not (.Get "type") }}
{{ errorf "The %q shortcode requires a 'type' argument equal to one of 'none' | 'tip' | 'best-practice'. See %s" .Name
.Position }}
{{ end }}
{{ if not (.Get "title") }}
{{ errorf "The %q shortcode requires a 'title' argument. See %s" .Name .Position }}
{{ end }}
<aside data-type="{{ .Get "type" }}">
    <span class="header">
        <div class="icon" style="mask: url(/images/aside-{{ .Get "type" }}.svg)"></div>
        <h1>{{ .Get "title" }}</h1>
    </span>

    {{ if eq (.Get "innertype") "markdown" }}
    <div>{{ .Inner | markdownify }}</div>
    {{ else }}
    <div>{{ .Inner }}</div>
    {{ end }}
</aside>
```

### _shortcode-aside.scss <!-- omit in toc -->
```scss
.content {
    aside {
        --aside-bg: var(--aside-none-bg);
        --aside-border: var(--aside-none-border);
        --aside-icon-url: '/images/aside-none.svg';
        color: var(--aside-fg-color);
        background-color: var(--aside-bg);
        border-left: 3px solid var(--aside-border);
        padding: 2rem;
        margin: 1rem 0;

        .header {
            .icon {
                display: inline-block;
                background: var(--aside-fg-color);
                width: 2.4rem;
                height: 2.4rem;
                margin-bottom: -2px; // hack
            }

            h1 {
                color: var(--aside-fg-color);
                display: inline;
                font-size: 1.8rem;
                margin-block-start: 0;
                margin-block-end: 0;
            }
        }
    }

    aside[data-type="tip"] {
        --aside-bg: var(--aside-tip-bg);
        --aside-border: var(--aside-tip-border);
        --aside-icon-url: '/images/aside-tip.svg';
    }

    aside[data-type="best-practice"] {
        --aside-bg: var(--aside-best-practice-bg);
        --aside-border: var(--aside-best-practice-border);
        --aside-icon-url: '/images/aside-best-practice.svg';
    }
}
```

### Relevant color variables in _variables.scss <!-- omit in toc -->
```css
:root {
    // [...]
    --aside-fg-color: #212121;
    --aside-none-bg: #eaf0fb;
    --aside-none-border: #4134f5;
    --aside-best-practice-bg: #eef8f4;
    --aside-best-practice-border: #417f3e;
    --aside-tip-bg: #f8f8ee;
    --aside-tip-border: #fff700;
    // [...]

    @media only screen and (prefers-color-scheme: dark) {
        // [...]
        --aside-fg-color: #fff;
        --aside-none-bg: #243a64;
        --aside-none-border: #4134f5;
        --aside-tip-bg: #085335;
        --aside-tip-border: #417f3e;
        --aside-best-practice-bg: #484800;
        --aside-best-practice-border: #fff700;
        // [...]
    }
}
```

### Static files <!-- omit in toc -->
* [/images/aside-none.svg](/images/aside-none.svg)
* [/images/aside-tip.svg](/images/aside-tip.svg)
* [/images/side-best-practice.svg](/images/aside-best-practice.svg)

### Usage <!-- omit in toc -->
```twig
{{</* aside type="best-practice" title="Clearly user-defined" */>}}
Prefix your &lt;custom-ident&gt; values with a double-hyphen to make it abundantly clear that the identifier is user-defined.
{{</* /aside */>}}
```

### Result <!-- omit in toc -->
{{< aside type="best-practice" title="Clearly user-defined" >}}
Prefix your &lt;custom-ident&gt; values with a double-hyphen to make it abundantly clear that the identifier is user-defined.
{{</ aside >}}

## baseline-status shortcode

### baseline-status.html <!-- omit in toc -->
```twig
{{ if not (.Get "featureId") }}
{{ errorf "The %q shortcode requires a 'featureId' argument. See %s" .Name .Position }}
{{ end }}

<baseline-status featureId="{{ .Get "featureId" }}"></baseline-status>
```

### config.toml (perhaps unnecessary indirection) <!-- omit in toc -->
```toml
baselineStatusWebComponentScriptUrl = "script/baseline-status.min.js"
```

### themes/hugo-coder/layouts/_default <!-- omit in toc -->
```html
// at the end of <head>
<script src="{{ .Site.Params.baselineStatusWebComponentScriptUrl | relURL }}" type="module"></script>
```

### Static files <!-- omit in toc -->
* [baseline-status.min.js](/script/baseline-status.min.js)

### Usage <!-- omit in toc -->
```twig
{{</* baseline-status featureId="view-transitions" */>}}
```

{{< aside type="tip" title="Feature ID?" innertype="markdown" >}}
The list of supported featureIds is maintained in [web-features/features](https://github.com/web-platform-dx/web-features/tree/main/features)
{{</ aside >}}



### Result <!-- omit in toc -->
{{< baseline-status featureId="view-transitions" >}}

## captioned-image shortcode

### captioned-image.html <!-- omit in toc -->
```twig
{{ if not (.Get "src") }}
    {{ errorf "The %q shortcode requires a 'src' argument. See %s" .Name .Position }}
{{ end }}

{{ if not (.Get "alt") }}
    {{ errorf "The %q shortcode requires an 'alt' argument. See %s" .Name .Position }}
{{ end }}

{{ if not (.Get "caption") }}
    {{ errorf "The %q shortcode requires a 'caption' argument. See %s" .Name .Position }}
{{ end }}

<figure class="captioned-image">
    <img src="{{ .Get "src" }}" alt="{{ .Get "alt" }}" />
    <figcaption>
        {{ if eq (.Get "captionType") "markdown"}}
            {{ .Get "captionType" | markdownify }}
        {{ else }}
        <p>{{ .Get "caption" }}</p>
        {{ end }}
    </figcaption>
</figure>
```

### shortcode-captioned-image.scss <!-- omit in toc -->
```scss
.content {
    .captioned-image {
        display: inline-block;
        margin-left: auto;
        margin-right: auto;

        img {
            object-fit: contain;
            display: block;
        }

        figcaption {
            background: var(--alt-bg-color);
            padding: .5em;
        }
    }
}
```

### Usage <!-- omit in toc -->
```twig
{{</* captioned-image 
src="LaserCats.jpg"
alt="Meme of four kittens pouncing with lasers coming out of their eyes."
caption="Maybe a caption isn't really needed for these meme."
*/>}}
```

### Result <!-- omit in toc -->
{{< captioned-image 
  src="LaserCats.jpg"
  alt="Meme of four kittens pouncing with lasers coming out of their eyes."
  caption="Maybe a caption isn't really needed for these meme."
>}}

## code shortcode

### code.html <!-- omit in toc -->
```twig
{{ if not (.Get "summary") }}
{{ errorf "The %q shortcode requires a 'summary' argument. See %s" .Name .Position }}
{{ end }}

<details>
    <summary>{{ .Get "summary" }}</summary>
    <div class="code">
        {{ .Inner | markdownify }}
    </div>
</details>
```

### _shortcode-code.scss <!-- omit in toc -->
```scss
.content {
    .code {
        overflow-y: auto;
        max-height: 60vh;
    }
}
```

### Usage <!-- omit in toc -->
````twig
{{</* code summary="Expand to see Hello World" */>}}
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!";
    return 0;
}
```
{{</* /code */>}}
````

### Result <!-- omit in toc -->
{{< code summary="Expand to see Hello World" >}}
```cpp
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, World!";
    return 0;
}
```
{{< /code >}}

## br shortcode

I wanted to insert a newline in a markdown table cell but `<br>` was getting stripped. This shortcode quickly unblocked me. It probably isn't the best way to solve this issue, but works for me.

### br.html <!-- omit in toc -->
```twig
<br>
```

### Usage <!-- omit in toc -->
```twig
{{ < br >}}
```

### Result <!-- omit in toc -->
Okay, it's what you'd expect. Just trust me on this one.

## rawhtml shortcode

An escape-hatch for anytime you need to embed raw html into markdown. I strive not to use this as shortcode will be much more maintainable in the long run, but it can be useful for quickly experimenting.

### rawhtml.html <!-- omit in toc -->
```twig
{{ .Inner }}
```

### Usage <!-- omit in toc -->
```twig
{{</* rawhtml */>}}
    <a data-pin-do="embedBoard" data-pin-board-width="700" data-pin-scale-height="750" data-pin-scale-width="300" href="https://www.pinterest.com/robizzle01/made-by-rob-meyer/"></a>
    <script async defer src="//assets.pinterest.com/js/pinit.js"></script>
{{</* /rawhtml */>}}
```

### Result <!-- omit in toc -->
{{< rawhtml >}}
    <a data-pin-do="embedBoard" data-pin-board-width="700" data-pin-scale-height="750" data-pin-scale-width="300" href="https://www.pinterest.com/robizzle01/made-by-rob-meyer/"></a>
    <script async defer src="//assets.pinterest.com/js/pinit.js"></script>
{{< /rawhtml >}}