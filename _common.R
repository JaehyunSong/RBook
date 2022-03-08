golem::detach_all_attached()
rm(list = ls())
pacman::p_load(tidyverse, knitr, kableExtra)
options(tinytex.latexmk.emulation = FALSE)
knitr::opts_chunk$set(attr.source = ".numberLines", 
                      dev         = "ragg_png",
                      fig.align   = "center",
                      dpi         = 300,
                      fig.pos     = "H")