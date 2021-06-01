#!/bin/bash


= ()
{
    local in="$(echo "$@" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
    awk 'BEGIN {print '"$in"'}' < /dev/null
}

if [ $# -lt 1 ]; then
  echo "evaluate C-f and D-f characteristics from given data file and produces gnuplot macro"
  echo "need at least 1 argument (filename)"
  echo "usage: $0 <file> | gnuplot"
  echo " parameters:"
  echo "  file - input data file"
  exit 1
fi

Rbias=0

if [ $# -gt 1 ]; then
	Rbias=$2
fi


vlist=$(sed -n "2,$ p" $1 | awk '{print $1}' | sort -h | uniq)
N=$(echo $vlist | wc -w)
#echo $N
#echo $vlist

#exit 0

echo "reset"

echo "set out 'cd-f.eps'"
#echo "set size 2, 1"
echo "set terminal postscript landscape enhanced color lw 1.0 '"'Helvetica'"' 16"
#echo "replot"

echo "NX=1; NY=2"
echo "DX=0.13; DY=0.10; SX=0.82; SY=0.42"
echo "set bmargin 0; set tmargin 0; set lmargin DX; set rmargin DX/2"
## set the margin of each side of a plot as small as possible
## to connect each plot without space
echo "set multiplot"





##—— First Figure–bottom

echo "set size SX,SY"
echo "set xrange [.5:1.5e3]"
#echo "set yrange [-0.9:0.9]"
echo "set origin DX,DY;"
echo 'set xlabel "f(kHz)"'
echo "set xlabel offset 0,graph 0.02"
echo "set logscale x"
echo "set logscale y"
echo 'set ylabel "D"'
echo "set ylabel offset graph 0.025,0"
echo 'set ytics format "%2.3f"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"
#echo "set key bottom right horizontal"
#echo "set key below"
echo "unset key"
echo "set yrange [0.001:5]"
#echo "set xtics offset 0,graph 0.05"
echo ""

#exit 0

echo -e "plot \\"

i=0

for volt in $vlist
do
#  echo $freq
#  echo '"-" index' $i 'u 1:4:6 w yerrorbars title "'$freq' Hz",\'
#  freqvalue=${freq/[eE]+*/*10^}

 
 vvalue=`echo ${volt} | sed -e 's/[eE]+*/\\*10\\^/'`
#  echo $freqvalue
#  echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc
  title=`echo "scale=1; print $vvalue"|bc`
  j=0
  let j=$i+1
  echo -n '"-" u ($3/1000):($5):($7) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'V"'
  let i=$i+1
  if [ $i -ne $N ];
  then
     echo -e ",\\"
  fi
#  echo ""
done

echo ""
echo ""


for volt in $vlist
do
#  echo $freq
  echo ""
  echo ""
  awk '{if($1=='$volt') print $0}' $1
  echo "end"
done
echo ""
echo ""









##——- 2nd Figure—-top
echo "set origin DX,DY+SY"
#echo "unset xtics"
echo 'set ylabel "C_{b}(pF)"'
echo "set ylabel offset graph 0.04,0"
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"
echo "set yrange [0.009:*]"
echo 'unset xlabel'
echo 'set xtics format ""'
echo "set key bottom right horizontal"
#echo "unset key"
echo ""

echo -e "plot \\"

i=0

for volt in $vlist
do
#  echo $freq
#  echo '"-" index' $i 'u 1:4:6 w yerrorbars title "'$freq' Hz",\'
#  freqvalue=${freq/[eE]+*/*10^}

 
 vvalue=`echo ${volt} | sed -e 's/[eE]+*/\\*10\\^/'`
#  echo $freqvalue
#  echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc
  title=`echo "scale=1; print $vvalue"|bc`
  j=0
  let j=$i+1
  echo -n '"-" u ($3/1000):($4*1e12):($6*1e12) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'V"'
  let i=$i+1
  if [ $i -ne $N ];
  then
     echo -e ",\\"
  fi
#  echo ""
done

echo ""
echo ""


#exit 0

## here follows the generated data array

echo ""
echo ""

for volt in $vlist
do
#  echo $freq
  echo ""
  echo ""
  awk '{if($1=='$volt') print $0}' $1
  echo "end"
done

#for volt in $vlist
#do
##  echo $freq
#  echo ""
#  echo ""
#  awk '{if($1=='$volt') print $0}' $1
#  echo "end"
#done

#echo "end"

echo ""
echo ""
echo "unset multiplot"

echo "pause -1"

