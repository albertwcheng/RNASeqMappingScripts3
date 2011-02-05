#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 paired chromList chromFaDir
	exit
fi

paired=$1
chromList=$2
chromFaDir=$3


#load the chrom list
#/lab/jaenisch_albert/genomes/hg18/hg18_nr.sizes
#or
#/lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes

#bsub bash scriptureRunScripture.sh 1 /lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes /lab/jaenisch_albert/genomes/mm9/fa/byChr/


chroms=( `cut -f1 $chromList` )
echo There were ${#chroms[@]} chromosomes $chroms loaded from $chromList

scriptDir=`pwd`

cd ..

rootDir=`pwd`
tophatOutputDir=${rootDir}/tophatOutput

if [[ $paired == 1 ]]; then
	scriptureOutputDir=${rootDir}/scriptureOutput_paired
else
	scriptureOutputDir=${rootDir}/scriptureOutput
fi

#### old version ####
#tmpdir=$scriptureOutputDir/tmp

#if [ ! -e tmpdir ]; then
#	mkdir $tmpdir
#fi

############

#concatenate all alignment files
#cat $scriptureOutputDir/*/sorted*.sam > $scriptureOutputDir/all_alignments.sam  ###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK

cd $scriptureOutputDir

for cellspecificalignmentfolder in *; do


if [ ! -e $cellspecificalignmentfolder/sorted*.sam ]; then
	continue
fi

cd $cellspecificalignmentfolder

if [[ $paired == 1 ]]; then
	cellspecificalignment=mergedpair.sam
	cat sorted.1.sam sorted.2.sam > $cellspecificalignment
else
	cellspecificalignment=sorted.sam
fi

#use SamTools for BAM instead
pref=${cellspecificalignment/.sam/}
echo convert $cellspecificalignment to ${pref}.bam
samtools view -b -S -t $chromList -o ${pref}.bam $cellspecificalignment

echo "sort ${pref}.bam as ${pref}.sorted.bam"
samtools sort ${pref}.bam ${pref}.sorted

echo "index ${pref}.sorted.bam as ${pref}.sorted.bam.bai"
samtools index ${pref}.sorted.bam


#should now have ${pref}.sorted.bam and ${pref}.sorted.bam.bai



if [[ $paired == 1 ]]; then
	#combined paired end alignment files
	#cat $scriptureOutputDir/*/paired.sam > all_alignments.paired.sam  ###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK###CHANGE BACK
	
		
	#use SamTools for BAM instead
	echo "convert paired.sam to paired.bam"
	samtools view -b -S -t $chromList -o paired.bam paired.sam
	
	echo "sort paired.bam as paired.sorted.bam"
	samtools sort paired.bam paired.sorted
	
	echo "index paired.sorted.bam as ${pref}.sorted.bam.bai"
	samtools index paired.sorted.bam
	
	#now we have paired.sorted.bam and paired.sorted.bam.bai

	
	
fi

#now we can run scripture
#do this for each chromosome

for chrom in ${chroms[@]}; do
echo submitting scripture segment task for chrom $chrom to cluster
	if [[ $paired == 1 ]]; then
		#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd all_alignments.paired.sorted.sam
		 bsub scripture -alignment ${pref}.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd paired.sorted.bam
	else
		#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
		bsub scripture -alignment ${pref}.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
	fi
done

cd ..

done