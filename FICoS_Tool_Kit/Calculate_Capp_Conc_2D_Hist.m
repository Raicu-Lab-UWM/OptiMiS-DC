function [handles, Stack_Conc_Bin] = Calculate_Capp_Conc_2D_Hist(handles, Plot_Type)

% mwHandles = guidata(handles.mwFigureH);

% if ~isfield(mwHandles, 'Polygon_List')
%     msgbox('Open Polygon Console', 'Error');
%     return;
% elseif isempty(mwHandles.Polygon_List)
%     msgbox('Open Polygon Console', 'Error');
%     return;
% end;

FICoS_List = handles.FICoS_List;
Conc       = [];
Capp       = [];
for ii = 1:length(FICoS_List)
    FICoS_Item    = FICoS_List(ii);
    transConc = FICoS_Item.Conc'; currConc = []; currConc(:,1) = transConc(:);
    transCapp = FICoS_Item.Capp'; currCapp = []; currCapp(:,1) = transCapp(:);
    Conc          = [Conc; currConc];
    Capp          = [Capp; currCapp];
end;
Capp(Capp < -1) = NaN;
Capp(Capp > 1)  = NaN;

handles.FICoS_Molecular_Info = [Capp, Conc];

% Sort the pixels according to cncentration
[Conc_Sorted, Ind] = sort(Conc,'ascend');
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = max(Conc); end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; end;

if ~isempty(Ind)
    Capp_Sorted = Capp(Ind);
else
    Capp_Sorted = Capp;
end
if ~isfield(handles, 'Capp_minRange'), handles.Capp_minRange = -1; end;
if ~isfield(handles, 'Capp_maxRange'), handles.Capp_maxRange = 1; end;
if ~isfield(handles, 'Capp_BinSize'), handles.Capp_BinSize = 0.01; end;

Conc_Sect        = Conc_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Capp_Sect        = Capp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Conc_Sect        = Conc_Sect(Capp_Sect > handles.Capp_minRange & Capp_Sect <= handles.Capp_maxRange);
Capp_Sect        = Capp_Sect(Capp_Sect > handles.Capp_minRange & Capp_Sect <= handles.Capp_maxRange);
handles.Capp_Val = [handles.Capp_minRange:handles.Capp_BinSize:handles.Capp_maxRange]';
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
handles.Capp_Hist_2D = zeros(length(handles.Capp_Val),length(handles.Conc_Val)-1);
for jj = 1:length(handles.Conc_Val)-1
    Capp_Conc_Sect             = Capp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.Capp_Hist_2D(:,jj) = hist(Capp_Conc_Sect, handles.Capp_Val)';
end;
handles.Scatter_Plot_Info = [Conc_Sect, Capp_Sect];