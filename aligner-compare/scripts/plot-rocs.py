import sys
from matplotlib import pyplot as plt
import os.path as op

f = plt.figure()
ax = f.add_subplot(1, 1, 1)

colors = list("rgbkycm")
colors.append("0.75")
colors.append("#ff3300")

def plot(f, ax, color):
    xs, ys = [], []
    xcut = None
    for toks in (l.rstrip().split("\t") for l in open(f) if not l[0] == "#"):
        xs.append(float(toks[2]))
        ys.append(float(toks[3]))
        if toks[0] == '22':
            xcut = float(toks[2])

    aln = op.basename(f).split(".")[1]
    ax.plot(xs, ys, marker="o", linestyle="--", color=color, label=aln,
            markersize=4, linewidth=1.5,
            mec=color)
    if 'bfast' == aln:
        ax.plot([xcut, xcut], [0, 100], color=color)

for i, f in enumerate(sys.argv[1:]):
    plot(f, ax, colors[i])

plt.legend(loc='lower right')
plt.xlim(0, 6)
plt.ylim(0, 70)
plt.xlabel("% reads outside target region")
plt.ylabel("% reads inside target region")
plt.show()
