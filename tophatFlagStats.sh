#!/bin/bash

source fileUtils.sh
source ./initvars.sh
source $tophatshvar

firstline=1

cd $tophatOutputDir

for sampleName in `ls -d *`; do
	

	
	i=$sampleName/accepted_hits.sorted.bam
	
	if [ ! -e $i ]; then
		continue
	fi
	
	if [ -e $i.flagstat ]; then
		if [[ $firstline == 1 ]]; then
			awk -v FS="\t" -v FS=" " 'BEGIN{printf("sampleName");}{lineData=""; for(i=2;i<=NF;i++){lineData=lineData $i " ";} printf("\t%s",lineData);}END{printf("\n");}' $i.flagstat > $tophatOutputDir/flagstat.summary
			firstline=0
		fi
		awk -v FS="\t" -v FS=" " -v sampleName=$sampleName 'BEGIN{printf(sampleName);}{printf("\t%s",$1);}END{printf("\n");}' $i.flagstat >> $tophatOutputDir/flagstat.summary
	else
		echo "samtools flagstat $i > $i.flagstat" | bsub
	fi
done

if [[ $firstline == 0 ]]; then
	cat $tophatOutputDir/flagstat.summary
fi
