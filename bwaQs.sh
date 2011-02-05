source ~/.bashrc
source fileUtils.sh
source ./initvars.sh

source $configDir/bwa.config.sh
source $tophatshvar




saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)

for sample in ${samples[@]}; do
	echo readching $sample
	for Qt in ${QThresholds[@]}; do
		samp_outdir=$samseDir/$sample/processed_Q$Qt/
		samp_outdirsorted=$samseDir/$sample/processed_Q$Qt/sorted/
		mkdir $samp_outdir
		mkdir $samp_outdirsorted
		for samfile in $samseDir/$sample/*.sam; do
			samfilebasename=`basename $samfile`
			echo processing $samfilebasename
			python partReadChrGeneric.py $samfile sam $samp_outdir/${samfilebasename/.sam/}. .SAM 10 > $samp_outdir/${samfilebasename/.sam/}.part.stdout 2> $samp_outdir/${samfilebasename/.sam/}.part.stderr
			#now sort
			bash sortByCoordGeneric.sh $samp_outdir *.q10.SAM $samp_outdirsorted .s SAM
		done	
	done
done
