"""
generate qual vs count 
"""

import collections
from toolshed import nopen
import sys

def counter(fname):
    qual_count = collections.defaultdict(int)
    for sam_line in (l.split("\t") for l in nopen(fname)):
        qual = int(sam_line[4])
        qual_count[qual] += 1
    return qual_count

# samtools view $BAM -L regions.bed
f_bam = sys.argv[1]
f_region = sys.argv[2]
total_reads = float(int(sys.argv[3]))


on_target = counter(nopen('| samtools view %s -L %s -F 4' % (f_bam, f_region)))
off_target = counter(nopen('| intersectBed -abam %s -b \
                    %s -wa -v | samtools view - -F 4' % (f_bam, f_region)))

tot_on_target = on_target.copy()
tot_off_target = off_target.copy()

from matplotlib import pyplot as plt
xs = []
ys = []

print "#mapq\t%on-target\tfalse+\ttrue+"

for i in range(0, 255):
    for j in range(i + 1, 256):
        tot_on_target[i] += on_target[j]
        tot_off_target[i] += off_target[j]

for i in range(1, 257):
    #tot_on_target[i] += tot_on_target[i - 1]
    #tot_off_target[i] += tot_off_target[i - 1]
    on = tot_on_target[i - 1]
    off = tot_off_target[i - 1]
    false_plus = 100. * off / total_reads
    true_plus = 100. * on / total_reads
    d = on / (float(on + off) or 1)
    print "\t".join(map(str, (i - 1, d, false_plus, true_plus, off, on)))

    xs.append(false_plus)
    ys.append(true_plus)


plt.plot(xs, ys, 'b.')
plt.plot( 100. * off_target[250] / total_reads,
        100. * on_target[250] / total_reads, 'ro')
plt.xlim(0, 8)
plt.ylim(0, 80)
plt.title(f_bam)
plt.show()
