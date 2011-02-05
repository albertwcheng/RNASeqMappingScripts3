source fileUtils.sh
source ./initvars.sh
source utilFuncs.sh
source ~/.bashrc


readPairSeparator="#" #### for WI

#bash ./initDirs.sh

#bash ./mergesolfq.sh manifest $readPairSeparator > $logDir/mergesolfq.stdout  2> $logDir/mergesol.stderr

#bash ./solfq2fq.sh > $logDir/solfq2fq.stdout 2> $logDir/solfq2fq.stderr

#bash ./fq2bfq.sh

bash ./maqmapAllSamples.sh manifest
