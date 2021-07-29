function handles = Scatter_FRET2D_View_FNC(handles)

[handles, ~]   = Calculate_Eapp_Conc_2D_Hist(handles, 'Scatter');
guidata(handles.output, handles);

hFigure        = Plot_Window_Generic ('Capp vs xA', handles.output);
handles.hAxes  = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.78, 0.84]);

plot3(handles.hAxes, handles.Scatter_Plot_Info(:,1), handles.Scatter_Plot_Info(:,2), round(handles.Scatter_Plot_Info(:,4), 2), 'b.');
ylim([0 1]); zlim([0 1]); xlim([handles.Conc_Val(1) handles.Conc_Val(end)] + handles.Conc_BinSize/2); % xlim([minC maxC]);
set(handles.hAxes, 'YTick',0:0.2:1, 'XTick',handles.Conc_Val(1):round((handles.Conc_Val(end)-handles.Conc_Val(1))/5,1):handles.Conc_Val(end), ...
    'ZTick',0:0.2:1, 'FontSize',24);
grid(handles.hAxes, 'on');
az = 73; el = 50; view(handles.hAxes, az, el); % view(handles.hAxes,[90,0]);

if length(handles.Conc_Val) > 2
    Plot_Eapp_vsXA_Conc(handles.output);
else
    handles.xA_Bin = 0.05; guidata(handles.output, handles);
    Plot_Conc_Dependent_Graph(handles.output, 'Capp vs xA')
end
% Plot_Capp_vsXA(handles.output);