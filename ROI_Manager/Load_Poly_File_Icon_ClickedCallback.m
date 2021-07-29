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
function Load_Poly_File_Icon_ClickedCallback(hObject, eventdata, handles)
if isfield(handles, 'mwFigureH'), 
    if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; else StandAlone = true; end; 
else StandAlone = true;
end
if StandAlone, curr_Path = handles.curr_Path; mwHandles = [];
    Include_SubFolders = handles.Include_SubFolders;
else curr_Path = mwHandles.curr_Path;
    Include_SubFolders = mwHandles.Include_SubFolders;
end

if Include_SubFolders, [handles.FOV_List, curr_Path] = Load_From_Multiple_Folders(handles);
    if ~isempty(handles.FOV_List), guidata(hObject, handles); Init_ImageStack_Window(hObject, eventdata); handles = guidata(hObject);
        if isfield(mwHandles, 'FIF_Tree')
            if ~isempty(mwHandles.FIF_Tree), selectedNodes = mwHandles.FIF_Tree.Tree.getSelectedNodes; selectedNode  = selectedNodes(1);
                if selectedNode.getLevel == 2, Image_List = Image_O;
                    if ~mwHandles.Image_List.isEmpty, Image_List = mwHandles.Image_List; end
                    mwHandles.Image_List = mwHandles.FIF_Tree.registerImage_Stack(handles.FOV_List, Image_List);
                    guidata(handles.mwFigureH, mwHandles);
                end
            end
        end
    end;
