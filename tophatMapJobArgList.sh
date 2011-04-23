#!/bin/bash



if [ $# -lt 4 ]; then
	echo $0 sampleName lfilelist rfilelist scriptDir
	exit
fi

sampleName=$1
lfilelist=$2
rfilelist=$3
scriptDir=$4

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




#$solexa_quality_flag
command="tophat $solexa_quality_flag $butterfly_search_flag $microexon_search_flag $no_novel_juncs_flag --mate-inner-dist $mate_inner_dist --mate-std-dev $mate_std_dev --min-anchor-length $min_anchor_length --min-isoform-fraction $min_isoform_fraction --num-threads $num_threads --max-multihits $max_multihits $GFF_flag $JUNCS_flag  $other_options --output-dir $sampleOutputDir $BOWTIE_INDEXES/$ebwt_base $lfilelist $rfilelist >> $stdout_file 2>> $stderr_file" #$tophat_command




echo $command > $stdout_file
echo $command > $stderr_file
#echo "PATH=${PATH}" >> $stderr_file
#echo tophat=`which tophat` >> $stderr_file


date >> $stdout_file
date >> $stderr_file

#$tophat_command  $butterfly_search_flag $microexon_search_flag $no_novel_juncs_flag --mate-inner-dist $mate_inner_dist --mate-std-dev $mate_std_dev --min-anchor-length $min_anchor_length --min-isoform-fraction $min_isoform_fraction --num-threads $num_threads --max-multihits $max_multihits $GFF_flag $JUNCS_flag  $other_options --output-dir $sampleOutputDir $BOWTIE_INDEXES/$ebwt_base $lfilelist $rfilelist >> $stdout_file 2>> $stderr_file  ###
eval $command

date >> $stdout_file
date >> $stderr_file



