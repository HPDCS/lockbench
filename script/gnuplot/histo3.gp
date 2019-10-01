ext = ".eps"
set term postscript eps enhanced color font "Courier" 16 size 6,6
set tics font "Courier,12"
set key font ",11"
set output filename.ext

#set key left top vertical Right noreverse noenhanced autotitle nobox
#set key left bottom  font ",10"
set key left below  font ",10"

set style data histogram
set style histogram clustered gap 1 title textcolor lt -1
set style fill pattern border -1

set size 0.6,0.4

set boxwidth 0.75

set ytics border in scale 0,0 mirror norotate  autojustify
set ytics norangelimit autofreq  font ",12"
set ztics border in scale 0,0 nomirror norotate  autojustify
set cbtics border in scale 0,0 mirror norotate  autojustify
set rtics axis in scale 0,0 nomirror norotate  autojustify

#set ytics 20
set title machine." - ".cores." cores\n CSL:".csl." CSU:".csu." NCSL:".ncsl." NCSU:".ncsu noenhanced
#set title "CSL:".csl." CSU:".csu." NCSL:".ncsl." NCSU:".ncsu noenhanced

set xlabel xl 

set style line 12 lc rgb '#000000' lt "-" lw 2
set grid back ls 12

#set logscale y

set xlabel  offset character 0,0,0 font "" textcolor lt -1 norotate

#set yrange[0.5:1.05	]
set yrange[0:1.05]
set ytics 0.1

if (csu eq '3.7' && ncsu eq '3.7'){
#	set yrange [0:2000]
}
if (csu eq '3.7' && ncsu eq '366'){
#	set yrange [0:2000]
}
if (csu eq '366' && ncsu eq '3.7'){
#	set yrange [0:50000]
}
if (csu eq '366' && ncsu eq '366'){
#	set yrange [0:50000]
}


set ylabel "Ratio w.r.t.\n the average value of optimum" offset 2,0,0

threads = "2 4 6 12 18 24 30 36 42 48"
THREADS="1 3 6 12 18 24 30 36 42 48 52 58 60 70 80 90 100 125 150 175 200"


#plot filename using 2:xtic(1) fs pattern 2 lc rgb "#000000" ti col, '' u 3 ti col, '' u 4 ti col, '' u 5 ti col, '' u 6 ti col



#filter = "< awk   '$1==\"THREADS\";$1==2;$1==5;$1==10;$1==20;$1==40;' "

#plot for [col=2:*] filename using col:xtic(1) fs pattern col lc rgb "#000000" title columnheader
plot for [col=2:*] filename using col:xtic(1)  title columnheader



#plot filename        		using 2:xtic(1) fs pattern 3 lc rgb "#000000" title "MCS"				, \
		  		 		 '' using 3:xtic(1) fs pattern 0 lc rgb "#000000" title "PT-SPINLOCK"		, \
		  		 		 '' using 4:xtic(1) fs pattern 2 lc rgb "#000000" title "PT-MUTEX"			, \
		  		 		 '' using 5:xtic(1) fs pattern 1 lc rgb "#000000" title "PT-ADAPTIVE-MUTEX"	, \
		  		 		 '' using 6:xtic(1) fs solid 	 lc rgb "#888888" title "MUTLOCK", \
		  		 		 '' using 7:xtic(1) fs pattern 6 lc rgb "#000000" title "PT-AVG"				
