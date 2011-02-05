#!/bin/bash


source fileUtils.sh
source ./initvars.sh
source $tophatshvar

#$tophatOutputDir

#echo $Samples

saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS

for sample in ${samples[*]}; do
	echo "initiate cufflink for sample $sample"
	samFile="$tophatOutputDir/$sample/$samFileBaseName"	
	qsubcommand="qsub -v SAMPLENAME=$sample,SCRIPTDIR=$scriptDir,SAMFILE=$samFile -q $jobQueue -e $queueJobStdWritePath/$sample.cufflink.err -m a -M $queueJobEmail -o queueJobStdWritePath/$sample.cufflink.out $scriptDir/cuffLinkJob.sh" ###-l nodes=$nodehostname	
	echo $qsubcommand
	eval $qsubcommand
done
