set -e
G=f5500
N=$(grep -c ">" data/${G}_F3.csfasta)
for aln in novo bfast novo bowtiev1 bfasta2 bfast mosaik shrimp bwa bowtie; do
    python scripts/roc-bam.py data/$G.$aln.bam data/regions.extended.bed $N \
        > data/roc.${aln}-5500.txt
    exit
done
