#!/bin/bash


test=$1

paste -d ' ' ${test}_F_off_T_off.max ${test}_F_off_T_on.max ${test}_F_on_T_off.max ${test}_F_on_T_on.max > ${test}.dat
