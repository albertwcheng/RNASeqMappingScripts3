sampleName=$1
paired=$2


targetSam="accepted_hits.sam"
targetBam="accepted_hits.bam"
#according to scripture manual and examples

scriptDir=`pwd`

cd ..

rootDir=`pwd`



bowtieOutputDir=${rootDir}/bowtieOutput
macsOutputDir=${rootDir}/macsOutput



if [ ! -e $macsOutputDir ]; then
	mkdir $macsOutputDir
fi

mkdir.py $macsOutputDir/$sampleName

cd $macsOutputDir/$sampleName


format="BAM"
tsize=36
space=25
mfold="10,30"
macs="macs14"

if [ ! -e $bowtieOutputDir/$sampleName/$targetBam ]; then
	#target bam file no exist, make it
	echo "targert bam file not exist, make it"
	samtools view -bS -o $bowtieOutputDir/$sampleName/$targetBam $bowtieOutputDir/$sampleName/$targetSam >  $bowtieOutputDir/$sampleName/$targetBam.stdout 2>  $bowtieOutputDir/$sampleName/$targetBam.stderr
fi

echo "run macs"
$macs -t $bowtieOutputDir/$sampleName/$targetBam --format=$format --name=$sampleName --tsize=$tsize --wig --space=$space --mfold="$mfold" > $macsOutputDir/$sampleName/macs.stdout 2> $macsOutputDir/$sampleName/macs.stderr


