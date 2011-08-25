#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 sampleName lfilelist scriptDir
	exit
fi

sampleName=$1
lfilelist=$2
scriptDir=$3

cd $scriptDir


source $scriptDir/initvars.sh  
source $configDir/tophat.config.sh 

sampleOutputDir=$bowtieOutputDir/$sampleName

stdout_file=$sampleOutputDir/tophat.stdout
stderr_file=$sampleOutputDir/tophat.stderr



if [ ! -d $sampleOutputDir ]; then
	mkdir $sampleOutputDir
fi

cd $fastqDir ##use fastq dir the more standard one

#lfilelist=`echo $lfilelist | tr "|" ","`
#rfilelist=`echo $rfilelist | tr "|" ","`

echo BOWTIE_INDEXES=$BOWTIE_INDEXES

#$solexa_quality_flag
command="bowtie $other_options $BOWTIE_INDEXES $lfilelist $bowtieOutputDir/$sampleName/accepted_hits.sam >> $stdout_file 2>> $stderr_file"




echo $command > $stdout_file
echo $command > $stderr_file

date >> $stdout_file
date >> $stderr_file

eval $command

date >> $stdout_file
date >> $stderr_file



