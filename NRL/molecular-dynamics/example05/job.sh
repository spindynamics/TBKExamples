#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the forces for 4 slabs of Au(111)"


# set the needed environment variables
. ../../../environment_variables

# removing things before computation
rm -rf tempo* *.dat *.txt *.gnuplot *.png scf

mkdir scf

a=2.88499566724111

cat > Etot_vs_forces.dat << EOF
@# a f Etot
EOF


#for dz in -0.2 -0.19 -0.18 -0.17 -0.16 -0.15 -0.14 -0.13 -0.12 -0.11 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0 0.01 0.02 0.03 0.04 0.05; do
for dz in 0 ; do
  echo "dz= ${dz}"

cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing='forces'
 post_processing_dir = 'scf'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 1
 symbol(1) = 'Au'
 q(1)   = 11.0
 q_d(1) = 10
 u_lcn(1)=20
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/au_par_fcc_bcc_sc_lda_fl'
 /
&lattice
 v_factor = $a
 v(1,:) = 1.0 0.0 0.0
 v(2,:) =-0.5 0.866025403784438 0
 v(3,:) = 0.0 0.0 2.44948974278317811398
 /
&atom
 ns = 1
 na =3
 ntag = 1
 tag(1) = 'Au'
 stag(1)=3 
 pbc = 15, 15, 0 
 r_coord='direct'
 r(1,:) =      0.0000000             0.0000000                  $dz
 r(2,:) =      0.33333333333333      0.6666666666666666         0.333333333333333333
 r(3,:) =      0.66666666666666      0.3333333333333333         0.666666666666666666
 /
&mesh
 type = 'mp'
 gx = 15 , 15 , 1
 dx = 0, 0, 0
 /
&hamiltonian_tb
 /
&energy
 smearing = 'mv'
 degauss = 0.1
 /
&mixing
 alpha = 0.1
 /
&scf
 delta_en=0.0001
 delta_q=0.0001
 verbose=.true.
 ni_max=200
 /
&forces
 computed=.true.
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x


cat > alat << EOF
dz= $(echo "$dz" | bc -l)
EOF

grep -e 'f(1' scf/out_log.txt| awk '/f/{print $(NF)}' >fz

grep -e 'dz=' alat | awk '{print $2}' > dz

grep -e 'en =' out_energy.txt | awk '{print $3}' > en

paste dz fz en >> Etot_vs_forces.dat

cp ./scf/out_log.txt ./scf/out_log$(echo "$dz" | bc -l).txt
done

rm -f alat dz en fz
 
