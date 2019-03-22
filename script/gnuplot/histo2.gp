ext = ".eps"
set term postscript eps enhanced color font "Courier" 16 size 8,8
set tics font "Courier,10"
set key font ",10"
set output filename.'-cores'.ext

set title "Test"
set key invert reverse Left outside 
set style data histogram
set style histogram rowstacked title offset 0,2
set style fill pattern border -1

set size 2,1

set boxwidth 0.75

set xtics border in scale 0,0 nomirror rotate by -45  autojustify
set xtics norangelimit  font ",8"
set xtics ()

set ytics border in scale 0,0 mirror norotate  autojustify
set ytics norangelimit autofreq  font ",8"
set ztics border in scale 0,0 nomirror norotate  autojustify
set cbtics border in scale 0,0 mirror norotate  autojustify
set rtics axis in scale 0,0 nomirror norotate  autojustify

set ytics 10
set title machine." - ".cores." cores\n CSL:".csl." CSU:".csu." NCSL:".ncsl." NCSU:".ncsu noenhanced
set xlabel xl 

set style line 12 lc rgb '#000000' lt "-" lw 2
set grid back ls 12


set xlabel  offset character 0,3,0 font "" textcolor lt -1 norotate
set yrange [ 0.00000 : * ] noreverse nowriteback
set ylabel "CPU usage (%)"

threads = "2 4 6 12 18 24 30 36 42 48"
THREADS="1 3 6 12 18 24 30 36 42 48 52 58 60 70 80 90 100 125 150 175 200"

