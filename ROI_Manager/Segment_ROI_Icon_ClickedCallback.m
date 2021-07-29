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
function Segment_ROI_Icon_ClickedCallback(hObject, eventdata, handles)

if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end
else mwHandles = [];
end

if isempty(mwHandles)
    Polygon_List    = handles.Polygon_List;
    Polygon_Type    = handles.Polygon_Type;
    Seg_Split_Value = handles.Seg_Split_Value;
    Segment_List    = handles.Segment_List;
    if isfield(handles, 'Find_Cells'), Find_Cells = handles.Find_Cells; else Find_Cells = false; end
else
    Polygon_List    = mwHandles.Polygon_List;
    Polygon_Type    = mwHandles.Polygon_Type;
    Seg_Split_Value = mwHandles.Seg_Split_Value;
    Segment_List    = mwHandles.Segment_List;
    if isfield(mwHandles, 'Find_Cells'), Find_Cells = mwHandles.Find_Cells; else Find_Cells = false; end
end

if isfield(mwHandles, 'FIF_Tree')
    Sample_Name = mwHandles.FIF_Tree.getSample_Brunch_Name;
else Sample_Name = [];
end
if Polygon_List.isEmpty
    [Polygon_List, Current_Polygon_Index] = Polygon_List.autoSelect_ROI(handles.FOV_List, Polygon_Type, Sample_Name, Seg_Split_Value, handles.Image_Stack_Axes, Find_Cells);
    set(handles.Polygon_List_ListBox, 'String', {Polygon_List.Name}, 'Value', length(Polygon_List));
    if isfield(mwHandles, 'Image_List'),
        if ~mwHandles.Image_List.isEmpty
            mwHandles.Image_List = mwHandles.Image_List.Add_ployName_toImage(mwHandles.FIF_Tree.Tree, {Polygon_List.Name});
        end
    end
    for ii = 1:length(Current_Polygon_Index)
        set(Polygon_List(Current_Polygon_Index(ii)).Poly_PlotH, 'Visible', 'off');
        set(Polygon_List(Current_Polygon_Index(ii)).Title_PrintH, 'Visible', 'off');
    end
    if handles.Show_All_Poly
        All_ROI_Frames    = {Polygon_List.Image_Frame_Index};
        ROI_subList_Index = find(cellfun(@(x) isequal(x, handles.Image_Frame_Index), All_ROI_Frames));
        for ii = 1:length(ROI_subList_Index)
            set(Polygon_List(ROI_subList_Index(ii)).Poly_PlotH, 'Visible', 'on');
            set(Polygon_List(ROI_subList_Index(ii)).Title_PrintH, 'Visible', 'on');
        end
    end
else
    if isempty(mwHandles), Current_Polygon_Index = handles.Current_Polygon_Index; else Current_Polygon_Index = mwHandles.Current_Polygon_Index; end
end

Polygon_Segment      = Polygon_List(Current_Polygon_Index);
Remove_Polygon_Index = [];
h = waitbar(0, 'Segmentation in Process...');
for ii = 1:length(Polygon_Segment)
    currMaster_Poly = Polygon_Segment(ii);
    Image_          = handles.FOV_List(handles.Image_Frame_Index).raw_Data;
    if isempty(currMaster_Poly.Mask)
        currMaster_Poly.Mask = poly2mask(currMaster_Poly.Coordinates(:,1), currMaster_Poly.Coordinates(:,2), size(Image_,1), size(Image_,2));
        Polygon_List(Current_Polygon_Index(ii)).Mask = currMaster_Poly.Mask;
    end;
    Segment_List     = Segment_List.Add_Segment_toList(Polygon_Segment(ii), [], handles);
    [currSegment, ~] = Segment_List.Segment_MasterPoly_Query('Master_Polygon', Segment_List.Master_Polygon);
    Labeled_Image    = currSegment.Labeled_Image;
    if sum(Labeled_Image(:)) == 0
        f = warndlg(['ROI - ' Polygon_Segment(ii).Name 'is too small. The ROI will be removed from the list'],'Warning');
        Remove_Polygon_Index = [Remove_Polygon_Index; ii, Current_Polygon_Index(ii)];
    end;
    waitbar(ii/length(Polygon_Segment), h);
end;
close(h);
if ~isempty(Remove_Polygon_Index)
    handles.Current_Polygon_Index = Remove_Polygon_Index(:,2);
    guidata(hObject, handles); Remve_Poly_fromList_Icon_ClickedCallback(hObject, eventdata, handles); handles = guidata(hObject);
    Current_Polygon_Index(Remove_Polygon_Index(:,1)) = [];
end;

if isempty(mwHandles),
    handles.Polygon_List          = Polygon_List;
    handles.Segment_List          = Segment_List;
    handles.Current_Polygon_Index = Current_Polygon_Index;
else
    mwHandles.Polygon_List          = Polygon_List;
    mwHandles.Segment_List          = Segment_List;
    mwHandles.Current_Polygon_Index = Current_Polygon_Index;
end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);