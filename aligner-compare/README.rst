ColorSpace Aligners ROC
=======================

This is on real *solid 3* data from a targetted resequencing project.
We can assess accuracy by wether a read falls within the target region.
I will have *solid 5500* data shortly, at which time I'll re-run.

Solid-3
=======

The plot below is for un-trimmed reads with mostly default paramters.
The upper-left corner of the plot is where we want to be.
The lines go only to about 55% on the y-axis because many reads are unmapped.

.. image:: https://raw.github.com/brentp/bowfast/master/aligner-compare/images/solid-3.png

Lines are created by varying the mapping quality cutoff from 0 to 255. Since
bowtie outputs 255 for all reads, it doesn't have a line.

The green line is at a mapping quality of 22, I'll use reads at or above that
mapping quality from BFAST.

Notes
-----

 + If using bowtie for colorspace, it is best to **use -v 1 -m 1**, don't just use
   -e. (the other bowtie dot is with -e 40).

 + BFAST -a 3 maps more reads than -a 2 without much change in accuracy.

 + if using BWA on solid-3, one *must* trim the reads or use -q 20+ and -n 4+ to
   get a good mapping rate.

 + the default for novoalignCS is for maximum sensitivity which is slow, it can be tuned
   to be faster. All other aligners, including BFAST run fairly quickly. At least with the 
   chosen parameters, novoalignCS, probably takes about 20X more computing time than BFAST.

 + There is no test here for the quality of the base-alignment--e.g.
   novoalignCS may do better at per-base qualities because it does quality
   calibration on-the-fly.
