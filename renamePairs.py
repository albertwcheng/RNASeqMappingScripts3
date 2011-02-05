#!/usr/bin/python

#renamePairs.py pair1file pair2file prefix separator > combinedFile 2> newID2OldID.list
#version 2

#prefix#read_no/pair_index

preReadNo="#"
prePairIndex="/"

from sys import stdout, stderr, argv, exit


	
try:
	file1,file2,prefix,separator,filePrefix=argv[1:]
except ValueError:
	print >> stderr,"Usage",argv[0],"pair1File pair2File prefixNewID readpairseparator combinedFilePrefix 2> newID2OldID.list"
	exit()


print >> stderr, prefix+"\t"+file1+"\t"+file2

file1=open(file1)
file2=open(file2)

ofile1=open(filePrefix+"_1.txt","w")
ofile2=open(filePrefix+"_2.txt","w")

lino=-1

bufferedLines1=[0,0,0,0]
bufferedLines2=[0,0,0,0]
entryNo=0

for line1 in file1:
	lino+=1
	line2=file2.readline()
	line1=line1.strip()
	line2=line2.strip()
	stage=(lino%4)+1
	if stage==1: #FIRST LINE IS IDENTIFIER; CHECK MATCHING.
		pairid1=line1.split(separator)[0]
		pairid2=line2.split(separator)[0]
		if pairid1!=pairid2:
			print >> stderr,"error: inconsistent read pair id",pairid1,pairid2
			exit()

		entryNo+=1

		pairedName=prefix+preReadNo+str(entryNo)
		origName1=line1
		origName2=line2		

		bufferedLines1[stage-1]="@"+pairedName+prePairIndex+"1"
		bufferedLines2[stage-1]="@"+pairedName+prePairIndex+"2"
	elif stage==3:
		bufferedLines1[stage-1]="+"
		bufferedLines2[stage-1]="+"
	elif stage==4:
		bufferedLines1[stage-1]=line1
		bufferedLines2[stage-1]=line2
		#now output	
		print >> stderr,pairedName+"\t"+origName1+"\t"+origName2
		
		for l in bufferedLines1:
			print >> ofile1, l
		
		for l in bufferedLines2:
			print >> ofile2, l
			
	else:
		bufferedLines1[stage-1]=line1
		bufferedLines2[stage-1]=line2

		
print >> stderr,"#total number of readpairs processed",entryNo
				
		

file1.close()
file2.close()
ofile1.close()
ofile2.close()
			
