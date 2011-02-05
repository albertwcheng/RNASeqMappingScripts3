source ~/.bashrc
source fileUtils.sh
source ./initvars.sh

source $configDir/bwa.config.sh
source $tophatshvar



saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS
###nodenum=1



for sample in ${samples[*]}; do
	echo "initiate tophat for sample $sample"
	vname=${sample}
	lfilelist=${!vname}	

	IFS=`echo -en ","`
	declare -a lfilelist=($lfilelist)	
	
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
		#rfile=${rfilelist[i]}
		echo processing $lfile
		#dice=`roll_die $numOKNodes`
		#dice=`expr $dice - 1`
		#echo dice $dice ${okNodes[dice]}

		header="#!/bin/bash"		

		commandAlnL="bwa aln -n $ALN_N -o $ALN_o -e $ALN_e -d $ALN_d -i $ALN_i $ALN_l_FLAG -k $ALN_k -t $ALN_t -M $ALN_M -O $ALN_O -E $ALN_E $ALN_R_FLAG $ALN_c_FLAG $ALN_N_FLAG -q $ALN_q $genome $fastqDir/${lfile} > $saiDir/${lfile/.fastq/.sai} 2> $saiDir/${lfile/.fastq/.err}; echo done >> $saiDir/${lfile/.fastq/.err};"
		
		commandSamseL="bwa samse -n $SAMSE_n $genome $saiDir/${lfile/.fastq/.sai} $fastqDir/${lfile} > $sampleSamseOutDir/${lfile/.fastq/.sam} 2> $sampleSamseOutDir/${lfile/.fastq/.stderr}; echo done >> $sampleSamseOutDir/${lfile/.fastq/.stderr};"	


		if [ ! -d $configDir/queuejobs ]; then
			mkdir $configDir/queuejobs
		fi

		tmpshName=$configDir/queuejobs/bwa_sub_${lfile/.fastq/}.sh		
		
		
		echo $header > $tmpshName
		echo "#$tmpshName" >> $tmpshName
		echo "source ~/.bashrc" >> $tmpshName		
		echo $commandAlnL >> $tmpshName
		echo $commandSamseL >> $tmpshName


		
		cat $tmpshName

		#qsubcommand="qsub -e $queueJobStdWritePath/$sample.bwa.err -m a -M $queueJobEmail -o queueJobStdWritePath/$sample.bwa.out $tmpshName"
				
		bsubcommand="bsub bash $tmpshName"
		echo $bsubcommand
		eval $bsubcommand
	done
	
	
	IFS=$saveIFS


done




exit;

command="echo 'source ~/.bashrc;  bwa index $indexFlag $genome > $logprefix/$genomeName.bwa_index.stdout 2> $logprefix/$genomeName.bwa_index.stderr' | qsub -l nodes=$nodehostname -q $jobQueue -m a -M $queueJobEmail -"

echo $command
eval $command
