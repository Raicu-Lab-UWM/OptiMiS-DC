function handles = ROI_Prop_Editor_Window(ROIM_hFigure)

ROI_Prop_Editor_hFigure = figure('units','pixels', 'Tag', 'ROI_Prop_Editor_hFigure', ...
                      'position',[750 500 400 320],...
                      'Menubar','none', 'Toolbar', 'figure', ...
                      'name','ROI Property Editor',...
                      'numbertitle','off');

handles           = guidata(ROIM_hFigure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

tabgp             = uitabgroup(ROI_Prop_Editor_hFigure,'Units', 'normalized', 'Position',[0 0 1 1]);
ROI_Params_Tab    = uitab(tabgp,'Title','ROI Info');
Seg_Param_Tab     = uitab(tabgp,'Title','Segments Info');

if isempty(mwHandles), iROI     = handles.Current_Polygon_Index; else iROI     = mwHandles.Current_Polygon_Index; end
if isempty(mwHandles), curr_ROI = handles.Polygon_List(iROI);    else curr_ROI = mwHandles.Polygon_List(iROI);    end
Poly_Info_Struct  = struct('Index',       iROI,                 ...
                           'Name',        curr_ROI.Name,        ...
                           'Label',       curr_ROI.Label,       ...
                           'Image_Drawn', curr_ROI.Image_Drawn, ...
                           'Frame',       curr_ROI.Image_Frame_Index);
rowNames          = {'Index', 'Name', 'Label', 'Image Drawn', 'Frame'};
colNames          = {'Values'};
Poly_Info_Table   = struct2cell(Poly_Info_Struct);
Poly_Info_uiTable = uitable('Parent', ROI_Params_Tab, 'Data', Poly_Info_Table(1:length(rowNames),1), ...
                            'ColumnName', colNames, 'RowName', rowNames, 'Units', 'normalized', ...
                            'Position',[0 0 1 1], 'ColumnWidth', {295}, 'Tag', 'Poly_Info_uiTable', 'ColumnEditable', true, ...
                            'CellEditCallback', {@Poly_Info_uiTable_CellEditCallback, ROIM_hFigure});
jscroll           = findjobj(Poly_Info_uiTable);
rowHeaderViewport = jscroll.getComponent(4);
rowHeader         = rowHeaderViewport.getComponent(0);
height            = rowHeader.getHeight;
rowHeaderViewport.setPreferredSize(java.awt.Dimension(100,0));
rowHeader.setPreferredSize(java.awt.Dimension(100,height));
rowHeader.setSize(100,height);
rend              = rowHeader.getCellRenderer(2,0);
rend.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
end

function Poly_Info_uiTable_CellEditCallback(hObject, eventdata, ROIM_hFigure)
handles          = guidata(ROIM_hFigure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

rowNames         = {'Index', 'Name', 'Label', 'Image_Drawn', 'Frame'};
Data             = get(hObject, 'Data');
Poly_Info_Struct = cell2struct(Data, rowNames, 1);

Field_Names      = fieldnames(Poly_Info_Struct);

if isempty(mwHandles), iROI = handles.Current_Polygon_Index; else iROI = mwHandles.Current_Polygon_Index; end
if isempty(mwHandles), curr_ROI = handles.Polygon_List(iROI); else curr_ROI = mwHandles.Polygon_List(iROI); end
for ii = 1:size(Field_Names,1)
    if strcmp(Field_Names{ii},'Frame'), curr_ROI.Image_Frame_Index = Poly_Info_Struct.(Field_Names{ii});
    else curr_ROI.(Field_Names{ii}) = Poly_Info_Struct.(Field_Names{ii});
    end;
end
if isempty(mwHandles), handles.Polygon_List(iROI) = curr_ROI; else mwHandles.Polygon_List(iROI) = curr_ROI; end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(ROIM_hFigure, handles);
end