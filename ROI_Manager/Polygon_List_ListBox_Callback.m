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
function handles = Polygon_List_ListBox_Callback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

hFigure     = get(handles.Polygon_List_ListBox,'Parent');    
Mouse_Click = get(hFigure,'selectiontype');
Modifier    = get(hFigure, 'CurrentModifier');
    
contents       = cellstr(get(hObject,'String'));
Polygons_Names = contents(get(hObject,'Value'));
iSelected      = 1;
if isempty(mwHandles), Polygon_List = handles.Polygon_List; else Polygon_List = mwHandles.Polygon_List; end
Current_Polygon_Index = [];
for ii = 1:length(Polygons_Names)
    [~, Found_Index] = Polygon_List.findROI('Polygon_Name', Polygons_Names{ii});
    if ~isempty(Found_Index), Current_Polygon_Index(iSelected) = Found_Index; end
    iSelected = iSelected + 1;
end
if ~isempty(Current_Polygon_Index)
    handles.Image_Frame_Index = Polygon_List(Current_Polygon_Index(1)).Image_Frame_Index;
    if handles.Image_Frame_Index == 0, handles.Image_Frame_Index = 1; end;
    if handles.Image_Frame_Index > length(handles.FOV_List), handles.Image_Frame_Index = length(handles.FOV_List); end;
    if ~isempty(handles.Image_Frame_Index)
        if isvalid(handles.FOV_hImage)
            set(handles.FOV_hImage, 'CData', handles.FOV_List(uint16(handles.Image_Frame_Index)).raw_Data);
            Image_Stack_sBar =  findobj('Tag', 'Image_Stack_sBar');
            set(Image_Stack_sBar, 'Value', handles.Image_Frame_Index);
        end;
    end;
    
    if isfield(handles, 'handSegment'), delete(handles.handSegment); end;
    guidata(hObject, handles);

    switch Mouse_Click
    case 'open'
        pause(0.01); % very important in order to saparate the double click from the single click
        if strcmp(Mouse_Click,'open')
            if numel(Current_Polygon_Index) == 1
                handles = ROI_Prop_Editor_Window(hObject);
            end;
        end;
    case 'normal'
        ROI_List_Names = {Polygon_List.Name};
        if isfield(mwHandles, 'FIF_Tree')
            if ~isempty(mwHandles.FIF_Tree)
                if ~isfield(mwHandles, 'Image_List'), Image_List = []; else Image_List = mwHandles.Image_List; end
                ROI_List_Names = mwHandles.FIF_Tree.retrieveROI_List(Image_List);
            end
        end
        nROIs = length(ROI_List_Names);
        for ii = 1:nROIs
            [~, iROI] = Polygon_List.findROI('Polygon_Name', ROI_List_Names{ii});
            iFrame    = Polygon_List(iROI).Image_Frame_Index; if iFrame == 0, iFrame = 1; end;
            if iFrame > length(handles.FOV_List), iFrame = length(handles.FOV_List); end;
            if isempty(mwHandles)
                if handles.Show_All_Poly && handles.Image_Frame_Index == iFrame
                    set(handles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'on'); set(handles.Polygon_List(iROI).Title_PrintH, 'Visible', 'on');
                else
                    set(handles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'off'); set(handles.Polygon_List(iROI).Title_PrintH, 'Visible', 'off');                    
                end
            else
                if handles.Show_All_Poly && handles.Image_Frame_Index == iFrame
                    set(mwHandles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'on'); set(mwHandles.Polygon_List(iROI).Title_PrintH, 'Visible', 'on');
                else
                    set(mwHandles.Polygon_List(iROI).Poly_PlotH, 'Visible', 'off'); set(mwHandles.Polygon_List(iROI).Title_PrintH, 'Visible', 'off');                    
                end
            end
        end

        if ~isempty(Modifier), Key_Pressed = Modifier{1}; else Key_Pressed = 'no Key'; end;

        if isfield(handles, 'ImPoly_figHand')
            if isvalid(handles.ImPoly_figHand)
                if ~strcmp(Key_Pressed,'no Key')
                    if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end;
                    guidata(hObject, handles); 
                    Show_ROI_Polygons(hObject, [], Current_Polygon_Index); handles = guidata(hObject);
                    if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); end; end
                elseif handles.Show_Segments
                    Polygon_Selected = Polygon_List(Current_Polygon_Index);
                    if isempty(mwHandles), Segment_List = handles.Segment_List; else Segment_List = mwHandles.Segment_List; end
                    [Segment_Item, Found_Segment_Index] = Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon_Selected.Name);
                    if ~isempty(Found_Segment_Index)
                        currSegment_Obj = Segment_Item;
                        Segments_ROIs   = currSegment_Obj.Polygons;
                        nSegments_ROIs  = length(Segments_ROIs);
                        for ii = 1:nSegments_ROIs
                            curPoly = currSegment_Obj.Polygons{ii};
                            hold(handles.Image_Stack_Axes ,'on'); handles.handSegment(ii) = plot(handles.Image_Stack_Axes, curPoly(:,1),curPoly(:,2),'r','LineWidth', 1);
                            if isempty(mwHandles), handles.currPolygon_Coords{ii} = curPoly; else mwHandles.currPolygon_Coords{ii} = curPoly; end
                        end;
                    end;
                end;
            end;
        end
    otherwise
    end;
end;
if isempty(mwHandles), handles.Current_Polygon_Index = Current_Polygon_Index; else mwHandles.Current_Polygon_Index = Current_Polygon_Index; end

set(hObject, 'Enable', 'off');
drawnow;
set(hObject, 'Enable', 'on');
if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);