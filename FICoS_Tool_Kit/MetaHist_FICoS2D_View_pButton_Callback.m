function MetaHist_FICoS2D_View_pButton_Callback(hObject, eventdata)

handles = guidata(hObject);

mwHandles = guidata(handles.mwFigureH);
% handles.Calc_2D_FICoS_Switch = 2;
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    handles = MetaHist_FICoS2D_View_FNC(handles);
else
    handles = MetaHist_FRET2D_View_FNC(handles);
end
guidata(hObject, handles);

% if length(handles.Conc_Val) > 2
%     hFigure     = Plot_Window_Generic ('Volcano Graph', hObject);
%     handles.hAxes = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.8, 0.84]);
%     
%     % Norm_Factor = max(max(handles.Capp_Hist_2D(1:end-1,:)));
%     Hist3D     = handles.Capp_Hist_2D;  %/Norm_Factor;
%     Conc_lBins = [handles.Conc_Val(1):round((handles.Conc_Val(end-1)-handles.Conc_Val(1))/5,1):handles.Conc_Val(end-1)] + handles.Conc_BinSize/2;
%     Capp_lBins = [handles.Capp_minRange:(handles.Capp_maxRange-handles.Capp_minRange)/5:handles.Capp_maxRange];
%     
%     % surf(handles.Conc_Val(1:end-1)+handles.Conc_BinSize/2, handles.Capp_Val(1:end-1), 10*(log10(Hist3D+0.99)-log10(0.99)), 'EdgeColor','none', ...
%     %                            'LineStyle','none', 'FaceLighting','phong', 'FaceLighting','gouraud', 'FaceColor','interp', 'AmbientStrength',0.5);
%     surf(handles.Conc_Val(1:end-1)+handles.Conc_BinSize/2, handles.Capp_Val, Hist3D, 'EdgeColor','none', ...
%                                'LineStyle','none', 'FaceLighting','phong', 'FaceLighting','gouraud', 'FaceColor','interp', 'AmbientStrength',0.5);
%     xlim([handles.Conc_Val(1) handles.Conc_Val(end-1)] + handles.Conc_BinSize/2);
%     ylim([handles.Capp_minRange handles.Capp_maxRange]);
%     set(handles.hAxes, 'YTick',Capp_lBins, 'XTick',Conc_lBins, 'FontSize',24); % , 'YDir','reverse'  
%     az = 73; el = 50; view(handles.hAxes, az, el);
%     colormap jet; material Shiny;
% 
%     % xLbl = get(handles.hAxes, 'xlabel'); yLbl = get(handles.hAxes, 'ylabel'); zLbl = get(handles.hAxes, 'zlabel');
%     % set(xLbl,'String', 'C_M [Pr./Pixel]', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 12.5, ...
%     %     'Position', [Conc_lBins(end)/2, (Capp_lBins(1)-Capp_lBins(2))*8.5/5, 0]);
%     % set(yLbl,'String', ['E_a_p_p'], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', -50, ...
%     %     'Position', [(Conc_lBins(1)-Conc_lBins(2))*6/5, Capp_lBins(end)/3, 0]);
%     % set(zLbl,'String', 'Frequency', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
%     %     'Position', [(Conc_lBins(1)-Conc_lBins(2))*4/5, Capp_lBins(end), ceil(max(Hist3D(:)))*cos(el/180*pi)]);
% end
% 
% [handles, ~] = Calculate_Capp_Conc_2D_Hist(handles, 'Stack');
% guidata(hObject, handles);
% 
% Capp_lBins    = [handles.Capp_minRange:(handles.Capp_maxRange-handles.Capp_minRange)/5:handles.Capp_maxRange];
% 
% Hist3D        = handles.Capp_Hist_2D;
% if length(handles.Conc_Val) > 2
%     hFigure       = Plot_Window_Generic ('Wire Stack', hObject);
%     handles.hAxes = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.8, 0.84]); hold on;
%     Norm_Factor = max(max(handles.Capp_Hist_2D));
%     Hist3D      = Hist3D/Norm_Factor;
%     for ii = 1:size(Hist3D,2)
%         zPos = ii-1;
%         plot3(zeros(length(handles.Capp_Val),1), handles.Capp_Val, Hist3D(:,ii) + zPos, 'LineWidth', 1);
%         text(0, handles.Capp_Val(end)-0.25, zPos + 0.5, ['C_M = ' num2str(handles.Conc_Val(ii) + handles.Conc_BinSize/2)]);
%     end;
%     set(handles.hAxes, 'YTick',Capp_lBins, 'FontSize',24, 'YDir','reverse', 'ZTick', [0:size(Hist3D,2)-1]);
%     view(handles.hAxes,-90,0);
%     colormap jet;
% 
%     ylim ([Capp_lBins(1) Capp_lBins(end)]); zlim ([0 size(Hist3D,2)]);
% 
%     pbaspect([1 1 1.25]);
%     g_y=[Capp_lBins(1):round(Capp_lBins(end)/10, 1):Capp_lBins(end)]; % user defined grid Y [start:spaces:end]
%     g_z=[0:size(Hist3D,2)]; % user defined grid Y [start:spaces:end]
%     for i=2:length(g_y)
%        plot3([0 0], [g_y(i) g_y(i)], [g_z(1) g_z(end)],'k:') %x grid lines
%        hold on    
%     end
%     for i=2:length(g_z)
%        plot3([0 0], [g_y(1) g_y(end)], [g_z(i) g_z(i)],'k:') %x grid lines
%        hold on    
%     end
% else
%     Plot_Conc_Dependent_MetaHist(hObject);
% %     plot(handles.Capp_Val, Hist3D, 'LineWidth', 1);
% %     set(handles.hAxes, 'XTick',Capp_lBins, 'FontSize',24);
% end


% guidata(hObject, handles);