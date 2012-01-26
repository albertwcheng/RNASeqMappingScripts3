
genomeRootDir=/lab/jaenisch_albert/genomes/
genome=mm9
genomeSizes=${genomeRootDir}/${genome}/${genome}_nr.sizes

MISOPATH=/lab/jaenisch_albert/Apps/yarden/MixtureIsoforms/

thisScriptDir=`pwd`

cd ..

rootDir=`pwd`

tophatOutputDir=$rootDir/tophatOutput

#echo $tophatOutputDir

cd $MISOPATH 

for sampleDir in $tophatOutputDir/*; do

if [ ! -e $sampleDir/accepted_hits.sam ];  then
	#continue
	if [ -e $sampleDir/accepted_hits.bam ]; then
		#just sort and index
		bsub bash sortAndIndexBam.sh $sampleDir/accepted_hits		
	fi
	
	continue
fi

#echo $sampleDir
bsub python sam_to_bam.py --convert $sampleDir/accepted_hits.sam $sampleDir/ --ref ${genomeSizes}
done