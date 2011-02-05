export BOWTIE_INDEXES="/lab/jaenisch_albert/genomes/mm9/fa/bowtie_indices/"  ####

ebwt_base=mm9_nr      #####
GFF_flag="--GFF /lab/jaenisch_albert/genomes/mm9/annos/acembly.pe.gff3"   #######pe= parent expanded
solexa_quality_flag=""  ##or --solexa1.3-quals --solexa1.3-quals these are fastq


mate_inner_dist=200
mate_std_dev=20
min_anchor_length=4 #tophat defulat is 8
splice_mismatches=0
min_intron_length=70
max_intron_length=500000
min_isoform_fraction=0.15
num_threads=4
max_multihits=40
butterfly_search_flag="" #--butterfly-search
microexon_search_flag="" #--microexon-search With this option, the pipeline will attempt to find alignments incident to microexons. Works only for reads 50bp or longer. 
raw_junc_flag="" ###"--raw-juncs ???"
no_novel_juncs_flag="" #"--no-novel-juncs"
other_options=""




