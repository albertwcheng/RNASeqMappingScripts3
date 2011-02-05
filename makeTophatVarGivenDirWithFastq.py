#!/usr/bin/python

from sys import *
from getopt import getopt
from os.path import *
from os import listdir

def printUsageAndExit(programName):
	print >> stderr,programName,"where_is_fastq"	
	print >> stderr,"options:"
	print >> stderr,"--paired pairedreads"
	print >> stderr,"--file-sep the filename separator e.g., s_1_2_sequence.txt, file sep is _ [default is _]"
	print >> stderr,"--paired-index the id of the split field to get pairing id. e.g., s_1_2_sequence.txt after splitting with _ is s,1,2,sequence.txt, paired-index is -2 which is 2 here. [default: -2]"
	print >> stderr,"--ext-fastq set the extension of fastq [default is fastq]"
	exit()

def getExtension(filename):
	return filename.split(".")[-1]

if __name__=='__main__':
	programName=argv[0]
	opts,args=getopt(argv[1:],'',['paired','file-sep=','paired-index=','ext-fastq='])
	
	paired=False
	pairedSep="_"
	pariedIdx=-2
	fastqExt="fastq"

	for o,v in opts:
		if o=='--paired':
			paired=True
		elif o=='--file-sep':
			pairedSep=v
		elif o=='--paired-index':
			pairedIdx=int(v)
		elif o=='--ext-fastq':
			fastqExt=v
	try:
		where,=args
	except:
		printUsageAndExit(programName)

	samples=[]
	

	listOfFiles=listdir(where)
	for filename in listOfFiles:
		if getExtension(filename)==fastqExt:
				
