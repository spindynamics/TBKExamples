#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the E(theta) MAE of a Fe cluster using penalization"
$ECHO "a similar calculation could be done for E(theta,phi)"

# set the needed environment variables
. ../../../environment_variables

rm -rf tempo* *.dat *.txt *.gnuplot *.png 


for i in {0..180..5} ; do
for j in {0..360..5} ; do

theta=$(echo "$i" | bc -l)
phi=$(echo "$j" | bc -l)
echo 'theta= ' $theta 'phi= '$phi


cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing = 'txt2xyz'
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
 symbol(1) = 'Fe'
 q(1)   = 8.0
 q_d(1) = 7.0
 u_lcn(1)=20
 i_stoner_d(1) = 0.95
 xi_so_d(1)=0.06
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/fe_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor =2.48549290886133891619
 v(1,:) = 10 0 0
 v(2,:) = 0 10 0
 v(3,:) = 0 0 10 
 /
&atom
 ns = 4
 na = 13
 ntag = 1
 tag(1) = 'Fe'
 stag(1)=13
 pbc = 0, 0, 0
 r_coord='cartesian'
 r(1,:) =      0.0000000     0.0000000     0.0000000
 r(2,:) =      0.0000000     1.7575089     1.7575089
 r(3,:) =      0.0000000    -1.7575089     1.7575089
 r(4,:) =      0.0000000     1.7575089    -1.7575089
 r(5,:) =      0.0000000    -1.7575089    -1.7575089
 r(6,:) =      1.7575089     0.0000000     1.7575089
 r(7,:) =     -1.7575089     0.0000000     1.7575089
 r(8,:) =      1.7575089     0.0000000    -1.7575089
 r(9,:) =     -1.7575089     0.0000000    -1.7575089
 r(10,:) =     1.7575089     1.7575089     0.0000000
 r(11,:) =    -1.7575089     1.7575089     0.0000000
 r(12,:) =     1.7575089    -1.7575089     0.0000000
 r(13,:) =    -1.7575089    -1.7575089     0.0000000
 m_listing = 'by_atom'
 m(1,:) = 3.0,  $theta, $phi
 m(2,:) = 3.0,  $theta, $phi
 m(3,:) = 3.0,  $theta, $phi
 m(4,:) = 3.0,  $theta, $phi
 m(5,:) = 3.0,  $theta, $phi
 m(6,:) = 3.0,  $theta, $phi
 m(7,:) = 3.0,  $theta, $phi
 m(8,:) = 3.0,  $theta, $phi
 m(9,:) = 3.0,  $theta, $phi
 m(10,:) = 3.0, $theta, $phi
 m(11,:) = 3.0, $theta, $phi
 m(12,:) = 3.0, $theta, $phi
 m(13,:) = 3.0, $theta, $phi
 lambda_pen_listing = 'by_tag'
lambda_pen(1) = 5.0
 /
&mesh
 type = 'mp'
 gx = 1, 1, 1
 dx = 0, 0, 0
 /
&hamiltonian_tb
m_penalization = 'theta,phi'
 /
&energy
 smearing = 'mv'
 degauss = 0.05
 /
&mixing
 alpha = 0.2
 /
&scf
 delta_en=0.00001
 delta_q=0.00001
 verbose=.false.
 ni_max=2000
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

cat > tempo << EOF
thetaphi= $theta  $phi
EOF

cat tempo out_energy.txt>>tempo2
done
done
grep -e 'thetaphi=' -e 'en =' tempo2 | awk '/thetaphi/{theta = $(NF-1)}/thetaphi/{phi = $(NF)}/en/{print theta, phi, $(NF)}' >> Etot_vs_theta_phi.dat

rm -f tempo*

E0=$(grep -m1 "0 0" Etot_vs_theta_phi.dat | awk '{print $NF}')

cat > MAE.gnuplot<<EOF
set term png enh size 700,500
set out 'Etot_vs_theta_phi.png'
set angles degrees
set view equal xy 
splot "Etot_vs_theta_phi.dat" using (1000*(\$3-$E0)*sin(\$1)*cos(\$2)):(1000*(\$3-$E0)*sin(\$1)*sin(\$2)):(1000*(\$3-$E0)*cos(\$1))
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot MAE.gnuplot
fi
