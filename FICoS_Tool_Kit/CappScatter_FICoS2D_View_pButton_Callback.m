function CappScatter_FICoS2D_View_pButton_Callback (hObject, eventdata)
handles   = guidata(hObject);

mwHandles = guidata(handles.mwFigureH);
% handles.Calc_2D_FICoS_Switch = 2;
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    handles = Scatter_FICoS2D_View_FNC(handles);
else
    handles = Scatter_FRET2D_View_FNC(handles);
end
guidata(hObject, handles);


% [handles, ~]   = Calculate_Capp_Conc_2D_Hist(handles, 'Scatter'); guidata(hObject, handles);
% guidata(hObject, handles);
% 
% hFigure        = Plot_Window_Generic ('Capp vs xA', hObject);
% handles.hAxes  = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.78, 0.84]);
% 
% plot3(handles.hAxes, handles.Scatter_Plot_Info(:,1), handles.Scatter_Plot_Info(:,2), round(handles.Scatter_Plot_Info(:,4), 2), 'b.');
% ylim([0 1]); zlim([0 1]); xlim([handles.Conc_Val(1) handles.Conc_Val(end)] + handles.Conc_BinSize/2); % xlim([minC maxC]);
% % set(get(handles.hAxes, 'xlabel'),'String', 'D + A [Proto./ Pixel]');
% % set(get(handles.hAxes, 'ylabel'),'String', 'xA');
% % set(get(handles.hAxes, 'zlabel'),'String', 'E_a_p_p');
% % set(handles.hAxes, 'YTick',0:0.2:1, 'XTick',minC:round((maxC-minC)/5,-1):maxC, 'ZTick',0:0.2:1, 'FontSize',24);
% set(handles.hAxes, 'YTick',0:0.2:1, 'XTick',handles.Conc_Val(1):round((handles.Conc_Val(end)-handles.Conc_Val(1))/5,1):handles.Conc_Val(end), ...
%     'ZTick',0:0.2:1, 'FontSize',24);
% grid(handles.hAxes, 'on');
% az = 73; el = 50; view(handles.hAxes, az, el); % view(handles.hAxes,[90,0]);
% 
% if length(handles.Conc_Val) > 2
%     Plot_Capp_vsXA_Conc(hObject);
% else
%     handles.xA_Bin = 0.05; guidata(hObject, handles);
%     Plot_Conc_Dependent_Graph(hObject, 'Capp vs xA')
% end
% % Plot_Capp_vsXA(hObject);