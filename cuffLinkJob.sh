#!/bin/bash
#PBS -v SAMPLENAME,SCRIPTDIR,SAMFILE



sampleName=$SAMPLENAME
scriptDir=$SCRIPTDIR
samFile=$SAMFILE



cd $scriptDir


source $scriptDir/initvars.sh  
source $configDir/cufflink.config.sh 

if [ ! -d $cuffLinkOutputDir ]; then
	mkdir $cuffLinkOutputDir
fi


sampleOutputDir=$cuffLinkOutputDir/$sampleName

stdout_file=$sampleOutputDir/cufflink.stdout
stderr_file=$sampleOutputDir/cufflink.stderr



if [ ! -d $sampleOutputDir ]; then
	mkdir $sampleOutputDir
fi


cd $sampleOutputDir


command="cufflinks -m $inner_dist_mean -s $inner_dist_std_dev -I $max_intron_length -F $min_isoform_fraction -j $pre_mran_fraction -p $num_threads -Q $min_mapqual -L $label $GFFFlag $samFile >> $stdout_file  2>> $stderr_file"


echo $command > $stdout_file
echo $command > $stderr_file

echo "set current dir to" >> $stdout_file
echo "set current dir to" >> $stderr_file

pwd >> $stdout_file
pwd >> $stderr_file

#echo $SAMFILE >> $stderr_file


date >> $stdout_file
date >> $stderr_file

eval $command

date >> $stdout_file
date >> $stderr_file




