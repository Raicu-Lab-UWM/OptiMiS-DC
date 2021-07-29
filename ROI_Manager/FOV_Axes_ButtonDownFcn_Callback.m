%

%------------------------------------------------------------------------

% Copyright (C) 2018  Raicu Lab.
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as
%     published by the Free Software Foundation, either version 3 of the
%     License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.
% 
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%------------------------------------------------------------------------------
% Writen By: Gabriel Biener, PhD 
% Advisor and Group Leader: Prof. Valerica Raicu
% For technical questions contact biener@uwm.edu
%------------------------------------------------------------------------------
function FOV_Axes_ButtonDownFcn_Callback(hObject, eventdata, Main_FigH)

handles   = guidata(Main_FigH);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

Tree           = [];
Sample_Name    = [];

if ~isempty(mwHandles)
    ROI_List_Names    = {mwHandles.Polygon_List.Name};
    All_Polygon_Names = {mwHandles.Polygon_List.Name};
    if isfield(mwHandles, 'FIF_Tree')
        if ~isempty(mwHandles.FIF_Tree)
            Tree = mwHandles.FIF_Tree.Tree;
            if ~isfield(mwHandles, 'Image_List'), Image_List = []; else Image_List = mwHandles.Image_List; end
            ROI_List_Names = mwHandles.FIF_Tree.retrieveROI_List(Image_List);
            Sample_Name    = mwHandles.FIF_Tree.getSample_Brunch_Name;
        end
    end
else
    ROI_List_Names    = {handles.Polygon_List.Name};
    All_Polygon_Names = {handles.Polygon_List.Name};
end
iPolygons         = cellfun(@(x) strcmp(x, All_Polygon_Names), ROI_List_Names, 'UniformOutput', false);
iPolygons         = cell2mat(cellfun(@(x) find(x), iPolygons, 'UniformOutput', false));
if isempty(mwHandles), Polygon_List = handles.Polygon_List(iPolygons); else Polygon_List = mwHandles.Polygon_List(iPolygons); end

if ~handles.Show_All_Poly
    for ii = 1:length(Polygon_List)
        set(Polygon_List(ii).Poly_PlotH, 'Visible', 'off');
        set(Polygon_List(ii).Title_PrintH, 'Visible', 'off');
    end
else
    All_ROI_Frames    = {Polygon_List.Image_Frame_Index};
    ROI_subList_Index = find(cellfun(@(x) isequal(x, handles.Image_Frame_Index), All_ROI_Frames));
    for ii = 1:length(ROI_subList_Index)
        set(Polygon_List(ROI_subList_Index(ii)).Poly_PlotH, 'Visible', 'on');
        set(Polygon_List(ROI_subList_Index(ii)).Title_PrintH, 'Visible', 'on');
    end
end;
Image_Drawn  = [handles.FOV_List(uint16(handles.Image_Frame_Index)).Path '\' handles.FOV_List(uint16(handles.Image_Frame_Index)).Name];
if isempty(mwHandles), Polygon_Type = handles.Polygon_Type; else Polygon_Type = mwHandles.Polygon_Type; end
Polygon_Prop = struct('Circle_Mode',       'Polygon',                 ...
                      'Polygon_Type',      Polygon_Type,      ...
                      'Images_Related',    [],                        ...
                      'Image_Drawn',       Image_Drawn,               ...
                      'Image_Frame_Index', handles.Image_Frame_Index, ...
                      'Sample_Name',       Sample_Name);
if handles.Draw_Polygon_On
    if isfield(handles, 'handSegment'), delete(handles.handSegment); end;
    Poly_Hand      = impoly(handles.Image_Stack_Axes); 
    api            = iptgetapi(Poly_Hand); 
    Polygon_Coords = api.getPosition(); 
    delete(Poly_Hand);
    Polygon_Coords = [Polygon_Coords;Polygon_Coords(1,:)];
    if isempty(mwHandles)
        handles.currPolygon_Coords      = {Polygon_Coords};
        [handles.Polygon_List, Polygon_Index] = handles.Polygon_List.Add_Polygon_toList(handles.currPolygon_Coords{1}, Polygon_Prop);
        Image_                          = handles.FOV_List(uint16(handles.Image_Frame_Index)).raw_Data;
        handles.Polygon_List(Polygon_Index).Mask         = poly2mask(Polygon_Coords(:,1), Polygon_Coords(:,2), size(Image_,1), size(Image_,2));
        handles.Polygon_List(Polygon_Index).Poly_PlotH   = handles.Polygon_List(Polygon_Index).Draw_aPolygon(handles.Image_Stack_Axes);
        handles.Polygon_List(Polygon_Index).Title_PrintH = handles.Polygon_List(Polygon_Index).Plot_Poly_Label(handles.Image_Stack_Axes);
        Polygon_List(end+1)             = handles.Polygon_List(Polygon_Index);
    else
        mwHandles.currPolygon_Coords      = {Polygon_Coords};
        [mwHandles.Polygon_List, Polygon_Index] = mwHandles.Polygon_List.Add_Polygon_toList(mwHandles.currPolygon_Coords{1}, Polygon_Prop);
        Image_                          = handles.FOV_List(uint16(handles.Image_Frame_Index)).raw_Data;
        mwHandles.Polygon_List(Polygon_Index).Mask         = poly2mask(Polygon_Coords(:,1), Polygon_Coords(:,2), size(Image_,1), size(Image_,2));
        mwHandles.Polygon_List(Polygon_Index).Poly_PlotH   = mwHandles.Polygon_List(Polygon_Index).Draw_aPolygon(handles.Image_Stack_Axes);
        mwHandles.Polygon_List(Polygon_Index).Title_PrintH = mwHandles.Polygon_List(Polygon_Index).Plot_Poly_Label(handles.Image_Stack_Axes);
        Polygon_List(end+1)             = mwHandles.Polygon_List(Polygon_Index);
    end
    set(handles.Polygon_List_ListBox, 'String', {Polygon_List.Name}, 'Value', length(Polygon_List));
    if isfield(mwHandles, 'Image_List'), mwHandles.Image_List = mwHandles.Image_List.Add_ployName_toImage(Tree, Polygon_List(end).Name); end
end;

guidata(Main_FigH, handles);
guidata(handles.mwFigureH, mwHandles);