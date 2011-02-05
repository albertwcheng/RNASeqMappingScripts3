#!/bin/bash
#PBS -v SAMPLENAME,LFILELIST,RFILELIST,SCRIPTDIR



sampleName=$SAMPLENAME
lfilelist=$LFILELIST
rfilelist=$RFILELIST
scriptDir=$SCRIPTDIR

cd $scriptDir


source $scriptDir/initvars.sh  
source $configDir/tophat.config.sh 

sampleOutputDir=$tophatOutputDir/$sampleName

stdout_file=$sampleOutputDir/tophat.stdout
stderr_file=$sampleOutputDir/tophat.stderr



if [ ! -d $sampleOutputDir ]; then
	mkdir $sampleOutputDir
fi

cd $mergedsolfqDir

lfilelist=`echo $lfilelist | tr "|" ","`
rfilelist=`echo $rfilelist | tr "|" ","`

command="tophat $solexa_quality_flag $butterfly_search_flag $microexon_search_flag $no_novel_juncs_flag --mate-inner-dist $mate_inner_dist --mate-std-dev $mate_std_dev --min-anchor-length $min_anchor_length --min-isoform-fraction $min_isoform_fraction --num-threads $num_threads --max-multihits $max_multihits $GFF_flag $raw_junc_flag $other_options --output-dir $sampleOutputDir $ebwt_base $lfilelist $rfilelist >> $stdout_file 2>> $stderr_file"




echo $command > $stdout_file
echo $command > $stderr_file

date >> $stdout_file
date >> $stderr_file

#eval $command

date >> $stdout_file
date >> $stderr_file




