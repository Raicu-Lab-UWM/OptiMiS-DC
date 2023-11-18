function handles= Calculate_Eapp_Conc_DB(handles)

mwHandles = guidata(handles.mwFigureH);

FRET_List = handles.FRET_List;
TEW_FD     = [];
TEW_FA     = [];
TEW_FDA_L1 = [];
TEW_FAD_L1 = [];
TEW_FAD_L2 = [];
TEW_Eapp   = [];
Eapp       = [];
for ii = 1:length(FRET_List)
    FRET_Item  = FRET_List(ii);
    FD = []; FD(:,1)    = FRET_Item.TEW_FD;
    TEW_FD     = [TEW_FD; FD];
    FA = []; FA(:,1)    = FRET_Item.TEW_FA;
    TEW_FA     = [TEW_FA; FA];
    FDA_L1 = []; FDA_L1(:,1) = FRET_Item.TEW_FDA_L1;
    TEW_FDA_L1 = [TEW_FDA_L1; FDA_L1];
    FAD_L1 = []; FAD_L1(:,1) = FRET_Item.TEW_FAD_L1;
    TEW_FAD_L1 = [TEW_FAD_L1; FAD_L1];
    FAD_L2 = []; FAD_L2(:,1) = FRET_Item.TEW_FAD_L2;
    TEW_FAD_L2 = [TEW_FAD_L2; FAD_L2];
    Eapp1 = []; Eapp1(:,1) = FRET_Item.TEW_Eapp;
    TEW_Eapp   = [TEW_Eapp; Eapp1];
%     Eapp2 = [];
%     Eapp2(:,size(FRET_Item.Eapp,2)) = FRET_Item.Eapp;
    Eapp2 = FRET_Item.Eapp;
    Eapp       = [Eapp; Eapp2];
end;
Eapp(Eapp == 0) = NaN;

UM_Params = mwHandles.UM_Params;
if isfield(UM_Params, 'SlopD'), SlopD = UM_Params.SlopD; else SlopD = 37985.4; end
if isfield(UM_Params, 'SlopA'), SlopA = UM_Params.SlopA; else SlopA = 7440.1; end
if isfield(UM_Params, 'psfD'), psfD = UM_Params.psfD; else psfD = 5.65E-20; end
if isfield(UM_Params, 'psfA'), psfA = UM_Params.psfA; else psfA = 4.71E-20; end
if isfield(UM_Params, 'qD'), qD = UM_Params.qD; else qD = 0.55; end
if isfield(UM_Params, 'qA'), qA = UM_Params.qA; else qA = 0.61; end
if isfield(UM_Params, 'rowD'), rowD = UM_Params.rowD; else rowD = 4.4351; end
if isfield(UM_Params, 'rowA'), rowA = UM_Params.rowA; else rowA = 0.056; end

rQuant_Yield = qD/qA;
FA1   = (TEW_FAD_L1-(TEW_FAD_L2*rowD))/(1-(rowD/rowA));
FD     = TEW_FDA_L1 + (rQuant_Yield*TEW_FAD_L1)-(rQuant_Yield*FA1);                                    % from Prof. Raicu's paper titled "Ab initio derivation
FA     = (TEW_FAD_L2-(TEW_FAD_L1/rowD))/(1-(rowA/rowD));                                         % of the FRET equations resolves old puzzles and 
                                                        
TEW_Eapp   = 1./(1+((TEW_FDA_L1*qA/qD)./(TEW_FAD_L1-(FA*rowA))));

SlopD = SlopD*1000/(6.022*10^23); % converted from Int/uM to m3/count
SlopA = SlopA*1000/(6.022*10^23);
Dconc = FD*psfD/SlopD;
Aconc = FA*psfA/SlopA;
Conc  = Dconc+Aconc;
xA    = Aconc./Conc;
% Conc        = (TEW_FD/SlopD + TEW_FA/SlopA)/handles.Pixel_Size^2/handles.Pr_MultFact;
% xA          = TEW_FA./(TEW_FD*SlopA/SlopD + TEW_FA);
% TEW_nD      = TEW_FD/SlopD;

handles.TEW_Molecular_Info = [Conc, xA, TEW_Eapp, TEW_FDA_L1, TEW_FAD_L1, TEW_FAD_L2, Eapp];
handles.TEW_Eapp_Conc_Info = [Dconc, Aconc, Conc, xA, Eapp];
