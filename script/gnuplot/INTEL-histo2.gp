ext = ".eps"
set term postscript eps enhanced color font "Courier" 26 size 8,8
set tics font "Courier,46"
set key font "Courier,26"
set output filename.'-cores'.ext

set title "Test"
set key invert reverse Left outside 
set style data histogram
set style histogram rowstacked title offset 0,2
set style fill pattern border -1

set size 2,1

set boxwidth 0.75

set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set xtics norangelimit  font ",16"
set xtics ()

set ytics border in scale 0,0 mirror norotate  autojustify
set ytics norangelimit autofreq  font ",20"
set ztics border in scale 0,0 nomirror norotate  autojustify
set cbtics border in scale 0,0 mirror norotate  autojustify
set rtics axis in scale 0,0 nomirror norotate  autojustify

set ytics 10
set title machine." - ".cores." cores\n CSL:".csl." CSU:".csu." NCSL:".ncsl." NCSU:".ncsu noenhanced
set xlabel xl 

set style line 12 lc rgb '#000000' lt "-" lw 2
set grid back ls 12


set xlabel  offset character 0,0,0 font "Courier" textcolor lt -1 norotate
set yrange [ 0.00000 : 110 ] noreverse nowriteback
set ylabel "CPU usage (%)"


THREADS="2 4 8 12 16    20 24 28 32 36    40 42 44 46 50   58 66 74 82 90   98 124 156 174 208 "
threads = "2 4 8 12 16 20"


plot newhistogram "2",  filename  using ($2/2   ):xtic(1) fs pattern 1 lc rgb "#000000" title "User",     '' using (column(2 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" title "Sys", \
     newhistogram "4",  filename  using ($3/2   ):xtic(1) fs pattern 1 lc rgb "#000000" notitle,  	 	 '' using (column(3 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" notitle, \
     newhistogram "8",  filename  using ($4/2   ):xtic(1) fs pattern 1 lc rgb "#000000" notitle,  		 '' using (column(4 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" notitle, \
     newhistogram "12", filename  using ($5/2   ):xtic(1) fs pattern 1 lc rgb "#000000" notitle,  		 '' using (column(5 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" notitle, \
     newhistogram "16", filename  using ($6/2   ):xtic(1) fs pattern 1 lc rgb "#000000" notitle,  		 '' using (column(6 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" notitle, \
     newhistogram "20", filename  using ($7/2   ):xtic(1) fs pattern 1 lc rgb "#000000" notitle,  		 '' using (column(7 +25)/2  ):xtic(1) fs pattern 3 lc rgb "#000000" notitle
    
