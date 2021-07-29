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
function Remve_Poly_fromList_Icon_ClickedCallback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), Polygon_Name = {handles.Polygon_List(handles.Current_Polygon_Index).Name}; else Polygon_Name = {mwHandles.Polygon_List(mwHandles.Current_Polygon_Index).Name}; end

Tree         = [];
if isfield(mwHandles, 'FIF_Tree')
    if ~isempty(mwHandles.FIF_Tree)
        Tree = mwHandles.FIF_Tree.Tree;
    end
end
if isfield(mwHandles, 'Image_List')
    if ~mwHandles.Image_List.isEmpty
        mwHandles.Image_List = mwHandles.Image_List.Rem_ployName_fromImage(Tree, Polygon_Name);
        guidata(handles.mwFigureH, mwHandles);
    end
end

if isempty(mwHandles), Polygon_List = handles.Polygon_List(handles.Current_Polygon_Index); else Polygon_List = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index); end
if ~isempty([Polygon_List.Poly_PlotH])
    if isvalid([Polygon_List.Poly_PlotH])
        delete([Polygon_List.Poly_PlotH]);
    end;
end;
if ~isempty([Polygon_List.Title_PrintH])
    if isvalid([Polygon_List.Title_PrintH])
        delete([Polygon_List.Title_PrintH]);
    end;
end;

if isempty(mwHandles)
    handles.Polygon_List  = handles.Polygon_List.Remove_Polygon_fromList(Polygon_Name);
    handles.Segment_List  = handles.Segment_List.Remove_Segment_fromList(Polygon_Name);
    handles.Current_Polygon_Index = max([min(handles.Current_Polygon_Index)-1,1]);
    Current_Polygon_Index = handles.Current_Polygon_Index;
    set(handles.Polygon_List_ListBox, 'String', {handles.Polygon_List.Name}, 'Value', Current_Polygon_Index);
else
    mwHandles.Polygon_List = mwHandles.Polygon_List.Remove_Polygon_fromList(Polygon_Name);
    mwHandles.Segment_List = mwHandles.Segment_List.Remove_Segment_fromList(Polygon_Name);
    mwHandles.Current_Polygon_Index = max([min(mwHandles.Current_Polygon_Index)-1,1]);
    Current_Polygon_Index  = mwHandles.Current_Polygon_Index;
    set(handles.Polygon_List_ListBox, 'String', {mwHandles.Polygon_List.Name}, 'Value', Current_Polygon_Index);
end


if isfield(mwHandles, 'Image_List')
    if ~mwHandles.Image_List.isEmpty
        if ~isempty(Tree)
            [Selected_Image, ~] = mwHandles.Image_List.findImage_Brunch(Tree);
            iList               = mwHandles.Current_Polygon_Index;
            if iList > length(Selected_Image.ROI_List)
                iList = length(Selected_Image.ROI_List);
            end
            set(handles.Polygon_List_ListBox, 'String', Selected_Image.ROI_List, 'Value', iList);
        end
    end
end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(hObject, handles);