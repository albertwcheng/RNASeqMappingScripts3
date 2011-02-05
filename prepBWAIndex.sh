
source ./initvars.sh
source ~/.bashrc
source $configDir/bwa.config.sh



command="echo 'source ~/.bashrc;  bwa index $indexFlag $genome > $logprefix/$genomeName.bwa_index.stdout 2> $logprefix/$genomeName.bwa_index.stderr' | qsub -l nodes=$nodehostname -q $jobQueue -m a -M $queueJobEmail -"

echo $command
eval $command
