#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`


# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "Forces for the Cr triangular trimer to a non-collinear magnetic calculation."

# set the needed environment variables
. ../../../environment_variables

rm -rf tempo* *.dat *.txt *.gnuplot *.png scf
mkdir scf

vfactor=2.79

cat > Etot_vs_forces.dat << EOF
@# a f Etot
EOF

for dx in -0.06 -0.05 -0.04 -0.035 -0.03 -0.025 -0.02 -0.01 0 0.01 0.02 0.025 0.03 0.035 0.04 0.05 0.06 ; do

  echo "dx= ${dx}"

cat > in_master.txt<<EOF
&units
 energy = 'eV'
 length = 'ang'
 time = 'fs'
 mass='hau'
 /
&calculation
 processing = 'scf'
 post_processing='forces'
 post_processing_dir = 'scf'
 /
&element
 ne = 1
 symbol(1) = 'Cr'
 q(1) = 6.0
 q_d(1) = 5.0
 u_lcn(1) = 20.0000000000000000
 i_stoner_d(1) = 0.82
 xi_so_d(1) = 0.0
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/cr_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor = $vfactor
 v(1,:) = 1.000000000000000, 0.0000000000000000, 0.0000000000000000
 v(2,:) = 0.0000000000000000, 1.000000000000000, 0.0000000000000000
 v(3,:) = 0.0000000000000000, 0.0000000000000000, 1.0000000000000000
 /
&atom
 ns = 4
 na = 3
 ntag = 1
 stag(1) = 3
 tag(1) = 'Cr_trimer'
 pbc = 0, 0, 0
 r(1,:) = $dx, 0.0000000000000000, 0.0
 r(2,:) = 0.86602540378443864676,-0.5, 0.0
 r(3,:) = 0.86602540378443864676, 0.5, 0.0
 m_listing = 'by_atom'
 m_coord = 'spherical'
 m(1,:) = 3.0000000000000000, 90.0000000000000000, 180.0000000000000000
 m(2,:) = 3.0000000000000000, 90.000000000000000, -60.0000000000000000
 m(3,:) = 3.0000000000000000, 90.0000000000000000, 60.0000000000000000
 lambda_pen_listing= 'by_tag'
 lambda_pen(1) = 0.0
 m_coord = 'spherical'
 /
&mesh
 type = 'mp'
 gx = 1, 1, 1
 dx = 0, 0, 0
 /
&hamiltonian_tb
 m_penalization = 'r,theta,phi'
 /
&energy
 smearing = 'mv'
 degauss = 0.1
 /
&mixing
 alpha = 0.1
 /
&scf
 delta_en = 0.0001
 delta_q  = 0.0001
 verbose = .true.
 ni_max = 1500
 /
&forces
 computed=.true.
 /
EOF

# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

cat > alat << EOF
dx= $(echo "$dx*$vfactor" | bc -l)
EOF

grep -e 'f(1' scf/out_log.txt| awk '/f/{print $(NF-2)}' >fx

grep -e 'dx=' alat | awk '{print $2}' > dx

grep -e 'en =' out_energy.txt | awk '{print $3}' > en

paste dx fx en >> Etot_vs_forces.dat

cp ./scf/out_log.txt ./scf/out_log$(echo "$dx*$vfactor" | bc -l).txt
done

rm -f dx alat en fx
