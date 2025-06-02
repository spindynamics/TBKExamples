#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "Fe monatomic wire: calculation of spin spiral energy by magnetic force theorem"
$ECHO "The difference of energy between FM and spin spiral is evaluated via MFT "
$ECHO "Similar ssystem as example 14 "

# set the needed environment variables
. ../../../environment_variables

ulimit -s unlimited

rm -rf mft scf

mkdir mft scf

$ECHO "super-cell (18 atoms) calculation"

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
post_processing_dir='mft'
/
&element
ne = 1
symbol(1) = 'Fe'
q(1)   = 8.0
q_d(1) = 7.0
u_lcn(1) = 20.0
i_stoner_d(1) = 0.95
xi_so_d(1) = 0.0
/
&element_tb
filename(1) = '$TBPARAM_DIR/fe_par_fcc_bcc_sc_gga_fl'
/
&lattice
v_factor = 2.20
v(1,:) = 10.0,  0.0,  0.0
v(2,:) =  0.0, 10.0,  0.0
v(3,:) =  0.0,  0.0,  18
/
&atom
ns = 2
na = 18
ntag = 1
stag(1) = 18
tag(1) = 'Fe'
pbc = 0, 0, 5
r(1,:)  = 0.0, 0.0, 0.0
r(2,:)  = 0.0, 0.0, $(echo "1.0/18" |bc -l)
r(3,:)  = 0.0, 0.0, $(echo "2.0/18" |bc -l)
r(4,:)  = 0.0, 0.0, $(echo "3.0/18" |bc -l)
r(5,:)  = 0.0, 0.0, $(echo "4.0/18" |bc -l)
r(6,:)  = 0.0, 0.0, $(echo "5.0/18" |bc -l)
r(7,:)  = 0.0, 0.0, $(echo "6.0/18" |bc -l)
r(8,:)  = 0.0, 0.0, $(echo "7.0/18" |bc -l)
r(9,:)  = 0.0, 0.0, $(echo "8.0/18" |bc -l)
r(10,:) = 0.0, 0.0, $(echo "9.0/18" |bc -l)
r(11,:) = 0.0, 0.0, $(echo "10.0/18" |bc -l)
r(12,:) = 0.0, 0.0, $(echo "11.0/18" |bc -l)
r(13,:) = 0.0, 0.0, $(echo "12.0/18" |bc -l)
r(14,:) = 0.0, 0.0, $(echo "13.0/18" |bc -l)
r(15,:) = 0.0, 0.0, $(echo "14.0/18" |bc -l)
r(16,:) = 0.0, 0.0, $(echo "15.0/18" |bc -l)
r(17,:) = 0.0, 0.0, $(echo "16.0/18" |bc -l)
r(18,:) = 0.0, 0.0, $(echo "17.0/18" |bc -l)
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 2.0
/
&mesh
type = 'mp'
gx = 1, 1, 20
dx = 0, 0, 0
/
&hamiltonian_tb
m_penalization = 'none'
/
&energy
smearing = 'mv'
degauss = 0.2
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
 calc='mconfig'
  nxa=2
 mconfig(1,1,:) =  0.0, 0.0
 mconfig(2,1,:) =  0.0, 0.0
 mconfig(3,1,:) =  0.0, 0.0
 mconfig(4,1,:) =  0.0, 0.0
 mconfig(5,1,:) =  0.0, 0.0
 mconfig(6,1,:) =  0.0, 0.0
 mconfig(7,1,:) =  0.0, 0.0
 mconfig(8,1,:) =  0.0, 0.0
 mconfig(9,1,:) =  0.0, 0.0
 mconfig(10,1,:) =  0.0, 0.0
 mconfig(11,1,:) =  0.0, 0.0
 mconfig(12,1,:) =  0.0, 0.0
 mconfig(13,1,:) =  0.0, 0.0
 mconfig(14,1,:) =  0.0, 0.0
 mconfig(15,1,:) =  0.0, 0.0
 mconfig(16,1,:) =  0.0, 0.0   
 mconfig(17,1,:) =  0.0, 0.0
 mconfig(18,1,:) =  0.0, 0.0  
 mconfig(1,2,:) =   90.0, 0.0
 mconfig(2,2,:) =   90.0, $(echo "1.0*20" |bc -l)  
 mconfig(3,2,:) =   90.0, $(echo "2.0*20" |bc -l)
 mconfig(4,2,:) =   90.0, $(echo "3.0*20" |bc -l)
 mconfig(5,2,:)  =  90.0, $(echo "4.0*20" |bc -l)
 mconfig(6,2,:)  =  90.0, $(echo "5.0*20" |bc -l)
 mconfig(7,2,:)  =  90.0, $(echo "6.0*20" |bc -l)
 mconfig(8,2,:)  =  90.0, $(echo "7.0*20" |bc -l)
 mconfig(9,2,:)  =  90.0, $(echo "8.0*20" |bc -l)
 mconfig(10,2,:) =  90.0, $(echo "9.0*20" |bc -l)
 mconfig(11,2,:) =  90.0, $(echo "10.0*20" |bc -l)
 mconfig(12,2,:) =  90.0, $(echo "11.0*20" |bc -l)
 mconfig(13,2,:) =  90.0, $(echo "12.0*20" |bc -l)
 mconfig(14,2,:) =  90.0, $(echo "13.0*20" |bc -l)
 mconfig(15,2,:) =  90.0, $(echo "14.0*20" |bc -l)
 mconfig(16,2,:) =  90.0, $(echo "15.0*20" |bc -l)
 mconfig(17,2,:) =  90.0, $(echo "16.0*20" |bc -l)
 mconfig(18,2,:) =  90.0, $(echo "17.0*20" |bc -l)
/
EOF

cat > mft/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 1, 1, 20
 dx = 0, 0, 0
 /
EOF
# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 




