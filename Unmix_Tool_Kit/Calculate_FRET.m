function [Eapp, FDonly, varargout] = Calculate_FRET(thScene_Inst, Scene_Inst, Tags, Threshold)
Donor             = Tags(1);
Quantum_Yeild_D   = Donor.Quantum_Yield;
dSI               = Donor.Spectral_Integral;
Acceptor          = Tags(2);
Quantum_Yeild_A   = Acceptor.Quantum_Yield;
aSI               = Acceptor.Spectral_Integral;
    
FDA               = squeeze(Scene_Inst.currUnmix_Images(1,:,:))*dSI;
FAD               = squeeze(Scene_Inst.currUnmix_Images(2,:,:))*aSI;
thFDA             = squeeze(thScene_Inst.currUnmix_Images(1,:,:))*dSI;
thFAD             = squeeze(thScene_Inst.currUnmix_Images(2,:,:))*aSI;
FDonly            = squeeze(FDA+FAD*Quantum_Yeild_D/Quantum_Yeild_A);
thFDonly          = squeeze(thFDA+thFAD*Quantum_Yeild_D/Quantum_Yeild_A);
Eapp              = squeeze(thFAD./(thFAD + thFDA.*Quantum_Yeild_A/Quantum_Yeild_D));
    
Eapp(isnan(Eapp)) = 0;
Eapp(isinf(Eapp)) = 0;
Eapp(thFDA == 0)  = 0;
Eapp(Eapp < 0)    = 0;
Eapp(Eapp > 1)    = 0;

if nargout > 2
    varargout{1} = thFDonly;
end