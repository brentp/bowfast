#!/bin/bash
#BSUB -J novo.map[1-13]
#BSUB -e logs/novo.%I.%J.err
#BSUB -o logs/novo.%I.%J.out
#BSUB -R "rusage[mem=25800]"
#BSUB -n 4


LC_ALL=C
set -eu
set -o pipefail

REF=$HOME/data/hg19.fa

BFQ=~/data/muc5b/reads/${GROUP}.fq

# create a new index for each job. runs much faster.
#novoindex -t 4 -c $REF.novo
<<DONE
DONE

novoalignCS -s 4 -c 4 -k -d $REF.novo.$LSB_JOBINDEX -f $BFQ -H -F BFASTQ -o SAM -r None \
     -K data/$GROUP.novo.stats.txt | samtools view -bSF 4 - > data/$GROUP.novo.bam

