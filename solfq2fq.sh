#!/bin/bash


source ./initvars.sh

#echo "pathbefore:$PATH"



cd $mergedsolfqDir


#echo `hostname`
#echo $PATH
#whereis maq


for i in *.txt; do
	#joinu.py
	echo "$maq sol2sanger $i $fastqDir/${i/.txt/.fastq}"
	eval "$maq sol2sanger $i $fastqDir/${i/.txt/.fastq}"
done


cd $scriptDir
