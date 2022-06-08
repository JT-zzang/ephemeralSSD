#!/bin/bash

password="1598"

TEST_NAME=$1

echo $password | sudo -S rm -r ./blktrace/hj/blk_backup/${TEST_NAME}
echo $password | sudo -S rm -r ./blktrace/hybrid/blk_backup/${TEST_NAME}
echo $password | sudo -S rm -r ./blktrace/smj/blk_backup/${TEST_NAME}
echo $password | sudo -S rm ./${TEST_NAME}*


echo $password | sudo -S rm ./iostat/smj/${TEST_NAME}.*
echo $password | sudo -S rm ./mpstat/smj/${TEST_NAME}.*
echo $password | sudo -S rm ./inotify/smj/${TEST_NAME}.*
echo $password | sudo -S rm ./log/smj/smartctl/${TEST_NAME}*
echo $password | sudo -S rm ./log/smj/temp_size/${TEST_NAME}*
echo $password | sudo -S rm -r ./query/smj/${TEST_NAME}*

echo $password | sudo -S rm ./iostat/hybrid/${TEST_NAME}.*
echo $password | sudo -S rm ./mpstat/hybrid/${TEST_NAME}.*
echo $password | sudo -S rm ./inotify/hybrid/${TEST_NAME}.*
echo $password | sudo -S rm ./log/hybrid/smartctl/${TEST_NAME}*
echo $password | sudo -S rm ./log/hybrid/temp_size/${TEST_NAME}*
echo $password | sudo -S rm -r ./query/hybrid/${TEST_NAME}*

echo $password | sudo -S rm ./iostat/hj/${TEST_NAME}.*
echo $password | sudo -S rm ./mpstat/hj/${TEST_NAME}.*
echo $password | sudo -S rm ./inotify/hj/${TEST_NAME}.*
echo $password | sudo -S rm ./log/hj/smartctl/${TEST_NAME}*
echo $password | sudo -S rm ./log/hj/temp_size/${TEST_NAME}*
echo $password | sudo -S rm -r ./query/hj/${TEST_NAME}*
