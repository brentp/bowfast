#!/bin/bash
#BSUB -J bfast.map
#BSUB -o logs/%J.bfast.out
#BSUB -e logs/%J.bfast.err
#BSUB -R "rusage[mem=13500]"
#BSUB -n 12

source ./setup.sh

BMF=${OUT}/$GROUP.bfast.bmf
BAF=${OUT}/$(basename $BMF .bmf).baf
UBAM=${OUT}/$(basename $BMF .bmf).unsorted.bam

#bfast match -f $FASTA -A 1 -r $BFQ -M 512 -K 8 -n $THREADS > $BMF && \
#bfast localalign -f $FASTA -A 1 -n $THREADS -m $BMF > $BAF && \

#bfast postprocess -f $FASTA -A 1 -i $BAF -a 3 -o $GROUP -n $THREADS -O 1 \
#    | samtools view -bS - > $UBAM && \
#samtools sort -m 3500000000 $UBAM ${OUT}/$(basename $BMF .bmf)

last_bam=${OUT}/${GROUP}.bfast.bam
# trim off 5 bases each time and retry.
for iter in $(seq 1 3); do
    base=${OUT}/${GROUP}.bfast.${iter}
    bfq=${base}.un.fq

    bash unaligned-to-fq.sh $last_bam 5 > ${bfq}

    bfast match -f $FASTA -A 1 -r $bfq -M 512 -K 8 -n $THREADS > $base.bmf
    bfast localalign -f $FASTA -A 1 -n $THREADS -m $base.bmf > $base.baf

    bfast postprocess -f $FASTA -A 1 -i $base.baf -a 2 -o $GROUP -n $THREADS -O 1 \
            | samtools view -bS - > $base.bam 

    last_bam=$base.bam
done

