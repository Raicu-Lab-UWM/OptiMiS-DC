function Meta_Hist_Plot(FICoS_FigureH)

handles   = guidata(FICoS_FigureH);
mwHandles = guidata(handles.mwFigureH);

Meta_Hist_FigureH = figure('Name', 'Meta Histogram Plot', 'Tag', 'Meta_Hist_FigureH', 'Position', [100, 100, 800, 600], ...
                           'NumberTitle','off', 'MenuBar', 'none', 'ToolBar', 'figure');

Meta_Hist_AxesH = axes('Parent', Meta_Hist_FigureH, 'Tag', 'Meta_Hist_AxesH', 'Units', 'normalized', 'Position', [0.1, 0.1, 0.87, 0.87]);

% removing un wanted toolbar icons
Legend_Icon = findall(Meta_Hist_FigureH, 'ToolTipString', 'Insert Legend'); set(Legend_Icon, 'Visible', 'off');
Rotate_Icon = findall(Meta_Hist_FigureH, 'ToolTipString', 'Rotate 3D'); set(Rotate_Icon, 'Visible', 'off');
Open_Icon   = findall(Meta_Hist_FigureH, 'ToolTipString', 'Open File'); set(Open_Icon, 'Visible', 'off');
Print_Icon  = findall(Meta_Hist_FigureH, 'ToolTipString','Print Figure'); set(Print_Icon, 'Visible', 'off');

% coding the functions of needed toolbat icons
MH_Save_Icon  = findall(Meta_Hist_FigureH, 'ToolTipString','Save Figure');     % Saving Meta-histogram.
set(MH_Save_Icon, 'ClickedCallback', {@MH_Save_Icon_ClickedCallback, FICoS_FigureH}, 'ToolTipString', 'Save Meta Histogram');
MH_Print_Icon = findall(Meta_Hist_FigureH, 'ToolTipString','Print');     % Printing Meta-histogram.
set(MH_Print_Icon, 'ClickedCallback', {@MH_Print_Icon_ClickedCallback, FICoS_FigureH}, 'ToolTipString', 'Save Meta Histogram');

if max(handles.Meta_Histogram(2:end,1)) > 1 + handles.Meta_Histogram(2,1) - handles.Meta_Histogram(1,1)
    Meta_Histogram_Bin =  handles.Meta_Histogram(:,1)/100;
else
    Meta_Histogram_Bin =  handles.Meta_Histogram(:,1);
end
bar(Meta_Hist_AxesH, Meta_Histogram_Bin, handles.Meta_Histogram(:,2), 1);
xlabel(Meta_Hist_AxesH, '\it{E_a_p_p}');
ylabel(Meta_Hist_AxesH, '\it{# Cells}');
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    axis(Meta_Hist_AxesH,[-1,1,0,inf]);
else
    axis(Meta_Hist_AxesH,[0,1,0,inf]);
end
end

function MH_Save_Icon_ClickedCallback(hObject, eventdata, FICoS_FigureH)

handles   = guidata(FICoS_FigureH);
mwHandles = guidata(handles.mwFigureH);

ROI_Names = {mwHandles.Polygon_List.Name};
tpltPath  = '.\Templates\';
[tpltName, tpltPath] = uigetfile([tpltPath '*.xlsx'], 'Load a Template');

Time_Stamp        = datestr(now,'ddmmyyyy HHMMSS');
Name              = [num2str(Time_Stamp) '_MetaHistogram'];
if ~isfield(handles, 'Ana_Path'), curr_Path = '.\'; elseif isempty(handles.curr_Path), curr_Path = '.\'; else curr_Path = handles.curr_Path; end
[Name, curr_Path] = uiputfile([curr_Path '\*.xlsx'], 'Save Data to', [curr_Path '\' Name]);
fName1            = [curr_Path '\' Name];
copyfile([tpltPath tpltName],fName1);
ppSheet_Name      = 'Peak Positions';
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    Peak_Pos = {handles.FICoS_List.Capp};
else
    Peak_Pos = {handles.FRET_List.Eapp};
end
Peak_Pos          = cell2mat(Peak_Pos);
% Peak_Pos(Peak_Pos == 0) = [];
% if max(Peak_Pos) > 1, Peak_Pos = Peak_Pos/100; end
% xlswrite(fName1, ROI_Names', ppSheet_Name, 'B4');
xlswrite(fName1, Peak_Pos', ppSheet_Name, 'C4');

end