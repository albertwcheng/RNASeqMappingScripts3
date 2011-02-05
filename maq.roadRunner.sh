#!/bin/bash

source ./initvars.sh
source $configDir/maq.config.sh


if [ $# -lt 1 ]; then 
echo "Usage maq.roadRunner.sh sampleName"
exit; 
fi

sampleName=$1



outputpref=$mapDir/$sampleName
readpref=$bfqDir/$sampleName

#outputpref="/nfs/coldfact/awcheng/Bill/Blood/maps.rr/$sampleName"; ##
#readpref="/nfs/coldfact/awcheng/Bill/Blood/bfq/$sampleName"; ###

partdir=$scriptDir

#if [ -e $outputpref ]; then
#	echo "$outputpref exists, delete it"
#	rm -R $outputpref
#fi;

#echo "making dir $outputpref"
#mkdir $outputpref

cd "$readpref";

#ls
for i in *.bfq; 
	do
	echo "queueing $i";
	#echo "-o $outputpref/$i.q.stdout -e $outputpref/$i.q.stderr"
	qsub -v READFILENAME=$i,SAMPLENAME=$sampleName,SCRIPTDIR=$scriptDir,LOGPATH=$outputpref/$i.q.stdout -q long "$partdir/maq.roadRunner.part.sh"  ####  -o "$outputpref/$i.q.stdout" -e "$outputpref/$i.q.stderr" 
done;




