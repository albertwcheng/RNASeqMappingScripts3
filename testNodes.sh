#!/bin/bash

####
#
#  This script goes into each node of a cluster, and run a test script specified in a configsh file defined in the argument.
#   The ok nodes are listed in okNodes.$testName.txt as a variable okNodes=node1,...,nodeN
#
####


currentPath=`pwd`

if [ $# -lt 1 ]; then
	echo $0 testConfig testName
	exit
fi



testName=$2
testConfig=$1

source ./$testConfig



###-l nodes=$nodehostname	

saveIFS=$IFS
IFS=`echo -en ","`
declare -a nodeNames=($nodeNames)
#declare -a jobNames=($nodeNames)
IFS=$saveIFS

jobNum=0

for nodeName in ${nodeNames[*]}; do
	jobNum=`expr $jobNum + 1`	
	
	echo "" > $currentPath/$nodeName.$testName.test.stdout
	echo "" > $currentPath/$nodeName.$testName.test.stderr 
	qsub -l nodes=$nodeName -v TESTSTDOUT=$currentPath/$nodeName.$testName.test.stdout,TESTSTDERR=$currentPath/$nodeName.$testName.test.stderr,TESTNAME=$testName,NODENAME=$nodeName $testNodeScript > qsub.tmp
	jobNames[$jobNum]=`cat qsub.tmp | cut -d"." -f1` 
	echo $jobNum : submitted test job to $nodeName as job ${jobNames[$jobNum]}
done


#qstat -n

echo waiting for $timeAllowed seconds
sleep $timeAllowed

#qstat -n

echo end waiting, see result

okNodes=""

echo -n "okNodes=" > okNodes.$testName.txt

jobNum=0
for nodeName in ${nodeNames[*]}; do
	jobNum=`expr $jobNum + 1`
	bash $resultValidationScript $currentPath/$nodeName.$testName.test.stdout $currentPath/$nodeName.$testName.test.stderr  $testName $nodeName  okNodes.$testName.txt
	curJobName=${jobNames[$jobNum]}
	echo deleting $curJobName 
	qdel $curJobName > /dev/null 2> /dev/null
done

echo OKNODES:
cat okNodes.$testName.txt
echo ""
echo "Done $0"


