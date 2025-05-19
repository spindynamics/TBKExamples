#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the band structure of Au(111) "
$ECHO  "To accelerate the scf calculation the out_charge.txt of example 14 is copied in in_charge.txt of example 15"


# set the needed environment variables
. ../../../environment_variables

a=2.88499566724111
rm -f out*

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
 symbol(1) = 'Au'
 q(1)   = 11.0
 q_d(1) = 10
 u_lcn(1)=20
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/au_par_fcc_bcc_sc_lda_fl'
 /
&lattice
 v_factor = $a
 v(1,:) = 1.0 0.0 0.0
 v(2,:) =-0.5 0.866025403784438 0
 v(3,:) = 0.0 0.0 0.1061445555206044D+02 
 /
&atom
 ns = 1
 na = 50
 ntag = 1
 tag(1) = 'Au'
 stag(1)=50
 pbc = 5, 5, 0
 r_coord='cartesian'
 r(1,:) =      0.0000000     0.0000000     0.0000000
 r(2,:) =      1.4424978    -0.8328265    -2.3555892
 r(3,:) =     -1.4424978     0.8328265    -4.7111783
 r(4,:) =      0.0000000     0.0000000    -7.0667677
 r(5,:) =      1.4424978    -0.8328265    -9.4223566
 r(6,:) =     -1.4424978     0.8328265   -11.7779455
 r(7,:) =      0.0000000     0.0000000   -14.1335354
 r(8,:) =      1.4424978    -0.8328265   -16.4891243
 r(9,:) =     -1.4424978     0.8328265   -18.8447132
 r(10,:) =    -0.0000000     0.0000000   -21.2003021
 r(11,:) =     1.4424978    -0.8328265   -23.5558910
 r(12,:) =    -1.4424978     0.8328265   -25.9114799
 r(13,:) =     0.0000000     0.0000000   -28.2670708
 r(14,:) =     1.4424978    -0.8328265   -30.6226578
 r(15,:) =    -1.4424978     0.8328265   -32.9782486
 r(16,:) =     0.0000000     0.0000000   -35.3338356
 r(17,:) =     1.4424978    -0.8328265   -37.6894264
 r(18,:) =    -1.4424978     0.8328265   -40.0450134
 r(19,:) =    -0.0000000     0.0000000   -42.4006042
 r(20,:) =     1.4424978    -0.8328265   -44.7561951
 r(21,:) =    -1.4424978     0.8328265   -47.1117821
 r(22,:) =    -0.0000000     0.0000000   -49.4673729
 r(23,:) =     1.4424978    -0.8328265   -51.8229599
 r(24,:) =    -1.4424978     0.8328265   -54.1785469
 r(25,:) =     0.0000000     0.0000000   -56.5341415
 r(26,:) =     1.4424978    -0.8328265   -58.8897285
 r(27,:) =    -1.4424978     0.8328265   -61.2453156
 r(28,:) =     0.0000000     0.0000000   -63.6009064
 r(29,:) =     1.4424978    -0.8328265   -65.9564972
 r(30,:) =    -1.4424978     0.8328265   -68.3120804
 r(31,:) =     0.0000000     0.0000000   -70.6676712
 r(32,:) =     1.4424978    -0.8328265   -73.0232620
 r(33,:) =    -1.4424978     0.8328265   -75.3788528
 r(34,:) =     0.0000000     0.0000000   -77.7344437
 r(35,:) =     1.4424978    -0.8328265   -80.0900269
 r(36,:) =    -1.4424978     0.8328265   -82.4456253
 r(37,:) =    -0.0000000     0.0000000   -84.8012085
 r(38,:) =     1.4424978    -0.8328265   -87.1567993
 r(39,:) =    -1.4424978     0.8328265   -89.5123901
 r(40,:) =    -0.0000000     0.0000000   -91.8679733
 r(41,:) =     1.4424978    -0.8328265   -94.2235641
 r(42,:) =    -1.4424978     0.8328265   -96.5791550
 r(43,:) =    -0.0000000     0.0000000   -98.9347458
 r(44,:) =     1.4424978    -0.8328265  -101.2903290
 r(45,:) =    -1.4424978     0.8328265  -103.6459198
 r(46,:) =    -0.0000000     0.0000000  -106.0015182
 r(47,:) =     1.4424978    -0.8328265  -108.3570938
 r(48,:) =    -1.4424978     0.8328265  -110.7126923
 r(49,:) =     0.0000000     0.0000000  -113.0682831
 r(50,:) =     1.4424978    -0.8328265  -115.4238663
 /
&mesh
 type = 'mp'
 gx = 10, 10, 1
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

cat > band/in_energy.txt<<EOF
&energy
 smearing = 'mv'
 degauss = 0.2
 en_min = -10.0
 en_max =  10.0
 /
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'path'
 nxs = 4
 gxs =100
 xs_label(1) = 'G'
 xs_label(2) = 'X'
 xs_label(3) = 'M'
 xs_label(4) = 'G'
 xs(1,:) = 0  , 0 , 0
 xs(2,:) = 0.5 , 0 , 0
 xs(3,:) = 0.666666666 , 0.33333333 , 0
 xs(4,:) = 0 ,  0 , 0
/
EOF

cat > band/in_dos.txt<<EOF
&dos
 nen=100
 na_dos=1
 ia= 1
 en_min=-10
 en_max=10
 /
EOF

# Set TBKOSTER root directory in in_master.txt
sed "s|BIN_DIR|$BIN_DIR|g" in_master.txt >in_master2.txt
mv -f in_master2.txt in_master.txt


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 
