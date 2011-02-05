#!/bin/bash

if [ $# -lt 3 ]; then
	echo $0 "sampleName fileList (sep by |) scriptDir"
fi

sampleName=$1
filelist=$2
scriptDir=$3

cd $scriptDir


source $scriptDir/initvars.sh  
source $configDir/tophat.config.sh 

sampleOutputDir=$tophatOutputDir/$sampleName

stdout_file=$sampleOutputDir/tophat.stdout
stderr_file=$sampleOutputDir/tophat.stderr



if [ ! -d $sampleOutputDir ]; then
	mkdir $sampleOutputDir
fi

cd $fastqDir #use fastq files instead!

#filelist=`echo $filelist | tr "|" ","`


command="tophat --output-dir $sampleOutputDir $BOWTIE_INDEXES/$ebwt_base $filelist >> $stdout_file 2>> $stderr_file"




echo $command > $stdout_file
echo $command > $stderr_file

date >> $stdout_file
date >> $stderr_file

eval $command

date >> $stdout_file
date >> $stderr_file




