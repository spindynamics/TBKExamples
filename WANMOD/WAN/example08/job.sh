#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use DyNaMol.x to calculate the band structure of Cu-O-Cu system from wannier hr.dat"

# set the needed environment variables
. ../environment_variables
ulimit -s unlimited


cat > in_master.txt<<EOF
&calculation
pre_processing='txt2xyz'
pre_processing_dir='xyz'
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
 symbol(1) = 'Co'
 symbol(2) = 'Pt'
 no(1) = 9
 no(2) = 9
 o(1,1:9) = 1, 4, 2, 3, 9, 7, 6, 8, 5
 o(2,1:9) = 1, 4, 2, 3, 9, 7, 6, 8, 5
 u_lcn(1)=20
 u_lcn(2)=20
 i_stoner_d(1) = 1.10
 i_stoner_d(2) = 0.50
 xi_so_d(1)=0.08
 xi_so_d(2)=0.45
 /
&element_tb
  tb_type='wan'
 /
&lattice
 v_factor= 1.0
 v(1,:) =  2.7744,  0.0, 0.0
 v(2,:) = -1.3872,  2.40270088025954658157,  0.0
 v(3,:) = 0.0, 0.0, 30.0
 /
&atom
 ns = 4
 na = 4
 ntag = 2
 stag(1) = 1
 tag(1) = 'Co'
 stag(2)= 3
 tag(2)= 'Pt'
 pbc = 10, 10, 1
 r_coord = 'cartesian'
 r(1,:) =     0.		      0.		      6.65530008000
 r(2,:) =     0.		      1.60180067232	      4.63529606208
 r(3,:) =     -1.38720000000	      0.80090019744	      2.26529205120
 r(4,:) =     0.		      0.		      0.00000000000
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 2.0, 0, 0
m(2,:) = 0.0, 0, 0
 /
&mesh
 type = 'mp'
 gx = 15, 15, 1
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
 na_band = 2
 ia_band = 1 , 2
 /
EOF

cat > band/in_mesh.txt<<EOF
&mesh
 type = 'path'
 nxs = 4
 gxs =200
 xs_label(1) = 'K'
 xs_label(2) = 'G'
 xs_label(3) = 'M'
 xs_label(4) = 'K'
 xs(1,:) = 0.5 , 0 , 0
 xs(2,:) = 0.0 , 0 , 0
 xs(3,:) = 0.333333333  , 0.33333333333 , 0
 xs(4,:) = 0.5 , 0 , 0
/
EOF


# Run DyNaMol
$BIN_DIR/TBKOSTER.x
# Run bands
$BIN_DIR/bands.x

# Plot the results
cat > band/band_weight.gnuplot<<EOF
set term png enh size 700,500
set out 'band/projbands.png'
#set xtics ("{/Symbol G}"0,"M"0.57735,"K"0.91068,"{/Symbol G}"1.57735)
set xrange [*:*] ; set yrange [-10:5]
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
#plot 'band/band_weight_site_orb.dat' u 1:2 lc rgb "grey" 
plot     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$4))  w circles lc rgb "black"  t "{Co s}", \
         'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$5))  w circles lc rgb "blue"   t "{Co pz}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$6))  w circles lc rgb "green"  t "{Co px}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$7))  w circles lc rgb "cyan"   t "{Co py}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$8))  w circles lc rgb "red"    t "{Co dz2}", \
         'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$9))  w circles lc rgb "pink"   t "{Co dzx}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$10)) w circles lc rgb "grey"   t "{Co dzy}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$11)) w circles lc rgb "gold"  t "{Co dx2-y2}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$12)) w circles lc rgb "yellow" t "{Co dxy}"   
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot band/band_weight.gnuplot
