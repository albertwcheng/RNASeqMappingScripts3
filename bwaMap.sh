source ~/.bashrc
source fileUtils.sh
source rollDie.sh #for randomizing nodes to run jobs
source ./initvars.sh

source $configDir/bwa.config.sh
source $tophatshvar

#bash testNodes.sh testNodes.config.sh BWATESTNODES
#source okNodes.BWATESTNODES.txt


saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
declare -a okNodes=($okNodes)
IFS=$saveIFS
###nodenum=1
numOKNodes=${#okNodes[*]}
numOKNodes=`expr $numOKNodes - 1`
echo numOKNodes=$numOKNodes

for sample in ${samples[*]}; do
	echo "initiate tophat for sample $sample"
	vname=${sample}_1
	lfilelist=${!vname}	
	vname=${sample}_2
	rfilelist=${!vname}

	IFS=`echo -en ","`
	declare -a lfilelist=($lfilelist)	
	declare -a rfilelist=($rfilelist)
	
	sizeFile=${#lfilelist[@]}

	
	if [ ! -d $saiDir ]; then
		mkdir $saiDir
	fi


	if [ ! -d $sampeDir ]; then
		mkdir $sampeDir
	fi

	if [ ! -d $samseDir ]; then
		mkdir $samseDir
	fi


	sampleSampeOutDir=$sampeDir/$sample
	sampleSamseOutDir=$samseDir/$sample



	if [ ! -d $sampleSampeOutDir ];then
		mkdir $sampleSampeOutDir
	fi

	if [ ! -d $sampleSamseOutDir ]; then
		mkdir $sampleSamseOutDir
	fi
	
	for((i=0;i<$sizeFile;i++)); do

		lfile=${lfilelist[i]}
		rfile=${rfilelist[i]}
		echo processing pair $lfile $rfile
		dice=`roll_die $numOKNodes`
		dice=`expr $dice - 1`
		echo dice $dice ${okNodes[dice]}

		header="#!/bin/bash"		

		commandAlnL="bwa aln -n $ALN_N -o $ALN_o -e $ALN_e -d $ALN_d -i $ALN_i $ALN_l_FLAG -k $ALN_k -t $ALN_t -M $ALN_M -O $ALN_O -E $ALN_E $ALN_R_FLAG $ALN_c_FLAG $ALN_N_FLAG -q $ALN_q $genome $fastqDir/${lfile/.txt/.fastq} > $saiDir/${lfile/.txt/.sai} 2> $saiDir/${lfile/.txt/.err}; echo done >> $saiDir/${lfile/.txt/.err};"
		commandAlnR="bwa aln -n $ALN_N -o $ALN_o -e $ALN_e -d $ALN_d -i $ALN_i $ALN_l_FLAG -k $ALN_k -t $ALN_t -M $ALN_M -O $ALN_O -E $ALN_E $ALN_R_FLAG $ALN_c_FLAG $ALN_N_FLAG -q $ALN_q $genome $fastqDir/${rfile/.txt/.fastq} > $saiDir/${rfile/.txt/.sai} 2> $saiDir/${rfile/.txt/.err}; echo done >> $saiDir/${rfile/.txt/.err};"		
		
		commandSamseL="bwa samse -n $SAMSE_n $genome $saiDir/${lfile/.txt/.sai} $fastqDir/${lfile/.txt/.fastq} > $sampleSamseOutDir/${lfile/.txt/.sam} 2> $sampleSamseOutDir/${lfile/.txt/.stderr}; echo done >> $sampleSamseOutDir/${lfile/.txt/.stderr};"	
		commandSamseR="bwa samse -n $SAMSE_n $genome $saiDir/${rfile/.txt/.sai} $fastqDir/${rfile/.txt/.fastq} > $sampleSamseOutDir/${rfile/.txt/.sam} 2> $sampleSamseOutDir/${rfile/.txt/.stderr}; echo done >> $sampleSamseOutDir/${rfile/.txt/.stderr};"	
		
		commandSampe="bwa sampe -a $SAMPE_a -o $SAMPE_o $genome $saiDir/${lfile/.txt/.sai} $saiDir/${rfile/.txt/.sai} $fastqDir/${lfile/.txt/.fastq} $fastqDir/${rfile/.txt/.fastq} > $sampleSampeOutDir/${lfile/_1.txt/.sam} 2> $sampleSampeOutDir/${lfile/_1.txt/.stderr}; echo done >> $sampleSampeOutDir/${lfile/_1.txt/.stderr};"

		if [ ! -d $configDir/queuejobs ]; then
			mkdir $configDir/queuejobs
		fi

		tmpshName=$configDir/queuejobs/bwa_sub_${lfile/.txt/}.${rfile/.txt/}.sh		
		
		
		echo $header > $tmpshName
		echo "#$tmpshName" >> $tmpshName
		echo "source ~/.bashrc" >> $tmpshName		
		echo $commandAlnL >> $tmpshName
		
		echo $commandAlnR >> $tmpshName
		echo $commandSamseL >> $tmpshName
		echo $commandSamseR >> $tmpshName
		echo $commandSampe >> $tmpshName
		
		cat $tmpshName

		qsubcommand="qsub -e $queueJobStdWritePath/$sample.bwa.err -m a -M $queueJobEmail -o queueJobStdWritePath/$sample.bwa.out $tmpshName"
		#qsubcommand="qsub -l nodes=${okNodes[dice]} -e $queueJobStdWritePath/$sample.bwa.err -m a -M $queueJobEmail -o queueJobStdWritePath/$sample.bwa.out $tmpshName"
				

		echo $qsubcommand
		eval $qsubcommand
	done
	
	
	IFS=$saveIFS

	#echo left file list $lfilelist
	#echo right file list $rfilelist
	###nodehostname="episode-0$nodenum"
	
	#qsubcommand="qsub -v SAMPLENAME=$sample,LFILELIST=\"$lfilelist\",RFILELIST=\"$rfilelist\",SCRIPTDIR=$scriptDir -q $jobQueue  -e $queueJobStdWritePath/$sample.tophatqueue.err -m a -M $queueJobEmail -o queueJobStdWritePath/$sample.tophatqueue.out $scriptDir/tophatMapJob.sh" ###-l nodes=$nodehostname	
	#echo $qsubcommand
	#eval $qsubcommand
	
	###nodenum=`expr $nodenum + 1`

	#declare -a filelist=(${!vname})
	#for fil in ${filelist[*]}; do
	#	echo "file $fil"
	#done
done




exit;

command="echo 'source ~/.bashrc;  bwa index $indexFlag $genome > $logprefix/$genomeName.bwa_index.stdout 2> $logprefix/$genomeName.bwa_index.stderr' | qsub -l nodes=$nodehostname -q $jobQueue -m a -M $queueJobEmail -"

echo $command
eval $command
