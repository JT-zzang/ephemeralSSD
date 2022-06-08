#!/bin/bash

input_file=$1

cat ${input_file}.final | grep R | grep C | awk '{printf "%d\n", $5/2}'  > ./${input_file}.final.size_R

cat ${input_file}.final | grep W | grep C | awk '{printf "%d\n", $5/2}'  > ./${input_file}.final.size_W 

#sed -i '/0.0000/d' ./parsed/parsed_$input_file

