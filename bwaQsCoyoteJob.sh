#PBS -v SAMINPREFIX,SAMSEOUTPREFIX,QTHRESHOLD,SAMPLE,SCRIPTDIR

#samseDir=$SAMINPREFIX
#samseOut=$SAMSEOUTPREFIX
#scriptDir=$SCRIPTDIR
#sample=$SAMPLE
#qThreshold=$QTHRESHOLD


samseDir=$1
samseOut=$2
qThreshold=$3
sample=$4
scriptDir=$5

cd $scriptDir

Qt=$qThreshold

samp_outdir=$samseOut/$sample/processed_Q$Qt/
samp_outdirsorted=$samseOut/$sample/processed_Q$Qt/sorted/
		
mkdir $samseOut;
		
mkdir $samseOut/$sample/
		
mkdir $samp_outdir
		
mkdir $samp_outdirsorted
		
for samfile in $samseDir/$sample/*.sam; do
			
	samfilebasename=`basename $samfile`
	echo processing $samfilebasename
	python partReadChrGeneric.py $samfile sam $samp_outdir/${samfilebasename/.sam/}. .SAM 10 > $samp_outdir/${samfilebasename/.sam/}.part.stdout 2> $samp_outdir/${samfilebasename/.sam/}.part.stderr
			#now sort
	bash sortByCoordGeneric.sh $samp_outdir *.q10.SAM $samp_outdirsorted .s SAM
done	

