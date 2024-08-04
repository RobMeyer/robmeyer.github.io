# About this repo
1. This static site is generated using [Hugo](https://gohugo.io)
    1. run `hugo server` to start the local server
    2. run `hugo` to generate the static site, copied to `/public`
3. The static site is deployed to Github Pages [here](https://robmeyer.net/)
4. A Github Workflow is used to automatically build and deploy the site when `master` is changed
5. Other miscellaneous web projects may be published by copying builds to subdirectories of `static`, for example `static/mondrianish` is published [here](https://robmeyer.net/mondrianish/). There's probably elegant ways to do this, but this is fine for how rarely I'm changing projects.