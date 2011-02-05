#!/bin/bash

#
#  updated 11-03-2009
#  Albert Cheng merged experiments into solexareads
#
#


if [ $# -lt 2 ]; then
	echo Usage: $0 "manifestfile" "readPairSeparator[usu # in WI]"
	exit;
fi


source ./initvars.sh

#Usage ./simplifyPairs.py pair1File pair2File prefixNewID readpairseparator > combinedFile 2> newID2OldID.list
#maq='/mit/awcheng/Desktop/App/maq-0.6.7.roadrunner/maq'
#maq='maq' maq not used here

manifestFile=$1
readPairSeparator=$2

saveIFS=$IFS
IFS=`echo -en "\n\b"`
sampleString=`cat $solexaOuputDir/$manifestFile`
declare -a samples=($sampleString)

#echo ${samples[0]}


sampleStringFlattened=`echo ${samples[*]} | tr " " ","`

echo "Samples=$sampleStringFlattened" > $tophatshvar


for sample in ${samples[*]}; do
	
	echo "entering sample $sample"
	cd $solexaOuputDir/$sample
	declare -a files=(`ls | tr " " "\n"`)
	howmanyfiles=${#files[*]}
	
	one_string=""
	two_string=""

	for((i=0;i<$howmanyfiles;i+=2)); 
		do		
		
		

		file1=${files[$i]}
		file2=${files[`expr $i + 1`]}
		replicateIndex=`expr $i / 2 + 1`
		basesolfqfile=${sample}_${replicateIndex}
		mergedsolfqfile=$mergedsolfqDir/$basesolfqfile
		echo "pairing replicate $replicateIndex $file1 $file2 to ${mergedsolfqfile}.txt"

		if [ $i -eq 0 ]; then
			one_string="${sample}_1=${basesolfqfile}_1.txt"
			two_string="${sample}_2=${basesolfqfile}_2.txt"
		else
			one_string=$one_string",${basesolfqfile}_1.txt"
			two_string=$two_string",${basesolfqfile}_2.txt"
		fi
			
		python $scriptDir/renamePairs.py $file1 $file2 "${sample}:${replicateIndex}" $readPairSeparator $mergedsolfqfile 2> ${mergedsolfqfile}.list
	done

	echo $one_string >> $tophatshvar
	echo $two_string >> $tophatshvar
	cd $scriptDir
done	
	


cd $scriptDir


IFS=$saveIFS


#./simplifyPairs.py ../R2r/s_5_1_sequence.txt ../R2r/s_5_2_sequence.txt R2 '#' > ../R2.txt 2> ../R2.list
#./simplifyPairs.py ../R3r/s_6_1_sequence.txt ../R3r/s_6_2_sequence.txt R3 '#' > ../R3.txt 2> ../R3.list
#./simplifyPairs.py ../R4r/s_7_1_sequence.txt ../R4r/s_7_2_sequence.txt R4 '#' > ../R4.txt 2> ../R4.list
#./simplifyPairs.py ../R5r/s_8_1_sequence.txt ../R5r/s_8_2_sequence.txt R5 '#' > ../R5.txt 2> ../R5.list

