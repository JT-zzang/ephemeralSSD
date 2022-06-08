#!/bin/bash


TEST_NAME=$1
NUM=$2
NUM2=$3
cur=1
cur2=1

while [ $cur -le $NUM ] 
do
	MAX=0
	while [ $cur2 -le $NUM2 ]
	do
		STR=`cat ./${TEST_NAME}/${TEST_NAME}_${cur}_${cur2}.qplan | grep Exec | awk '{printf "%d", $3/1000}'`
		NEXT=$(($STR))
		if [ $NEXT -ge ${MAX} ];then
			MAX=${NEXT}
		fi
		((cur2++))
	done
	MAX=$(expr ${MAX} + 1)
	echo ${MAX} >> ${TEST_NAME}.max
	((cur++))
	cur2=1
done


cat ${TEST_NAME}.max
