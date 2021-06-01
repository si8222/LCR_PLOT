#!/bin/bash


= ()
{
    local in="$(echo "$@" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
    awk 'BEGIN {print '"$in"'}' < /dev/null
}


vlist=$(sed -n "2,$ p" $1 | awk '{print $1}' | sort -h | uniq)
N=$(echo $vlist | wc -w)
#echo $N
#echo $vlist

#exit 0

echo "reset"
echo "set out 'c-f.eps'"

## uncomment the following line for landscape format
#echo "set size 2, 1"
echo "set terminal postscript portrait enhanced color lw 1.5 '"'Helvetica'"' 18"
#echo "set xrange [100:1e6]"
echo "set yrange [0.001:*]"

echo "set logscale x"
echo "set logscale y"
#echo "set xlabel offset 0,graph 0.02"

echo "set ylabel offset graph 0.035,0"
echo 'set ylabel "C_{b}(pF)"'
echo 'set xlabel "f(kHz)"'
echo 'set ytics format "%2.3f"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"
echo "set key bottom right horizontal"
#echo "unset key"

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
  echo -n '"-" u ($3/1000):($4*1e12):($6*1e12) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'V"'
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

for volt in $vlist
do
#  echo $freq
  echo ""
  echo ""
  awk '{if($1=='$volt') print $0}' $1
  echo "end"
done

#echo "end"
echo "pause -1"


