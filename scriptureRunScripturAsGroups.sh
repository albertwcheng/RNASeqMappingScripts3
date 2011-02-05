#!/bin/bash

if [ $# -lt 5 ]; then
	echo $0 paired chromList chromFaDir outputPrefixRelToRoot groupFileRelToRoot
	exit
fi

paired=$1
chromList=$2
chromFaDir=$3
outputPrefix=$4
groupFile=$5


#load the chrom list
#/lab/jaenisch_albert/genomes/hg18/hg18_nr.sizes
#or
#/lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes

#bsub bash scriptureRunScripturAsGroups.sh 0 /lab/jaenisch_albert/genomes/mm9/mm9_nr.sizes /lab/jaenisch_albert/genomes/mm9/fa/byChr/ scriptureOutput_byCellTypes groups/cellTypes.grp



:<<'COMMENT'
	format:
		<groupName>=<FolderName1>,...
		groups=<groupName1>,...
COMMENT




chroms=( `cut -f1 $chromList` )
echo There were ${#chroms[@]} chromosomes $chroms loaded from $chromList

scriptDir=`pwd`

cd ..

source $groupFile

rootDir=`pwd`
tophatOutputDir=${rootDir}/tophatOutput

if [ -e $outputPrefix ]; then
	rm $outputPrefix #clean up everything!
fi



mkdir ${outputPrefix}

cd $outputPrefix
outputPrefix=`pwd`
cd $rootDir

if [[ $paired == 1 ]]; then
	scriptureOutputDir=${rootDir}/scriptureOutput_paired
else
	scriptureOutputDir=${rootDir}/scriptureOutput
fi

#parse the groups variable into an array 
saveIFS=$IFS
IFS=`echo -en ","`
declare -a groups=($groups)
IFS=$saveIFS

#for each group
for thisGroup in ${groups[@]}; do

	#make output folder for this group
	thisGroupDir=${outputPrefix}/${thisGroup}
	
	mkdir $thisGroupDir
	
	vname=${thisGroup}
	filelist=${!vname}
	
	saveIFS=$IFS
	IFS=`echo -en ","`
	declare -a filelist=($filelist)
	IFS=$saveIFS
#concatenate all alignment files
	for perFolder in ${filelist[@]}; do
		cat $scriptureOutputDir/$perFolder/sorted*.sam >> ${thisGroupDir}/all_alignments.sam  
	done
	
	cd $thisGroupDir

	cellspecificalignment=all_alignments.sam
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
		for perFolder in ${filelist[@]}; do
			cat $scriptureOutputDir/$perFolder/paired.sam >> ${thisGroupDir}/all_alignments.paired.sam  
		done
			
		#use SamTools for BAM instead
		echo "convert ${pref}.paired.sam to ${pref}.paired.bam"
		samtools view -b -S -t $chromList -o ${pref}.paired.bam ${pref}.paired.sam
		
		echo "sort ${pref}.paired.bam as ${pref}.paired.sorted.bam"
		samtools sort ${pref}.paired.bam ${pref}.paired.sorted
		
		echo "index ${pref}.paired.sorted.bam as ${pref}.sorted.bam.bai"
		samtools index ${pref}.paired.sorted.bam
		
		#now we have ${pref}.paired.sorted.bam and ${pref}.paired.sorted.bam.bai
	
		
		
	fi

	#now we can run scripture
	#do this for each chromosome
	
	for chrom in ${chroms[@]}; do
	echo submitting scripture segment task for chrom $chrom to cluster
		if [[ $paired == 1 ]]; then
			#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd all_alignments.paired.sorted.sam
			 bsub scripture -alignment ${pref}.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa -pairedEnd ${pref}.paired.sorted.bam
		else
			#bsub scripture -alignment all_alignments.sorted.sam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
			bsub scripture -alignment ${pref}.sorted.bam -out $chrom.scriptureESTest.segments -sizeFile $chromList -chr $chrom -chrSequence $chromFaDir/${chrom}.fa 
		fi
	done

	cd ..

done