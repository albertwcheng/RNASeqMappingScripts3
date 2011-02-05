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

sampleOutputDir=$tophatOutputDir/$sampleName

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
command="tophat  $butterfly_search_flag $microexon_search_flag $no_novel_juncs_flag  --min-anchor-length $min_anchor_length --min-isoform-fraction $min_isoform_fraction --num-threads $num_threads --max-multihits $max_multihits $GFF_flag $raw_junc_flag $other_options --output-dir $sampleOutputDir $ebwt_base $lfilelist  >> $stdout_file 2>> $stderr_file"




echo $command > $stdout_file
echo $command > $stderr_file

date >> $stdout_file
date >> $stderr_file

eval $command

date >> $stdout_file
date >> $stderr_file



