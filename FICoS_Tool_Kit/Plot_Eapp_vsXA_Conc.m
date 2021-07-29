function Plot_Eapp_vsXA_Conc(hObject)
handles        = guidata(hObject);

binC           = handles.Conc_BinSize;
binE           = handles.Capp_BinSize;

Data_Sort      = handles.Scatter_Plot_Info;
Data_Sort(:,1) = round(Data_Sort(:,1)/binC)*binC;
Data_Sort(:,2) = round(Data_Sort(:,2)/binE)*binE;
Conc_Uniq      = handles.Conc_minRange:binC:handles.Conc_maxRange;
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
        Eapp_Map(int16((Conc_Uniq(ii)-Conc_Uniq(1))/binC)+1, int16([0:binE:1]/binE)+1) = avgEapp;
    else
        Eapp_Map(int16((Conc_Uniq(ii)-Conc_Uniq(1))/binC)+1, int16([0:binE:1]/binE)+1) = NaN*[0:binE:1];
    end
end

hFigure_Surf = Plot_Window_Generic ('Eapp vs xA and D+A', hObject);
handles.hAxes_Surf = axes('Parent', hFigure_Surf, 'Position',[0.12, 0.1, 0.79, 0.87]);
surf(0:binE:1, Conc_Uniq', Eapp_Map, 'EdgeColor','none', ...
     'LineStyle','none', 'FaceLighting','phong', 'FaceLighting','gouraud', 'FaceColor','interp', 'AmbientStrength',0.5);

ylim([Conc_Uniq(1) Conc_Uniq(end)]); xlim([0 1]);
% Conc_lBins = Conc_Uniq(1):round((Conc_Uniq(end) - Conc_Uniq(1))/5,-1):Conc_Uniq(end);
% xA_lBins   = 0:0.2:1;
% set(handles.hAxes_Surf, 'YTick',Conc_lBins, 'XTick',xA_lBins, 'FontSize',10); % , 'YDir','reverse'
az = -25; el = 50; view(handles.hAxes_Surf, az, el);
colormap jet; material Shiny;

set(get(handles.hAxes_Surf, 'ylabel'),'String', 'D + A [Proto./ Pixel]');
set(get(handles.hAxes_Surf, 'xlabel'),'String', 'xA');
set(get(handles.hAxes_Surf, 'zlabel'),'String', 'E_a_p_p');
grid(handles.hAxes_Surf, 'on');
