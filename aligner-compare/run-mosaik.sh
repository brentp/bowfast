#!/bin/bash
#BSUB -J mosaik.map
#BSUB -o logs/%J.mosaik.out
#BSUB -e logs/%J.mosaik.err
#BSUB -R "rusage[mem=35000]"
#BSUB -n 8

source ./setup.sh

LC_ALL=C

READS=$OUT/${GROUP}.mfq

FASTA=~/data/hg19.fa
# have to strip the first base from sequence.
awk '(NR % 4 == 2){ print substr($0, 2)}(NR %4 !=2)' $BFQ > $READS

<<BUILD

MosaikBuild -cs -fr $FASTA -oa $(basename $FASTA .fa).cs.msk
MosaikBuild -fr $FASTA -oa $(basename $FASTA .fa).bs.msk
MosaikJump -ia $(basename $FASTA .fa).cs.msk -out $(basename $FASTA .fa).cs.15.jmp -hs 15 -mem 4
MosaikJump -ia $(basename $FASTA .fa).bs.msk -out $(basename $FASTA .fa).bs.15.jmp -hs 15 -mem 4

BUILD
MosaikBuild -cs -st solid -q $READS -out $OUT/$GROUP.reads.msk \
    -sam $GROUP -ds grp -id $GROUP

# http://code.google.com/p/mosaik-aligner/wiki/ParameterSettings
##<<DONE
BASE=$(dirname $FASTA)/$(basename $FASTA .fa)
MosaikAligner -mm 4 -act 25 -bw 17 -mhp 100 -p $THREADS \
        -m unique -hs 15 \
        -mmal \
        -rur $OUT/${GROUP}.mosaik.unaligned.fq \
        -in $OUT/$GROUP.reads.msk \
        -j ${BASE}.cs.15.jmp \
        -ia ${BASE}.cs.msk \
        -ibs ${BASE}.bs.msk \
        -out $OUT/mosaik.${GROUP}.aln
##DONE
#TODO take unaligned, trim, send back...

MosaikText -u -in $OUT/mosaik.${GROUP}.aln -bam $OUT/mosaik.${GROUP}.unsorted.bam
samtools sort -m 3500000000 $OUT/mosaik.${GROUP}.unsorted.bam $OUT/${GROUP}.mosaik
samtools index $OUT/${GROUP}.mosaik.bam
