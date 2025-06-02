#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to compute the forces on a trimer"


# removing things before computation
rm -rf tempo* *.dat *.txt *.gnuplot *.png scf

mkdir scf

# set the needed environment variables
. ../../../environment_variables

#y=$(echo "sqrt(3.0)" | bc -l)

END=30

for ((i=0;i<=END;i++)); do

y=$(echo "scale=5;sqrt(3.0)+($i-$END/2)/$END"| bc -l)

echo "y= $y"

cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing= 'forces'
 post_processing_dir= 'scf'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 1
 symbol(1) = 'Pt'
 q(1)   = 10.0
 q_d(1) = 8.8
 u_lcn(1)=20
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/pt_par_fcc_bcc_sc_lda_fl'
 /
&lattice
 v_factor = 1.0
 v(1,:) = 1 0 0
 v(2,:) = 0 1 0
 v(3,:) = 0 0 1 
 /
&atom
 ns = 1
 na = 3
 ntag = 1
 tag(1) = 'Pt'
 stag(1)= 3
 pbc = 0, 0, 0
 r_coord='cartesian'
 r(1,:) = 0.0 0.0 0.0
 r(2,:) = 0.0 ${y} 1.0
 r(3,:) = 0.0 0.0 2.0
 /
&mesh
 type = 'mp'
 gx = 1, 1, 1
 dx = 0, 0, 0
 /
&hamiltonian_tb
 /
&energy
 smearing = 'mv'
 degauss = 0.05
 /
&mixing
 alpha = 0.1
 /
&scf
 delta_en=0.0001
 delta_q=0.0001
 verbose=.false.
 ni_max=200
 /
&forces
 computed=.true.
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x

en=$(grep "en =" ./out_energy.txt | cut -d"=" -f2)

Fx1=$(grep -e 'f(1' scf/out_log.txt| awk '/f/{print $(NF-2)}'| sed -e 's/,//g')
Fy1=$(grep -e 'f(1' scf/out_log.txt| awk '/f/{print $(NF-1)}'| sed -e 's/,//g')
Fz1=$(grep -e 'f(1' scf/out_log.txt| awk '/f/{print $(NF)}'| sed -e 's/,//g')
F1=$(echo "scale=4;sqrt(${Fx1}*${Fx1}+${Fy1}*${Fy1}+${Fz1}*${Fz1})" | bc -l)
Fx2=$(grep -e 'f(2' scf/out_log.txt| awk '/f/{print $(NF-2)}'| sed -e 's/,//g')
Fy2=$(grep -e 'f(2' scf/out_log.txt| awk '/f/{print $(NF-1)}'| sed -e 's/,//g')
Fz2=$(grep -e 'f(2' scf/out_log.txt| awk '/f/{print $(NF)}'| sed -e 's/,//g')
F2=$(echo "scale=4;sqrt(${Fx2}*${Fx2}+${Fy2}*${Fy2}+${Fz2}*${Fz2})" | bc -l)
Fx3=$(grep -e 'f(3' scf/out_log.txt| awk '/f/{print $(NF-2)}'| sed -e 's/,//g')
Fy3=$(grep -e 'f(3' scf/out_log.txt| awk '/f/{print $(NF-1)}'| sed -e 's/,//g')
Fz3=$(grep -e 'f(3' scf/out_log.txt| awk '/f/{print $(NF)}'| sed -e 's/,//g')
F3=$(echo "scale=4;sqrt(${Fx3}*${Fx3}+${Fy3}*${Fy3}+${Fz3}*${Fz3})" | bc -l)

sumx=$(echo "${Fx1}+${Fx2}+${Fx3}"| bc -l)
sumy=$(echo "${Fy1}+${Fy2}+${Fy3}"| bc -l)
sumz=$(echo "${Fz1}+${Fz2}+${Fz3}"| bc -l)

echo ${y} ${en} ${Fx1} ${Fy1} ${Fz1} ${F1} >> results.dat
echo ${y} ${en} ${Fx2} ${Fy2} ${Fz2} ${F2} >> results.dat
echo ${y} ${en} ${Fx3} ${Fy3} ${Fz3} ${F3} >> results.dat

echo  ${sumx} ${sumy} ${sumz} >> results.dat

done
