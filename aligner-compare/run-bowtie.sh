#!/bin/bash
#BSUB -J bowtie.map
#BSUB -o logs/%J.bowtie.out
#BSUB -e logs/%J.bowtie.err
#BSUB -R "rusage[mem=13500]"
#BSUB -n 8

source ./setup.sh

bowtie -f -C -Q data/${GROUP}_F3_QV.qual --chunkmbs 1025 --best --sam \
                --max data/bowtie.max --un data/bowtie.un \
                -y \
                --maxbts 25000 \
                -p $THREADS --seed 42 $(dirname $FASTA)/$(basename $FASTA .fa) data/${GROUP}_F3.csfasta | \
                samtools view -bSF 4 - > data/${GROUP}.bowtie.unsorted.bam


samtools sort -m 3500000000 data/${GROUP}.bowtie.unsorted.bam data/${GROUP}.bowtie
samtools index data/${GROUP}.bowtie.bam
