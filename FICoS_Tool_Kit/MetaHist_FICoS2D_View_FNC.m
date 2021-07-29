function handles = MetaHist_FICoS2D_View_FNC(handles)
 
handles = Calculate_Capp_Conc_2D_Hist(handles, 'Surf');

if length(handles.Conc_Val) > 2
    hFigure     = Plot_Window_Generic ('Volcano Graph', handles.output);
    handles.hAxes = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.8, 0.84]);
    
    Hist3D     = handles.Capp_Hist_2D;
    Conc_lBins = [handles.Conc_Val(1):round((handles.Conc_Val(end-1)-handles.Conc_Val(1))/5,1):handles.Conc_Val(end-1)] + handles.Conc_BinSize/2;
    Capp_lBins = [handles.Capp_minRange:(handles.Capp_maxRange-handles.Capp_minRange)/5:handles.Capp_maxRange];
    
    surf(handles.Conc_Val(1:end-1)+handles.Conc_BinSize/2, handles.Capp_Val, Hist3D, 'EdgeColor','none', ...
                               'LineStyle','none', 'FaceLighting','phong', 'FaceLighting','gouraud', 'FaceColor','interp', 'AmbientStrength',0.5);
    xlim([handles.Conc_Val(1) handles.Conc_Val(end-1)] + handles.Conc_BinSize/2);
    ylim([handles.Capp_minRange handles.Capp_maxRange]);
    set(handles.hAxes, 'YTick',Capp_lBins, 'XTick',Conc_lBins, 'FontSize',24); % , 'YDir','reverse'  
    az = 73; el = 50; view(handles.hAxes, az, el);
    colormap jet; material Shiny;
end

[handles, ~] = Calculate_Capp_Conc_2D_Hist(handles, 'Stack');
guidata(handles.output, handles);

Capp_lBins    = [handles.Capp_minRange:(handles.Capp_maxRange-handles.Capp_minRange)/5:handles.Capp_maxRange];

Hist3D        = handles.Capp_Hist_2D;
if length(handles.Conc_Val) > 2
    hFigure       = Plot_Window_Generic ('Wire Stack', handles.output);
    handles.hAxes = axes('Parent', hFigure, 'Position',[0.1, 0.12, 0.8, 0.84]); hold on;
    Norm_Factor = max(max(handles.Capp_Hist_2D));
    Hist3D      = Hist3D/Norm_Factor;
    for ii = 1:size(Hist3D,2)
        zPos = ii-1;
        plot3(zeros(length(handles.Capp_Val),1), handles.Capp_Val, Hist3D(:,ii) + zPos, 'LineWidth', 1);
        text(0, handles.Capp_Val(end)-0.25, zPos + 0.5, ['C_M = ' num2str(handles.Conc_Val(ii) + handles.Conc_BinSize/2)]);
    end;
    set(handles.hAxes, 'YTick',Capp_lBins, 'FontSize',24, 'YDir','reverse', 'ZTick', [0:size(Hist3D,2)-1]);
    view(handles.hAxes,-90,0);
    colormap jet;

    ylim ([Capp_lBins(1) Capp_lBins(end)]); zlim ([0 size(Hist3D,2)]);

    pbaspect([1 1 1.25]);
    g_y=[Capp_lBins(1):round(Capp_lBins(end)/10, 1):Capp_lBins(end)]; % user defined grid Y [start:spaces:end]
    g_z=[0:size(Hist3D,2)]; % user defined grid Y [start:spaces:end]
    for i=2:length(g_y)
       plot3([0 0], [g_y(i) g_y(i)], [g_z(1) g_z(end)],'k:') %x grid lines
       hold on    
    end
    for i=2:length(g_z)
       plot3([0 0], [g_y(1) g_y(end)], [g_z(i) g_z(i)],'k:') %x grid lines
       hold on    
    end
else
    Plot_Conc_Dependent_MetaHist(handles.output);
end

guidata(handles.output, handles);