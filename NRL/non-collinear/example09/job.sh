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
$ECHO  


# set the needed environment variables
. ../../../environment_variables
ulimit -s unlimited

rm -rf tempo* *.dat *.txt *.gnuplot *.png results band

mkdir band

a=2.88499566724111

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
 u_lcn(1)=0
 xi_so_d(1)=0.65
 xi_so_p(1)=1.0
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/au_par'
 /
&lattice
 v_factor = $a
 v(1,:) = 1.0 0.0 0.0
 v(2,:) =-0.5 0.866025403784438 0
 v(3,:) = 0.0 0.0 0.1061445555206044D+02 
 /
&atom
 ns = 4
 na = 20
 ntag = 1
 tag(1) = 'Au'
 stag(1)=20
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

cat > band/in_mesh.txt <<EOF
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
cat > band/in_band.txt <<EOF
&band
proj='site'
na_band=2
ia_band= 1, 10
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

# Run bands
$BIN_DIR/bands.x 

# Plot the results
cat > band/band_weight.gnuplot<<EOF
set term png enh size 700,500
set out 'band/projbands.png'
#set xtics ("{/Symbol G}"0,"M"0.57735,"K"0.91068,"{/Symbol G}"1.57735)
set xrange [*:*] ; set yrange [*:*]
set grid xtics
stats 'band/band_weight_site_orb.dat'  u 1:2 nooutput
set xra [STATS_min_x:STATS_max_x]
set yra [STATS_min_y:STATS_max_y]
set xlabel "k"
set ylabel "E - E_F (eV)"
set xzeroaxis
set key opaque box width 1.0
set style fill solid noborder
radius(proj)=proj/200.
#plot 'band/band_weight.dat' u 1:2 lc rgb "grey" 
plot 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$3)) w circles lc rgb "red" t "{surface}", 'band/band_weight_site_orb.dat' i 1 u 1:2:(radius(\$3)) w circles lc rgb "blue" t "{bulk}"
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot band/band_weight.gnuplot
fi

