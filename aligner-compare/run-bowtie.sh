#!/bin/bash
#BSUB -J bowtie.map
#BSUB -o logs/%J.bowtie.out
#BSUB -e logs/%J.bowtie.err
#BSUB -R "rusage[mem=13500]"
#BSUB -n 12

source ./setup.sh

bowtie -f -C -Q $OUT/${GROUP}_F3_QV.qual --chunkmbs 1025 --best --sam \
                --strata -v 1 -m 1\
                --max $OUT/bowtie.max --un $OUT/bowtie.un \
                -y -n 1 \
                --maxbts 25000 \
                -p $THREADS --seed 42 $(dirname $FASTA)/$(basename $FASTA .fa) $OUT/${GROUP}_F3.csfasta | \
                samtools view -bSF 4 - > $OUT/${GROUP}.bowtie.unsorted.bam 

samtools sort -m 3500000000 $OUT/${GROUP}.bowtie.unsorted.bam $OUT/${GROUP}.bowtiev1
samtools index $OUT/${GROUP}.bowtiev1.bam
