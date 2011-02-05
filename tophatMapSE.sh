#!/bin/bash

source fileUtils.sh
source ./initvars.sh
source $tophatshvar

#requestEmptyDirWithWarning $tophatOutputDir

saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS
###nodenum=1

for sample in ${samples[*]}; do
	echo "initiate tophat for sample $sample"
	vname=${sample}
	lfilelist=${!vname}
	#lfilelist=`echo $lfilelist | tr "," "|"`


	echo left file list $lfilelist
	###nodehostname="episode-0$nodenum"
	
	#qsubcommand="qsub -v SAMPLENAME=$sample,LFILELIST=\"$lfilelist\",RFILELIST=\"$rfilelist\",SCRIPTDIR=$scriptDir -q $jobQueue  -e $queueJobStdWritePath/$sample.tophatqueue.err -m a -M $queueJobEmail -o $queueJobStdWritePath/$sample.tophatqueue.out $scriptDir/tophatMapJob.sh" ###-l nodes=$nodehostname	
	#echo $qsubcommand
	#eval $qsubcommand
	
	mkdir $tophatOutputDir/${sample}
	bsubcommand="bsub $scriptDir/tophatMapJobArgListSE.sh ${sample} $lfilelist $scriptDir"
	echo $bsubcommand
	eval $bsubcommand

	
	###nodenum=`expr $nodenum + 1`

	#declare -a filelist=(${!vname})
	#for fil in ${filelist[*]}; do
	#	echo "file $fil"
	#done
done


