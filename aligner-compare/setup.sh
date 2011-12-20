GROUP=DNApool_AB

export LC_ALL=C
set -e

GROUP=f5500
OUT=data

<<DONE
# for 5500 only...
BFQ=${OUT}/DNA46_2.sub.bfastq
zcat ~/data/muc5b/2012/reads/muc5b-1-DNA46_2.bfastq.gz  \
    | head -n $((4777222 * 4 + 1000000)) | tail -n $((4777222 * 4)) \
    > data/DNA46_2.bfast.fastq
python scripts/csfasta-from-bfastq.py data/DNA46_2.bfast.fastq
mv data/DNA46_2_F3_QV.qual data/${GROUP}_F3_QV.qual
mv data/DNA46_2_F3.csfasta data/${GROUP}_F3.csfasta 
ln -s $BFQ data/${GROUP}.bfast.fastq
DONE

BFQ=${OUT}/${GROUP}.bfast.fastq
THREADS=20
FASTA=$HOME/data/bfast/hg19All.fa

PATH=$PATH:~/src/novoalign/novocraft/:~/src/novoalign/novoalignCS:~/src/bfast-git/scripts/:~/src/bfast-git/
PATH=$PATH:~/src/bwa:/vol2/home/brentp/src/bowtie/bowtie-0.12.7/:$HOME/src/mosaik-aligner-svn/bin/
PATH=$PATH:~/src/maq/maq-svn/


if [ ! -e $BFQ ]; then
    solid2fastq data/${GROUP}_F3.csfasta \
                data/${GROUP}_F3_QV.qual > $BFQ
fi
WFQ=${OUT}/${GROUP}.single.fastq.gz

if [ ! -e $WFQ ]; then
    solid2fastq.pl data/${GROUP}_ data/${GROUP}
fi
