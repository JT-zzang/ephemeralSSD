#!/bin/bash

password="1598"

PGSQL_VER="12"
TRIM="off"
SSD="micron"
FALLOC="off"
n=100
dum_size=57
if [ "$SSD" = "micron" ] ; then
	DEV=/dev/sdb
elif [ "$SSD" == "samsung970" ] ; then
	DEV=/dev/nvme1n1
else
	DEV=" "
fi
    
RESULT_PATH=/result/postgres
DATA_DIR=/home/postgres/mount/970pro/pg12_data
TEST_NAME="5P_20GDB_4Mwork_128Mshared_${dum_size}Gdum_noidx_hj_${SSD}_pg${PGSQL_VER}_${n}Q_F_${FALLOC}_T_${TRIM}"
log=/home/postgres/mount/970pro/pg_log


log_streams(){
	
	while true
	do
		date &&
		echo $password | sudo -S smartctl -A ${DEV}
		sleep 60
	done
}
dirty_streams() {
	while true
	do
		date && df -h ${DEV}
		sleep 60
	done
}

echo $password | sudo -S fuser -ck ${DEV}

echo $password | sudo -S sysctl -w vm.drop_caches=3

echo $password | sudo -S umount ${DEV}

echo $password | sudo -S blkdiscard ${DEV}

echo $password | sudo -S mkfs.ext4 ${DEV} -E discard,lazy_itable_init=0,lazy_journal_init=0 -F

if [ "$TRIM" = "on" ] ; then
	echo $password | sudo -S mount -o discard ${DEV} ${DATA_DIR}/base/pgsql_tmp
else
	echo $password | sudo -S mount ${DEV} ${DATA_DIR}/base/pgsql_tmp
fi

echo $password | sudo -S chown -R postgres:postgres ${DATA_DIR}/base/pgsql_tmp


#make dummy file to limit RAM
echo $password | sudo -S dd if=/dev/zero of=/home/postgres/ramdisk/dummy bs=1G count=$dum_size

#start pgsql server
/home/postgres/pgsql/bin/pg_ctl -D ${DATA_DIR} -l ${log}/${TEST_NAME}_log start

sleep 10

#check pgsql server status
/home/postgres/pgsql/bin/pg_ctl -D ${DATA_DIR} -l ${log}/${TEST_NAME}_log status

echo "server started"

#inotify

echo "inotify starting"

inotifywatch -v ${DATA_DIR}/base/pgsql_tmp > ${RESULT_PATH}/inotify/hj/${TEST_NAME}.inotifywatch &
#inotifywait -m --timefmt '%T' --format '%T %e %f' ${DATA_DIR}/base/pgsql_tmp -o ${RESULT_PATH}/inotify/hj/${TEST_NAME}.inotifywait &

echo "inotify started"

#iostat

echo "iostat starting"

echo $password | sudo -S iostat -xm 1 ${DEV} > ${RESULT_PATH}/iostat/hj/${TEST_NAME}.iostat &

echo "iostat started"

#mpstat

echo "mpstat starting"

echo $password | sudo -S mpstat -P ALL 60 > ${RESULT_PATH}/mpstat/hj/${TEST_NAME}.mpstat &

echo "mpstat started"


#blktrace

echo "blktrace starting"

echo $password | sudo -S blktrace ${DEV} -o ${TEST_NAME} -a issue -a requeue -a complete &

echo "blktrace started"

(dirty_streams >> ${RESULT_PATH}/log/hj/temp_size/${TEST_NAME}_temp_size.log) &
dirty_pid=$!

(log_streams >> ${RESULT_PATH}/log/hj/smartctl/${TEST_NAME}_smartctl.log) &
stream_pid=$!

echo "Query started"

number=1

while [ $number -le $n ]
do
	echo -e "\n\n\n\nRepetition $number started\n\n\n\n" 

	/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_1.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
	q1_pid=$!
	/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_2.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
	q2_pid=$!
	/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_3.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
	q3_pid=$!
	/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_4.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
	q4_pid=$!
	/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_5.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
	q5_pid=$!
	#/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_6.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
        q6_pid=$!
        #/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_7.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
        q7_pid=$!
        #/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_8.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
        #q8_pid=$!
        #/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_9.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
        #q9_pid=$!
        #/home/postgres/pgsql/bin/psql -U postgres -d postgres -o ${RESULT_PATH}/query/hj/${TEST_NAME}_${number}_10.qplan -c "EXPLAIN ANALYZE /*+ HashJoin(lineitem orders) SeqScan(orders) SeqScan(lineitem) */ SELECT * FROM lineitem JOIN orders ON orders.o_orderkey = lineitem.l_orderkey" &
        #q10_pid=$!	

	wait ${q1_pid}
	wait ${q2_pid}
	wait ${q3_pid}
	wait ${q4_pid}
	wait ${q5_pid}
	#wait ${q6_pid}
        #wait ${q7_pid}
        #wait ${q8_pid}
        #wait ${q9_pid}
        #wait ${q10_pid}
	
	((number++))
done

echo $password | sudo -S sysctl -w vm.drop_caches=3
#for_stop_test $q1_pid $q2_pid $q3_pid $q4_pid $q5_pid
sleep 100

echo $password | sudo -S kill -9 ${dirty_pid}
echo $password | sudo -S kill -9 ${stream_pid}
echo $password | sudo -S killall -15 inotifywatch inotifywait iostat blktrace mpstat

sleep 100

echo $password | sudo -S rm /home/postgres/ramdisk/dummy

echo $password | sudo -S mkdir /result/postgres/blktrace/hj/blk_backup/${TEST_NAME}

echo $password | sudo -S mv ./${TEST_NAME}.blktrace.* /result/postgres/blktrace/hj/blk_backup/${TEST_NAME}/



/home/postgres/pgsql/bin/pg_ctl -D ${DATA_DIR} -l ${log}/${TEST_NAME}_log stop
