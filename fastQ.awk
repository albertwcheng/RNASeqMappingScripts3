function chr(c)
{
return sprintf("%c",c+0);

}

BEGIN{
split(FILE,s,".");
sampleName=s[1]; 

	if(eScore>=93)
	{
	asci=chr(93+33);
	}
	else{
	asci=chr(eScore+33)
	}
}

{
asciString="";
for(i=0;i<length($1);i++)
{
  asciString=asciString asci
}
printf("@%s_%d\n%s\n+\n%s\n",sampleName,FNR,$1,asciString);
}
