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
. ../../../environment_variables
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
 symbol(1) = 'Cu'
 symbol(2) = 'O'
 no(1) = 9
 no(2) = 4
 o(1,1:9) = 1, 4, 2, 3, 9, 7, 6, 8, 5
 o(2,1:4) = 1, 4, 2, 3
 q(1) = 11.0000000000000000
 q_d(1)= 10
 q(2) = 6.0000000000000000
 q_s(2)=2
 q_p(2)= 4
 q_d(2)= 0
 /
&element_tb
  tb_type='wan'
 /
&lattice
 v_factor= 2.5596559048
 v(1,:) =  1.0,  0.0, 0.0
 v(2,:) = -0.5, 0.86602540378443864676, 0.0
 v(3,:) = 0.0, 0.0, 12.24744804253268941182
 /
&atom
 ns = 1
 na = 14
 ntag = 2
 stag(1) = 13
 tag(1) = 'Cu'
 stag(2)= 1
 tag(2)= 'O'
 pbc = 7, 7, 1
 r_coord = 'cartesian'
 r(1,:) =    0.0000000000	0.0000000000	     0.0000000000
 r(2,:) =    0.0000000000	1.4778180700	     2.0899500549
 r(3,:) =    1.2798279910	0.7389090350	     4.1799001110
 r(4,:) =    0.0000000000	0.0000000000	     6.2698506340
 r(5,:) =    0.0000000000	1.4778180700	     8.3598002220
 r(6,:) =    1.2798276281	0.7389087485	    10.4661589532
 r(7,:) =    0.0000001768      -0.0000005619	    12.6101296000
 r(8,:) =    0.0000002676       0.0000002288	   18.8157189536
 r(9,:) =    0.0000003551       1.4778181999	   20.8995803827
 r(10,:) =   1.2798279910       0.7389090350	   22.9894524790 
 r(11,:) =   0.0000000000       0.0000000000	   25.0794025340 
 r(12,:) =   0.0000000000       1.4778180700	   27.1693525890 
 r(13,:) =   1.2798279910       0.7389090350	   29.2593026449 
 r(14,:) =   0.0000007326       1.4778172418        13.8113843179
 
 /
&mesh
 type = 'mp'
 gx = 10, 10, 1
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
 ia_band = 7 , 14
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
plot     'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$4))  w circles lc rgb "black"  t "{Cu s}", \
         'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$5))  w circles lc rgb "blue"   t "{Cu pz}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$6))  w circles lc rgb "green"  t "{Cu px}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$7))  w circles lc rgb "cyan"   t "{Cu py}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$8))  w circles lc rgb "red"    t "{Cu dz2}", \
         'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$9))  w circles lc rgb "pink"   t "{Cu dzx}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$10)) w circles lc rgb "grey"   t "{Cu dzy}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$11)) w circles lc rgb "gold"  t "{Cu dx2-y2}", \
	 'band/band_weight_site_orb.dat' i 0 u 1:2:(radius(\$12)) w circles lc rgb "yellow" t "{Cu dxy}", \
	 'band/band_weight_site_orb.dat' i 1 u 1:2:(radius(\$4))  w circles lc rgb "magenta"  t "{O s}", \
	 'band/band_weight_site_orb.dat' i 1 u 1:2:(radius(\$5))  w circles lc rgb "khaki"   t "{O pz}", \
	 'band/band_weight_site_orb.dat' i 1 u 1:2:(radius(\$6))  w circles lc rgb "beige"  t "{O px}", \
         'band/band_weight_site_orb.dat' i 1 u 1:2:(radius(\$7))  w circles lc rgb "violet"   t "{O py}"   
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot band/band_weight.gnuplot
