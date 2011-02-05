#!/bin/bash

manifestFile=$1

source ./initvars.sh

saveIFS=$IFS
IFS=`echo -en "\n\b"`
sampleString=`cat $solexaOuputDir/$manifestFile`

#echo $sampleString

declare -a samples=($sampleString)

for sample in ${samples[*]}; do
	echo sending maq command for sample $sample
	bash ./maq.roadRunner.sh $sample
done
