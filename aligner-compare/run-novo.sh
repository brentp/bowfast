#!/bin/bash
#BSUB -J novo.map
#BSUB -e logs/novo.%I.%J.err
#BSUB -o logs/novo.%I.%J.out
#BSUB -R "rusage[mem=25800]"
#BSUB -n 12



source ./setup.sh
REF=$HOME/data/hg19.fa


# create a new index for each job. runs much faster.
#novoindex -t 4 -c $REF.novo

novoalignCS -c 24 -s 5 -k -d $REF.novo -f $BFQ -H -F BFASTQ -o SAM -r None \
     -K $OUT/$GROUP.novo.stats.txt | samtools view -bSF 4 - > $OUT/$GROUP.novo.bam