else
    [fName, curr_Path] = uigetfile([curr_Path '\*.mroi;*.xls;*.xlsx;*.mseg;*.tif;*.tiff;*.png;*.lsm;*.zip']);
    if strcmp(fName(end-2:end), 'tif') || strcmp(fName(end-3:end), 'tiff') || strcmp(fName(end-2:end), 'png') || strcmp(fName(end-2:end), 'lsm')
        if isfield(mwHandles, 'FIF_Tree')
            if ~isempty(mwHandles.FIF_Tree), Image_List = Image_O;
                if isfield(mwHandles, 'Image_List'), if ~mwHandles.Image_List.isEmpty, Image_List = mwHandles.Image_List; end; end
                [mwHandles.FIF_Tree, mwHandles.Image_List] = mwHandles.FIF_Tree.registerImageF(Image_List, curr_Path, fName);
            end
        end

        handles.FOV_List = Field_ofView_O;
        if StandAlone
            handles.FOV_List = handles.FOV_List.loadFOV_List(curr_Path, fName, [], handles.Remove_HotPixels);
        else
            handles.FOV_List = handles.FOV_List.loadFOV_List(curr_Path, fName, [], mwHandles.Remove_HotPixels);
        end

        if ~StandAlone, guidata(handles.mwFigureH, mwHandles); end
        guidata(hObject, handles);
        Init_ImageStack_Window(hObject, eventdata); handles = guidata(hObject);
    else
        PolyXLS_Param = struct('Sheet_Name', 'All_Sheets', 'Start_Cell', 'B5');
        Polygon_Prop  = struct('Circle_Mode', 'Polygon', ...
                               'Polygon_Type', 'Patch', ...
                               'Images_Related', [], ...
                               'Image_Drawn', handles.FOV_List(1).Name, ...
                               'Image_Frame_Index', handles.Image_Frame_Index);
        if StandAlone, Polygon_List = handles.Polygon_List.Load_aPolygon_fromFile(curr_Path, fName, Polygon_Prop, PolyXLS_Param);
            Current_Polygon_Index = handles.Current_Polygon_Index;
        else Polygon_List = mwHandles.Polygon_List.Load_aPolygon_fromFile(curr_Path, fName, Polygon_Prop, PolyXLS_Param);
            Current_Polygon_Index = mwHandles.Current_Polygon_Index;
        end
        if strcmp(fName(end-3:end), 'mroi') || strcmp(fName(end-2:end), 'xls') || strcmp(fName(end-3:end), 'xlsx') || strcmp(fName(end-2:end), 'zip')
            if isfield(mwHandles, 'FIF_Tree')
                if ~isempty(mwHandles.FIF_Tree)
                    selectedNodes = mwHandles.FIF_Tree.Tree.getSelectedNodes;
                    selectedNode  = selectedNodes(1);
                    if selectedNode.getLevel == 2
                        Image_List = Image_O;
                        if ~mwHandles.Image_List.isEmpty, Image_List = mwHandles.Image_List; end
                        mwHandles.Image_List = mwHandles.FIF_Tree.registerROI_List(Polygon_List, Image_List); guidata(handles.mwFigureH, mwHandles);
                        Polygon_List         = Polygon_List.updateROI_Sample(mwHandles.FIF_Tree.Tree, mwHandles.Image_List);
                    end
                end
            end
            if StandAlone, handles.Polygon_List = Polygon_List;
                handles.Current_Polygon_Index = Current_Polygon_Index;
            else
                h = waitbar(0, 'Loading Regions of interest');
                for ii = 1:length(Polygon_List)
                    [~, Found] = mwHandles.Polygon_List.findROI('Polygon_Name', Polygon_List(ii).Name);
                    if ~isempty(Found), mwHandles.Polygon_List(Found) = Polygon_List(ii);
                        mwHandles.Current_Polygon_Index = Found;
                    else
                        if mwHandles.Polygon_List.isEmpty, iROI = 1; else iROI = length(mwHandles.Polygon_List) + 1; end
                        mwHandles.Polygon_List(iROI) = Polygon_List(ii);
                        mwHandles.Current_Polygon_Index = iROI;
                    end
                    waitbar(ii/length(Polygon_List), h);
                end
            end
            close(h);

            set(handles.Polygon_List_ListBox, 'String', {Polygon_List.Name}, 'Value', 1);
            if ~StandAlone, guidata(handles.mwFigureH, mwHandles); end; guidata(hObject, handles);
            Recreate_Polygons_Handles(hObject, eventdata); handles = guidata(hObject);
            if ~StandAlone, mwHandles = guidata(handles.mwFigureH); end
        else % Loading the segments
            All_Polygon_Names = {Polygon_List.Master_Polygon};
            ROI_List_Names    = get(handles.Polygon_List_ListBox, 'String');
            iPolygons         = cellfun(@(x) strcmp(x, All_Polygon_Names), ROI_List_Names, 'UniformOutput', false);
            iPolygons         = cellfun(@(x) find(x), iPolygons, 'UniformOutput', false);
            inotEmpty_Poly    = find(cell2mat(cellfun(@(x) ~isempty(x), iPolygons, 'UniformOutput', false)));
            iPolygons         = cell2mat(iPolygons(inotEmpty_Poly));
            Segment_List      = Polygon_List(iPolygons);
            if StandAlone, Master_Polygon = {handles.Segment_List.Master_Polygon}; else Master_Polygon = {mwHandles.Segment_List.Master_Polygon}; end
            if length(Master_Polygon) == 1 && isempty(Master_Polygon{1}), Master_Polygon = {''}; nSeg_Items = 0;
            else nSeg_Items = length(Master_Polygon);
            end
            h = waitbar(0, 'Loading ROI Segments');
            for ii = 1:length(Segment_List)
                Found = find(~cellfun('isempty', strfind(Master_Polygon, Segment_List(ii).Master_Polygon)),1);
                if isempty(Found)
                    if isempty(mwHandles), handles.Segment_List(nSeg_Items + 1) = Segment_List(ii);
                    else mwHandles.Segment_List(nSeg_Items + 1) = Segment_List(ii);
                    end
                    nSeg_Items = nSeg_Items + 1;
                else
                    if StandAlone, handles.Segment_List(Found) = Segment_List(ii); else mwHandles.Segment_List(Found) = Segment_List(ii); end
                end;
                waitbar(ii/length(Segment_List), h);
            end;
            close(h);
            if StandAlone
                handles.Seg_Method       = Segment_List(1).Segmentation_Method;
                handles.Seg_Type         = Segment_List(1).Segment_Type;
                handles.Seg_Split_Value  = Segment_List(1).Segment_Param_Value;
                if ~isempty(Segment_List(1).nIterations), handles.Seg_nIterations = Segment_List(1).nIterations; end;
                if ~isempty(Segment_List(1).Intensity_Variation_Coeff), handles.Seg_Intensity_Weight = Segment_List(1).Intensity_Variation_Coeff; end;
                handles.Seg_nVert_inPoly = Segment_List(1).nPoints_inSegment_Poly;
            else
                mwHandles.Seg_Method       = Segment_List(1).Segmentation_Method;
                mwHandles.Seg_Type         = Segment_List(1).Segment_Type;
                mwHandles.Seg_Split_Value  = Segment_List(1).Segment_Param_Value;
                if ~isempty(Segment_List(1).nIterations), mwHandles.Seg_nIterations = Segment_List(1).nIterations; end;
                if ~isempty(Segment_List(1).Intensity_Variation_Coeff), mwHandles.Seg_Intensity_Weight = Segment_List(1).Intensity_Variation_Coeff; end;
                mwHandles.Seg_nVert_inPoly = Segment_List(1).nPoints_inSegment_Poly;
            end
        end;
    end;
end;
Recreate_Polygons_Handles(hObject, eventdata); handles = guidata(hObject);
if StandAlone, handles.curr_Path  = curr_Path; else mwHandles.curr_Path = curr_Path; end

if ~StandAlone, guidata(handles.mwFigureH, mwHandles); end; guidata(hObject, handles);