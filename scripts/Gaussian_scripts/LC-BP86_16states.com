%NProcShared=16
%Chk=TD-16.chk
%mem=1500MB
#p TD(singlets,Add=8,Nstates=16,FC) LC-BP86 lanl2dz
SCF=(NoVarACC,XQC,IntRep) Integral=(Acc2E=12)
Geom=AllCheck Guess=Read


