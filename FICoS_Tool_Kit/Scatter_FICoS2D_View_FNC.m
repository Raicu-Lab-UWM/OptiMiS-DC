function handles = Scatter_FICoS2D_View_FNC(handles)

[handles, ~]  = Calculate_Capp_Conc_2D_Hist(handles, 'Scatter'); guidata(handles.output, handles);
guidata(handles.output, handles);

hFigure       = Plot_Window_Generic ('Capp vs xA', handles.output);
handles.hAxes = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.78, 0.84]);

plot(handles.hAxes, handles.Scatter_Plot_Info(:,1), handles.Scatter_Plot_Info(:,2), 'b.');
ylim([-1 1]); xlim([handles.Conc_Val(1) handles.Conc_Val(end)] + handles.Conc_BinSize/2); % xlim([minC maxC]);
set(handles.hAxes, 'YTick',-1:0.5:1, 'XTick',handles.Conc_Val(1):round((handles.Conc_Val(end)-handles.Conc_Val(1))/5,1):handles.Conc_Val(end), ...
    'FontSize',24);
grid(handles.hAxes, 'on');