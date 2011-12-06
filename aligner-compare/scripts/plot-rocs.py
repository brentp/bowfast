import sys
from matplotlib import pyplot as plt
import os.path as op

f = plt.figure()
ax = f.add_subplot(1, 1, 1)

colors = "rgbkyc"

def plot(f, ax, color):
    xs, ys = [], []
    for toks in (l.rstrip().split("\t") for l in open(f) if not l[0] == "#"):
        xs.append(float(toks[2]))
        ys.append(float(toks[3]))

    aln = op.basename(f).split(".")[1]
    ax.plot(xs, ys, color + "--o", label=aln)

for i, f in enumerate(sys.argv[1:]):
    plot(f, ax, colors[i])

plt.legend()
plt.xlim(0, 10)
plt.ylim(0, 80)
plt.xlabel("% reads out of target region")
plt.ylabel("% reads in target region")
plt.show()
