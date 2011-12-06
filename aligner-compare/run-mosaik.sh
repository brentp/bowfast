#!/bin/bash
#BSUB -J mosaik.map
#BSUB -o logs/%J.mosaik.out
#BSUB -e logs/%J.mosaik.err
#BSUB -R "rusage[mem=35000]"
#BSUB -n 8

set -e

MOSAIK=$HOME/src/mosaik-aligner-svn/bin/
THREADS=8
FASTA=$HOME/data/hg19.fa

LC_ALL=C
DATA=$HOME/data/muc5b/reads/

GROUP=DNApool_AB
OREADS=~/data/muc5b/reads/${GROUP}.fq
READS=~/data/muc5b/reads/${GROUP}.mfq

awk '(NR % 4 == 2){ print substr($0, 2)}(NR %4 !=2)' $OREADS > $READS

<<TRIM
python ../../bio-playground/solidstuff/solid-trimmer.py -c
~/data/muc5b/reads/2873043_F3.csfasta -q ~/data/muc5b/reads/2873043_F3_QV.qual
--max-ns 3 --min-qual 15 -p ~/data/muc5b/reads/2873043_ma_mosaik.fq
--moving-average 7:12 --min-read-length 28
TRIM

##if [ ! -e $GROUP.bfast.fastq ]; then
##    echo solid2fastq $DATA/${GROUP}_F3.csfasta $DATA/${GROUP}_F3_QV.qual 
##fi

<<BUILD

#$MOSAIK/MosaikBuild -cs -fr $FASTA -oa $(basename $FASTA .fa).cs.msk
#$MOSAIK/MosaikBuild -fr $FASTA -oa $(basename $FASTA .fa).bs.msk
#$MOSAIK/MosaikJump -ia $(basename $FASTA .fa).cs.msk -out $(basename $FASTA .fa).cs.15.jmp -hs 15 -mem 4
$MOSAIK/MosaikJump -ia $(basename $FASTA .fa).bs.msk -out $(basename $FASTA .fa).bs.15.jmp -hs 15 -mem 4

BUILD
$MOSAIK/MosaikBuild -cs -st solid -q $READS -out data/$GROUP.reads.msk \
    -sam $GROUP -ds grp -id $GROUP

# http://code.google.com/p/mosaik-aligner/wiki/ParameterSettings
##<<DONE
BASE=$(dirname $FASTA)/$(basename $FASTA .fa)
time $MOSAIK/MosaikAligner -mm 4 -act 25 -bw 17 -mhp 100 -p $THREADS \
        -m unique -hs 15 \
        -rur data/${GROUP}.mosaik.unaligned.fq \
        -in data/$GROUP.reads.msk \
        -j ${BASE}.cs.15.jmp \
        -ia ${BASE}.cs.msk \
        -ibs ${BASE}.bs.msk \
        -out data/mosaik.${GROUP}.aln
##DONE
#TODO take unaligned, trim, send back...

time $MOSAIK/MosaikText -u -in data/mosaik.${GROUP}.aln -bam data/mosaik.${GROUP}.unsorted.bam
samtools sort -m 3500000000 data/mosaik.${GROUP}.unsorted.bam data/${GROUP}.mosaik
samtools index data/${GROUP}.mosaik.bam
