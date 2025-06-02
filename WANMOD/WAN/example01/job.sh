#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the band structure from the wannier file hr.dat of Cu bulk"

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
 ne = 1
 symbol(1) = 'Cu'
 no(1) = 9
! o(1,1:9) = 1, 2, 3, 4, 5, 6, 7, 8, 9
 o(1,1:9) = 1, 4, 2, 3, 9, 7, 6, 8, 5
 q_s(1)=0.5
 q_p(1)=0.5
 q_d(1)=10.0
 q(1) = 11.0000000000000000
 /
&element_tb
  tb_type='wan'
 /
&lattice
 v_factor= 3.61
 v(1,:) =  -0.5,  0.0, 0.5
 v(2,:) =   0.0,  0.5, 0.5
 v(3,:) =  -0.5,  0.5, 0.0
 /
&atom
 ns = 1
 na = 1
 ntag = 1
 stag(1) = 1
 tag(1) = 'Cu'
 pbc = 15, 15, 15
 r_coord = 'direct'
 r(1,:) = 0.00000000000000,   0.00000000000000, 0.00000000000000
 /
&mesh
 type = 'mp'
 gx = 12, 12, 12
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
 proj='site'
 na_band = 1
 ia_band = 1 
 /
/
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'path'
 nxs = 5
 gxs =100
 xs_label(1) = 'G'
 xs_label(2) = 'X'
 xs_label(3) = 'W'
 xs_label(4) = 'K'
 xs_label(5) = 'G'
 xs(1,:) = 0.0  , 0.0 , 0
 xs(2,:) = 0.5 , 0 , 0.5
 xs(3,:) = 0.5 , 0.25 , 0.75
 xs(4,:) = 0.375  , 0.375 , 0.75
 xs(5,:) = 0.0  , 0.0 , 0.0
/
EOF

# Run TBKOSTER
$BIN_DIR/TBKOSTER.x

# Run bands.x
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
plot 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$4))  w circles lc rgb "black"  t "{Fe s}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$5))  w circles lc rgb "blue"   t "{Fe pz}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$6))  w circles lc rgb "green"  t "{Fe px}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$7))  w circles lc rgb "cyan"   t "{Fe py}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$8))  w circles lc rgb "red"    t "{Fe dz2}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$9))  w circles lc rgb "pink"   t "{Fe dzx}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$10)) w circles lc rgb "grey"   t "{Fe dzy}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$11)) w circles lc rgb "gold"   t "{Fe dx2-y2}", \
     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$12)) w circles lc rgb "yellow" t "{Fe dxy}"
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot band/band_weight.gnuplot
fi


