#!/bin/bash
#BSUB -J maq.map
#BSUB -o logs/%J.maq.out
#BSUB -e logs/%J.maq.err
#BSUB -R "rusage[mem=13500]"
#BSUB -n 1

source ./setup.sh

UFQ=$(dirname $WFQ)/$(basename $WFQ .gz)
##maq fastq2bfq $UFQ ${OUT}/${GROUP}.maq.bfq
READ_PREFIX=${OUT}/${GROUP}
FASTA=~/data/hg19.fa

<<DONE
maq fasta2csfa $FASTA > $FASTA.maq.csfa
maq fasta2bfa $FASTA.maq.csfa $FASTA.maq.csbfa
maq fasta2bfa $FASTA $FASTA.maq.bfa
DONE

maq map -c ${READ_PREFIX}.maq.cs.map $FASTA.maq.csbfa ${READ_PREFIX}.maq.bfq
maq csmap2nt ${READ_PREFIX}.maq.nt.map $FASTA.maq.bfa ${READ_PREFIX}.maq.cs.map


~/src/samtools-svn/misc/maq2sam-long ${READ_PREFIX}.maq.nt.map \
 | samtools view -bF 4 -hSt $FASTA.fai - > ${READ_PREFIX}.maq.bam

"""
Usage:   maq map [options] <out.map> <chr.bfa> <reads_1.bfq> [reads_2.bfq]

Options: -1 INT      length of the first read (<=127) [0]
         -2 INT      length of the second read (<=127) [0]
         -m FLOAT    rate of difference between reads and references [0.001]
         -e INT      maximum allowed sum of qualities of mismatches [70]
         -d FILE     adapter sequence file [null]
         -a INT      max distance between two paired reads [250]
         -A INT      max distance between two RF paired reads [0]
         -n INT      number of mismatches in the first 24bp [2]
         -M c|g      methylation alignment mode [null]
         -u FILE     dump unmapped and poorly aligned reads to FILE [null]
         -H FILE     dump multiple/all 01-mismatch hits to FILE [null]
         -C INT      max number of hits to output. >512 for all 01 hits. [250]
         -s INT      seed for random number generator [random]
         -W          disable Smith-Waterman alignment
         -t          trim all reads (usually not recommended)
         -c          match in the colorspace

"""
