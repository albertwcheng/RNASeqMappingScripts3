source fileUtils.sh
source ./initvars.sh

requestEmptyDirWithWarning $mergedsolfqDir

requestEmptyDirWithWarning $fastqDir

requestEmptyDirWithWarning $bfqDir

requestEmptyDirWithWarning $mapDir

askMkDirIfNotExist $logDir y

requestEmptyDirWithWarning $tophatOutputDir
