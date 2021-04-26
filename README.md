
# epidsampler

<!-- badges: start -->
[![GitHub build status](https://github.com/vincnardelli/epidsampler/workflows/R-CMD-check/badge.svg)](https://github.com/vincnardelli/epidsampler/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/vincnardelli/epidsampler/branch/master/graph/badge.svg)](https://codecov.io/gh/vincnardelli/epidsampler?branch=master)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![arXiv](https://img.shields.io/badge/arXiv-2004.06068-b31b1b.svg)](https://arxiv.org/abs/2004.06068)
[![arXiv](https://img.shields.io/badge/arXiv-2103.01254-b31b1b.svg)](https://arxiv.org/abs/2103.01254)
<!-- badges: end -->

## Overview
**epidsampler** is a package for simulate an epidemic map with mobility and social interaction between individuals. Useful for testing sampling methods.

This package was used to perform the simulations in Alleva, Giorgio, et al. <a href="https://arxiv.org/abs/2004.06068">"A sample approach to the estimation of the critical parameters of the SARS-CoV-2 epidemics: an operational design"</a> arXiv preprint arXiv:2004.06068 (2020) and  <a href="https://arxiv.org/abs/2004.06068">"Spatial sampling design to improve the efficiency of the estimation of the critical parameters of the SARS-CoV-2 epidemic"</a> (2021) arXiv preprint arXiv:2103.01254.

This package is in the very early stage of development. It is distributed so users can start to use it and report feedback, but its interface and/or behaviour is likely to change in the future. It is generally best to avoid depending on experimental features.

<img src="https://raw.githubusercontent.com/vincnardelli/epidsampler/master/dev/img/animation.gif" align="center" width="100%" />

## Installation
The package is work in progress and it is not available in the CRAN. However you can install it directly from the github repo.
``` r
# The easiest way to get epidsampler is to install it from GitHub:
# install.packages("devtools")
devtools::install_github("vincnardelli/epidsampler")
```

## How to use
The simulation is divided in two main function. We generate the map (regular grid or irregular map) and the individuals using generate(). Then, for each day of the simulation, we simulate the mobility, social interaction and the evolution of the epidemics with the infection and evolution of the disease for each individual in the map.


### Map generation
It is possible to generate two different types of maps:

- regular map or grid

- irregular map or polygon

``` r
map <- generate(n=25, P=1000, type="grid")
```
<a href="articles/epidsampler.html">Find out more on the parameter of generate() in the vignette.</a>

### Simulation
``` r
phase1 <- . %>%
  move_uniform(m=0.2, s=3) %>%
  meet(cn=3, cp=4, im=2) %>%
  move_back()

map <- run(map, phase1, days = 21, tE=5, tA=14,
            tI=14, ir=1, cfr=0.15)
```
<a href="articles/epidsampler.html">Find out more on the parameter of run() in the vignette.</a>

#### Evolution of the epidemics
First of all, in order to simulate an artificial population describing the time evolution of an epidemics, we considered a popular model constituted by a system of six differential equations which, in each moment of time, describe six categories of individuals, namely: the susceptibles (S), those exposed to the virus (E), the infected with symptoms (I), those without symptoms (A) and those that are removed from population either because healed (R) or dead (D).  The figure below describes diagrammatically the transition between the 6 categories. 

<img src="https://raw.githubusercontent.com/vincnardelli/epidsampler/master/dev/img/schema.png" align="center" width="80%" />


<a href="articles/epidsampler.html">Find out more on the parameter of the map generation and the simulation in the vignette.</a>


## Authors and contributors
**Vincenzo Nardelli** Bicocca University, Milan - vincnardelli@gmail.com

**Giorgio Alleva** - Sapienza University of Rome

**Giuseppe Arbia** - Catholic University of the Sacred Heart, Milan

**Piero Demetrio Falorsi** - Former Director of Methodology at Istat and International Consultant

**Alberto Zuliani** - Emeritus Professor, Sapienza University of Rome

