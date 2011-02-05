
TESTSTDOUT=$1
TESTSTDERR=$2
TESTNAME=$3
NODENAME=$4
OKNODESLOG=$5

stdoutLength=`wc -l $TESTSTDOUT | cut -d" " -f1`
stderrLength=`wc -l $TESTSTDERR | cut -d" " -f1`

echo stdout=$stdoutLength stderr=$stderrLength

if [ $stdoutLength -eq 3 ]; then
	if [ $stderrLength -lt 1 ]; then
		echo $NODENAME is ok!
		echo -n $NODENAME, >> $OKNODESLOG
	else
		echo error occured for some network drive
		cat $TESTSTDERR
	fi
else
	echo $NODENAME does not response within time allowed
fi
	

rm $TESTSTDOUT
rm $TESTSTDERR

