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
		
		qsubcommand="bsub bash $scriptDir/bwaQsCoyoteJob.sh $samseDir $samseDirOutCoyote $Qt $sample $scriptDir"
		echo $qsubcommand
		eval $qsubcommand
	done
done
