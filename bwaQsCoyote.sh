source ~/.bashrc
source ./initvars.sh


source $configDir/bwa.config.sh
source $tophatshvar



saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS


for sample in ${samples[@]}; do
	for Qt in ${QThresholds[@]}; do
		echo reaching $sample

		##PBS -v SAMINPREFIX,SAMSEOUTPREFIX,QTHRESHOLD,SAMPLE,SCRIPTDIR
		#qsubcommand="qsub  -v SAMINPREFIX=\"$samseDir/\",SAMSEOUTPREFIX=\"$samseDirOutCoyote/\",QTHRESHOLD=$Qt,SAMPLE=\"$sample\",SCRIPTDIR=\"$scriptDir\" -q $jobQueue  -m a -M $queueJobEmail $scriptDir/bwaQsCoyoteJob.sh" ###-l nodes=$nodehostname	 -l nodes=${okNodes[dice]}
		qsubcommand="bsub bash $scriptDir/bwaQsCoyoteJob.sh $samseDir $samseDirOutCoyote $Qt $sample $scriptDir" ###-l nodes=$nodehostname	 -l nodes=${okNodes[dice]}
		echo $qsubcommand
		eval $qsubcommand
	done
done
