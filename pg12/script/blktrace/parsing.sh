#!/bin/bash

TEST=$1

./1_pre_btrace.sh ./${TEST}/${TEST}.btrace
./request_size.sh ./${TEST}/${TEST}.btrace


awk '{sum += $1} END { print sum }' ./${TEST}/${TEST}.btrace.final.size_R
awk '{sum += $1} END { print sum }' ./${TEST}/${TEST}.btrace.final.size_W
