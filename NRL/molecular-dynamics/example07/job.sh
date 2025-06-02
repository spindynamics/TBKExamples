e!/usr/bin/env bash
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

rm -rf md scf

mkdir md
mkdir scf


cat > in_master.txt << EOF
&calculation
processing = 'md'
post_processing= 'txt2xyz'
post_processing_dir= 'md'
/
&units
length='ang'
energy='ev'
time='fs'
mass='g/mol'
/
&element
ne=1
symbol(1)='Cr'
q(1)=6.0
q_d(1)=5.0
u_lcn(1)=20
i_stoner_d(1) = 0.82
xi_so_d(1) = 0.0
/
&element_tb
filename(1) = '$TBPARAM_DIR/cr_par_fcc_bcc_sc_gga_fl'
/
&lattice
v_factor = 2.1
v(1,:) = 1, 0, 0
v(2,:) = 0, 1, 0
v(3,:) = 0, 0, 1
/
&atom
ns = 4
na = 3
ntag = 1
tag(1)='Cr_trimer'
stag(1)= 3
pbc = 0, 0, 0
r_coord='direct'
r(1,:) = 0.0,0.0,0.0
r(2,:) = 0.86602540378443864676,-0.5,0.0
r(3,:) = 0.86602540378443864676,0.5,0.0
m_listing = 'by_atom'
m_coord = 'spherical'
 m(1,:) = 3.0000000000000000, 90.0000000000000000, 180.0000000000000000
 m(2,:) = 3.0000000000000000, 90.000000000000000, -60.0000000000000000
 m(3,:) = 3.0000000000000000, 90.0000000000000000, 60.0000000000000000
lambda_pen_listing= 'by_tag'
!lambda_pen(1) = 5.0
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
degauss = 0.2
/
&mixing
alpha = 0.1
/
&scf
delta_en=0.0001
delta_q=0.0001
verbose=.false.
ni_max= 1500
/
&forces
computed=.true.
/
&md
ensemble='nvt'
t_i=0
t_f=10.0
dt=0.1
verbose=.true.
gamma=10.0
temperature=0.0
/
EOF

# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

