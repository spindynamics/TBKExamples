#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO " Use MFT to Calculate the difference of energy between two clock-wise and anti clock-wise"
$ECHO " magnetic configuration of Co/Pt(111) to extract the DMI as in PRL 115, 267210 (2015)"
# set the needed environment variables
. ../../../environment_variables

ulimit -s unlimited

rm -rf mft 

mkdir mft
#mkdir scf

cat > in_master.txt<<EOF
&calculation
 processing = 'scf'
 post_processing = 'mft'
 /
&units
 length='ang'
 energy='ev'
 time='fs'
 mass='hau'
 /
&element
 ne = 2
 symbol(1) = 'Pt'
 symbol(2) = 'Co'
 u_lcn(1)=20
 u_lcn(2)=20
 i_stoner_d(1) = 0.60
 i_stoner_d(2) = 1.10
 xi_so_d(1)=0.45
 xi_so_d(2)=0.08
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/pt_par_fcc_bcc_sc_lda_fl'
 filename(2) = '$TBPARAM_DIR/co_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor =1.00000
 v(1,:) =  11.097616666654154, 0.0, 0.0
 v(2,:) = -1.3872020833317682, 2.4027044886960196, 0.0
 v(3,:) =  0.0, 0.0, 23.59174909715449
 /
&atom
 ns = 2
 na = 16
 ntag = 2
 tag(1) = 'Pt'
 stag(1)=12
 tag(2) = 'Co'
 stag(2)=4
 pbc = 5, 5, 0
 r_coord='direct'
 r(1,:)=    0.166666714457,  0.333333403102, -0.	     	
 r(2,:)=    0.416666714457,  0.333333403102, -0.	     	
 r(3,:)=    0.666666714457,  0.333333403102, -0.	     	 
 r(4,:)=    0.916666714457,  0.333333403102, -0.	     	
 r(5,:)=    0.083333318036,  0.666666649899,  0.099597380526 	
 r(6,:)=    0.333333318036,  0.666666649899,  0.099597380526 	
 r(7,:)=    0.583333318036,  0.666666649899,  0.099597380526 	
r(8,:)=     0.833333318036,  0.666666649899,  0.099597380526 	
r(9,:)=     0.000000110042, -0.000000080687,  0.199040195219 	
r(10,:)=    0.249999889958, -0.000000080687,  0.199040195219 	
r(11,:)=    0.499999889958, -0.000000080687,  0.199040195219 	
r(12,:)=    0.749999889958, -0.000000080687,  0.199040195219 	
r(13,:)=    0.166666541251,  0.333333232649,  0.286828970531 	
r(14,:)=    0.416666541251,  0.333333232649,  0.286828970531 	
r(15,:)=    0.666666541251,  0.333333232649,  0.286828970531 	
r(16,:)=    0.916666541251,  0.333333232649,  0.286828970531 		
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 0.0
m(2,:) = 2.0
 /
&mesh
 type = 'mp'
 gx = 5, 20, 1
 dx = 0, 0, 0
 /
&hamiltonian_tb

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
 verbose=.true.
 ni_max=2000
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
 na_mft=16
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
 mconfig(13,1,:) =    0, 0.0
 mconfig(14,1,:) =    90, 0.0
 mconfig(15,1,:) =    180, 0.0
 mconfig(16,1,:) =    270, 0.0 
 mconfig(1,2,:) =  0.0, 0.0
 mconfig(2,2,:) =  0.0, 0.0
 mconfig(3,2,:) =  0.0, 0.0
 mconfig(4,2,:) =  0.0, 0.0
 mconfig(5,2,:) =  0.0, 0.0
 mconfig(6,2,:) =  0.0, 0.0
 mconfig(7,2,:) =  0.0, 0.0
 mconfig(8,2,:) =  0.0, 0.0
 mconfig(9,2,:) =  0.0, 0.0
 mconfig(10,2,:) =  0.0, 0.0
 mconfig(11,2,:) =  0.0, 0.0
 mconfig(12,2,:) =  0.0, 0.0
 mconfig(13,2,:) =    0, 0.0
 mconfig(14,2,:) =    270, 0.0
 mconfig(15,2,:) =    180, 0.0
 mconfig(16,2,:) =    90, 0.0 
 /
EOF

cat > mft/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 10, 40, 1
 dx = 0, 0, 0
 /
EOF
# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 


