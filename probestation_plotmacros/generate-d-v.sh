#!/bin/bash
 
flist=$(sed -n "2,$ p" $1 | awk '{print $3}' | sort -h | uniq)
N=$(echo $flist | wc -w)
#echo $N

#exit 0
if [ $# -lt 1 ]; then
  echo "evaluate D-V characteristics from given data file and produces gnuplot macro"
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


#echo $flist
echo "reset"

## uncomment the following line for landscape format
#echo "set size 2, 1"
echo "set out 'd-v.eps'"
echo "set terminal postscript portrait enhanced color lw 1.5 '"'Helvetica'"' 18"
echo "set xrange [1:400]"
echo "set yrange [0.001:*]"

echo "set logscale x"
echo "set logscale y"
echo 'set xlabel "V_{bias}(V)"'
#echo "set xlabel offset 0,graph 0.02"

echo "set ylabel offset graph 0.035,0"
echo 'set ylabel "D"'
echo 'set ytics format "%2.3f"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"

echo ""

echo -e "plot \\"

i=0

for freq in $flist
do
#  echo $freq
#  echo '"-" index' $i 'u 1:4:6 w yerrorbars title "'$freq' Hz",\'
  freqvalue=`echo ${freq} | sed -e 's/[eE]+*/\\*10\\^/'`
#  echo $freqvalue
#  echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc
  title=`echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc`
  j=0
  let j=$i+1
  echo -n '"-" u ($1-'$Rbias'*$2):($5):($7) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'Hz"'
  let i=$i+1
  if [ $i -ne $N ];
  then
     echo -e ",\\"
  fi
#  echo ""
done

#exit 0
echo ""
echo ""

for freq in $flist
do
#  echo $freq
  echo ""
  echo ""
  awk '{if($3=='$freq') print $0}' $1
  echo "end"
done

#echo "end"
echo "pause -1"


