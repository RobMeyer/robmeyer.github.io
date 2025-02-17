+++ 
draft = false
date = 2024-01-24
title = "Web Dev Reference"
description = "Consolidated reference materials for web developers"
slug = ""
authors = []
tags = ["Web", "Reference"]
categories = []
externalLink = ""
series = []
+++

I have a bunch of bookmarks of reference materials. I'll try to consolidate and summarize these resources for my own use, and if you find it helpful too, even better!

# Table of Contents <!-- omit in toc -->
- [How to Favicon in 2024](#how-to-favicon-in-2024)
- [CSS Reset](#css-reset)
- [nice-forms.css](#nice-formscss)
- [vite-plugin-minify](#vite-plugin-minify)
- [Web Components](#web-components)
- [Tools/Resources](#toolsresources)
- [Cheatsheets](#cheatsheets)

# [How to Favicon in 2024](https://evilmartians.com/chronicles/how-to-favicon-in-2021-six-files-that-fit-most-needs)

## HTML <!-- omit in toc -->
```html
<link rel="icon" href="/favicon.ico" sizes="32x32">
<link rel="icon" href="/icon.svg" type="image/svg+xml">
<link rel="apple-touch-icon" href="/apple-touch-icon.png"><!-- 180×180 -->

<!-- Optionally, if you're making a PWA -->
<link rel="manifest" href="/manifest.webmanifest">
```

And, again optionally, in that `manifest.webmanifest`, you'll want the following.
```json
{
  "icons": [
    { "src": "/icon-192.png", "type": "image/png", "sizes": "192x192" },
    { "src": "/icon-mask.png", "type": "image/png", "sizes": "512x512", "purpose": "maskable" },
    { "src": "/icon-512.png", "type": "image/png", "sizes": "512x512" }
  ]
}
```

Use [maskable.app](https://maskable.app/), [PWA Builder Image Generator](https://www.pwabuilder.com/imagegenerator), or [Progressier's generator](https://progressier.com/pwa-icons-and-ios-splash-screen-generator) to generate those assets. 

### ❗️ A word of caution <!-- omit in toc -->
I wasted an afternoon trying to get my icons to feel platform-native (squircles on Mac/iOS, circles on Android, can't-remember--what on Windows, and a maskable fallback) while also using the best supported mimetype (starting with SVG and falling back through avif, webp, and finally png). I wasn't able to find the magic incantation of type, format, sizes, and purpose to work as expected across all the browsers and platforms I was testing (MacOS Safari, MacOS Chromium [Edge and Chrome], MacOS Firefox, iOS [always webkit 🤮], and I didn't even make it to Windows, though I knew it doesn't support SVG 🤦🏻‍♂️.) Your mileage may vary, but you've been warned. Don't get nerd sniped, or if you do, please take good notes and forward grievances to [OWA](https://open-web-advocacy.org/get-involved/). Browser support may have improved by the time you read this or you might solve the puzzle.

# CSS Reset
A lot has been written about the mighty CSS Reset and I won't do the topic justice. There's no "wrong" or or "right" here, just understanding what it does and making choices that improve your development workflow.

Here are some popular ones
* [Josh Comeau](https://www.joshwcomeau.com/css/custom-css-reset/) [2021 November]
* [Andy Bell](https://piccalil.li/blog/a-more-modern-css-reset/) [2023 September]
* [Eric Meyer](https://meyerweb.com/eric/tools/css/reset/) [2011 January]


And for what it's worth, here's mine (mostly Josh Comeau's)
```css
/* Opt-in to page navigation animations */
@view-transition {
  navigation: auto;
}

/* Use a more-intuitive box-sizing model */
*, *::before, *::after {
  box-sizing: border-box;
}

* {
  /* Remove default margin */
  margin: 0;

  /* Add accessible line-height that doesn't get too large in headings */
  /* line-height: calc(1em + 0.5rem); */
}

body {
  /* Improve text rendering */
  -webkit-font-smoothing: antialiased;
}

/* Improve media defaults */
img, picture, video, canvas, svg {
  display: block;
  max-width: 100%;
  /* In the uncommon case that an image should be oversized, apply max-width: revert to that specific element */
}

/* Inherit fonts for form controls */
input, button, textarea, select {
  font: inherit;
}

/* Avoid text overflows */
p, h1, h2, h3, h4, h5, h6 {
  overflow-wrap: break-word;
}

/* Improve line wrapping */
p {
  text-wrap: pretty;
}

h1, h2, h3, h4, h5, h6 {
  text-wrap: balance;
}

/* Create a root stacking context */
/* Optional and generally only needed when using a JS framework. Update to target the top-level element your app renders into (e.g. typically #root for React) */
#root, #__next {
  isolation: isolate;
}
```

# [nice-forms.css](https://nielsvoogt.github.io/nice-forms.css/)

## Download <!-- omit in toc -->
* [nice-forms.css](https://unpkg.com/nice-forms.css@0.1.7/dist/nice-forms.css) 28kb raw, 5.5kb brotli compressed
* [nice-forms-reset.css](https://raw.githubusercontent.com/nielsVoogt/nice-forms.css/main/dist/nice-forms-reset.css) 20kb raw, 3.2kb brotli compressed. Applies directly to form elements, without needing to add nice-forms classnames. Also removes some icon support.

I needed to make a form look half decent in a hurry and landed on nice-forms.css after 10 minutes of browsing [FreeFrontend](https://freefrontend.com/). There may well be a better boilerplate out there, but this worked well for me. 

# vite-plugin-minify
Vite minifies CSS and JS, but doesn't minify html out of the box. Good news, there's a quick fix.

```bash
npm install vite-plugin-minify -D
```

Add to plugins in `vite.config.ts` and make sure all your html files are listed under `build.rollupOptions.input`.
```javascript
import { defineConfig } from 'vite'
import { ViteMinifyPlugin } from 'vite-plugin-minify';
import { resolve } from 'path';

export default defineConfig({
  build: {
    sourcemap: true,
    cssMinify: true,
    cssCodeSplit: true,
    rollupOptions: {
      input: {
        file1: resolve(__dirname, 'index.html')
      }
    }
  },
  plugins: [
    ViteMinifyPlugin({})
  ]
})
```

See also [Optimizing frontend builds with vite](https://sorbx64.hashnode.dev/optimizing-frontend-builds-with-vite) if you run into issues.

# Web Components
* [awesome-web-components](https://github.com/web-padawan/awesome-web-components) A curated list of awesome Web Components resources.
* [Where web components shine](https://daverupert.com/2024/10/super-web-components-sunshine/) - An honest assessment and great read after you begin venturing into Web Components, but perhaps still lack the instinct of where they're best used or when you want to stick your neck out to use them in a project.

# Tools/Resources
* Image compression
  * [Squoosh](https://squoosh.app/) - In-browser compression with support for avif, webp, png, jpeg, and more.
  * [Svgomg [My fork]](https://svgomg.robmeyer.net) - My fork has an updated svgo dependency, no advertisements blocking critical UX and, IMO, improved layout. Or use the [official SVGOMG](https://svgomg.net/).
* [Google Fonts](https://fonts.google.com)
* [Josh Comeau's Gradient Generator](https://www.joshwcomeau.com/gradient-generator/)
* [Easing Wizard](https://easingwizard.com/) - Preview and generate CSS animation timing functions
* [Tabler Icons](https://tablericons.com/) - Thousands of SVG icons offering copy-to-clipboard ready snippets for the raw SVG contents or Data URI. I wish the React and Vue options provided the code rather than adding a dependency
* Misc. in-browser tools
  * [URL-encoder for SVG](https://yoksel.github.io/url-encoder/) - Easily encode SVG XML for CSS data:image
* Browser support
   * [Can I use](https://caniuse.com/) - Check for browser support before using a new feature.
   * [Web Platform Status](https://webstatus.dev/) - See the Baseline YYYY lists, as well as Top CSS/HTML Interop issues.
* Beautiful code screenshots/snippets
  * [Cabon](https://carbon.now.sh/) - Share beautiful code snippets
  * [Picyard.in/code](https://www.picyard.in/code) - Also lovely with great presets.
  * SVG Patterns
    * [Haikei Generator](https://app.haikei.app/)
    * [Pattern Monster](https://pattern.monster/)
    * [Hero Patterns](https://heropatterns.com/)

# Cheatsheets
* [CSS Flexbox](https://flexbox.malven.co/) and the [css-tricks guide](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
* [CSS Grid](https://grid.malven.co/) and a [guide](https://learncssgrid.com/)