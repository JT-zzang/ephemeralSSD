#!/bin/bash

TEST=$1
password='1598'

cd ./$TEST

mkdir /result/postgres/blktrace/hj/parsed/$TEST
echo $password | sudo -S blkparse $TEST > /result/postgres/blktrace/hj/parsed/$TEST/${TEST}.btrace
