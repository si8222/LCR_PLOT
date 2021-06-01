#!/bin/bash


= ()
{
    local in="$(echo "$@" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
    awk 'BEGIN {print '"$in"'}' < /dev/null
}

if [ $# -lt 1 ]; then
  echo "evaluate I-V characteristics from given data file and produces gnuplot macro"
  echo "need at least 1 argument (filename)"
  echo "usage: $0 <file> [<Rbias>] | gnuplot"
  echo " parameters:"
  echo "  file - input data file"
  echo "  Rbias - value of bias series resistor in MOhm (default 0)"
  exit 1
fi

Rbias=0

if [ $# -gt 1 ]; then
	Rbias=$2
fi


echo "reset"

# title
filename=$(basename "$1")
filename="${filename%.*}"

echo "set title \"APD" $filename "irrad+annealed\""

echo "set out 'i-v.eps'"

echo "set terminal postscript landscape enhanced color lw 1.2 '"'Helvetica'"' 16"
echo "set xrange [1.5:500]"
echo "set yrange [0.0005:*]"

echo "set logscale x"
echo "set logscale y"
echo 'set xlabel "V_{bias}(V)"'
#echo "set xlabel offset 0,graph 0.01"

echo "set ylabel offset graph 0.035,0"
echo 'set ylabel "I_{L}(uA)"'
echo 'set ytics format "%2.3f"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"

echo ""

#exit 0

echo -e "plot \\"

echo '"-" u ($1-'$Rbias'*$2):($2):(0.00005*$1+0.8):(0.001*$2+0.02) w xyerrorbars lt 1 lc 1 lw 0.4 pt 7 ps 0.6 notitle'
#echo '"-" u ($1-'$Rbias'*$2):($2) lt 1 lc 1 pt 7 ps 0.5 notitle'

echo ""
echo ""

#awk '{if($3=='$freq') print $0}' $1
sed -n "2,$ p" $1
echo "end"

echo "pause -1"


