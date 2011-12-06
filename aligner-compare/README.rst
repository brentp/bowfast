ColorSpace Aligners ROC
=======================

This is on real *solid 3* data from a targetted resequencing project.
We can assess accuracy by wether a read falls within the target region.
I will have *solid 5500* data shortly, at which time I'll re-run.

Raw Reads
=========

The plot below is for un-trimmed reads with mostly default paramters.
The upper-left corner of the plot is where we want to be.
The lines go only to about 55% on the y-axis because many reads are unmapped.

.. image:: https://raw.github.com/brentp/bowfast/master/aligner-compare/images/solid-3.png

Notes
-----

 + If using bowtie for colorspace, it is best to use -v 1 -m 1, don't just use
   -e. (the other bowtie dot is with -e 40).

 + BFAST -a 3 maps more reads than -a 2 without much change in accuracy.

 + Other aligners may perform better after trimming.
