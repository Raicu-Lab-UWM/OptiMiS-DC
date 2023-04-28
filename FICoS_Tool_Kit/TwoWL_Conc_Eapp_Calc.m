function [Eapp12, Dconc, Aconc, Conc, xA] = TwoWL_Conc_Eapp_Calc(FDA_L1, FAD_L1, FAD_L2, qD, qA, rowD, rowA, SlopD, SlopA, psfD, psfA)
    rQuant_Yield = qD/qA;
    FA1   = (FAD_L1-(FAD_L2*rowD))/(1-(rowD/rowA));
    FD    = FDA_L1 + (rQuant_Yield*FAD_L1)-(rQuant_Yield*FA1);                                    % from Prof. Raicu's paper titled "Ab initio derivation
    FA    = (FAD_L2-(FAD_L1/rowD))/(1-(rowA/rowD));                                         % of the FRET equations resolves old puzzles and 

    Eapp12   = 1./(1+((FDA_L1*qA/qD)./(FAD_L1-(FA*rowA))));

    SlopD = SlopD*1000/(6.022*10^23); % converted from Int/uM to m3/count
    SlopA = SlopA*1000/(6.022*10^23);
    Dconc = FD*psfD/SlopD;
    Aconc = FA*psfA/SlopA;
    Conc  = Dconc+Aconc;
    xA    = Aconc./Conc;
end