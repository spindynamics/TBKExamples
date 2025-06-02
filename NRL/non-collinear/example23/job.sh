#!/usr/bin/env bash
# run from directory where this script is
cd `echo $0 | sed 's/\(.*\)\/.*/\1/'` # extract pathname
EXAMPLE_DIR=`pwd`

# check whether echo has the -e option
if test "`echo -e`" = "-e" ; then ECHO=echo ; else ECHO="echo -e" ; fi

$ECHO
$ECHO "$EXAMPLE_DIR : starting"
$ECHO
$ECHO "This example shows how to use TBKOSTER.x to calculate the E(theta,phi) of Co(643) vicinal surface"
$ECHO "using the magnetic force theorem"

# set the needed environment variables
. ../../../environment_variables

ulimit -s unlimited

#rm -rf mae scf

#mkdir mae
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
 ne = 1
 symbol(1) = 'Co'
 u_lcn(1)=20
 i_stoner_d(1) = 1.10
 xi_so_d(1)=0.08
 /
&element_tb
 filename(1) = '$TBPARAM_DIR/co_par_fcc_bcc_sc_gga_fl'
 /
&lattice
 v_factor =1.00000
 v(1,:) =  6.631526469448794, 0.0, 0.0
 v(2,:) = -2.842082772620912, 7.3991253512541215, 0.0
 v(3,:) =  0.0, 0.0, 18.623194237664578 
 /
&atom
 ns = 2
 na = 38
 ntag = 1
 tag(1) = 'Co'
 stag(1)=38
 pbc = 1, 1, 0
 r_coord='direct'
 r(1,:)=     0.527123787444,  0.067841731984,  0.021590991442  
 r(2,:)=     0.218775194276,  0.173662096554,  0.033436346153  
 r(3,:)=     0.900234565135,  0.270094509521,  0.043158949536	
 r(4,:)=     0.591690061798,  0.378402602358,  0.054907336208  
 r(5,:)=     0.280488480604,  0.484733622204,  0.066186159719  
 r(6,:)=     0.967720126549,  0.58915343427 ,  0.076746125284  
 r(7,:)=     0.655412277439,  0.696129587089,  0.087554852567  
r(8,:)=      0.343643851162,  0.802290068016,  0.09647622799   
r(9,:)=      0.033433179071,  0.908950773852,  0.10657350514   
r(10,:)=     0.72387274087 ,  0.013840033789,  0.120118923911  
r(11,:)=     0.410332160723,  0.121580742326,  0.135930765379  
r(12,:)=     0.098411676031,  0.227536221609,  0.1480337063    
r(13,:)=     0.787154853113,  0.335109360179,  0.159483545971  
r(14,:)=     0.475656561679,  0.442848938694,  0.171184762991  
r(15,:)=     0.162370709579,  0.547329554259,  0.182336520162  
r(16,:)=     0.850423035084,  0.654926781183,  0.193530543993  
r(17,:)=     0.538330044442,  0.761741841961,  0.205152660268  
r(18,:)=     0.226876056404,  0.868026654162,  0.216693243597  
r(19,:)=     0.916808787913,  0.975177067672,  0.230851519071  
r(20,:)=     0.607788072562,  0.082209332921,  0.244374064977  
r(21,:)=     0.297714223028,  0.189355761536,  0.258526279254  
r(22,:)=     0.986254000142,  0.295625291044,  0.270070989953  
r(23,:)=     0.674168691817,  0.402449774032,  0.281694636048  
r(24,:)=     0.362214941187,  0.510042267764,  0.292876729512  
r(25,:)=     0.048927466295,  0.614531888199,  0.304032315419  
r(26,:)=     0.737442476283,  0.722267804303,  0.315736039769  
r(27,:)=     0.42618580547 ,  0.829843556211,  0.327188769144  
r(28,:)=     0.114262475328,  0.935808440817,  0.339291130956  
r(29,:)=     0.800707940719,  0.043526578474,  0.355104548826  
r(30,:)=     0.491140799633,  0.148408799987,  0.368644386     
r(31,:)=     0.18095824261 ,  0.255091171594,  0.37874244896   
r(32,:)=     0.869178540792,  0.361245408739,  0.387666490303  
r(33,:)=     0.55686682443 ,  0.468220661877,  0.398472837763  
r(34,:)=     0.244104068333,  0.572654750278,  0.409024818441  
r(35,:)=     0.932893172912,  0.678977818034,  0.420312164289  
r(36,:)=     0.624345691056,  0.787267679456,  0.43206741931   
r(37,:)=     0.305825028031,  0.883720690569,  0.441780866778  
r(38,:)=    -0.002523495191, -0.010459363091,  0.453632536928  
m_listing = 'by_tag'
m_coord = 'spherical'
m(1,:) = 2.0
 /
&mesh
 type = 'mp'
 gx = 5, 5, 1
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
 calc='mae'
 type='mesh'
 na_mft=38
 nxa=50
 /
EOF

cat > mft/in_mesh.txt<<EOF
&mesh
 type = 'mp'
 gx = 10, 10, 1
 dx = 0, 0, 0
 /
EOF
# Run TBKOSTER
$BIN_DIR/TBKOSTER.x 

cat > MAE.gnuplot<<EOF
set term png enh size 700,500
set out 'Etot_vs_theta_phi.png'
set angles degrees
set view equal xy 
splot "mft/mae_angle.dat" every::1 using (\$3)*sin(\$1)*cos(\$2):(\$3)*sin(\$1)*sin(\$2):(\$3)*cos(\$1)
EOF

# Display the results
if ! command -v gnuplot &> /dev/null
then 
    $ECHO "The gnuplot command cound not be found. Please install gnuplot."
    exit 1
else 
    gnuplot MAE.gnuplot
fi


