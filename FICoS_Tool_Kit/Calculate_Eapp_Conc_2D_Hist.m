function [handles, Stack_Conc_Bin] = Calculate_Eapp_Conc_2D_Hist(handles, Plot_Type)

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
    Eapp2 = []; Eapp2(:,size(FRET_Item.Eapp,2)) = FRET_Item.Eapp;
    Eapp       = [Eapp; Eapp2];
end;
Eapp(Eapp == 0) = NaN;

UM_Params = mwHandles.UM_Params;
if isfield(UM_Params, 'SlopD'), SlopD = UM_Params.SlopD; else SlopD = 689; end
if isfield(UM_Params, 'SlopA'), SlopA = UM_Params.SlopA; else SlopA = 1534; end

Conc        = (TEW_FD/SlopD + TEW_FA/SlopA)/handles.Pixel_Size^2/handles.Pr_MultFact;
xA          = TEW_FA./(TEW_FD*SlopA/SlopD + TEW_FA);
% TEW_nD      = TEW_FD/SlopD;

handles.TEW_Molecular_Info = [Conc, xA, TEW_Eapp, TEW_FDA_L1, TEW_FAD_L1, TEW_FAD_L2, Eapp];

% Sort the pixels according to cncentration
[Conc_Sorted, Ind] = sort(Conc,'ascend');
xA_Sorted          = xA(Ind);
% TEW_nD_Sorted      = TEW_nD(Ind);
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = max(Conc); end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; end;

% 3D Histogram claculation
% if isfield(handles, 'SEW_Eapp')
%     if handles.SEW_Eapp
Eapp_Sorted     = Eapp;
TEW_Eapp_Sorted = TEW_Eapp;
%     else Eapp_Sorted = TEW_Eapp;
%     end
% end
Eapp_Sorted = Eapp_Sorted(Ind);
if ~isfield(handles, 'Capp_minRange'), handles.Capp_minRange = 0; end;
if ~isfield(handles, 'Capp_maxRange'), handles.Capp_maxRange = 1; end;
if ~isfield(handles, 'Capp_BinSize'), handles.Capp_BinSize = 0.01; end;

Conc_Sect        = Conc_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
xA_Sect          = xA_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Eapp_Sect        = Eapp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
TEW_Eapp_Sect    = TEW_Eapp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
% TEW_nD_Sect      = TEW_nD_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Conc_Sect        = Conc_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
xA_Sect          = xA_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
% TEW_nD_Sect      = TEW_nD_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
Eapp_Sect        = Eapp_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
TEW_Eapp_Sect    = TEW_Eapp_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
Conc_Sect        = Conc_Sect(xA_Sect >= 0 & xA_Sect <= 1);
Eapp_Sect        = Eapp_Sect(xA_Sect >= 0 & xA_Sect <= 1);
TEW_Eapp_Sect    = TEW_Eapp_Sect(xA_Sect >= 0 & xA_Sect <= 1);
% TEW_nD_Sect      = TEW_nD_Sect(xA_Sect >= 0 & xA_Sect <= 1);
xA_Sect          = xA_Sect(xA_Sect >= 0 & xA_Sect <= 1);
handles.Eapp_Val = [handles.Capp_minRange:handles.Capp_BinSize:handles.Capp_maxRange]';
Stack_Conc_Bin   = double(handles.Conc_BinSize);
switch Plot_Type
    case 'Stack'
        if handles.Conc_BinSize*8 < handles.Conc_maxRange - handles.Conc_minRange
            if handles.Conc_maxRange > 80
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8,-1));
            elseif handles.Conc_maxRange > 8
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8));
            else
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8,1));
            end
        end;
    case 'Surf'
    case 'Image'
    case 'Scatter'
    otherwise
end;
handles.Conc_Val         = [handles.Conc_minRange:Stack_Conc_Bin:handles.Conc_maxRange + Stack_Conc_Bin]' - Stack_Conc_Bin/2;
handles.Eapp_Hist_2D     = zeros(length(handles.Eapp_Val),length(handles.Conc_Val)-1);
handles.TEW_Eapp_Hist_2D = zeros(length(handles.Eapp_Val),length(handles.Conc_Val)-1);
for jj = 1:length(handles.Conc_Val)-1
    Eapp_Conc_Sect             = Eapp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.Eapp_Hist_2D(:,jj) = hist(Eapp_Conc_Sect, handles.Eapp_Val)';
    TEW_Eapp_Conc_Sect         = TEW_Eapp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.TEW_Eapp_Hist_2D(:,jj) = hist(TEW_Eapp_Conc_Sect, handles.Eapp_Val)';
end;
handles.Scatter_Plot_Info = [Conc_Sect, xA_Sect, Eapp_Sect, TEW_Eapp_Sect];