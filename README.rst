Bowfast
=======
Run bowtie, then BFAST on single-end colorspace reads and get
a single BAM file like:

   bowfast -f hg19.fa -p output_prefix input.csfasta input.qual

The output will be `output_prefix.calmd.bam` which has samtools
calmd -E adjusted qualities.

Run ./bowfast with no options to see full help.

Pipeline
========

automates mapping single-end colorspace reads with this pipeline:

    1) run bowtie with conservative parameters to map high-quality reads
       quickly and discard reads that map to multiple locations
    2) quality trim reads that are unmapped by bowtie
    3) map trimmed reads with BFAST
    4) sort and merge bowtie and BFAST outputs
    5) index and run samtools calmd -E on merged file.
  
The alignments from bowtie are given fake mapping quality scores
based on the number of mismatches (it's completely ad-hoc, but is
tuned so that it seems to give the ability to filter).

Example
=======

This command will create final output of 'output/prefix.calmd.bam':

    bowfast -f hg19.fasta -p output/prefix -t 8 some.csfasta some.qual


Options
=======

     -f reference fasta file.                            [required]
     -p output prefix for all files. e.g. 'data/sample1' [required]
     -t number of threads.                               [default: 8]
     -a option to BFAST 2: keep only uniquely mapped reads.
                        3: choose the best scoring alignment.
        2 is more stringent.                             [default: 3]

Installation
============
Note: this assumes that samtools, bowtie, and BFAST are on your path
      and that indexes for bowtie and BFAST have been created. If you
      use the build-all.sh script in this repo, it will download and
      build them for you in the lib/ directory. the `bowfast` executable
      adds lib/* to your path during the execution of the script.

Download and build::

    $ git clone --recursive https://github.com/brentp/bowfast/
    $ cd bowfast
    $ bash build-all.sh
    $ ./bowfast

TODO
====

+ can add a meta script to split, parallize, and merge.
+ figure out trimming with sickle (see:
  https://github.com/najoshi/sickle/issues/3)

+ current defaults seem to do pretty well, but can adjust -e to
  bowtie and -a, -b to BFAST and check results.

