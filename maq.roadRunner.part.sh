#!/bin/bash
#PBS -v READFILENAME,SAMPLENAME,SCRIPTDIR,LOGPATH

# $READFILENAME read file, 

readfile=$READFILENAME;
sampleName=$SAMPLENAME;
scriptDir=$SCRIPTDIR;
logPath=$LOGPATH

cd $scriptDir

#pwd > $logPath

source ./initvars.sh 

echo "configDir=$configDir" >> $logPath

source $configDir/maq.config.sh

echo "sampleName=$sampleName" >> $logPath
echo "readfile=$readfile" >> $logPath
echo "scriptDir=$scriptDir" >> $logPath
echo "PATH=$PATH" >> $logPath

date >> $logPath

#genome="/nfs/coldfact/awcheng/genomes/mm9/mm9A/bfa/mm9=Av1_r36m1.bfa"; ##
#outputpref="/nfs/coldfact/awcheng/Bill/Blood/maps.rr/$sampleName"; ##
#maq="/mit/awcheng/Desktop/App/maq-0.6.7.roadrunner/maq ";

#readpref="/nfs/coldfact/awcheng/Bill/Blood/bfq/$sampleName"; ###

readpref=$bfqDir/$sampleName
outputpref=$mapDir/$sampleName

echo "genome=$genome" >> $logPath
echo "outputpref=$outputpref" >> $logPath
echo "maq=$maq" >> $logPath
echo "readpref=$readpref" >> $logPath
echo "hostname=" `hostname` >> $logPath



stderrfile="$outputpref/$readfile.maq.stderr";
stdoutfile="$outputpref/$readfile.maq.stdout";

rm $stderrfile;
rm $stdoutfile;

#cd "$readpref";

filename="$outputpref/$readfile.$mapinfix.map"; ##
 

echo "mapping $readfile onto $genome as $filename" >> $logPath
command="$maq map -u $filename.unmap -H $filename.01mismatch $filename $genome $readpref/$readfile >> $stdoutfile 2>> $stderrfile";
echo "running command $command" >> $logPath

eval $command;

echo "done mapping $i" >> $logPath

if [ ! -d $readpref/finished ]; then
	mkdir $readpref/finished
fi

mv $readpref/$readfile $readpref/finished/$readfile

date >> $logPath


