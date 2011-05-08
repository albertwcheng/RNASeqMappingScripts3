#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 sourceParent outputParent groupFileRelToRoot
	exit
fi

sourceParent=$1
outputPrefix=$2
groupFile=$3


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


scriptDir=`pwd`

cd ..

source $groupFile

rootDir=`pwd`
tophatOutputDir=`abspath.py $sourceParent`

#if [ -e $outputPrefix ]; then
#	rm $outputPrefix #clean up everything!
#fi



mkdir.py ${outputPrefix}

cd $outputPrefix
outputPrefix=`pwd`
cd $rootDir


#parse the groups variable into an array 
saveIFS=$IFS
IFS=`echo -en ","`
declare -a groups=($groups)
IFS=$saveIFS

#for each group
for thisGroup in ${groups[@]}; do
	vname=${thisGroup}
	filelist=${!vname}
	filelistArray=(`echo $filelist | tr "," " "`)
	for((i=0;i<${#filelistArray[@]};i++)); do
		filelistArray[$i]="$tophatOutputDir/${filelistArray[$i]}/accepted_hits.sorted.bam"
	done
	
	mkdir.py $outputPrefix/$thisGroup
	
	cmd="samtools merge $outputPrefix/$thisGroup/accepted_hits.sorted.bam ${filelistArray[@]}"
	echo $cmd > $outputPrefix/merge_for_$thisGroup.sh
	cmd="samtools index $outputPrefix/$thisGroup/accepted_hits.sorted.bam"
	
	bsub bash $outputPrefix/merge_for_$thisGroup.sh
	#samtools merge $tophatOutputDir
done