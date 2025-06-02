# non-collinear examples
example01
 "This example shows how to use TBKOSTER.x to calculate band structure with SOC of Cufcc"
example02
 "SCF NON-collinear spin calculation of a 5-atom Fe wire with magnetic penalization on atom 1"
 "The penalization on atome 1 is theta,phi=(30,0) and the other atoms are free "
 "during scf the spin tend do align and the magnetization of atom 1 is the same as the other atoms"
example03
 "SCF NON-collinear spin calculation of a 5-atom Fe wire"
 "The initial magnetization of atom 1 is opposite to other 4 atoms "
 "this the simplest magnetic excitation"
example04
 "SCF NON-collinear spin calculation of a 4-atom Fe wire"
 "The initial magnetization is a spin spiral of period 5a "
 "Due to periodic boundary conditions the spin spiral configuration is kept during scf"
example05
 "SCF NON-collinear spin-constrained (on theta angle) calculation with SOC of a Fe wire"
 " The E(theta) curve is evaluated for various elecronic interaction"
 " Stoner, UJ and UJB "
example06
 "This example shows how to use TBKOSTER.x to calculate band structure of a Fe wire with SOC"
 'electronic interaction' $e_e_interaction
example07
 "This example shows how to use TBKOSTER.x to calculate the total energy and magnetization versus a for Ptfcc includiing SOC"
example08
 "This example shows how to use TBKOSTER.x to calculate a Cr trimer"
example09
 "This example shows how to use TBKOSTER.x to calculate the band structure of Au(111) "
example10
 "This example shows how to use TBKOSTER.x to calculate the total energy of Co-Pt L10 a function of c/a cte volume"
example11
 "SCF NON-collinear spin calculation of a 4-atom Fe wire"
 "The initial magnetization is a spin spiral of period 5a "
 "Due to periodic boundary conditions the spin spiral configuration is kept during scf"
 "The calculation is compared with the generalized Bloch theorem spin spiral and to the collinear case "
 "super-cell (4 atoms) calculation"
 "spin-spiral calculation"
 "FM calculation ns=2"
example12
 "This example shows how to use TBKOSTER.x to model Crbcc AF by two approaches"
 "super-cell spin collinear (up down) or non-collinear spin spiral with k_spiral in zone border"
example13
 "SCF NON-collinear spin-spiral calculation of a monatomic Fe wire"
 "a minimum is found for q.ne.0 hence a spin spiral solution will develop"
 "spin-spiral calculation"
 "k_spiral=" $k_spiral
example14
 "Fe monatomic wire: calculation of spin spiral by two different ways:"
 "non-collinear calculation with 18 atoms per unit cell and theta_pen(i)=20*(i-1) i=1,18 "
 "spin spiral calculation with one atom per unit-cell and  k_spiral=(0,0,1/18) (direct)"
 "super-cell (18 atoms) calculation"
 "spin-spiral calculation"
example15
 "This example shows how to use TBKOSTER.x to calculate band structure and DOS with SOC for Febcc"
example16
 "This example shows how to use TBKOSTER.x to calculate a Fe cuboctahedron cluster"
 "verbose=.true. and the relaxation process is saved in scf->vizualization with ovito"
example17
 "This example shows how to use TBKOSTER.x to calculate the E(theta) MAE of a Fe cluster using penalization"
 "a similar calculation could be done for E(theta,phi)"
 example18
 This example shows how to use TBKOSTER.x to calculate the spin texture of Au(111) around Gamma (Shockley state)
 This can be compared to example 09.
example 19
 This example shows how to calculate the MAE using the Force Theorem for a monatomic wire. The energy is calculated for various
 angles theta ranging from 0 (M along the wire) to 90 (M perpendicular to the wire) and saved in mft/mae_theta.dat. The mae is defined as (E(90)-E(0)) 
 decomposed over the different orbitals and sites is saved in mae_atom.dat
example 20
 This example shows how to calculate the MAE(theta) along a given line using the Force theorem for a fcc Co(111) surface.
 the lattice parameter can be imposed by the Pt (a=2.77) or Co (a=2.50).
example 21
 This example shows how to calculate the MAE(theta) along a given line using the Force theorem for a fcc Pt/Co(111) surface.
 the lattice parameter can be imposed by the Pt (a=2.77) or Co (a=2.50).
example 22
  MAE(theta,phi) calculation (using Magnetic Force Theorem) of a Fe cubo cluster
example 23
  MAE(theta,phi) calculation (using Magnetic Force Theorem) of a Co(643) vicinal surface
example 24
  MAE(theta,phi) calculation (using Magnetic Force Theorem) of a Pt/Co(643) vicinal surface
 example 24_bis
Same as example24 but where the Pt atoms have been suppressed. It is to evaluate the influence of Pt substrate..
example 25
 This example uses MFT to Calculate the difference of energy between two clock-wise and anti clock-wise magnetic configuration of Co/Pt(111) to extract the DMI as in PRL 115, 267210 (2015)
example 26
 This example uses MFT to Calculate the difference of energy between the skyrmion and the FM solution for Co/Pt(111)
example 27
 This example shows a scf calculation of a magnetic skyrmion (impossible to converge!) in Co/Pt(111)
example 28
 This example is the same as example 27 but for the FM solution.
 example 29
 This example shows how to use TBKOSTER.x to calculate orbital moment and DOS of 1LCo/3LPt(111)
 example 30
 same as example 14 but using the Magnetic Force Theorem
 
 
 
 
 
 
 
 
 
 
