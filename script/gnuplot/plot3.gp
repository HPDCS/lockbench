ext = ".eps"
set term postscript eps enhanced color font "Courier" 16 size 8,8
set tics font "Courier,10"
set key font ",10"
set output filename.ext


set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0
set xtics tic
set size 1.0,0.5
set xrange [0:xmax]

set style line 1 lt 2 lw 2 pt 3 ps 1.5 lc rgb "#000000"
set style line 2 lt 2 lw 2 pt 2 ps 1.5 lc rgb "#000000"
set style line 3 lt 2 lw 2 pt 4 ps 1.5 lc rgb "#000000"
set style line 4 lt 2 lw 2 pt 1 ps 1.5 lc rgb "#000000"
set style line 5 lt 2 lw 2 pt 6 ps 1.5 lc rgb "#000000"
set style line 6 lt 2 lw 2 pt 8 ps 1.5 lc rgb "#000000"

set style line 12 lc rgb '#000000' lt "-" lw 2
set grid back ls 12

#set key center right spacing 2
set key below center height 5 width 2

set title machine." - ".cores." cores\n CSL:".csl." CSU:".csu." NCSL:".ncsl." NCSU:".ncsu noenhanced

set arrow from cores, graph 0 to cores, graph 1 nohead lt "_" lw 6
set xlabel xl 




set ylabel "Total Energy (uJ)"
plot for [col=2:*] filename using 1:col with linespoints ls col title columnheader
