#!/bin/bash

source ~/.bashrc
source ./initvars.sh

#echo "pathbefore:$PATH"

#alias ill2sanger='/mit/awcheng/App/maq-0.7.1-coyote-patched/maq ill2sanger'
#alias

cd $mergedsolfqDir


#echo `hostname`
#echo $PATH
#whereis maq


for i in *_1_*.txt; do
	#joinu.py
	echo "ill2sanger sol2sanger $i $fastqDir/${i/.txt/.fastq}"
	/mit/awcheng/App/maq-0.7.1-coyote-patched/maq sol2sanger $i $fastqDir/${i/.txt/.fastq}
done

for i in *_2_*.txt; do
	#joinu.py
	echo "ill2sanger ill2sanger $i $fastqDir/${i/.txt/.fastq}"
	/mit/awcheng/App/maq-0.7.1-coyote-patched/maq ill2sanger $i $fastqDir/${i/.txt/.fastq}
done

cd $scriptDir
