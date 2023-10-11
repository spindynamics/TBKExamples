Two types of constraints:\
m_penalization='none' = no constraint\
m_penalization='r' = constraint on the magnetization vector **M**

|Description|Example|
|:---|:---:|
|Calculation of energy vs lattice parameter curve of fcc Pt| **example01**|
|Self consistent calculation of the (111) surface of Pt. projected DOS calculation for the surface atom |**example02**|
|Self consistent calculation of the (111) surface of Pt. band structure calculation |**example03**|
|Self consistent calculation of magnetic bcc Fe at several lattice parameters,then as an output we can plot Etot_vs_a.dat and M_vs_a.dat|**example04**|
|Self consistent calculation of bcc Fe for fixed-spin-moment (fixed_spin_moment=T) at various values of M to get E(M)|**example05**|
|Comparison with SCF of Fe-bcc with penalization on the total moment of the type lambda(M-Mo)^2. Here the bcc is described by a cubic lattice with 2 atoms per unit cell and the penalization is only on atom 1. Atom is free to adapt.. |**example06**|
|Self consistent calculation of iron cluster (cuboctahedron) verbose=.true. and the relaxation process is saved in scf->vizualization with ovito | **example07**|
|Magnetization of Rh as a function of the lattice parameter and band structure of Rh.|**example08**|
|Study of the influence of the number of k points on the total energy and study of the influence of the smearing technique on the total energy|**example09**|
|Self consistent calculation of a 5 atom of Fe in a wire with penalization on atom 1 m1=3 m2,m3,m4,m5 is free|**example10**|
|Chromium bcc: magnetism as a function of lattice parameter|**example11**|
|Self consistent calculation of fcc-Co at several lattice parameters|**example12**|
|Apparition of magnetic moment with expansion of the lattice parameter for pcc-Pt|**example13**|
|Au(111) fcc surface scf calculation. Projected DOS calculation for the surface atom|**example14**|
|Au(111) fcc surface band structure calculation. To accelerate the scf calculation one can cp the out_charge.txt of example14 into in_charge.txt of example15 so that the scf calculation will restart from a converged charge. The band structure calculation is performed. Remakable agreement with pwscf calculation (Surf. Sci. 602, (2008) 893, Fig. 2)|**example15**|
|Ni fcc magnetic with respect to lattice parameter: study of the influence of the Stoner parameter->comparison with _ab-initio_|**example16**|
|Ni monolayer on Au fcc(111) interface, magnetic calculation|**example17**|
|Co-Pt L10 scf + DOS|**example18**|
|Fe-Pt L10 Etot(c/a) for FM and AF|**example19**|
|This example shows how to use TBKOSTER.x to calculate the total energy of zirconium fcc, bcc and hcp(c/a)|**example25**|
|This example shows how to use TBKOSTER.x to explore the magnetic configuration FM and AFM (+ continuous transition between the two) of B2 FeRh. For lattice parameters below a=3A the system is AFM while it becomes FM above a=3A. This is in perfect agreement with DFT calculations.|**example26**|