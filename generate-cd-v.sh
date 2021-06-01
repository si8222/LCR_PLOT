#!/bin/bash


= ()
{
    local in="$(echo "$@" | sed -e 's/\[/(/g' -e 's/\]/)/g')";
    awk 'BEGIN {print '"$in"'}' < /dev/null
}



if [ $# -lt 1 ]; then
  echo "evaluate C-V and D-V characteristics from given data file and produces gnuplot macro"
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


flist=$(sed -n "2,$ p" $1 | awk '{print $3}' | sort | uniq)
N=$(echo $flist | wc -w)
#echo $N
#echo $flist

#exit 0

echo "reset"

# unset title
echo "unset title"

echo "set out 'cd-v.eps'"
#echo "set size 2, 1"
#echo "set terminal postscript portrait enhanced color lw 1.5 '"'Helvetica'"' 18"
echo "set terminal postscript landscape enhanced color lw 1.0 '"'Helvetica'"' 16"
#echo "replot"

echo "NX=1; NY=2"
echo "DX=0.13; DY=0.10; SX=0.82; SY=0.42"
echo "set bmargin 0; set tmargin 0; set lmargin DX; set rmargin DX/2"
## set the margin of each side of a plot as small as possible
## to connect each plot without space
#echo "set size 2.0,1.0"
echo "set multiplot"





##—— First Figure–bottom

echo "set size SX,SY"
echo "set xrange [-1.0:5.0e2]"
#echo "set yrange [-0.9:0.9]"
echo "set origin DX,DY;"
echo 'set xlabel "V_{bias} (V)"'
echo "set xlabel offset 0,graph 0.03"
echo "set logscale x"
echo "set logscale y"
echo 'set ylabel "D"'
echo "set ylabel offset graph 0.025,0"
echo 'set ytics format "%2.4g"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"
#echo "set key bottom right horizontal"
#echo "set key below"
echo "unset key"
echo "set yrange [0.00001:2]"
#echo "set xtics offset 0,graph 0.05"
echo ""

#exit 0

echo -e "plot \\"

i=0
#exit 0

#for freq in $flist #sends plot command for every freq
for F in $flist
do
#  echo $freq
#  echo '"-" index' $i 'u 1:4:6 w yerrorbars title "'$freq' Hz",\'
#  freqvalue=${freq/[eE]+*/*10^}
# fvalue=`echo ${freq} | sed -e 's/[eE]+*/\\*10\\^/'`
  fvalue=`echo ${F} | sed -e 's/[eE]+*/\\*10\\^/'`
##  echo $fvalue
#  echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc
# title=`echo "scale=1; if ($fvalue>=1000) { x=$fvalue/1000; print x; print \"k\"} else { print $freq}"|bc`
  title=`echo "scale=1; if ($fvalue>=1000) { x=$fvalue/1000; print x; print \"k\"} else { print $F}"|bc`
  j=0
  let j=$i+1
  #echo -n '"-" u ($1-'$Rbias'*$2):($5):($7) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'Hz"'
  echo -n '"-" u ($6):($4) pt 7 ps 0.5 title "'$title'Hz"'
  let i=$i+1
  if [ $i -ne $N ];
  then
     echo -e ",\\"
  fi
#  echo ""
done

echo ""
echo "TEST1"
echo ""

#for freq in $flist #file sorted by freq
for F in $flist
do
#  echo $freq
  echo ""
  echo "TEST"
  echo ""
# awk '{if($3=='$freq') print $0}' $1
  awk '{if($3=='$F') print $0}' $1 #maybe 3. row
  echo "end"
done
echo ""
echo ""









##——- 2nd Figure—-top

# title
filename=$(basename "$1")
filename="${filename%.*}"

echo "set title \"APD" $filename "irrad+annealed\""

echo "set origin DX,DY+SY"
#echo "unset xtics"
echo 'set ylabel "Cb (pF)"'
echo "set ylabel offset graph 0.0,0"
echo 'set ytics format "%2.0f"'
echo "set grid"
echo "set grid mytics"
echo "set grid mxtics"
#echo "set yrange [0.009:*]"
#echo "set yrange [90.0:5000]"
echo "set yrange [1:1000]"
echo 'unset xlabel'
echo 'set xtics format ""'
echo "set key bottom left horizontal"
#echo "unset key"
echo ""

echo -e "plot \\"

i=0

#for freq in $flist
for F in $flist
do
#  echo $freq
#  echo '"-" index' $i 'u 1:4:6 w yerrorbars title "'$freq' Hz",\'
#  freqvalue=${freq/[eE]+*/*10^}

 
  #fvalue=`echo ${freq} | sed -e 's/[eE]+*/\\*10\\^/'`
  fvalue=`echo ${F} | sed -e 's/[eE]+*/\\*10\\^/'`
#  echo $freqvalue
#  echo "scale=1; if ($freqvalue>=1000) { x=$freqvalue/1000; print x; print \"k\"} else { print $freq}"|bc
  title=`echo "scale=1; if ($fvalue>=1000) { x=$fvalue/1000; print x; print \"k\"} else { print $fvalue}"|bc`
  j=0
  let j=$i+1
  #echo -n '"-" u ($1-'$Rbias'*$2):($4*1e12):($6*1e12) w yerrorbars lt 1 lc '$j' pt 7 ps 0.5 title "'$title'Hz"'
  echo -n '"-" u ($6):($2*1e12) pt 7 ps 0.5 title "'$title'Hz"' #reihen geändert
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
for F in $flist
#for freq in $flist
do
#  echo $freq
  echo ""
  echo ""
#  awk '{if($3=='$freq') print $0}' $1
  awk '{if($3=='$F') print $0}' $1
  awk '{if($3=='$F') print $0}' $1 >> $filename$F'depl'.csv 
  
  echo "end"
done


echo ""
echo ""
echo "unset multiplot"

echo "pause -1"

