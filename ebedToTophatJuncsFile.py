from sys import *


def printUsageAndExit(programName):
	print >> stderr,programName,"inebed outjuncs"
	exit(1)

if __name__=='__main__':
	
	programName=argv[0]
	args=argv[1:]
	
	try:
		inebed,outjuncs=args
	except:
		printUsageAndExit(programName)
	
	juncSet=set()
	
	fil=open(inebed)
	fout=open(outjuncs,"w")
	
	for lin in fil:
		lin=lin.rstrip("\r\n")
	
		if len(lin)<0:
			continue
		if lin[0]=='#':
			continue
		if lin[0:5]=='track':
			continue
		
		fields=lin.split("\t")
		
		try:
			chrom,chromStartG0,chromEndG1,name,score,strand,thickStartG0,thickEndG1,itemRGB,blockCount,blockSizes,blockStarts0=fields
			chromStartG0=int(chromStartG0)
			chromEndG1=int(chromEndG1)
			thickStartG0=int(thickStartG0)
			thickEndG1=int(thickEndG1)
			blockCount=int(blockCount)
			blockSizeSplits=blockSizes.split(",")
			blockSizes=[]
			for s in blockSizeSplits:
				s=s.strip()
				if len(s)>0:
					blockSizes.append(int(s))
			blockStarts0Splits=blockStarts0.split(",")
			blockStarts0=[]
			for s in blockStarts0Splits:
				s=s.strip()
				if len(s)>0:
					blockStarts0.append(int(s))		
					
			if len(blockStarts0)!=blockCount or len(blockSizes)!=blockCount:
				print >> stderr,"block count not consistent with blockStarts or blockSizes data"
				raise ValueError
		except:
			print >> stderr,"format error",fields
			raise ValueError
		
		exonStartsG0=[]
		exonEndsG1=[]
		
		for bStart0,bSize in zip(blockStarts0,blockSizes):
			exonStartsG0.append(bStart0+chromStartG0)
			exonEndsG1.append(bStart0+chromStartG0+bSize)
		
		for i in range(0,blockCount-1):
			juncSet.add((chrom,exonEndsG1[i]-1,exonStartsG0[i+1],strand))
	


	for a,b,c,d in juncSet:
		print >> fout,"%s\t%d\t%d\t%s" %(a,b,c,d)
		
	fil.close()
	fout.close()