scriptDir=`pwd`
cd ..
rootDir=`pwd`
cd $scriptDir

source ~/.bashrc

#echo 'initvar'

solexaOuputDir=$rootDir/solexaOutputs

mergedsolfqDir=$rootDir/mergedsolfq
fastqDir=$rootDir/fastq
bfqDir=$rootDir/bfq
logDir=$rootDir/log
mapDir=$rootDir/maps.rr
configDir=$rootDir/config

saiDir=$rootDir/sai
sampeDir=$rootDir/sampe
samseDir=$rootDir/samse
samseDirOutCoyote=$rootDir/samse #/srv/crate-01/data/burge-stuff/awcheng/JohanData/samse   #    /net/crate-01/data/burge-stuff/awcheng/bill-samse/

tophatshvar=$logDir/tophat.shvar

#tophatOutputDir=$rootDir/tophatOutput2
tophatOutputDir=$rootDir/tophatOutput
bowtieOutputDir=$rootDir/bowtieOutput
 #/srv/crate-01/data/burge-stuff/awcheng/tophatOutput #    /net/crate-01/data/burge-stuff/awcheng/tophatOutput #####
cuffLinkOutputDir=#/srv/crate-01/data/burge-stuff/awcheng/cuffLinkOutput #    /net/crate-01/data/burge-stuff/awcheng/cuffLinkOutput ####

maq="maq" # in path??

queueJobEmail=albertwcheng@gmail.com ####
queueJobStdWritePath=/mit/awcheng #####
jobQueue=long  ####

samFileBaseName=accepted_hits.sam


function getSampleName {

	OIFS=$IFS
	IFS='_'
	declare -a splitter=( $1 )
	echo ${splitter[0]}
}

bsub_command="qsub"
tophat_command="/net/sugarman/scratch/awcheng/App/bin/tophat"
