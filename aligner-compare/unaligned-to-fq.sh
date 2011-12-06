BAM=$1
TRIM=$2
CUTOFF=22
# get unmapped reads.
samtools view -f 4 $1 | awk -F$'\t' -vtrim=$TRIM '{ 
    header="@"substr($1, index($1, ":")  + 1)
    # NOTE this is very fragile... pulls out CS:Z tag by column index.
    seq=substr($17, 6)
    qual=substr($18,6)
    trim_seq=substr(seq, 1, length(seq) - trim)
    # NOTE: hard-coded 25
    if(length(trim_seq) > 25){
        print header"\n"trim_seq"\n+\n"substr(qual, 1, length(qual) - trim)
    }
}'
# get mapped reads with quality less than cutoff.
samtools view -F 4 $1 | awk -F$'\t' -vtrim=$TRIM '($5 < 22){ 
    header="@"substr($1, index($1, ":")  + 1)
    # NOTE this is very fragile... pulls out CS:Z tag by column index.
    seq=substr($17, 6)
    qual=substr($18,6)
    trim_seq=substr(seq, 1, length(seq) - trim)
    # NOTE: hard-coded 25
    if(length(trim_seq) > 25){
        print header"\n"trim_seq"\n+\n"substr(qual, 1, length(qual) - trim)
    }
}'
