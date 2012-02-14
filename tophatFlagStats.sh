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
				awk -v FS="\t" -v FS=" " 'BEGIN{printf("sampleName\torigRead1\torigRead2\tkeptRead1\tkeptRead2\tread1Alignments\tread2Alignments\tread1Mapped\tread2Mapped\ttotalMapped");}{lineData="flagstat"; for(i=2;i<=NF;i++){lineData=lineData "." $i;} printf("\t%s",lineData);}END{printf("\n");}' $i.flagstat > $tophatOutputDir/flagstat.summary
				firstline=0
			fi
			
			tp1=`tempfile`
			cat $sampleName/left_kept_reads.info | tr -d " " > $tp1
			source $tp1
			
			left_reads_in=$reads_in
			left_kept_reads=$reads_out
			
			tp1=`tempfile`
			cat $sampleName/right_kept_reads.info | tr -d " " > $tp1
			source $tp1
			
			right_reads_in=$reads_in
			right_kept_reads=$reads_out
			
			read1Alignments=`tail -n 5 $i.nhits.txt | grep TotalAlignments | cut  -f2`
			read2Alignments=`tail -n 5 $i.nhits.txt | grep TotalAlignments | cut -f3`
			read1Mapped=`tail -n 5 $i.nhits.txt | awk -v FS="\t" '$1=="TotalMapped"' | cut -f2`
			read2Mapped=`tail -n 5 $i.nhits.txt | awk -v FS="\t" '$1=="TotalMapped"' | cut -f3`
			totalMappedReads=`tail -n 5 $i.nhits.txt | grep TotalMappedUnion | cut -f2`
			
			
					
			awk -v FS=" " -v read1Alignments=$read1Alignments -v read2Alignments=$read2Alignments -v read1Mapped=$read1Mapped -v read2Mapped=$read2Mapped -v leftReadsIn=$left_reads_in -v rightReadsIn=$right_reads_in -v leftKept=$left_kept_reads -v rightKept=$right_kept_reads -v sampleName=$sampleName -v totalMappedReads=$totalMappedReads 'BEGIN{printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",sampleName,leftReadsIn,rightReadsIn,leftKept,rightKept,read1Alignments,read2Alignments,read1Mapped,read2Mapped,totalMappedReads);}{printf("\t%s",$1);}END{printf("\n");}' $i.flagstat >> $tophatOutputDir/flagstat.summary
		else
			bsub filterMaxHits --print-NH-stat-to $i.nhits.txt --in $i
		fi
	else
		echo "samtools flagstat $i > $i.flagstat" | bsub
		bsub filterMaxHits --print-NH-stat-to $i.nhits.txt --in $i
	fi
done

if [[ $firstline == 0 ]]; then
	cat $tophatOutputDir/flagstat.summary
else
	echo "run this again after all jobs finish"
fi
