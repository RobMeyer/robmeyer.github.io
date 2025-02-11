# Projects

## Mondrianish

{{< captioned-image
src="mondrianish2.jpg"
alt="Screenshot of an in-browser 3D art museum featuring Mondrian style artwork"
caption="[mondrianish.robmeyer.net](https://mondrianish.robmeyer.net)"
captionType="markdown"
>}}

{{< captioned-image
src="mondrian-svg-gen.png"
alt="Screenshot of an in-browser 3D art museum featuring Mondrian style artwork"
caption="[mondrian-svg-gen.robmeyer.net](https://mondrian-svg-gen.robmeyer.net)"
captionType="markdown"
>}}

Built in 2021 at the peak of the NFT fad (while I was fully aware that it was a fad), this one's two projects in one!

First, [mondrian-svg-gen](https://mondrian-svg-gen.robmeyer.net) is a tool to create generative art in the style of Piet Mondrian's Neoplastism works. The tool generates an SVG with the configured palette, complexity, and dimensions following a set of ratios.

Written using React because that's what I was most familiar with, but it could easily be vanilla HTML+JS.

Second, [Mondrianish](https://mondrianish.robmeyer.net) is a fork of [virtual-art-gallery](https://github.com/ClementCariou/virtual-art-gallery) with some modifications to showcase my creations (and some tweaks to the user experience [do you prefer 'normal' or 'pilot' pull-down-to-look-up style controls?]).

Had the NFT craze continued, I considered making it easily configurable and adding in-app crypto-based purchases. Imagine visiting galleries to shop for new art and digital collectables; likewise, collectors would have their own browsable collections that they could embed on their homepage or link to on their social media profiles. 

## Print Proxy Cards
{{< captioned-image
src="print-proxy-cards.jpg"
alt="Screenshot of an app to easily print correctly sized cards"
caption="[print-proxy-cards.robmeyer.net](https://print-proxy-cards.robmeyer.net)"
captionType="markdown"
>}}

Leaning into my 6-year-old son's Pokémon addition, I discovered the much less expensive way to build decks to play the card game -- printing our own proxy cards. Actually, it started as a way for him to provide his own artwork for existing cards, and eventually, making up entirely new Pokémon cards

I quickly realized that manually scaling and aligning the cards in Photoshop to print 8 at a time was going to be way too time consuming, so I created this simple page to drag-and-drop files into a preset template. Configuration settings make it easy to take advantage of printers with 'print on both sides' support, or manually reload the tray between printing the front and back sides. The back side artwork is oversized ensuring that even with a little imprecision, there won't be a white gap along the unprinted edge on the backside.

This project was originally written in React, and I later came back and rewrote it using SolidJS because I wanted to compare and contrast the developer experience and resulting performance. At the moment, I'm loving SolidJS.

P.S. For designing new cards, I highly recommend [Pokécardmaker.net](https://pokecardmaker.net/creator).

## Arrow Maze Creator
{{< captioned-image
src="arrow-maze-creator.jpg"
alt="Screenshot of an app to create and print arrow mazes"
caption="[arrow-maze-creator.robmeyer.net](https://arrow-maze-creator.robmeyer.net)"
captionType="markdown"
>}}

Another project built for my 6-year-old son, this tool makes it easy to design and print an arrow maze. For the uninitiated, arrow mazes have start and end points, but you have to follow the arrow of any space you land on. More info and a bunch of quality free mazes can be found [here](https://www.doyoumaze.com/free-printable-mazes#/arrow-mazes/).

This project was an opportunity for me to check out SolidJS. I also played with custom cursors and subtle css animations to add a little polish. If I ever come back to this code, I'd look at accessibility (keyboard navigation and aria-labels within the maze as well as hotkeys for switching between the most common tools). Another area to explore would be adding a backend to save and share mazes. There is, at least, localStorage support to save your work, but there's no way to amass a collection of finished mazes (I just print to PDF and save them in a folder).

# Big plans, maybe someday
## Worth the Squeeze
🚧 Just some local code at the moment. Playing around with web assembly and image compression. Locally processed (Your data is yours! Nothing uploaded) hands-free image compressor. Tries numerous formats and quality settings to automatically find optimal compression-to-quality trade-off. Easily preview the before/after as well as a diff-overlay.

Took this project as an opportunity to check out Deno, Web Assembly, and dusting off my C++ knowledge.

## SVGOMG (Fork)
[SVGOMG Fork](https://svgomg.robmeyer.net)
Annoyed by the obtrusive ads on the official site (which overlap critical components, breaking critical functionality), I'm self-hosting a fork.
  * Changed the page layout to make better use of available screen estate and slightly improving rendering performance.
  * Updated the svgo dep to v4.0.0-rc.1, picking up numerous bug fixes and improvements.
## Squoosh (Fork)
Not yet published
  * Updated dependencies, addressing security warnings.
  * Add image-diff overlay support (semitransparent red pixels indicate changes)
  * Incorporate "auto compress" mode, inspired by [Worth the Squeeze](#worth-the-squeeze)
