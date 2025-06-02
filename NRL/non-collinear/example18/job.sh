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

a=2.88499566724111
abohr=$(echo "$a/0.5291771 " |bc -l)
nkx=101
nky=101
nkz=1
cat > tempo <<EOF
$nkx $nky $nkz
$abohr
0.2
EOF

# Run TBKOSTER
$BIN_DIR/build_kpoints.x<tempo

mv -f in_mesh.txt band/

rm -rf tempo* *.dat *.txt *.gnuplot *.png 

#cp -f out_mesh.txt band/in_mesh.txt



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

cat > band/in_band.txt <<EOF
&band
proj='spin'
i_min=238
i_max=241
na_band=2
ia_band= 1, 10
 /
EOF


# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

# Run bands
$BIN_DIR/bands.x 

cd band
cat > tempo <<EOF
$nkx $nky $nkz
EOF
# Run transform data output for gnuplot
$BIN_DIR/dat2gnu.x<tempo

# Plot the results
cat > vector_field.gnuplot<<EOF
set term png enh size 700,700
set out 'vector_field.png'
set xrange [*:*] ; set yrange [*:*]
set grid xtics
stats 'gnu-vector-field.dat' 
set xra [STATS_min_x:STATS_max_x]
set yra [STATS_min_y:STATS_max_y]
set xlabel "k"
set ylabel "k"
plot 'gnu-vector-field.dat' using 1:2:(5*\$3):(5*\$4):(sgn(\$3/sqrt(\$3*\$3+\$4*\$4))) with vectors filled lc palette
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot vector_field.gnuplot
fi

# Plot the results
cat > fermi.gnuplot<<EOF
set term png enh size 700,700
set out 'fermi.png'
set xrange [*:*] ; set yrange [*:*]
set grid xtics
stats 'gnu-fermi.dat'  
set xra [STATS_min_x:STATS_max_x]
set yra [STATS_min_y:STATS_max_y]
set xlabel "k"
set ylabel "k"
set pm3d ; set palette
set view projection xy
splot 'gnu-fermi.dat' using 1:2:4
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot fermi.gnuplot
fi



