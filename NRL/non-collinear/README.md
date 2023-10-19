### Non collinear spin examples (ns=4)

Different types of constraints:\
magnetic_penalization='none' = no constraint\
magnetic_penalization='r' = constraint on the magnetization component  (r,  .  , . )\
magnetic_penalization='r,theta' = constraint on the magnetization components (r,theta, . )\
magnetic_penalization='r,theta,phi' = constraint on the magnetization vector     (r,theta,phi)\
magnetic_penalization='theta' = constraint on the magnetization component  (.,theta, . )\
magnetic_penalization='theta,phi' = constraint on the magnetization components (.,theta,phi)\
magnetic_penalization='phi' = constraint on the magnetization component  (.,  .  ,phi)

|Description|Example|
|:---|:---:|
|Band structure of Cu fcc with SOC|**example01**|
|SCF non-collinear spin calculation of a 5-atom Fe wire with magnetic penalization on atom 1. The penalization on atom 1 is theta,phi=(3,30,0) and the other atoms are free. During scf the spin tend do align|**example02**|
|Same system as example01 but with no penalization. However the initial magnetization of atom 1 is opposite to the other atoms. For symmetry reasons the magnetization remains opposite which simulate the simplest magnetic excitation|**example03**|
|SCF NON-collinear spin calculation of a 4-atom Fe wire. The initial magnetization is a spin spiral of period 4a. Due to periodic boundary conditions the spin spiral configuration is kept during scf|**example04**|
|Magnetic anisotropy, spin and orbital moment of Fe wire for several TB models (Stoner UJ, UJB)|**example05**|
|band-structure of Fe wire with SOC. Magnetization along the wire and perpendicular to the wire|**example06**|
|Same as example 13 but with SOC. Apparition of magnetic moment with expansion of the lattice parameter for Ptfcc with and without spin-orbit coupling. Strong influence of SOC|**example07**|
|Anisotropy of of Fe monolayer with several magnetic interaction: Stoner & UJB|**example08**|
|Same as example15 but with SOC. Au(111) scf calculation with SOC (xi_p=1.0eV xi_d=0.65eV) + Au(111) band structure calculation (Rashba splitting of shockley surface state)|**example09**|
|Same as example19 but with SOC. Fe-Pt L10 system: magnetic anisotropy of FM solution versus c/a at fixed volume|**example10**|
|Fe monatomic wire: calculation of spin-spiral configuration by two different ways: - standard calculation with 4 atoms per unit cell - spin spiral calculation with one atom per unit-cell and  k_spiral=(0,0,1/4) - a FM calculation is also performed... it is the most stable.|**example11**|
|Cr bcc: calculation of AF configuration by two different ways: - standard collinear calculation with two atoms per unit cell - spin spiral calculation with one atom per unit-cell and k_spiral=(0,0,1/2) (xyz)=(-1/2,1/2,1/2) (direct)|**example12**|
|Fe monatomic wire: spin spiral calculation of E(q) there is a shallow minimum for a given k_spiral this minimum disappears for larger lattice parameters.|**example13**|
|Fe monatomic wire: calculation of spin spiral by two different ways: - non-collinear calculation with 18 atoms per unit cell and theta_pen(i)=20*(i-1) i=1,18 - spin spiral calculation with one atom per unit-cell and Q=(0,0,1/18)|**example14**|
|DOS of bcc-Fe with SOC. band structure of bcc-Fe with SOC|**example15**|
|SCF calculation of Cr trimer. Neel configuration is found (depending on the input magnetism). verbose=.true. and the relaxation process is saved in scf->vizualization with ovito|**example16**|
|This example shows how to use TBKOSTER.x to calculate a Fe cuboctahedron cluster. verbose=.true. and the relaxation process is saved in scf->vizualization with ovito|**example17**|