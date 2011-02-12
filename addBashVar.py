#!/usr/bin/env python


from sys import *
from types import *
import types
def readVDictFromFile(filename):
	vDict=dict()
	fil=open(filename)
	for lin in fil:
		lin=lin.rstrip("\r\n")
		if len(lin)<1:
			continue

		if lin[0]=="#":
			continue

		fields=lin.split("=")
		if len(fields)!=2:
			continue
		key=fields[0]
		try:
			ival=int(fields[1])
			fval=float(fields[1])
			if ival != fval:
				val=fval
			else:
				val=ival				
			key=fields[0]
			vDict[key]=val
		except:
			vDict[key]=fields[1].split(",")

			

	fil.close()
	return vDict

def writeVDictToFile(vDict,filename):
	fil=open(filename,"w")
	for key,val in vDict.items():
		if type(val)==types.ListType:
			print >> fil,key+"="+",".join(val)
		else:
			print >> fil,key+"="+str(val)

	fil.close()

if __name__=='__main__':
	programName=argv[0]
	args=argv[1:]
	
	try:
		in1,in2,out=args
	except:
		print >> stderr,programName,"in1 in2 out"
		exit()
	
	vDict1=readVDictFromFile(in1)
	vDict2=readVDictFromFile(in2)

	vDictOut=dict()
	for in1k,in1v in vDict1.items():
		if in1k not in vDict2:
			vDictOut[in1k]=in1v
			continue

		in2v=vDict2[in1k]
		if type(in1v)!=type(in2v):
			print >> stderr,"inconsistent type for key=",in1k
			exit()
		
		vDictOut[in1k]=in1v+in2v

		
	writeVDictToFile(vDictOut,out)
