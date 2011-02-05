#!/bin/sh

origPath=`pwd`
if [ $# -lt 5 ]; then
	echo $0 "wherefolder infilefilter sortedprefix sortedsuffix format[MAPVIEW|SAM]"
	exit
fi

where=$1 #'../byChr/' ####
infilefilter=$2 #'*.mapview' ####
sortedprefix=$3
sortedsuffix=$4 #.s ##
format=$5


if [ $format == "MAPVIEW" ]; then
	format=1
elif [ $format == "SAM" ]; then
	format=2
else
	echo "unknown format $format"
	exit
fi

cd $where

for i in $infilefilter
	do 
	fileoutname="$sortedprefix$i$sortedsuffix";
	
	
	
	#sort coordinates
	if [ $format -eq 1 ]; then
		echo "sorting $i as MAPVIEW to $fileoutname";
		cat $i | sort -k 2,2 -k 3,3n > $fileoutname #sort uses start0 end1. sort the chr name first then the coordinate
	elif [ $format -eq 2 ]; then
		echo "sorting $i as SAM to $fileoutname";
		cat $i | sort -k 3,3 -k 4,4n > $fileoutname #sort uses start0 end1. sort the chr name first then the coordinate
	fi		


done
	
cd $origPath
