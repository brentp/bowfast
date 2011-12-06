GROUP=DNApool_AB

export LC_ALL=C
set -e

THREADS=12
FASTA=$HOME/data/bfast/hg19All.fa
GROUP=DNApool_AB

PATH=$PATH:~/src/novoalign/novocraft/:~/src/novoalign/novoalignCS:~/src/bfast-git/scripts/:~/src/bfast-git/
PATH=$PATH:~/src/bwa:/vol2/home/brentp/src/bowtie/bowtie-0.12.7/

OUT=data

BFQ=${OUT}/${GROUP}.fq
if [ ! -e $BFQ ]; then
    solid2fastq data/${GROUP}_F3.csfasta \
                data/${GROUP}_F3_QV.qual > $BFQ
fi
WFQ=${OUT}/${GROUP}.single.fastq.gz

if [ ! -e $WFQ ]; then
    solid2fastq.pl data/${GROUP}_ data/${GROUP}
fi
