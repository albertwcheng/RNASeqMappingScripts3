
if [ $# -lt 1 ]; then
	echo $0 inbamNoExt
	exit
fi

inbamNoExt=$1

samtools sort $inbamNoExt.bam $inbamNoExt.sorted
samtools index $inbamNoExt.sorted.bam
