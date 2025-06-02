#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the band structure of VSe2 from wannier file hr.dat"

# set the needed environment variables
. ../../../environment_variables

ulimit -s unlimited

cat > in_master.txt<<EOF
&calculation
processing = 'scf'
post_processing='band'
/
&units
 energy = 'ev'
 length = 'ang'
 time = 'fs'
 mass = 'hau'
 /
&element
 ne = 2
 symbol(1) = 'V'
 symbol(2) = 'Se'
 no(1) = 5
 no(2) = 4
 o(1,1:5) = 5, 6, 7, 8, 9
 o(2,1:4) = 1, 2, 3, 4
 q(1) = 5.0000000000000000
 q(2) = 6.0000000000000000
 /
&element_tb
  tb_type='wan'
 /
&lattice
 v_factor= 3.31
 v(1,:) =  1.0,  0.0, 0.0
 v(2,:) = -0.5, 0.86602540378443864676, 0.0
 v(3,:) = 0.0, 0.0, 4.53172205438066465256
 /
&atom
 ns = 1
 na = 3
 ntag = 2
 stag(1) = 1
 tag(1) = 'V'
 stag(2)= 2
 tag(2)= 'Se'
 pbc = 5, 5, 0
 r_coord = 'direct'
 r(1,:) = 0.00000000000000,   0.00000000000000, 0.00000000000000
 r(2,:) = 0.33333333333333,  -0.33333333333333,  0.105594
 r(3,:) = 0.66666666666666,   0.33333333333333, -0.105594 
 /
&mesh
 type = 'mp'
 gx = 50, 50, 1
 dx = 0, 0, 0
 /
&hamiltonian_tb
 e_e_interaction = 'stoner'
 m_penalization = 'none'
 /
&energy
 smearing = 'mv'
 degauss =0.05
 fixed_fermi_level = .false.
 /
&mixing
 type = 'broyden'
 alpha = 0.10000000000000001
 n_init = 1
 n_hist = 50
 /
&scf
 delta_en=0.0001
 delta_q=0.0001
 verbose=.true.
 ni_max=200

 /
EOF

cat > band/in_band.txt<<EOF
&band
 na_band = 3
 ia_band = 1 , 2 , 3
 /
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'path'
 nxs = 4
 gxs =100
 xs_label(1) = 'K'
 xs_label(2) = 'G'
 xs_label(3) = 'M'
 xs_label(4) = 'K'
 xs(1,:) = 0.333333333  , 0.33333333333 , 0
 xs(2,:) = 0.0 , 0 , 0
 xs(3,:) = 0.5 , 0 , 0
 xs(4,:) = 0.333333333  , 0.33333333333 , 0
/
EOF


# Run DyNaMol
$BIN_DIR/TBKOSTER.x

# Run DyNaMol
$BIN_DIR/bands.x

# Plot the results
cat > band/band_weight.gnuplot<<EOF
set term png enh size 700,500
set out 'band/projbands.png'
#set xtics ("{/Symbol G}"0,"M"0.57735,"K"0.91068,"{/Symbol G}"1.57735)
set xrange [*:*] ; set yrange [*:*]
set grid xtics
stats 'band/band_weight.dat'  u 1:2 nooutput
set xra [STATS_min_x:STATS_max_x]
set yra [STATS_min_y:STATS_max_y]
set xlabel "k"
set ylabel "E - E_F (eV)"
set xzeroaxis
set key opaque box width 1.0
set style fill solid noborder
radius(proj)=proj/200.
#plot 'band/band_weight.dat' u 1:2 lc rgb "grey" 
plot 'band/band_weight.dat' i 0 u 1:2:(radius(\$3)) w circles lc rgb "red" t "{V}", \
 'band/band_weight.dat' i 1 u 1:2:(radius(\$3)) w circles lc rgb "blue" t "{Se}", \
 'band/band_weight.dat' i 1 u 1:2:(radius(\$3)) w circles lc rgb "blue" t "{Se}"
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot band/band_weight.gnuplot
fi

