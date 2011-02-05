#!/usr/bin/python

import sys;
from sys import *
from getopt import getopt

def printUsageAndExit(programName):
	print >> stderr,programName,"infile format[SAM|MAPVIEW] prefix suffix Qthreshold(>=)[=-1|Qt]"
	exit()


if __name__=="__main__":

	programName=argv[0]
	
	qLessThanInfix=".qlt"
	qGreaterEqualInfix=".q"


		
	try:
		opts,args=getopt(argv[1:],'',['qLessThanInfix=','qGreaterEqualInfix'])
		for o,v in opts:
			if o=='qLessThanInfix':
				qLessThanInfix=v
			elif o=="qGreaterEqualInfix":
				qGreaterEqualInfix=v
		infile,format,prefix,suffix,Qt=args
	except:
		printUsageAndExit(programName)

	Qt=int(Qt)

	filewriters=dict();
	linos=dict();

	format=format.upper()

	if format=="MAPVIEW":
		chrcol0=1
		Qcol0=6
	elif format=="SAM":
		chrcol0=2
		Qcol0=4
	else:
		print >> stderr,"unknown format",format
		printUsageAndExit(programName)



	
	linog=0;

	linojnx=0;

	linogQ=0
	linojQ=0
	linogQlt=0
	linojQlt=0
	linounmapped=0
	
	

	
	filMapview=open(infile);
	lino=0;
	for line in filMapview:
		lino+=1;
		if(lino % 100000==1):
			print >>sys.stderr, "processing",format+"-formated read map line "+str(lino);
		isJnx=False;
				
		if format=="SAM" and line[0]=='@':
			#header,ignore
			continue

		splitons=line.split("\t");
			
		if format=="SAM" and len(splitons)<11:
			#strangely formated line, ignore
			continue
		try:
			chrom=splitons[chrcol0];
			Q=int(splitons[Qcol0])
			chrForLine="";
			sp=chrom.split("|");
		except:
			print >> stderr,"error processing line",lino,"=",splitons,"ignored"
			continue
		
		if(len(sp)>1): # a jnx in form of setName:jnxID
			chrForLine=sp[0];
			isJnx=True;
		else:
			chrForLine=chrom;
		
		filw=None;
		
		infix=chrForLine;
		
		mapped=True

		if infix=="*":
			infix="unmapped"
			linounmapped+=1
			mapped=False

		
		if isJnx:
			infix+=".j";
			linojnx+=1;
		else:
			if mapped:
				linog+=1;
			infix+=".g";
		
		if Qt>-1:
			if Q<Qt:
				infix+=qLessThanInfix+str(Qt)
				if isJnx:
					linojQlt+=1
				else:
					if mapped:
						linogQlt+=1
			else: #Q>=Qt
				infix+=qGreaterEqualInfix+str(Qt)
				if isJnx:
					linojQ+=1
				else:
					if mapped:
						linogQ+=1	
		
		if(filewriters.has_key(infix)):
			filw=filewriters[infix];	
		else:
			filw=open(prefix+infix+suffix,"w");
			filewriters[infix]=filw;
			linos[infix]=0;
			
		
		filw.write(line);
		linos[infix]+=1;
		if linos[infix]%10000==1:
			print >> stderr,infix,"<<",chrom,Q

	
	filMapview.close();
	keys=filewriters.keys();
	
	keys.sort()

	print >> sys.stderr, "total lines\t\tDstFile";
	print >> sys.stdout, "#\tsource\t\t"+sys.argv[1];
	print >> sys.stdout, "#\ttotal lines\t\tDstFile";
	for k in keys:
		print >> sys.stderr, str(linos[k])+"\t\t" +prefix+k+suffix;
		print >> sys.stdout, "#\t"+str(linos[k])+"\t\t" +prefix+k+suffix;

		filewriters[k].close();
	
	print >> sys.stderr, str(linog+linojnx+linounmapped)+ " total lines (" +str(linojnx)+" jnx,"+str(linog)+" non-jnx,"+str(linounmapped)+" unmapped) written";
	print >>sys.stdout,"#";
	
	print >> sys.stdout, "#\t"+str(linog+linojnx+linounmapped)+ " total lines (" +str(linojnx)+" jnx,"+str(linog)+" non-jnx,"+str(linounmapped)+" unmapped) written";
	print >> sys.stdout, "#\t"+str(lino)+" total lines of read map file processed";
	print >> sys.stderr, str(lino)+" total lines of read map file processed";

	#now the bash readable format:
	print >> sys.stdout, 'infile="%s"' %(infile)
	print >> sys.stdout, "totalLines=%d" %(lino)
	print >> sys.stdout, "totalReads=%d" %(linog+linojnx+linounmapped)
	print >> sys.stdout, "totalReadsMapped=%d" %(linog+linojnx)
	print >> sys.stdout, "totalReadsUnmapped=%d" %(linounmapped)
	print >> sys.stdout, "totalReadsMappedToGenome=%d" %(linog)
	print >> sys.stdout, "totalReadsMappedToJnx=%d" %(linojnx)
	print >> sys.stdout, "totalReadsPassQ=%d" %(linogQ+linojQ)
	print >> sys.stdout, "totalGenomicReadsPassQ=%d" %(linogQ)
	print >> sys.stdout, "totalJnxReadsPassQ=%d" %(linojQ)
	print >> sys.stdout, "totalReadsNotPassQ=%d" %(linogQlt+linojQlt)	
	print >> sys.stdout, "totalGenomicReadsNotPassQ=%d" %(linogQlt)
	print >> sys.stdout, "totalJnxReadsNotPassQ=%d" %(linojQlt)
	
	
		
	


