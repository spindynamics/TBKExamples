#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "magnetic force theorem MAE calculation of a Fe wire"
$ECHO " The E(theta) curve is calculated "

# set the needed environment variables
. ../../../environment_variables

rm -rf mft scf


mkdir mft
mkdir scf

IStoner=0.95
U=$(echo "5.0/7.0*$IStoner" |bc -l)
J=$(echo "$U" |bc -l)
B=$(echo "0.14*$J" |bc -l)

e_e_interaction=stoner

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
ne = 1
symbol(1) = 'Fe'
q(1)   = 8.0
q_d(1) = 7.0
u_lcn(1) = 20.0
i_stoner_d(1) = $IStoner
u_dd(1)= $U
j_dd(1)=$J
b(1) = $B
xi_so_d(1) = 0.06
/
&element_tb
filename(1) = '$TBPARAM_DIR/fe_par_fcc_bcc_sc_gga_fl'
/
&lattice
v_factor = 2.25
v(1,:) = 10.0,  0.0,  0.0
v(2,:) =  0.0, 10.0,  0.0
v(3,:) =  0.0,  0.0,  1.0
/
&atom
ns = 2
na = 1
ntag = 1
stag(1) = 1
tag(1) = 'Fe'
pbc = 0, 0, 5
r(1,:) = 0.0, 0.0, 0.0
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 3.0
/
&mesh
type = 'mp'
gx = 1, 1, 100
dx = 0, 0, 0
/
&hamiltonian_tb
e_e_interaction = '$e_e_interaction'
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
 na_mft=1
 ia(1)= 1
 nangle=2
 nxa=20
 angle_xs(1,:)= 0.0, 0.0
 angle_xs(2,:)= 90.0, 0.0
 /
EOF

cat > mft/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 1, 1, 500
 dx = 0, 0, 0
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 


