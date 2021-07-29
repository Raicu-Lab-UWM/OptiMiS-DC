function Plot_Conc_Dependent_MetaHist(hObject)
Plot_Conc_Dependent_Graph(hObject, 'Meta Histogram');
% handles      = guidata(hObject);
% 
% Conc         = handles.TEW_Molecular_Info(:,3);
% maxC         = max(Conc);
% 
% MetaHist_FRET2D_FigureH = figure('Position', [400, 400, 900, 600], 'MenuBar', 'none', 'ToolBar', 'none', 'NumberTitle','off');
% mhHandles               = guihandles(MetaHist_FRET2D_FigureH);
% mhHandles.output        = MetaHist_FRET2D_FigureH; guidata(MetaHist_FRET2D_FigureH, mhHandles)
% MetaHist_FRET2D_AxesH   = axes('Parent', MetaHist_FRET2D_FigureH, 'Tag', 'Meta_Hist_2D_FRET_AxesH', 'Units', 'normalized', ...
%                                 'Position', [0.1, 0.1, 0.76, 0.85]);
% Eapp_lBins              = [handles.Eapp_minRange:(handles.Eapp_maxRange-handles.Eapp_minRange)/5:handles.Eapp_maxRange];
% set(MetaHist_FRET2D_AxesH, 'XTick',Eapp_lBins, 'FontSize',24);
% [handles, ~]            = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack'); guidata(hObject, handles);
% if isempty(handles.Eapp_Hist_2D)
%     handles.Eapp_Hist_2D = zeros(size(handles.Eapp_Val));
% end
% xlim(MetaHist_FRET2D_AxesH,[Eapp_lBins(1) Eapp_lBins(end)]); ylim(MetaHist_FRET2D_AxesH, [0 inf]);
% 
% mhHandles.MetaHist_FRET2D_CurveH = plot(MetaHist_FRET2D_AxesH, handles.Eapp_Val, handles.Eapp_Hist_2D, 'LineWidth', 1);
% guidata(MetaHist_FRET2D_FigureH, mhHandles);
% 
% mhHandles.minC_Slider = uicontrol('Style', 'Slider', 'Parent', MetaHist_FRET2D_FigureH, 'Units', 'normalized', 'Position', [0.88, 0.1, 0.04, 0.8], ...
%                                    'Value', handles.Conc_minRange, 'Min', -maxC, 'Max', maxC, 'Tag', 'minC_Slider', 'SliderStep', [0.01, 0.1], ...
%                                    'Callback',{@minC_sBar_Callback, hObject});
% mhHandles.maxC_Slider = uicontrol('Style', 'Slider', 'Parent', MetaHist_FRET2D_FigureH, 'Units', 'normalized', 'Position', [0.94, 0.1, 0.04, 0.8], ...
%                                    'Value', handles.Conc_maxRange, 'Min', -maxC, 'Max', maxC, 'Tag', 'maxC_Slider', 'SliderStep', [0.01, 0.1], ...
%                                    'Callback',{@maxC_sBar_Callback, hObject});
% mhHandles.minC_Text   = uicontrol('Parent', MetaHist_FRET2D_FigureH, 'Style', 'text', 'String', 'Min C', ...
%                                    'HorizontalAlignment', 'left', 'Units', 'Normalized', 'Position', [0.88 0.9 0.05 0.04], 'FontSize', 10);
% mhHandles.minC_Edit   = uicontrol('Style', 'edit', 'Parent', MetaHist_FRET2D_FigureH, 'Units', 'normalized', 'Position', [0.88, 0.04, 0.04, 0.05], ...
%                                    'Tag', 'minC_Edit', 'FontSize', 10, 'String', num2str(handles.Conc_minRange), ...
%                                    'Callback',{@minC_Edit_Callback, hObject});
% mhHandles.maxC_Text   = uicontrol('Parent', MetaHist_FRET2D_FigureH, 'Style', 'text', 'String', 'Max C', ...
%                                    'HorizontalAlignment', 'left', 'Units', 'Normalized', 'Position', [0.94 0.9 0.05 0.04], 'FontSize', 10);
% mhHandles.maxC_Edit   = uicontrol('Style', 'edit', 'Parent', MetaHist_FRET2D_FigureH, 'Units', 'normalized', 'Position', [0.94, 0.04, 0.04, 0.05], ...
%                                    'Tag', 'maxC_Edit', 'FontSize', 10, 'String', num2str(handles.Conc_maxRange), ...
%                                    'Callback',{@maxC_Edit_Callback, hObject});
% 
% mhHandles.Meta_Hist_ToolBar = uitoolbar(MetaHist_FRET2D_FigureH);
% mhHandles.Snapshot_Icon     = uipushtool(mhHandles.Meta_Hist_ToolBar,'TooltipString','Snapshot', ...
%                                           'ClickedCallback', {@Snapshot_Icon_Callback, handles});
% [cdata,~]                    = imread('.\Icons\Snapshot_2_16x16.png');
% mhHandles.Snapshot_Icon.CData = cdata;
% 
% mhHandles.Save_MH_Data_Icon = uipushtool(mhHandles.Meta_Hist_ToolBar,'TooltipString','Save Meta-Histogram Data', ...
%                                          'ClickedCallback', {@Save_MH_Data_Icon_Callback, hObject});
% [cdata,~]                    = imread('.\Icons\file_save.png');
% mhHandles.Save_MH_Data_Icon.CData = cdata;
% 
% guidata(MetaHist_FRET2D_FigureH, mhHandles);
% 
% function Snapshot_Icon_Callback(hObject, eventdata, handles)
% if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
% else mwHandles = [];
% end
% 
% if isempty(mwHandles), [Name, Path] = uiputfile([handles.Ana_Path '\Snapshot.png'], 'Save Snapshot'); 
% else [Name, Path] = uiputfile([mwHandles.Ana_Path '\Snapshot.png'], 'Save Snapshot');
% end
% % Axes_Frame = getframe(handles.Meta_Hist_2D_FRET_AxesH);
% % Axes_Image = frame2im(Axes_Frame);
% % imwrite(Axes_Image, [Path '\' Name]);
% export_fig([Path '\' Name], '-png', handles.Meta_Hist_2D_FRET_FigureH);
% 
% function Save_MH_Data_Icon_Callback(hObject, eventdata, FRET_FigureH)
% handles   = guidata(FRET_FigureH);
% 
% tpltPath  = '.\Templates\';
% [tpltName, tpltPath] = uigetfile([tpltPath '*.xlsx'], 'Load a Template');
% 
% Time_Stamp        = datestr(now,'ddmmyyyy HHMMSS');
% Name              = [num2str(Time_Stamp) '_MetaHistogram'];
% if ~isfield(handles, 'Ana_Path'), curr_Path = '.\'; elseif isempty(handles.curr_Path), curr_Path = '.\'; else curr_Path = handles.curr_Path; end;
% [Name, curr_Path] = uiputfile([curr_Path '\*.xlsx'], 'Save Data to', [curr_Path '\' Name]);
% fName1            = [curr_Path '\' Name];
% copyfile([tpltPath tpltName],fName1);
% mhSheet_Name      = 'Meta_Hist';
% MetaHist_Data     = [handles.Eapp_Val,handles.Eapp_Hist_2D];
% xlswrite(fName1, MetaHist_Data, mhSheet_Name, 'C4');
% 
% function minC_sBar_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
% handles   = guidata(FRET_ToolKet_FigureH);
% mhHandles = guidata(hObject);
% 
% handles.Conc_minRange = double(get(hObject, 'Value'));
% if handles.Conc_minRange > handles.Conc_maxRange
%     handles.Conc_maxRange = handles.Conc_minRange;
%     set(mhHandles.maxC_Slider, 'Value', handles.Conc_maxRange);
%     set(mhHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));
% end
% handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
% set(mhHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));
% 
% [handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack');
% set(mhHandles.MetaHist_FRET2D_CurveH, 'YData', handles.Eapp_Hist_2D);
% 
% guidata(FRET_ToolKet_FigureH, handles);
% guidata(hObject, mhHandles);
% 
% function minC_Edit_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
% handles   = guidata(FRET_ToolKet_FigureH);
% mhHandles = guidata(hObject);
% 
% handles.Conc_minRange = str2double(get(hObject, 'String'));
% if handles.Conc_minRange > handles.Conc_maxRange
%     handles.Conc_maxRange = handles.Conc_minRange;
%     set(mhHandles.maxC_Slider, 'Value', handles.Conc_maxRange);
%     set(mhHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));
% end
% handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
% set(mhHandles.minC_Slider, 'Value', handles.Conc_minRange);
% 
% [handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack');
% set(mhHandles.MetaHist_FRET2D_CurveH, 'YData', handles.Eapp_Hist_2D);
% 
% guidata(FRET_ToolKet_FigureH, handles);
% guidata(hObject, mhHandles);
% 
% function maxC_sBar_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
% handles   = guidata(FRET_ToolKet_FigureH);
% mhHandles = guidata(hObject);
% 
% handles.Conc_maxRange = double(get(hObject, 'Value'));
% if handles.Conc_minRange > handles.Conc_maxRange
%     handles.Conc_minRange = handles.Conc_maxRange;
%     set(mhHandles.minC_Slider, 'Value', handles.Conc_minRange);
%     set(mhHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));
% end
% handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
% set(mhHandles.maxC_Edit, 'String', num2str(handles.Conc_maxRange));
% 
% [handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack');
% set(mhHandles.MetaHist_FRET2D_CurveH, 'YData', handles.Eapp_Hist_2D);
% 
% guidata(FRET_ToolKet_FigureH, handles);
% guidata(hObject, mhHandles);
% 
% function maxC_Edit_Callback(hObject, eventdata, FRET_ToolKet_FigureH)
% handles   = guidata(FRET_ToolKet_FigureH);
% mhHandles = guidata(hObject);
% 
% handles.Conc_maxRange = str2double(get(hObject, 'String'));
% if handles.Conc_minRange > handles.Conc_maxRange
%     handles.Conc_minRange = handles.Conc_maxRange;
%     set(mhHandles.minC_Slider, 'Value', handles.Conc_minRange);
%     set(mhHandles.minC_Edit, 'String', num2str(handles.Conc_minRange));
% end
% handles.Conc_BinSize  = (handles.Conc_maxRange - handles.Conc_minRange)*2;
% set(mhHandles.maxC_Slider, 'Value', handles.Conc_maxRange);
% 
% [handles, ~] = Calculate_Eapp_Conc_2D_Hist(handles, 'Stack');
% set(mhHandles.MetaHist_FRET2D_CurveH, 'YData', handles.Eapp_Hist_2D);
% 
% guidata(FRET_ToolKet_FigureH, handles);
% guidata(hObject, mhHandles);