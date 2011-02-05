source fileUtils.sh
source ./initvars.sh

askRmDirIfExist $mergedsolfqDir  y
if [ $? -eq 0 ]; then
	exit
fi
askRmDirIfExist $fastqDir y
if [ $? -eq 0 ]; then
	exit
fi
askRmDirIfExist $bfqDir y
if [ $? -eq 0 ]; then
	exit
fi

echo "<clean done>"
