function [handles, Stack_Conc_Bin] = Calculate_Eapp_Conc_2D_Hist(handles, Plot_Type)

% mwHandles = guidata(handles.mwFigureH);

% if ~isfield(mwHandles, 'Polygon_List')
%     msgbox('Open Polygon Console', 'Error');
%     return;
% elseif isempty(mwHandles.Polygon_List)
%     msgbox('Open Polygon Console', 'Error');
%     return;
% end;

FRET_List = handles.FRET_List;
TEW_FD    = [];
TEW_FA    = [];
TEW_Eapp  = [];
Eapp      = [];
for ii = 1:length(FRET_List)
    FRET_Item = FRET_List(ii);
    TEW_FD    = [TEW_FD; FRET_Item.TEW_FD'];
    TEW_FA    = [TEW_FA; FRET_Item.TEW_FA'];
    TEW_Eapp  = [TEW_Eapp; FRET_Item.TEW_Eapp'];
%     Eapp      = [Eapp; FRET_Item.Eapp'/100];
    Eapp      = [Eapp; FRET_Item.Eapp'];
end;
Eapp(Eapp == 0) = NaN;

SlopD       = 689;
SlopA       = 1534;

Conc        = (TEW_FD/SlopD + TEW_FA/SlopA)/handles.Pixel_Size^2/handles.Pr_MultFact;
xA          = TEW_FA./(TEW_FD*SlopA/SlopD + TEW_FA);
TEW_nD      = TEW_FD/SlopD;

handles.TEW_Molecular_Info = [Eapp, TEW_Eapp, Conc, TEW_FD, TEW_FA, xA];

% Sort the pixels according to cncentration
[Conc_Sorted, Ind] = sort(Conc,'ascend');
xA_Sorted          = xA(Ind);
TEW_nD_Sorted      = TEW_nD(Ind);
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = max(Conc); end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; end;

% 3D Histogram claculation
if isfield(handles, 'SEW_Eapp')
    if handles.SEW_Eapp
        Eapp_Sorted = Eapp;
    else Eapp_Sorted = TEW_Eapp;
    end
end
Eapp_Sorted = Eapp_Sorted(Ind);
if ~isfield(handles, 'Eapp_minRange'), handles.Eapp_minRange = 0; end;
if ~isfield(handles, 'Eapp_maxRange'), handles.Eapp_maxRange = 1; end;
if ~isfield(handles, 'Eapp_BinSize'), handles.Eapp_BinSize = 0.01; end;

Conc_Sect        = Conc_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
xA_Sect          = xA_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Eapp_Sect        = Eapp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
TEW_nD_Sect      = TEW_nD_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Conc_Sect        = Conc_Sect(Eapp_Sect > handles.Eapp_minRange & Eapp_Sect <= handles.Eapp_maxRange);
xA_Sect          = xA_Sect(Eapp_Sect > handles.Eapp_minRange & Eapp_Sect <= handles.Eapp_maxRange);
TEW_nD_Sect      = TEW_nD_Sect(Eapp_Sect > handles.Eapp_minRange & Eapp_Sect <= handles.Eapp_maxRange);
Eapp_Sect        = Eapp_Sect(Eapp_Sect > handles.Eapp_minRange & Eapp_Sect <= handles.Eapp_maxRange);
Conc_Sect        = Conc_Sect(xA_Sect >= 0 & xA_Sect <= 1);
Eapp_Sect        = Eapp_Sect(xA_Sect >= 0 & xA_Sect <= 1);
TEW_nD_Sect      = TEW_nD_Sect(xA_Sect >= 0 & xA_Sect <= 1);
xA_Sect          = xA_Sect(xA_Sect >= 0 & xA_Sect <= 1);
handles.Eapp_Val = [handles.Eapp_minRange:handles.Eapp_BinSize:handles.Eapp_maxRange]';
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
handles.Conc_Val     = [handles.Conc_minRange:Stack_Conc_Bin:handles.Conc_maxRange + Stack_Conc_Bin]' - Stack_Conc_Bin/2;
handles.Eapp_Hist_2D = zeros(length(handles.Eapp_Val),length(handles.Conc_Val)-1);
for jj = 1:length(handles.Conc_Val)-1
    Eapp_Conc_Sect             = Eapp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.Eapp_Hist_2D(:,jj) = hist(Eapp_Conc_Sect, handles.Eapp_Val)';
end;
handles.Scatter_Plot_Info = [Conc_Sect, xA_Sect, TEW_nD_Sect, Eapp_Sect];