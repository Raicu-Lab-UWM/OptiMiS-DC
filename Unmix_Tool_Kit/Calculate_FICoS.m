function [Capp, D_Plus_A, varargout] = Calculate_FICoS(thScene_Inst, Scene_Inst, Tags, Threshold)
Donor                = Tags(1);
Quantum_Yeild_D      = Donor.Quantum_Yield;
dSI                  = Donor.Spectral_Integral;
Acceptor             = Tags(2);
Quantum_Yeild_A      = Acceptor.Quantum_Yield;
aSI                  = Acceptor.Spectral_Integral;
QY_Ratio             = Quantum_Yeild_D/Quantum_Yeild_A;
    
FDA                  = squeeze(Scene_Inst.currUnmix_Images(1,:,:))*dSI;
FAD                  = squeeze(Scene_Inst.currUnmix_Images(2,:,:))*aSI;
thFDA                = squeeze(thScene_Inst.currUnmix_Images(1,:,:))*dSI;
thFAD                = squeeze(thScene_Inst.currUnmix_Images(2,:,:))*aSI;
D_Plus_A             = (QY_Ratio*FAD + FDA);                              % total protein concentration map calculated from the color contrast imaging setup
thD_Plus_A           = (QY_Ratio*thFAD + thFDA);                          % total protein concentration map calculated from the color contrast imaging setup
Capp                 = (QY_Ratio*thFAD - thFDA)./thD_Plus_A;              % Color contrast map calculated from the color contrast imaging setup
D_Plus_A             = D_Plus_A/Quantum_Yeild_D;

Capp(isinf(Capp))    = NaN;
Capp(Capp < -1)      = NaN;
Capp(Capp > 1)       = NaN;
Capp(thFDA/FDA == 0) = NaN;
Capp(thFAD/FAD == 0) = NaN;

if nargout > 2
    varargout{1} = thD_Plus_A/Quantum_Yeild_D;
end