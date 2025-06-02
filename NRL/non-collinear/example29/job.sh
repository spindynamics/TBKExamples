#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate orbital moment and DOS of 1LCo/3LPt(111)"


# set the needed environment variables
. ../../../environment_variables

ulimit -s unlimited

rm -rf xyz scf dos

mkdir xyz
mkdir scf
mkdir dos

cat > in_master.txt<<EOF
&calculation
 processing='scf'
 post_processing='dos'
 post_processing_dir='dos'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 2
 symbol(1) = 'Co'
 symbol(2) = 'Pt'
 u_lcn(1)=10
 u_lcn(2)=10
 i_stoner_d(1) = 1.10
 i_stoner_d(2) = 0.50
 xi_so_d(1)=0.08
 xi_so_d(2)=0.45
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/co_par_fcc_bcc_sc_gga_fl'
 filename(2) = '$TBPARAM_DIR/pt_par_fcc_bcc_sc_lda_fl'
 /
&lattice
 v_factor =1.00000
 v(1,:) =  1.38719996045356221723, -2.40270081176310708345, 0.0
 v(2,:) =  1.38719996045356221723,  2.40270081176310708345, 0.0
 v(3,:) =  0.0, 0.0, 30.00
 /
&atom
 ns = 4
 na = 4
 ntag = 2
 tag(1) = 'Co'
 stag(1)=1
 tag(2) = 'Pt'
 stag(2)=3
 pbc = 5, 5, 0
 r_coord='direct'
 r(1,:) =   0.            ,  0.            ,  0.221843333333
 r(2,:) =   0.333333838943,  0.666666135826,  0.1545098728 
 r(3,:) =  -0.333333836759,  0.333333836759,  0.075509730533
 r(4,:) =   0.            ,  0.            ,  0.000000005867
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 3.0, 0, 0
m(2,:) = 0.0, 0, 0
 /
&mesh
 type = 'mp'
 gx = 15, 15, 1
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
 delta_en=0.00001
 delta_q=0.00001
 verbose=.true.
 /
EOF

cat > dos/in_energy.txt<<EOF
&energy
 smearing = 'g'
 degauss = 0.1
 en_min = -10.0
 en_max =  10.0
 /
EOF

cat > dos/in_dos.txt<<EOF
&dos
 nen=500
 na_dos=4
 ia(1)=1
 ia(2)=2
 ia(3)=3
 ia(4)=4 
 en_min=-5
 en_max=5
 /
EOF

cat > dos/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 15, 15, 1
 dx = 0, 0, 0
 /
EOF



# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 


