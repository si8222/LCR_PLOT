set datafile separator ' '
set key autotitle columnhead
set ylabel "Cp [nF]" 
set xlabel 'Bias [V]'
set xtics #5
set y2tics # enable second axis
set ytics nomirror  #0.01
set y2label "D" # label for second axis
set y2range [0:2] 
set xrange [0:] 
set style line 100 lt 1 lc rgb "grey" lw 0.5 # linestyle for the grid
set grid ls 100

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1.5 \
    pointtype 6 pointsize 0.5
set style line 2 \
    linecolor rgb 'red' \
    linetype 1 linewidth 1.5 \
    pointtype 6 pointsize 0.5




plot "5khz_0.50V_101stps.csv" using 6:($2*10**9) with linespoints linestyle 1, '' using 6:4 with linespoints linestyle 2 axis x1y2#'' using 6:4 with lines axis x1y2 lt rgb "red" 

pause -1
#gnuplot -p tut.gnuplot 
