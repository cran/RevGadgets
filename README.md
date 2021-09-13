# RevGadgets

<a href="https://revbayes.github.io/tutorials/intro/revgadgets"><img src="https://raw.githubusercontent.com/cmt2/RevGadgets/master/inst/hex_sticker.png" height="200" align="right" /></a>

<!-- badges: start -->
[![R-CMD-check](https://github.com/cmt2/RevGadgets/workflows/R-CMD-check/badge.svg)](https://github.com/cmt2/RevGadgets/actions)
<!-- badges: end -->
  
Postprocessing gadgets for output generated by [RevBayes](http://www.revbayes.com)

Through user-friendly data pipelines, RevGadgets guides users through importing RevBayes output into R, processing the output, and producing figures or other summaries of the results. RevGadgets provide paired processing and plotting functions built around commonly implemented analyses, such as tree building and divergence-time estimation, diversification-rate estimation, ancestral-state reconstruction and biogeographic range reconstruction, and posterior predictive simulations. 

### To install: 

First, make sure that you have a recent version of [R](https://www.r-project.org) installed.
RevGadgets requires R version 4.0 or greater. 

Then, install the devtools R-package:

```R
install.packages("devtools")
```

Install RevGadgets directly from GitHub:

```R
devtools::install_github("cmt2/RevGadgets")
```

### Note about magick dependency:

A few RevGadgets dependencies require magick, which may require 
you to install the imagemagick software external to R. 

On a mac, you can do this with homebrew on terminal:

```bash
brew install imagemagick
```
### Tutorial: 

For an introduction to using RevGadgets, check out the [tutorial](https://revbayes.github.io/tutorials/intro/revgadgets) on the RevBayes website.