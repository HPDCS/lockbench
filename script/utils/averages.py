import sys

cores = int(sys.argv[2])
f = sys.argv[1]
o1 = sys.argv[1].replace("TH", "AVG")

print f


f = open(f)
o1 = open(o1, "w")


d = {}
opt = {}
count = 0
for line in f.readlines():
	line = line.strip().split()
	if count == 0:
		count+=1
		o1.write(" ".join(line)+"\n")
		continue
	k = int(line[0])
	d[k] = [float(v) for v in line[1:]]
	opt[k] = max(d[k])


threads = sorted(d)


avgs = {}
opt_avg = {}
for i in range(len(threads)-1):
	avgs[threads[i]] = []
	opt_avg[threads[i]] = []
	b = threads[i+1]-threads[i]
	for j in range(len(d[1])):
		h1 = min(d[threads[i]][j], d[threads[i+1]][j]) 
		h2 = max(d[threads[i]][j], d[threads[i+1]][j]) 
		avg = b*h1 + b*(h2-h1)/2
		avgs[threads[i]] += [avg]
	
	h1 = min(opt[threads[i]], opt[threads[i+1]]) 
	h2 = max(opt[threads[i]], opt[threads[i+1]]) 
	avg = b*h1 + b*(h2-h1)/2
	opt_avg[threads[i]] = avg


acc = [0]
for j in range(len(d[1])):
	acc += [0]

for k in sorted(d)[:-1]:
	if k < cores:
		for j in range(len(d[1])):
			acc[j] += avgs[k][j]	
		acc[-1] += opt_avg[k]


for j in range(len(acc)):
	acc[j] /= cores-threads[0]	

for j in range(len(acc)):
	acc[j] /= acc[-1]	

acc = [str(v) for v in acc]
o1.write("NO-TIMESHARING " +" ".join(acc[:-1])+"\n")
res1 = acc[:]

acc = [0]
for j in range(len(d[1])):
	acc += [0]

for k in sorted(d)[:-1]:
	if k >= cores:
		for j in range(len(d[1])):
			acc[j] += avgs[k][j]	
		acc[-1] += opt_avg[k]


for j in range(len(acc)):
	try:
		acc[j] /= threads[-1]-cores	
	except:
		acc[j] = 0
for j in range(len(acc)):
	try:
		acc[j] /= acc[-1]	
	except:
		acc[j] = 0

acc = [str(v) for v in acc]
o1.write("TIMESHARING " +" ".join(acc[:-1])+"\n")
res2 = acc[:]

acc = [0]
for j in range(len(d[1])):
	acc += [0]

for k in sorted(d)[:-1]:
		#if k != cores:
		for j in range(len(d[1])):
			acc[j] += avgs[k][j]	
		acc[-1] += opt_avg[k]


for j in range(len(acc)):
	acc[j] /= threads[-1]-threads[0]	

for j in range(len(acc)):
	acc[j] /= acc[-1]	


acc = [str(v) for v in acc]
o1.write("OVERALL " +" ".join(acc[:-1])+"\n")

o1.close()