#!/bin/bash


:<<'COMMENT'

#sampleGroup.txt
sampleGroups=( A B C )
A=( A1 A2 A3 )
B=( B1 B2 )
C=( C1 C2 C3 C4)

COMMENT

if [ $# -lt 3 ]; then
	echo $0 "sampleGroupFile newBwaParent Qthreshold"
	exit
fi

sampleGroupFile=$1
newBwaParent=$2
Qthreshold=$3

newBwaParent=`abspath.py $newBwaParent`
newBwaSamseDir=$newBwaParent/samse

mkdir.py $newBwaSamseDir
source $sampleGroupFile


cd ..

cd samse

for sampleGroup in ${sampleGroups[@]}; do
	rm -Rf $newBwaSamseDir/$sampleGroup
	mkdir.py $newBwaSamseDir/$sampleGroup
	vname=${sampleGroup}
	
	retriever="echo \${$vname[@]}"
	sampleList=(`eval $retriever`)
	

	for sample in ${sampleList[@]};do
		echo $sample for $sampleGroup
		for srcFile in $sample/processed_Q${Qthreshold}/sorted/*.SAM.s; do
			bnSrcFile=`basename $srcFile`
			ln $srcFile $newBwaSamseDir/$sampleGroup/$sample.$bnSrcFile
		done
	done

done

