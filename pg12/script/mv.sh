#!/bin/bash

password=1598
for num in {0..55}
do 
echo $password | sudo -S mv ./200GDB_1Gwork_1Gshared_0Gdum_noidx_hj_micron_pg13_5Q_F_off_T_on/20GDB_1Gwork_1Gshared_0Gdum_noidx_hj_micron_pg13_5Q_F_off_T_on.blktrace.$num ./200GDB_1Gwork_1Gshared_0Gdum_noidx_hj_micron_pg13_5Q_F_off_T_on/200GDB_1Gwork_1Gshared_0Gdum_noidx_hj_micron_pg13_5Q_F_off_T_on.blktrace.$num
done

