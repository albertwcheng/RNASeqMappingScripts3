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
		if [ -e $i.nhits.txt  ]; then
			if [[ $firstline == 1 ]]; then
				awk -v FS="\t" -v FS=" " 'BEGIN{printf("sampleName\torigRead1\torigRead2");}{lineData=""; for(i=2;i<=NF;i++){lineData=lineData $i " ";} printf("\t%s",lineData);}END{printf("\n");}' $i.flagstat > $tophatOutputDir/flagstat.summary
				firstline=0
			fi
			
			tp1=`tempfile`
			cat $sampleName/left_kept_reads.info | tr -d " " > $tp1
			source $tp1
			
			left_reads_in=$reads_in
			
			tp1=`tempfile`
			cat $sampleName/right_kept_reads.info | tr -d " " > $tp1
			source $tp1
			
			right_reads_in=$reads_in
			
					
			awk -v FS="\t" -v FS=" " -v leftReadsIn=$left_reads_in -v rightReadsIn=$right_reads_in -v sampleName=$sampleName 'BEGIN{printf("%s\t%s\t%s",sampleName,leftReadsIn,rightReadsIn);}{printf("\t%s",$1);}END{printf("\n");}' $i.flagstat >> $tophatOutputDir/flagstat.summary
		else
			bsub filterMaxHits --print-NH-stat-to $i.nhits.txt --in $i
		fi
	else
		echo "samtools flagstat $i > $i.flagstat" | bsub
	fi
done

if [[ $firstline == 0 ]]; then
	cat $tophatOutputDir/flagstat.summary
else
	echo "run this again after all jobs finish"
fi
