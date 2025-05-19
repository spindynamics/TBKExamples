#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "SCF NON-collinear spin calculation of a 4-atom Fe wire"
$ECHO "The initial magnetization is a spin spiral of period 5a "
$ECHO "Due to periodic boundary conditions the spin spiral configuration is kept during scf"

# set the needed environment variables
. ../../../environment_variables

mkdir scf
rp -f out*

cat > in_master.txt<<EOF
&units
energy = 'ev'
length = 'ang'
time = 'fs'
mass='hau'
/
&calculation
processing = 'scf'
post_processing='txt2xyz'
post_processing_dir='scf'
/
&element
ne = 1
symbol(1) = 'Fe'
q(1)   = 8.0
q_d(1) = 7.0
u_lcn(1) = 20.0
i_stoner_d(1) = 0.95
xi_so_d(1) = 0.06
/
&element_tb
filename(1) = '$TBPARAM_DIR/fe_par_fcc_bcc_sc_gga_fl'
/
&lattice
v_factor = 2.27
v(1,:) = 10.0,  0.0,  0.0
v(2,:) =  0.0, 10.0,  0.0
v(3,:) =  0.0,  0.0,  4.0
/
&atom
ns = 4
na = 4
ntag = 4
stag(1) = 1
stag(2) = 1
stag(3) = 1
stag(4) = 1
tag(1) = 'Fe_up'
tag(2)='Fe_90'
tag(3)='Fe_180'
tag(4)='Fe_270'
pbc = 0, 0, 5
r(1,:) = 0.0, 0.0, 0.0
r(2,:) = 0.0, 0.0, 0.25
r(3,:) = 0.0, 0.0, 0.5
r(4,:) = 0.0, 0.0, 0.75
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 3.0, 90.0, 0.0
m(2,:) = 3.0, 90.0, 90.0
m(3,:) = 3.0, 90.0, 180.0
m(4,:) = 3.0, 90.0, 270.0
/
&mesh
type = 'mp'
gx = 1, 1, 100
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

# Set TBKOSTER root directory in in_master.txt
sed "s|BIN_DIR|$BIN_DIR|g" in_master.txt >in_master2.txt
mv -f in_master2.txt in_master.txt


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 
