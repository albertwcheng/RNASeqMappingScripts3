######## BWA CONFIG ###########
#1) Building index
 
logprefix=" /lab/jaenisch_albert/genomes/mm9/mm9A/fa"; ###
genome="/lab/jaenisch_albert/genomes/mm9/mm9A/fa/mm9=Av1_r36m1.fa"; ###

bngenome=`basename $genome`
genomeName=${bngenome/.fa/}

nodehostname="episode-03"
indexFlag="-a bwtsw"
#-c 	Build color-space index. The input fast should be in nucleotide space.
#-a STR 	Algorithm for constructing BWT index. Available options are:
#
#is 	IS linear-time algorithm for constructing suffix array. It requires 5.37N memory where N is the size of the database. IS is moderately fast, but does not work with database #larger than 2GB. IS is the default algorithm due to its simplicity. The current codes for IS algorithm are reimplemented by Yuta Mori.
#
#bwtsw 	Algorithm implemented in BWT-SW. This method works with the whole human genome, but it does not work with database smaller than 10MB and it is usually slower than IS. 

################################

#aln parameters:
#-n NUM 	Maximum edit distance if the value is INT, or the fraction of missing alignments given 2% uniform base error rate if FLOAT. In the latter case, the maximum edit distance is automatically chosen for different read lengths. [0.04]
ALN_N=0.04
#-o INT 	Maximum number of gap opens [1]
ALN_o=1
#-e INT 	Maximum number of gap extensions, -1 for k-difference mode (disallowing long gaps) [-1]
ALN_e=-1
#-d INT 	Disallow a long deletion within INT bp towards the 3’-end [16]
ALN_d=16
#-i INT 	Disallow an indel within INT bp towards the ends [5]
ALN_i=5
#-l INT 	Take the first INT subsequence as seed. If INT is larger than the query sequence, seeding will be disabled. For long reads, this option is typically ranged from 25 to 35 for ‘-k 2’. [inf]
ALN_l_FLAG=""
#-k INT 	Maximum edit distance in the seed [2]
ALN_k=2
#-t INT 	Number of threads (multi-threading mode) [1]
ALN_t=1
#-M INT 	Mismatch penalty. BWA will not search for suboptimal hits with a score lower than (bestScore-misMsc). [3]
ALN_M=3
#-O INT 	Gap open penalty [11]
ALN_O=11
#-E INT 	Gap extension penalty [4]
ALN_E=4
#-R INT 	Proceed with suboptimal alignments if there are no more than INT equally best hits. This option only affects paired-end mapping. Increasing this threshold helps to improve the pairing accuracy at the cost of speed, especially for short reads (~32bp).
ALN_R_FLAG=""
#-c 	Reverse query but not complement it, which is required for alignment in the color space.
ALN_c_FLAG=""
#-N 	Disable iterative search. All hits with no more than maxDiff differences will be found. This mode is much slower than the default.
ALN_N_FLAG=""
#-q INT 	Parameter for read trimming. BWA trims a read down to argmax_x{\sum_{i=x+1}^l(INT-q_i)} if q_l<INT where l is the original read length. [0] 
ALN_q=0


#samse parameters
#-n INT 	Output up to INT top hits. Value -1 to disable outputting multiple hits. [-1] 
SAMSE_n=-1


#sampe parameters
#-a INT 	Maximum insert size for a read pair to be considered being mapped properly. Since 0.4.5, this option is only used when there are not enough good alignment to infer the distribution of insert sizes. [500]
SAMPE_a=50000
#-o INT 	Maximum occurrences of a read for pairing. A read with more occurrneces will be treated as a single-end read. Reducing this parameter helps faster pairing. [100000] 
SAMPE_o=100000



QThresholds[1]=10

