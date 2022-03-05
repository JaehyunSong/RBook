#!/usr/bin/env perl

$latex      = 'uplatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$lualatex   = 'lualatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';
$xelatex    = 'xelatex %O -synctex=1 -shell-escape -interaction=nonstopmode -file-line-error %S';
$pdflatex   = 'pdflatex %O -synctex=1 -interaction=nonstopmode -file-line-error %S';

$biber      = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex     = 'upbibtex %O %B';
$makeindex  = 'upmendex %O -o %D %S';
$dvipdf     = 'dvipdfmx %O -o %D %S';
$dvips      = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf     = 'ps2pdf %O %S %D';
$pdf_mode   = 3;