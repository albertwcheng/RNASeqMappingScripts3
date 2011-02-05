#!/bin/sh

#if [ $# -lt 1 ]; then
#	echo Usage: $0 readDir
#	exit
#fi

source ./initvars.sh
#maq='/mit/awcheng/Desktop/App/maq-0.6.7.roadrunner/maq';
#maq should be in PATH
maq='maq'
#readDir='/nfs/coldfact/awcheng/Bill/Blood/fastq';

#readDir=$1
#cd $readDir;

cd $fastqDir

#if [ -e $logDir/fq2bfq.std* ]; then
#	rm $logDir/fq2bfq.std*
#fi

echo "" > $logDir/fq2bfq.stderr
echo "" > $logDir/fq2bfq.stdout

for i in *.fastq; do
	#echo $i >> "sol2sanger.stderr";
	#echo $i >> $logDir/


	
	nonExtFileName=${i/.fastq/}	

	sampleName=$(getSampleName "$i") #${i/.fastq/}
	
	echo "processing sample" $sampleName of file $i

	echo $i for sample $sampleName >> $logDir/fq2bfq.stderr    #"../bfq/fastq2bfq.stderr";
	echo $i for sample $sampleName >> $logDir/fq2bfq.stdout    #"../bfq/fastq2bfq.stdout";

	
	#if [ -e ../bfq/$sampleName ]; then
	#	rm -R ../bfq/$sampleName
	#fi;
	if [ ! -d $bfqDir/$sampleName ]; then
		mkdir $bfqDir/$sampleName
	fi;

	echo "now spliting $i"
	split -l 8000000 $i $bfqDir/$sampleName/$nonExtFileName

	for j in $bfqDir/$sampleName/${nonExtFileName}*; do
		echo "converting $j to the binary format" as $j.bfq
		$maq fastq2bfq  $j $j.bfq >> $logDir/fq2bfq.stdout  2>> $logDir/fq2bfq.stderr  
	done;

done;
	
