%NProcShared=16
%Chk=TD-8.chk
%mem=1GB
#p Stable=(Opt,RRHF) LC-BP86 lanl2dz
SCF=(NoVarACC,Fermi,XQC,IntRep) Integral=(Acc2E=12) Symm=Loose

Au24 8 states

@Au24_entire.geom

--link1--
%NProcShared=16
%Chk=TD-8.chk
%mem=1GB
#p TD(singlets,Nstates=8,FC) LC-BP86 lanl2dz
SCF=(NoVarACC,XQC,IntRep) Integral=(Acc2E=12)
Geom=AllCheck Guess=Read


