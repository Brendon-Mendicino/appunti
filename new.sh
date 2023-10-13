#!/bin/sh

if [ -z $1 ]; then
	echo "$0: Usage: new.sh DIR"
	exit 1
fi

if [ $(find -name $1) ]; then
	echo "$0: $1 already exists!"
	exit 1
fi

mkdir $1
mkdir $1/img
touch $1/appunti_$1.tex
(cd $1 && ln -s ../notestyle.sty -t .)
echo "\\documentclass[12pt]{article}

\\usepackage{notestyle}

\\graphicspath{{./img/}}


\\\\title{Notes $1}
\\\\author{Brendon Mendicino}


\\\\begin{document}

\\maketitle
\\\\newpage
\\\\tableofcontents
\\\\newpage

\\\\end{document}

%% vim: ts=2 sts=2 sw=2 et" > $1/appunti_$1.tex
