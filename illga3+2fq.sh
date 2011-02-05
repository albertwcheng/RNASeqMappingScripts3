#!/bin/bash

source ~/.bashrc
source ./initvars.sh

#echo "pathbefore:$PATH"
scriptPath=`pwd`
#alias ill2sanger='/mit/awcheng/App/maq-0.7.1-coyote-patched/maq ill2sanger'
#alias

cd $mergedsolfqDir


#echo `hostname`
#echo $PATH
#whereis maq


for i in *.txt; do
	#joinu.py
	echo "ill2sanger $i $fastqDir/${i/.txt/.fastq}"
	$scriptPath/maq-conv ill2sanger $i $fastqDir/${i/.txt/.fastq}
done


cd $scriptDir
