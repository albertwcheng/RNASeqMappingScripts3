#!/bin/bash


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
bsub bash runMACSOnBowtieFolderJobArgListSE.sh $sample 
done
