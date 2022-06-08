#!/bin/bash


for num in {0..55}
do 
echo $password | sudo -S mv ./150GDB_128Mwork_256Mshared_noindex_smj_micron_pg13-6_1Q_F_off_T_on.blktrace.$num ./150GDB_512Mwork_256Mshared_noindex_smj_micron_pg13-6_1Q_F_off_T_on.blktrace.$num
done
