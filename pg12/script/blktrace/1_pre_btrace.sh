#!/bin/bash

input_file=$1
#btrace 파싱_ 필요한것 확인하여 쓰기
sed -e '/WS 0 \[0\]/d' -e '/jbd/d'  -e '/smartctl/d' -e '/smartd/d' -e '/FWFS/d' -e '/PC/d' -e '/N/d' -e '/CPU/d' -e '/blktrace/d' -e '/IO/d' -e '/Total/d' -e '/Event/d' -e '/Skips/d' -e '/Read/d' -e '/Throughput/d' -e '/fdisk/d' -e '/lshw/d' -e '/pool/d' $input_file > ./$input_file.sed
#sed '/R/d'  $input_file > ./parsed/rm_READ_$input_file
#sed '/D  D/d'  $input_file > first.txt
#sed '/D   D/d'  first.txt > second.txt
#sed '/W/d'  $input_file > temp.txt
cat $input_file.sed | grep + > ./$input_file.mid


cat $input_file.mid | awk '{printf "%.9f %s %s %d %d %s\n", $4, $6, $7, $8, $10, $11}'  > ./$input_file.final

#sed -i '/0.0000/d' ./parsed/parsed_$input_file

rm $input_file.sed
rm $input_file.mid
