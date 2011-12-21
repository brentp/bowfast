import sys
fq = sys.argv[1]

base = fq.split(".bfast.fastq")[0]
quals = open(base + "_F3_QV.qual", "w")
seq = open(base + "_F3.csfasta", "w")

for i, line in enumerate(open(fq)):

    mod = i % 4
    if mod == 0: # name
        assert line[0] == "@"
        quals.write(">" + line[1:])
        seq.write(">" + line[1:])
    elif mod == 1: # cseq
        seq.write(line)
    elif mod == 3:
        print >>quals, " ".join((str(ord(q) - 31) for q in line.rstrip("\r\n")))

seq.close(); quals.close()
print >>sys.stderr, "wrote %s, %s" % (quals.name, seq.name)

