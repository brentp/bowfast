set -e
N=$(grep -c ">" data/DNApool_AB_F3.csfasta)
for aln in novo mosaik shrimp bwa bowtie bfast; do
    python scripts/roc-bam.py data/DNApool_AB.$aln.bam data/regions.merged.bed $N \
        > data/roc.${aln}.txt
    exit;
done
