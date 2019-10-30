ext = ".eps"
set term postscript eps enhanced color font "Courier" 16 size 18,4


set style data histogram
set style histogram clustered 
set style fill pattern border -1

set style line 12 lc rgb '#000000' lt "-" lw 2
set grid back ls 12 
set key left horizontal below height 2



set xtics font ",20"
set title font ",30"
set ylabel font ",25"

set ylabel "Ratio w.r.t.\n the average value of optimum" offset -2,0

configurations=17





tit1="csl-0-csu-3.7-ncsl-0-ncsu-3.7-AVG"
tit2="csl-0-csu-366-ncsl-0-ncsu-3.7-AVG"
tit3="csl-0-csu-3.7-ncsl-0-ncsu-366-AVG"
tit4="csl-0-csu-366-ncsl-0-ncsu-366-AVG"

filename1="./../out/GenuineIntel-out-batch_res_0_3.7_0_3.7/dat-aggregated/".tit1
filename2="./../out/GenuineIntel-out-batch_res_0_366_0_3.7/dat-aggregated/".tit2
filename3="./../out/GenuineIntel-out-batch_res_0_3.7_0_366/dat-aggregated/".tit3
filename4="./../out/GenuineIntel-out-batch_res_0_366_0_366/dat-aggregated/".tit4

set xtics (tit1 0,  tit2 1.05, tit3 2.1, tit4 3.15)

set xrange [-0.6:3.8]
set yrange [0.4:1.2]

set output filename.'-NO-TIMESHARING'.ext
set title "NO-TIMESHARING"
filter = "< awk   '$1==\"THREADS\";$1==\"NO-TIMESHARING\";' "


plot newhistogram at 0, \
for [col=2:configurations] filter.filename1 using col  title columnheader, \
for [col=2:configurations] ''  using        ((col - (configurations+1) / 2.0) / (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 0.05, \
for [col=2:configurations] filter.filename2 using col  notitle, \
for [col=2:configurations] ''  using (1.05 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 1.1, \
for [col=2:configurations] filter.filename3 using col  notitle, \
for [col=2:configurations] ''  using (2.1 + (col - (configurations+1) / 2.0) /    (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 2.15, \
for [col=2:configurations] filter.filename4 using col  notitle, \
for [col=2:configurations] ''  using (3.15 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle


set output filename.'-TIMESHARING'.ext
set title "TIMESHARING"
filter = "< awk   '$1==\"THREADS\";$1==\"TIMESHARING\";' "


plot newhistogram at 0, \
for [col=2:configurations] filter.filename1 using col  title columnheader, \
for [col=2:configurations] ''  using        ((col - (configurations+1) / 2.0) / (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 0.05, \
for [col=2:configurations] filter.filename2 using col  notitle, \
for [col=2:configurations] ''  using (1.05 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 1.1, \
for [col=2:configurations] filter.filename3 using col  notitle, \
for [col=2:configurations] ''  using (2.1 + (col - (configurations+1) / 2.0) /    (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 2.15, \
for [col=2:configurations] filter.filename4 using col  notitle, \
for [col=2:configurations] ''  using (3.15 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle




set output filename.'-OVERALL'.ext
set title "OVERALL"
filter = "< awk   '$1==\"THREADS\";$1==\"OVERALL\";' "


plot newhistogram at 0, \
for [col=2:configurations] filter.filename1 using col  title columnheader, \
for [col=2:configurations] ''  using        ((col - (configurations+1) / 2.0) / (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 0.05, \
for [col=2:configurations] filter.filename2 using col  notitle, \
for [col=2:configurations] ''  using (1.05 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 1.1, \
for [col=2:configurations] filter.filename3 using col  notitle, \
for [col=2:configurations] ''  using (2.1 + (col - (configurations+1) / 2.0) /    (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle, \
newhistogram at 2.15, \
for [col=2:configurations] filter.filename4 using col  notitle, \
for [col=2:configurations] ''  using (3.15 + (col - (configurations+1) / 2.0) /  (configurations + 1)):col:(gprintf("%.3f", (column(col)))) with labels center offset 0,2 rotate by 90 notitle




#plot filename        		using 2:xtic(1) fs pattern 3 lc rgb "#000000" title "MCS"				, \
		  		 		 '' using 3:xtic(1) fs pattern 0 lc rgb "#000000" title "PT-SPINLOCK"		, \
		  		 		 '' using 4:xtic(1) fs pattern 2 lc rgb "#000000" title "PT-MUTEX"			, \
		  		 		 '' using 5:xtic(1) fs pattern 1 lc rgb "#000000" title "PT-ADAPTIVE-MUTEX"	, \
		  		 		 '' using 6:xtic(1) fs solid 	 lc rgb "#888888" title "MUTLOCK", \
		  		 		 '' using 7:xtic(1) fs pattern 6 lc rgb "#000000" title "PT-AVG"				
