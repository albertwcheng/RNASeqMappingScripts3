#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 inSam outSamGenQ outSamJnxQ Q
fi

inSam=$1
outSamGenQ=$2
outSamJnxQ=$3
Qt=$4

wc -l in $inSam1 > $inSam1.$Q.log
awk -v qthreshold=$Qt '$1!~/\@/ && $5>=qthreshold && $3~/?/' $inSam1 > $outSamGenQ #genomeQ
wc -l in $outSamGenQ >> $inSam1.$Q.log
awk -v qthreshold=$Qt '$1!~/\@/ && $5>=qthreshold && $3~/?/' $inSam1 > $outSamJnxQ #jnxQ
wc -l in $outSamJnxQ >> $inSam1.$Q.log
