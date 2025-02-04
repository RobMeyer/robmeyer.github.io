+++ 
draft = false
date = 2025-01-30
title = "Hugo Problems"
description = "Miscellaneous problems (with solutions!) encountered using Hugo for this site"
slug = ""
authors = []
tags = ["Hugo", "Github Pages", "Cloudflare"]
categories = []
externalLink = ""
series = []
+++

This site is built using [Hugo](https://gohugo.io/). There is a lot to like, but I've also run into a lot of problems. Over the first week of standing up this site, I'd estimate that about 70% of my time went to ~~fighting with~~ learning about Hugo. Good news, I'm writing this post to hopefully warn you about the foot-guns and surface the solution to common issues.

# The hugo-coder theme
I chose the [hugo-coder](https://github.com/luizdepra/hugo-coder) theme when I first stood this site up about 4 years ago. I was doing a lot of web performance optimizations at work and has just learned about [The 512KB Club](https://512kb.club/), which quickly lead me down the rabbit hole to discover [The 250KB Club](https://250kb.club/) and (the now-defunct) 1024b Club. This preamble is to say, perhaps my expectations are extreme or even downright unreasonable, so this is not me throwing shade in the slightest. It's a great theme and I'm glad 175 contributors have put in work to share it with me freely.

Anyways, as this story goes, even though I wasn't personally experiencing any performance issues, nor were any of my **zero** daily visitors, my curiosity led me to put it under the performance microscope for fun. As any self-respecting performance engineer would do, I rolled up my sleeves, opened DevTools, disabled my network cache, reloaded my website, and skimmed the status bar summary...

```
10 requests | 346 kB transferred | 473 kB resources
```

Then I smiled, because I knew I could do better. The first rule of performance is you need only pay for what you can see and my homepage is quite sparse -- 4 hyperlinks across the top nav, a reasonably sized photo, and a few more hyperlinks with icons and text across the bottom. If I were to take it to the extreme, the entire homepage could be 10-15kb.

The first thing I had to do was "eject" from the official hugo-coder theme. I really liked what they had done with the layout and design so I wanted to use it as a starting point, but I also wanted to have complete control over my site. The stylesheet and page templates don't belong to my theme, they belong to me!

I won't bore you with all the details (the commit history is in GitHub), but here were the big wins:
* Remove font-awesome icons. That fa-brans-solid.woff2 is 119 kB, fa-regular-400.woff2 is 26.6 kB, and fa-solid-900.woff2 is 158 kB, plus there's ~7.8kb of the 28.5 kB of CSS is for Font Awesome alone. Font Awesome does offer font subsetting with their Pro plan, but I'm not going to drop $50 (soon $60) per year for the 6 icons I'm using. (It is much smarter to spend an hour rolling my own icons and another hour writing a blog post about it 🤦🏻‍♂️.) I originally went with emoji characters (they pack a lot of visual impact into 32 bits), but I ultimately switched back to proper brand icons (svgs) for a more polished look. Even so, running the brand svgs through SVGOMG shaved 10-20% off each one.
* Compress my "avatar" -- the photo of myself on the landing page was saved with Photoshop's compression, which isn't nearly as good as [Squoosh.app](https://squoosh.app/). I'm looking forward to universal support of avif, but for now I'm sticking with jpeg and svg (it's not worth the hassle of managing multiple assets and using srcset). This image is also clipped into a circle with border-radius: 50%, which poses an opportunity: we could crop the image because white or transparent pixels will compress better, but I opted to keep the rectangular photo because I'm not a complete performaphobe. 
* Reducing network requests. Hugo-coder's CSS is structured as a main 28.5 kB file with the base styles with light theme colors and a 1.7 kB css containing just the dark mode color overrides, along with 763 bytes of javascript to handle mode switching, never mind the fact that the dark mode CSS gets downloaded even when you're in light mode. 

# VS Code Fighting with {{ handlebars }} in .html files
On many occasions, VS Code's automatic format on save (which I dearly love), has reformatted my Hugo "html" documents with breaking changes. It screws with indentation within handlebar blocks, but worse, sometimes it feels the need to add a space inside a literal string (a param containing a key name) causing the key to not be found. Please reach out if you know of a clean, easy solution. Right now I find myself using VS Code's "File: Save without Formatting" for these few problem files. Luckily only one or two of my "html" fragment files are affected and I rarely edit them, else I'd spend more time looking for a fix, or even resort to disabling format on save for the entire project.

Possible solutions
* I've read about a difficult-to-configure [Prettier plugin](https://github.com/NiklasPor/prettier-plugin-go-template) which I'm not going to sink time into.
* I tried installing `Twig Formatter`, `PHP Twig`, `Twig Language`, and `Twig Language 2` VS Code extensions, setting my document Language Mode to `HTML (twig)`. This stopped the automatic format on save, but oddly VS Code likes to forget the language mode after a few minutes.

# Code snippet syntax highlighting
One great thing about Hugo is compile-time code syntax highlighting. Visitors shouldn't need their browser to download and run JavaScript to syntax highlight code snippets. But, I found that it wasn't syntax highlighting my HTML and CSS snippets. First, I went down a rabbit-hole checking that my `config.toml` was properly configured for `markup.highlight`, which was actually non-trivial because I "ejected" from hugo-coder many Hugo versions ago and am using some configuration keys that are still supported but likely on the path to deprecation. Next I looked at the available Chroma themes and went down a light+dark mode side quest (more on that later). Finally, I remembered that markdown supports a way to hint which language the code snippet is in. Triple-backtick alone is a generic code snippet:

````
```
<html>
    <head><title>Generic code snippet containing html</title></head>
    <body></body>
</html>
```
````

Add the language directly following the triple-tick and Hugo and Chroma give us nice syntax highlighted output:

````html
```html
<html>
    <head><title>HTML format code snippet</title></head>
    <body></body>
</html>
```
````

Wondering which languages are supported and what are their specifiers? [Here you go](https://hugo-docs.netlify.app/en/content-management/syntax-highlighting/#list-of-chroma-highlighting-languages).

# Code snippet light and dark mode syntax highlighting
Unfortunately, many of Chroma's styles only support light or dark mode, not both. Luckily, the CSS that describes each Chroma style is easy to understand and work with -- the generator tool even has comments to explain the class name abbreviations.

My favorite way to support light and dark themes is with CSS Variables and a media query. I define CSS Variables for all my semantic colors and set them to their light mode values, then use a media query to modify the value when in dark mode. This cleanly separates concerns. Your design system tokens can go into their own variables/tokens file and all styles can be written against semantic concepts. Now, when product wants to introduce a pink theme, only the variable code needs to be updated. There's no duplication of styles so there's no risk of non-color properties (like font-size, line-height, margin, etc.) getting out of sync between the light and dark mode css. Furthermore, your Selector Stats performance numbers will look a lot better, with half the number of selectors. And finally, the debugging experience is great; DevTools makes it easy to see which style is setting a given css variable and (through the computed tab, or a hover tooltip on the styles tab) what the concrete value is for any element's color properties.

The pattern looks like this:

```CSS
/* define semantic tokens in :root */
:root {
    --background-color: #fafafa;
    --foreground-color: #212121;

    /* automatically switch values when in dark mode */
    @media only screen and (prefers-color-scheme: dark) {
        --background-color: #282828;
        --foreground-color: #dadada;
    }

    /* then simply use color variables instead of hardcoding values */
    body {
        background: var(--background-color);
        color: var(--foreground-color);
    }
}
```

I liked the base16-snazzy theme, which only has dark mode support, so for light mode I simply viewed them against my light mode background and darkened foreground colors until they had sufficient contrast and looked good. Lastly, there were a lot of class names that used the same `color` definition and there was an opportunity to simplify and reduce code by taking advantage of CSS Nesting, so I asked Claude.ai to do some mechanical refactoring that I didn't want to bother doing manually.

{{< code summary="For anyone interested, expand for the CSS (291 lines)" >}}
```css
.highlight {
    /* Manually darkened the colors from the dark mode base16-snazzy theme */
    --chroma-fg: #212121;
    --chroma-bg: #fff;
    --chroma-line-highlight-bg: #c1c0c0;
    --chroma-err: #f0534e;
    --chroma-proper-noun: #f0534e;
    --chroma-literal-string: #3ba55e;
    --chroma-line: #7f7f7f;
    --chroma-keyword: #c85498;
    --chroma-comment: #8d8d8d;
    --chroma-keyword-type: #c44234;
    --chroma-name-attribute: #46a0cc;
    --chroma-name-class: #c0c57d;
    --chroma-name-constant: #c87c35;
    --chroma-name-function: #4497c0;
    --chroma-literal-number: #cb5d51;
    --chroma-generic: #292929;
    --chroma-operator: #b14a86;

    @media (prefers-color-scheme: dark) {
        /* Dark mode colors from chromastyles base16-snazzy */
        --chroma-fg: #e2e4e5;
        --chroma-bg: #282a36;
        --chroma-line-highlight-bg: #3d3f4a;
        --chroma-err: #ff5c57;
        --chroma-proper-noun: #ff5c57;
        --chroma-literal-string: #5af78e;
        --chroma-line: #7f7f7f;
        --chroma-keyword: #ff6ac1;
        --chroma-comment: #78787e;
        --chroma-keyword-type: #ff9f43;
        --chroma-name-attribute: #57c7ff;
        --chroma-name-class: #f3f99d;
        --chroma-name-constant: #ff9f43;
        --chroma-name-function: #57c7ff;
        --chroma-literal-number: #ff9f43;
        --chroma-generic: #43454f;
        --chroma-operator: #ff6ac1;
    }

    overflow-x: auto;

    /* Background */
    .bg {
        color: var(--chroma-fg);
        background-color: var(--chroma-bg);
    }

    /* PreWrapper */
    .chroma {
        color: var(--chroma-fg);
        background-color: var(--chroma-bg);

        /* Error */
        .err {
            color: var(--chroma-err);
        }

        /* All line-related selectors:
         * .lnlinks - LineLink
         * .lntd    - LineTableTD
         * .lntable - LineTable
         * .hl      - LineHighlight
         * .lnt     - LineNumbersTable
         * .ln      - LineNumbers
         * .line    - Line
         */
        .lnlinks {
            outline: none;
            text-decoration: none;
            color: inherit;
        }

        .lntd {
            vertical-align: top;
            padding: 0;
            margin: 0;
            border: 0;
        }

        .lntable {
            border-spacing: 0;
            padding: 0;
            margin: 0;
            border: 0;
        }

        .hl {
            background-color: var(--chroma-line-highlight-bg);
        }

        .lnt,
        .ln {
            white-space: pre;
            -webkit-user-select: none;
            user-select: none;
            margin-right: 0.4em;
            padding: 0 0.4em 0 0.4em;
            color: var(--chroma-line);
        }

        .line {
            display: flex;
        }

        /* All keyword-related selectors:
         * .k   - Keyword
         * .kc  - KeywordConstant
         * .kn  - KeywordNamespace
         * .kp  - KeywordPseudo
         * .kr  - KeywordReserved
         * .nt  - NameTag
         */
        .k,
        .kc,
        .kn,
        .kp,
        .kr,
        .nt {
            color: var(--chroma-keyword);
        }

        /* Declaration and builtin selectors:
         * .kd  - KeywordDeclaration
         * .nb  - NameBuiltin
         */
        .kd,
        .nb {
            color: var(--chroma-proper-noun);
        }

        /* KeywordType */
        .kt {
            color: var(--chroma-keyword-type);
        }

        /* Name-related selectors:
         * .na  - NameAttribute
         * .nf  - NameFunction
         */
        .na,
        .nf {
            color: var(--chroma-name-attribute);
        }

        /* NameClass */
        .nc {
            color: var(--chroma-name-class);
        }

        /* Constant and decorator selectors:
         * .no  - NameConstant
         * .nd  - NameDecorator
         */
        .no,
        .nd {
            color: var(--chroma-name-constant);
        }

        /* Variable-related selectors:
         * .nl  - NameLabel
         * .nv  - NameVariable
         * .vc  - NameVariableClass
         * .vg  - NameVariableGlobal
         * .vi  - NameVariableInstance
         */
        .nl,
        .nv,
        .vc,
        .vg,
        .vi {
            color: var(--chroma-proper-noun);
        }

        /* All string-related selectors:
         * .s   - LiteralString
         * .sa  - LiteralStringAffix  
         * .sb  - LiteralStringBacktick
         * .sc  - LiteralStringChar
         * .dl  - LiteralStringDelimiter
         * .sd  - LiteralStringDoc
         * .s2  - LiteralStringDouble
         * .s3  - LiteralStringEscape
         * .sh  - LiteralStringHeredoc
         * .si  - LiteralStringInterpol
         * .sx  - LiteralStringOther
         * .sr  - LiteralStringRegex
         * .s1  - LiteralStringSingle
         * .ss  - LiteralStringSymbol
         */
        .s,
        .sa,
        .sb,
        .sc,
        .dl,
        .sd,
        .s2,
        .s3,
        .sh,
        .si,
        .sx,
        .sr,
        .s1,
        .ss {
            color: var(--chroma-literal-string);
        }

        /* All number-related selectors:
         * .m   - LiteralNumber
         * .mb  - LiteralNumberBin
         * .mf  - LiteralNumberFloat
         * .mh  - LiteralNumberHex
         * .mi  - LiteralNumberInteger
         * .il  - LiteralNumberIntegerLong
         * .mo  - LiteralNumberOct
         */
        .m,
        .mb,
        .mf,
        .mh,
        .mi,
        .il,
        .mo {
            color: var(--chroma-literal-number);
        }

        /* Operator-related selectors:
         * .o   - Operator
         * .ow  - OperatorWord
         */
        .o,
        .ow {
            color: var(--chroma-operator);
        }

        /* All comment-related selectors:
         * .c   - Comment
         * .ch  - CommentHashbang
         * .cm  - CommentMultiline
         * .c1  - CommentSingle
         * .cs  - CommentSpecial
         * .cp  - CommentPreproc
         * .cpf - CommentPreprocFile
         */
        .c,
        .ch,
        .cm,
        .c1,
        .cs,
        .cp,
        .cpf {
            color: var(--chroma-comment);
        }

        /* All generic-related selectors:
         * .gd  - GenericDeleted
         * .ge  - GenericEmph
         * .gr  - GenericError 
         * .gh  - GenericHeading
         * .gi  - GenericInserted
         * .go  - GenericOutput
         * .gs  - GenericStrong
         * .gu  - GenericSubheading
         * .gl  - GenericUnderline
         */
        .gd,
        .gr {
            color: var(--chroma-proper-noun);
        }

        .ge,
        .gl {
            text-decoration: underline;
        }

        .gh,
        .gi,
        .gu {
            font-weight: bold;
        }

        .go {
            color: var(--chroma-generic);
        }

        .gs {
            font-style: italic;
        }
    }
}
```
{{< /code >}}

## Wanted: Special-case Color Literal Styles
The colorize VS Code plugin is a must-have, and I want the same treatment in my chromastyles output. Basically, the background color of text such as `#ff0000`, `rgb(255, 0, 0)` and `red` will be set to the color itself (red in these examples) and the text color is set to either white or black, whichever has a higher contrast ratio. Bonus points: on click or in a hover tooltip, open a color picker that shows the value in other formats (hex, rgb, hsv, etc.).

# Move Hosting from GitHub Pages to Cloudflare
I wanted to move to Cloudflare's Worker Page infrastructure to build and deploy this site because I was already using it for all my other projects. I also haven't decided on a traffic analytics solution yet, but I noticed Cloudflare has a free solution that is highly recommended, so I want to give it a try (and I'm guessing I need to publish to Cloudflare's CDN, not GitHub Pages, which ironically appears to use Cloudflare). 

I ran into two issues
1. Build failure
2. Cloudflare's deployment URLs

## Build failure
The Hugo build failed in Cloudflare's build environment. This was especially annoying because it was building fine locally and in GitHub Actions.

```bash
	Error: error building site: "/opt/buildhome/repo/themes/hugo-coder/layouts/posts/li.html:2:1": parse failed: template: posts/li.html:2: function "hash" not defined
```

The build error checks out. I am, in fact, using `hash` in li.html. The question is, "why is this a build fail in Cloudflare but not GitHub Actions?"
```html
<li>
  <a style="view-transition-name: post-title-{{ hash.XxHash .Title }}" class="title"
    href="{{ .Params.ExternalLink | default .RelPermalink }}">{{ .Title }}</a>
  <span class="date">{{ .Date.Format (.Site.Params.dateFormat | default "January 2, 2006" ) }}</span>
</li>
```

I suspected that it was a version issue. The first thing I did was search the error message, but it only led to some unrelated forum posts. 

{{< aside type="none" title="rabbit hole" >}}
Then I went down a rabbit hole for 30 minutes trying to find if there was a globally unique PostId field I could use, because the only reason I was using `{{ Hash.XxHash .Title }}` as a hacky proxy for uniqueness. 
{{< /aside >}}

Then I looked up the documentation for hash.XxHash, hoping that it would have a minimum version number (and that it would be relatively recent). No such luck. I compared the build output from GitHub (and my local environment) and Cloudflare had different version numbers, with Cloudflare being the oldest. I found that you can supply an environment variable to specify the Hugo version in Cloudflare Worker's settings and it worked like a charm. I'm setting `HUGO_VERSION` to `0.142.0`.

## Cloudflare's deployment URLs
Cloudflare generates a unique subdomain (such as `https://c74ea08e.robmeyer-github-io.pages.dev`) With each Cloudflare Worker Page build and deployment. Hugo's build sees this as `base_url`, which will be used by `absURL`, `absLangURL`, and `.Permalink`, many of which are used by many Hugo themes. In my case, my site navigation and various tags under `<head>` (favicon, sitemap, twitter and Open Graph metadata, etc.) were fully-pathed to include these deployment URLs rather than `https://robmeyer.net`. 

The fix, again is a Cloudflare Worker environment variable. I'm setting `CF_PAGES_URL` to `https://robmeyer.net/`. And this variable is passed in the build command -- `hugo -b $CF_PAGES_URL --minify`.

## Don't forget to minify
Lastly, one piece of Cloudflare documentation left out the `--minify` parameter in the hugo build command. It's easy to copy-paste and forget to add that back. 

The full build command is:
```bash
hugo -b $CF_PAGES_URL --minify
```

## Polyfill.io
At some point while diagnosing unrelated issues, I saw a console error about a 404 trying to request javascript from polyfill.io. It was trying to fetch es6 polyfills, which I was pretty sure I didn't need anymore -- made a mental note to follow that lead later, but first: I tried to go to polyfill.io and got a `Hmmm... can't reach that page [DNS_PROBE_FINISHED_NXDOMAIN]` error, then searched the web and, oh joy, the first search result was "Remove Polyfill.io code from your website immediately".

I searched my repository and, lo and behold, there was a polyfill.io. I'm surprised GitHub never added a codescan and automatic alert about this one. Good news, Cloudflare mitigated this automatically for all sites hosted on their CDN, which appears to include GitHub Pages.

This is one big downside of "ejecting" from the `hugo-coder` theme. Now I'm on the hook to keep it updated. On the plus side, now I'm much more aware of various dependencies (and I've since removed the dependencies against Font Awesome and polyfill.io, because who needs 'em anyways.)

# Other improvements I've made
This last set of things aren't necessarily Hugo's fault, but they are nonetheless things that I spent time on, which I wouldn't have if I had chosen a different static site generator, a different Hugo theme, or "simply" written this site with vanilla HTML+CSS.

## Remove the light/dark mode switcher
To each their own, but I've always found it gauche to present the user with a light/dark mode switcher. I want to support both views out of respect for the user's preference, but I don't need to shout off the rooftop, "Look at me, I built a website that has supports two palettes!". I went over my preferred light and dark mode CSS pattern above. This item only required deleting a JavaScript file and a little html toggle switch that appeared in the bottom-right corner of the page.

## Simplify Light/Dark Color CSS
Hugo Coder was built with SCSS and used $variables (not to be confused with CSS --variables) to support light and dark mode themes. The problem with using SCSS variables is that you end up needing to pick a default theme whose colors are referenced in the "base" CSS, then conditionally add "override" CSS stylesheets to the document with selectors that override these colors with a second set of colors. This also breaks co-location of styles -- whenever you introduce a new style rule with a color, you need to open a different file to introduce the override rule.

But, there's a better way. CSS Variables and media queries simplify all of this complexity.
* There's only one stylesheet for the browser to load.
* CSS rules only need to set a given color property once (e.g.`color`, `background-color`, `border-color`) you only need to 

## Rolled my own SVG Icons

Worth of its own post, this content can be found [here]({{< relref "/posts/0005-RollingMyOwnIconLibrary" >}})

## Hugo shortcodes

Worthy of its own post, this content can be found [here]({{< relref "/posts/0004-HugoShortcodes/" >}}).