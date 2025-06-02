#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO " magnetic force theorem to calculate E(theta) for PtCo(111) surface"

# set the needed environment variables
. ../../../environment_variables

rm -rf mft scf
ulimit -s unlimited

a=2.5064814072719552
#a=2.7744041666635386
mkdir mft
mkdir scf

cat > in_master.txt<<EOF
&units
energy = 'ev'
length = 'ang'
time = 'fs'
mass='hau'
/
&calculation
processing = 'scf'
post_processing='mft'
/
&element
ne = 2
symbol(1) = 'Co'
symbol(2) = 'Pt'
q(1)   = 9.0
q(2)   = 10.0
q_d(1) = 8.0
q_d(2) = 9.0
u_lcn(1) = 20.0
u_lcn(2) = 20.0
i_stoner_d(1) = 1.10
i_stoner_d(2) = 0.60
xi_so_d(1) = 0.08
xi_so_d(2) = 0.45
/
&element_tb
filename(1) = '$TBPARAM_DIR/co_par_fcc_bcc_sc_gga_fl'
filename(2) = '$TBPARAM_DIR/pt_par_fcc_bcc_sc_lda_fl'
/
&lattice
v_factor = $a
 v(1,:) = 1.0 0.0 0.0
 v(2,:) =-0.5 0.866025403784438 0
 v(3,:) = 0.0 0.0 14.69693845669903525950 
/
&atom
ns = 2
na = 18
ntag = 2
stag(1) = 6
tag(1) = 'Co'
stag(2) = 12
tag(2) = 'Pt'
pbc = 5, 5, 0
r_coord='direct'
 r(1,:) =    0.666666666667,  0.333333333333,  0.055555555556
 r(2,:) =    0.333333333333,  0.666666666667,  0.111111111111
 r(3,:) =    0. 	   , -0.	    ,  0.166666666667
 r(4,:) =    0.666666666667,  0.333333333333,  0.222222222222
 r(5,:) =    0.333333333333,  0.666666666667,  0.277777777778
 r(6,:) =    0. 	   , -0.	    ,  0.333333333333
 r(7,:) =    0.666666666667,  0.333333333333,  0.388888888889
 r(8,:) =    0.333333333333,  0.666666666667,  0.444444444444
 r(9,:) =    0. 	   , -0.	    ,  0.5	     
 r(10,:) =   0.666666666667,  0.333333333333,  0.555555555556
 r(11,:) =   0.333333333333,  0.666666666667,  0.611111111111
 r(12,:) =   0. 	   , -0.	    ,  0.666666666667
 r(13,:) =   0.666666666667,  0.333333333333,  0.722222222222
 r(14,:) =   0.333333333333,  0.666666666667,  0.777777777778
 r(15,:) =   0. 	   , -0.	    ,  0.833333333333
 r(16,:) =   0.666666666667,  0.333333333333,  0.888888888889
 r(17,:) =   0.333333333333,  0.666666666667,  0.944444444444
 r(18,:) =   0. 	   , -0.	    ,  1.	     
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 2.0
m(2,:) = 0.0
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
degauss = 0.1
/
&mixing
alpha = 0.1
/
&scf
delta_en = 0.00001
delta_q  = 0.00001
verbose = .true.
ni_max=500
/
EOF

cat > mft/in_energy.txt<<EOF
&energy
 smearing = 'mv'
 degauss = 0.1
 en_min = -10.0
 en_max =  10.0
 /
EOF

cat > mft/in_mft.txt<<EOF
&mft
 calc='mae'
 type='path'
 na_mft=18
 nangle=4
 nxa=20
 angle_xs(1,:)= 0.0, 0.0
 angle_xs(2,:)= 90.0, 0.0
 angle_xs(3,:)= 90.0, 360.0
 angle_xs(4,:)= 0.0,  360.0
 /
EOF

cat > mft/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 30, 30, 1
 dx = 0, 0, 0
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 


