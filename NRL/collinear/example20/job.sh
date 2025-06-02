#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the Fermi Surface of Cu bulk"

# set the needed environment variables
. ../../../environment_variables

a=3.61
rm -fr xyz band scf *.txt *.bxsf
mkdir band 

cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing='band'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 1
 symbol(1) = 'Cu'
 q(1)   = 11.0
 q_d(1) = 10
 u_lcn(1)=20
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/cu_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor = $a
v(1,:) = 0.0 0.5 0.5
v(2,:) = 0.5 0.0 0.5
v(3,:) = 0.5 0.5 0.0
 /
&atom
ns = 1
na = 1
ntag = 1
tag(1) = 'Cu'
stag(1) = 1
pbc = 5, 5, 5
r_coord = 'direct'
r(1,:) = 0.0, 0.0, 0.0
 /
&mesh
 type = 'mp'
 gx = 10, 10, 10
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
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 21, 21, 21
 dx = 0, 0, 0
 /
EOF

cat > band/in_band.txt<<EOF
&band
 proj = 'site'
 na_band=1
 ia_band=1
 /
EOF

# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

# Run fermisurface.x
$BIN_DIR/fermisurface.x 

cp -f band/fermi.bxsf  fermiCu.bxsf


$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the Fermi Surface of Ni bulk"

a=3.52
rm -fr xyz band scf *.txt
mkdir band 

cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing='band'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 1
 symbol(1) = 'Ni'
 q(1)   = 10.0
 q_d(1) = 9
 u_lcn(1)=20
 i_stoner_d(1)=1.05
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/ni_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor = $a
v(1,:) = 0.0 0.5 0.5
v(2,:) = 0.5 0.0 0.5
v(3,:) = 0.5 0.5 0.0
 /
&atom
ns = 2
na = 1
ntag = 1
tag(1) = 'Ni'
stag(1) = 1
pbc = 5, 5, 5
r_coord = 'direct'
r(1,:) = 0.0, 0.0, 0.0
m(1,:) =1.0, 0 ,0
 /
&mesh
 type = 'mp'
 gx = 10, 10, 10
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
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 21, 21, 21
 dx = 0, 0, 0
 /
EOF

cat > band/in_band.txt<<EOF
&band
 proj = 'site'
 na_band=1
 ia_band=1
 /
EOF

# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

# Run fermisurface.x
$BIN_DIR/fermisurface.x 

cp -f band/fermi.up.bxsf  fermiNi.up.bxsf
cp -f band/fermi.dn.bxsf  fermiNi.dn.bxsf

