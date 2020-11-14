import sys

f1 = open(sys.argv[1])
f2 = open(sys.argv[2])

l1 = []
l2 = []

for line in f1.readlines():
	line = line.strip()
	l1 += [line.split(" ")]

for line in f2.readlines():
	line = line.strip()
	l2 += [line.split(" ")]

for i in range(len(l1)):
	if i == 0:
		print " ".join(l1[i])
	else:
		print l1[i][0]+" " + " ".join([str(int(l1[i][1:][j])/int(l2[i][1:][j])) for j in range(len(l1[i][1:]))])
