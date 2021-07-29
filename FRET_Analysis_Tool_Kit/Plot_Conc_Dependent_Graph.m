function Plot_Conc_Dependent_Graph(hObject, Plot_Type)
handles                   = guidata(hObject);

Conc                      = handles.TEW_Molecular_Info(:,3);
maxC                      = max(Conc);

Conc_Depend_Graph_FigureH = figure('Name', Plot_Type, 'Position', [400, 400, 900, 600], 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle','off');
cdHandles                 = guihandles(Conc_Depend_Graph_FigureH);
cdHandles.output          = Conc_Depend_Graph_FigureH; guidata(Conc_Depend_Graph_FigureH, cdHandles);
cdHandles.Plot_Type       = Plot_Type; guidata(Conc_Depend_Graph_FigureH, cdHandles);
Conc_Depend_Graph_AxesH   = axes('Parent', Conc_Depend_Graph_FigureH, 'Tag', 'Meta_Hist_2D_FRET_AxesH', 'Units', 'normalized', ...
                                 'Position', [0.1, 0.1, 0.76, 0.85]);

switch Plot_Type
    case 'Meta Histogram'
        cdHandles.Conc_Depend_Graph_CurveH = plot(Conc_Depend_Graph_AxesH, handles.Eapp_Val, handles.Eapp_Hist_2D, 'LineWidth', 1);
        Eapp_lBins = [handles.Eapp_minRange:(handles.Eapp_maxRange-handles.Eapp_minRange)/5:handles.Eapp_maxRange];
        set(Conc_Depend_Graph_AxesH, 'XTick',Eapp_lBins, 'FontSize',24);
        xlim(Conc_Depend_Graph_AxesH,[Eapp_lBins(1) Eapp_lBins(end)]); ylim(Conc_Depend_Graph_AxesH, [0 inf]);
    case 'Eapp vs xA'
        Plot_Eapp_vsXA(hObject);
        cdHandles.Conc_Depend_Graph_CurveH = errorbar(Conc_Depend_Graph_AxesH, handles.Eapp_vsXA_Info(:,1), handles.Eapp_vsXA_Info(:,2), handles.Eapp_vsXA_Info(:,4), ...
                                                      'color', [0.4660, 0.6740, 0.1880],'linestyle','none', 'marker','.', 'markersize',30);
        xA_lBins = 0:0.2:1;
        set(Conc_Depend_Graph_AxesH, 'XTick',xA_lBins, 'FontSize',24);
        xlim(Conc_Depend_Graph_AxesH,[0 1]); ylim(Conc_Depend_Graph_AxesH, [0 1]);
    otherwise
end

guidata(Conc_Depend_Graph_FigureH, cdHandles);

cdHandles.minC_Slider = uicontrol('Style', 'Slider', 'Parent', Conc_Depend_Graph_FigureH, 'Units', 'normalized', 'Position', [0.88, 0.1, 0.04, 0.8], ...
                                   'Value', handles.Conc_minRange, 'Min', -maxC, 'Max', maxC, 'Tag', 'minC_Slider', 'SliderStep', [0.01, 0.1], ...
                                   'Callback',{@minC_sBar_Callback, hObject});
cdHandles.maxC_Slider = uicontrol('Style', 'Slider', 'Parent', Conc_Depend_Graph_FigureH, 'Units', 'normalized', 'Position', [0.94, 0.1, 0.04, 0.8], ...
                                   'Value', handles.Conc_maxRange, 'Min', -maxC, 'Max', maxC, 'Tag', 'maxC_Slider', 'SliderStep', [0.01, 0.1], ...
                                   'Callback',{@maxC_sBar_Callback, hObject});
cdHandles.minC_Text   = uicontrol('Parent', Conc_Depend_Graph_FigureH, 'Style', 'text', 'String', 'Min C', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Normalized', 'Position', [0.88 0.9 0.05 0.04], 'FontSize', 10);
cdHandles.minC_Edit   = uicontrol('Style', 'edit', 'Parent', Conc_Depend_Graph_FigureH, 'Units', 'normalized', 'Position', [0.88, 0.04, 0.04, 0.05], ...
                                   'Tag', 'minC_Edit', 'FontSize', 10, 'String', num2str(handles.Conc_minRange), ...
                                   'Callback',{@minC_Edit_Callback, hObject});
cdHandles.maxC_Text   = uicontrol('Parent', Conc_Depend_Graph_FigureH, 'Style', 'text', 'String', 'Max C', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Normalized', 'Position', [0.94 0.9 0.05 0.04], 'FontSize', 10);
cdHandles.maxC_Edit   = uicontrol('Style', 'edit', 'Parent', Conc_Depend_Graph_FigureH, 'Units', 'normalized', 'Position', [0.94, 0.04, 0.04, 0.05], ...
                                   'Tag', 'maxC_Edit', 'FontSize', 10, 'String', num2str(handles.Conc_maxRange), ...
                                   'Callback',{@maxC_Edit_Callback, hObject});

cdHandles.Conc_Depend_Graph_ToolBar = uitoolbar(Conc_Depend_Graph_FigureH);
cdHandles.Snapshot_Icon     = uipushtool(cdHandles.Conc_Depend_Graph_ToolBar,'TooltipString','Snapshot', ...
                                          'ClickedCallback', {@Snapshot_Icon_Callback, handles});
[cdata,~]                    = imread('.\Icons\Snapshot_2_16x16.png');
cdHandles.Snapshot_Icon.CData = cdata;

cdHandles.Save_MH_Data_Icon = uipushtool(cdHandles.Conc_Depend_Graph_ToolBar,'TooltipString','Save Meta-Histogram Data', ...
                                         'ClickedCallback', {@Save_MH_Data_Icon_Callback, hObject});
[cdata,~]                    = imread('.\Icons\file_save.png');
cdHandles.Save_MH_Data_Icon.CData = cdata;

guidata(Conc_Depend_Graph_FigureH, cdHandles);

function Snapshot_Icon_Callback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), [Name, Path] = uiputfile([handles.Ana_Path '\Snapshot.png'], 'Save Snapshot'); 
else [Name, Path] = uiputfile([mwHandles.Ana_Path '\Snapshot.png'], 'Save Snapshot');
end
% Axes_Frame = getframe(handles.Meta_Hist_2D_FRET_AxesH);
% Axes_Image = frame2im(Axes_Frame);
% imwrite(Axes_Image, [Path '\' Name]);
export_fig([Path '\' Name], '-png', handles.Meta_Hist_2D_FRET_FigureH);

function Save_MH_Data_Icon_Callback(hObject, eventdata, FRET_FigureH)
handles   = guidata(FRET_FigureH);
cdHandles = guidata(hObject);

tpltPath  = '.\Templates\';
[tpltName, tpltPath] = uigetfile([tpltPath '*.xlsx'], 'Load a Template');

Time_Stamp             = datestr(now,'ddmmyyyy HHMMSS');
Name                   = [num2str(Time_Stamp) '_MetaHistogram'];
if ~isfield(handles, 'Ana_Path'), curr_Path = '.\'; elseif isempty(handles.curr_Path), curr_Path = '.\'; else curr_Path = handles.curr_Path; end;
[Name, curr_Path]      = uiputfile([curr_Path '\*.xlsx'], 'Save Data to', [curr_Path '\' Name]);
fName1                 = [curr_Path '\' Name];
copyfile([tpltPath tpltName],fName1);
cdSheet_Name           = cdHandles.Plot_Type;
switch cdHandles.Plot_Type
    case 'Meta Histogram'
        Conc_Depend_Graph_Data = [handles.Eapp_Val,handles.Eapp_Hist_2D];
    case 'Eapp vs xA'
        Conc_Depend_Graph_Data = [handles.Eapp_vsXA_Info(:,1),handles.Eapp_vsXA_Info(:,2)];
    otherwise
end

xlswrite(fName1, Conc_Depend_Graph_Data, cdSheet_Name, 'C4');

function minC_sBar_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
handles   = guidata(FRET_ToolKet_FigureH);
cdHandles = guidata(hObject);

handles.Conc_minRange = double(get(hObject, 'Value'));
if handles.Conc_minRange > handles.Conc_maxRange
    handles.Conc_maxRange = handles.Conc_minRange;
    set(cdHandles.maxC_Slider, 'Value', handles.Conc_maxRange);
    set(cdHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));
end
handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
set(cdHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));

[handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack'); guidata(FRET_ToolKet_FigureH, handles);
switch cdHandles.Plot_Type
    case 'Meta Histogram'
        set(cdHandles.Conc_Depend_Graph_CurveH, 'YData', handles.Eapp_Hist_2D);
    case 'Eapp vs xA'
        Plot_Eapp_vsXA(FRET_ToolKet_FigureH); handles = guidata(FRET_ToolKet_FigureH);
        set(cdHandles.Conc_Depend_Graph_CurveH, 'XData', handles.Eapp_vsXA_Info(:,1), 'YData', handles.Eapp_vsXA_Info(:,2), ...
            'LData', handles.Eapp_vsXA_Info(:,4), 'UData', handles.Eapp_vsXA_Info(:,4));
    otherwise
end

guidata(FRET_ToolKet_FigureH, handles);
guidata(hObject, cdHandles);

function minC_Edit_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
handles   = guidata(FRET_ToolKet_FigureH);
cdHandles = guidata(hObject);

handles.Conc_minRange = str2double(get(hObject, 'String'));
if handles.Conc_minRange > handles.Conc_maxRange
    handles.Conc_maxRange = handles.Conc_minRange;
    set(cdHandles.maxC_Slider, 'Value', handles.Conc_maxRange);
    set(cdHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));
end
handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
set(cdHandles.minC_Slider, 'Value', handles.Conc_minRange);

[handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack'); guidata(FRET_ToolKet_FigureH, handles);
switch cdHandles.Plot_Type
    case 'Meta Histogram'
        set(cdHandles.Conc_Depend_Graph_CurveH, 'YData', handles.Eapp_Hist_2D);
    case 'Eapp vs xA'
        Plot_Eapp_vsXA(FRET_ToolKet_FigureH); handles = guidata(FRET_ToolKet_FigureH);
        set(cdHandles.Conc_Depend_Graph_CurveH, 'XData', handles.Eapp_vsXA_Info(:,1), 'YData', handles.Eapp_vsXA_Info(:,2), ...
            'LData', handles.Eapp_vsXA_Info(:,4), 'UData', handles.Eapp_vsXA_Info(:,4));
    otherwise
end

guidata(FRET_ToolKet_FigureH, handles);
guidata(hObject, cdHandles);

function maxC_sBar_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
handles   = guidata(FRET_ToolKet_FigureH);
cdHandles = guidata(hObject);

handles.Conc_maxRange = double(get(hObject, 'Value'));
if handles.Conc_minRange > handles.Conc_maxRange
    handles.Conc_minRange = handles.Conc_maxRange;
    set(cdHandles.minC_Slider, 'Value', handles.Conc_minRange);
    set(cdHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));
end
handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
set(cdHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));

[handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack'); guidata(FRET_ToolKet_FigureH, handles);
switch cdHandles.Plot_Type
    case 'Meta Histogram'
        set(cdHandles.Conc_Depend_Graph_CurveH, 'YData', handles.Eapp_Hist_2D);
    case 'Eapp vs xA'
        Plot_Eapp_vsXA(FRET_ToolKet_FigureH); handles = guidata(FRET_ToolKet_FigureH);
        set(cdHandles.Conc_Depend_Graph_CurveH, 'XData', handles.Eapp_vsXA_Info(:,1), 'YData', handles.Eapp_vsXA_Info(:,2), ...
            'LData', handles.Eapp_vsXA_Info(:,4), 'UData', handles.Eapp_vsXA_Info(:,4));
    otherwise
end

guidata(FRET_ToolKet_FigureH, handles);
guidata(hObject, cdHandles);

function maxC_Edit_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
handles   = guidata(FRET_ToolKet_FigureH);
cdHandles = guidata(hObject);

handles.Conc_maxRange = str2double(get(hObject, 'String'));
if handles.Conc_minRange > handles.Conc_maxRange
    handles.Conc_minRange = handles.Conc_maxRange;
    set(cdHandles.minC_Slider, 'Value', handles.Conc_minRange);
    set(cdHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));
end
handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
set(cdHandles.maxC_Slider, 'Value', handles.Conc_maxRange);

[handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack'); guidata(FRET_ToolKet_FigureH, handles);
switch cdHandles.Plot_Type
    case 'Meta Histogram'
        set(cdHandles.Conc_Depend_Graph_CurveH, 'YData', handles.Eapp_Hist_2D);
    case 'Eapp vs xA'
        Plot_Eapp_vsXA(FRET_ToolKet_FigureH); handles = guidata(FRET_ToolKet_FigureH);
        set(cdHandles.Conc_Depend_Graph_CurveH, 'XData', handles.Eapp_vsXA_Info(:,1), 'YData', handles.Eapp_vsXA_Info(:,2), ...
            'LData', handles.Eapp_vsXA_Info(:,4), 'UData', handles.Eapp_vsXA_Info(:,4));
    otherwise
end

guidata(FRET_ToolKet_FigureH, handles);
guidata(hObject, cdHandles);