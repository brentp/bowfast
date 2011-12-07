#!/bin/bash
#BSUB -J bwa.map
#BSUB -o logs/%J.bwa.out
#BSUB -e logs/%J.bwa.err
#BSUB -R "rusage[mem=13500]"
#BSUB -n 12

##$BWA/bwa index -a bwtsw -c $FASTA

source ./setup.sh
FASTA=~/data/hg19.fa

bwa aln -q 25 -c -t $THREADS -l 22 -n 5 -k 1 $FASTA $WFQ > $OUT/$GROUP.sai

# bwa doesn't trim the quals after trimming the reads...
bwa samse $FASTA $OUT/$GROUP.sai $WFQ -n 1 | \
    awk 'BEGIN{FS=OFS="\t"}
         ($1 ~ /^@/){ print $0} 
         ($1 !~ /^@/){ $11 = substr($11, 0, length($10)); print $0}' | \
    samtools view -bSF 4 - > $OUT/$GROUP.bwa-x.bam

#samtools sort -m 3500000000 $OUT/$GROUP.bwa.unsorted.bam $OUT/$GROUP.bwa-x
#samtools index $OUT/$GROUP.bwa.bam 
