function FRET_2D_Plot_EappXA_pButton_Callback (hObject, eventdata, FRET_Tool_Kit_FigH)

handles   = guidata(FRET_Tool_Kit_FigH);
mwHandles = guidata(handles.Main_FigureH);

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

SlopD     = 689;
SlopA     = 1534;
TEW_nD    = TEW_FD/SlopD;
TEW_nA    = TEW_FA/SlopA;
xA        = TEW_nA./(TEW_nD + TEW_nA);
Conc      = TEW_nD + TEW_nA;

minC      = mwHandles.Disp_Params.Conc_minRange;
maxC      = mwHandles.Disp_Params.Conc_maxRange;
binC      = mwHandles.Disp_Params.Conc_BinSize;
minE      = mwHandles.Disp_Params.Eapp_minRange;
maxE      = mwHandles.Disp_Params.Eapp_maxRange;
binE      = mwHandles.Disp_Params.Eapp_BinSize;

xA(Conc > maxC)       = []; xA(Conc < minC)       = [];
Eapp(Conc > maxC)     = []; Eapp(Conc < minC)     = [];
TEW_Eapp(Conc > maxC) = []; TEW_Eapp(Conc < minC) = [];
TEW_nD(Conc > maxC)   = []; TEW_nD(Conc < minC)   = [];
Conc(Conc > maxC)     = []; Conc(Conc < minC)     = [];

Eapp(xA > 1)          = []; Eapp(xA < 0)          = [];
TEW_Eapp(xA > 1)      = []; TEW_Eapp(xA < 0)      = [];
Conc(xA > 1)          = []; Conc(xA < 0)          = [];
TEW_nD(xA > 1)        = []; TEW_nD(xA < 0)        = [];
xA(xA > 1)            = []; xA(xA < 0)            = [];

hFigure             = Plot_Window_Generic ('Eapp vs xA', FRET_Tool_Kit_FigH);
handles.hAxes       = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.78, 0.84]);
if isfield(handles, 'SEW_Eapp')
    if handles.SEW_Eapp,
        Conc(Eapp > maxE)   = []; Conc(Eapp < minE)   = [];
        xA(Eapp > maxE)     = []; xA(Eapp < minE)     = [];
        TEW_nD(Eapp > maxE) = []; TEW_nD(Eapp < minE) = [];
        Eapp(Eapp > maxE)   = []; Eapp(Eapp < minE) = [];
        plot3(handles.hAxes, Conc, xA, round(Eapp, 2), 'b.');
    else
        Conc(TEW_Eapp > maxE)     = []; Conc(TEW_Eapp < minE)     = [];
        xA(TEW_Eapp > maxE)       = []; xA(TEW_Eapp < minE)       = [];
        TEW_nD(TEW_Eapp > maxE)   = []; TEW_nD(TEW_Eapp < minE)   = [];
        TEW_Eapp(TEW_Eapp > maxE) = []; TEW_Eapp(TEW_Eapp < minE) = [];
        plot3(handles.hAxes, Conc, xA, round(TEW_Eapp, 3), 'b.');
    end
else
    Conc(TEW_Eapp > maxE)     = []; Conc(TEW_Eapp < minE)     = [];
    xA(TEW_Eapp > maxE)       = []; xA(TEW_Eapp < minE)       = [];
    TEW_nD(TEW_Eapp > maxE)   = []; TEW_nD(TEW_Eapp < minE)   = [];
    TEW_Eapp(TEW_Eapp > maxE) = []; TEW_Eapp(TEW_Eapp < minE) = [];
    plot3(handles.hAxes, Conc, xA, round(TEW_Eapp, 3), 'b.');
end

ylim([0 1]); zlim([0 1]); xlim([minC maxC]);
% set(get(handles.hAxes, 'xlabel'),'String', 'D + A [Proto./ Pixel]');
% set(get(handles.hAxes, 'ylabel'),'String', 'xA');
% set(get(handles.hAxes, 'zlabel'),'String', 'E_a_p_p');
set(handles.hAxes, 'YTick',0:0.2:1, 'XTick',minC:round((maxC-minC)/5,1):maxC, 'ZTick',0:0.2:1, 'FontSize',24);
grid(handles.hAxes, 'on');
az = 73; el = 50; view(handles.hAxes, az, el);

if isfield(handles, 'SEW_Eapp')
    if handles.SEW_Eapp,
        Data = [Conc, xA, TEW_nD, Eapp];
    else
        Data = [Conc, xA, TEW_nD, TEW_Eapp];
    end
else
    Data = [Conc, xA, TEW_nD, TEW_Eapp];
end

Data_Sort      = sortrows(Data,1);
Data_Sort(:,1) = round(Data_Sort(:,1)/binC)*binC;
Data_Sort(:,2) = round(Data_Sort(:,2)/binE)*binE;
Conc_Uniq      = minC:binC:maxC;
Conc_Bin_Hist  = hist(Data_Sort(:,1), Conc_Uniq);
Conc_Cluster   = mat2cell(Data_Sort, Conc_Bin_Hist, 4);
Eapp_Map       = zeros(length(Conc_Uniq),round(1/binE)+1);

for ii = 1:length(Conc_Uniq)
    currConc      = (Conc_Cluster{ii});
    currConc_Sort = sortrows(currConc, 2);
    xA_Hist       = hist(currConc_Sort(:,2), 0:binE:1);
    xA_Cluster    = mat2cell(currConc_Sort, xA_Hist, 4);
    avgEapp       = cellfun(@(x) sum(x(~isnan(x(:,4)),3).*x(~isnan(x(:,4)),4))/sum(x(~isnan(x(:,4)),3)), xA_Cluster);
    if ~isempty(currConc)
        Eapp_Map(int16(Conc_Uniq(ii)/binC)+1, int16([0:binE:1]/binE)+1) = avgEapp;
    else
        Eapp_Map(int16(Conc_Uniq(ii)/binC)+1, int16([0:binE:1]/binE)+1) = NaN*[0:binE:1];
    end
end

hFigure_Surf = Plot_Window_Generic ('Eapp vs xA and D+A', FRET_Tool_Kit_FigH);
handles.hAxes_Surf = axes('Parent', hFigure_Surf, 'Position',[0.12, 0.1, 0.79, 0.87]);
surf(0:binE:1, Conc_Uniq', Eapp_Map, 'EdgeColor','none', ...
     'LineStyle','none', 'FaceLighting','phong', 'FaceLighting','gouraud', 'FaceColor','interp', 'AmbientStrength',0.5);

ylim([Conc_Uniq(1) Conc_Uniq(end)]); xlim([0 1]);
Conc_lBins = Conc_Uniq(1):round((Conc_Uniq(end) - Conc_Uniq(1))/5,-1):Conc_Uniq(end);
xA_lBins   = 0:0.2:1;
% set(handles.hAxes_Surf, 'YTick',Conc_lBins, 'XTick',xA_lBins, 'FontSize',10); % , 'YDir','reverse'
az = -25; el = 50; view(handles.hAxes_Surf, az, el);
colormap jet; material Shiny;

set(get(handles.hAxes_Surf, 'ylabel'),'String', 'D + A [Proto./ Pixel]');
set(get(handles.hAxes_Surf, 'xlabel'),'String', 'xA');
set(get(handles.hAxes_Surf, 'zlabel'),'String', 'E_a_p_p');
grid(handles.hAxes_Surf, 'on');
