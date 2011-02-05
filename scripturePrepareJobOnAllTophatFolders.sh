#!/bin/bash

if [ $# -lt 1 ]; then
	echo $0 paired [ 1 or 0 ]
	exit
fi

source fileUtils.sh
source ./initvars.sh
source $tophatshvar

saveIFS=$IFS
IFS=`echo -en ","`
declare -a samples=($Samples)
IFS=$saveIFS

paired=$1

scriptDir=`pwd`

for sample in ${samples[@]}; do
bsub bash scripturePrepareJobOnTophatFolder.sh $sample $paired
done

	