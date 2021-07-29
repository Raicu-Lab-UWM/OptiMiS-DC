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
function Image_Stack_sBar_Callback(hObject, eventdata, Main_FigH)
handles      = guidata(Main_FigH);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

% set the image stack window title and load the first frame
handles.Image_Frame_Index = uint16(get(hObject, 'Value'));
ii       = handles.Image_Frame_Index;
FOV_Item = handles.FOV_List(ii);
if isfield(FOV_Item, 'iName')
    if isempty(FOV_Item.iName)
        set(handles.ImPoly_figHand, 'Name', [num2str(ii) '/' num2str(length(handles.FOV_List)) ' (' handles.FOV_List(ii).Name ')'], 'NumberTitle', 'off');
    else
        set(handles.ImPoly_figHand, 'Name', [num2str(ii) '/' num2str(length(handles.FOV_List)) ' (' handles.FOV_List(ii).iName ')'], 'NumberTitle', 'off');
    end;
else
    set(handles.ImPoly_figHand, 'Name', [num2str(ii) '/' num2str(length(handles.FOV_List)) ' (' handles.FOV_List(ii).Name ')'], 'NumberTitle', 'off');
end;
set(handles.FOV_hImage, 'CData', handles.FOV_List(ii).raw_Data);

% get the ROI list names when sample registration is involved
if ~isempty(mwHandles)
    if mwHandles.Polygon_List.isEmpty, ROI_List_Names = {}; else ROI_List_Names = {mwHandles.Polygon_List.Name}; end
    if isfield(mwHandles, 'FIF_Tree')
        if ~isempty(mwHandles.FIF_Tree)
            if ~isfield(mwHandles, 'Image_List'), Image_List = []; else Image_List = mwHandles.Image_List; end
            ROI_List_Names = mwHandles.FIF_Tree.retrieveROI_List(Image_List);
        end
    end
else
    if handles.Polygon_List.isEmpty, ROI_List_Names = {}; else ROI_List_Names = {handles.Polygon_List.Name}; end
end

if ~isempty(ROI_List_Names)
    for ii = 1:length(ROI_List_Names)
        if isempty(mwHandles), Polygon_List = handles.Polygon_List; else Polygon_List = mwHandles.Polygon_List; end
        [~, iROI] = Polygon_List.findROI('Polygon_Name', ROI_List_Names{ii});
        if handles.Show_All_Poly
            if Polygon_List(iROI).Image_Frame_Index == handles.Image_Frame_Index, Show = 'on'; else Show = 'off'; end
        else
            Show = 'off';
        end
        if ~isempty(Polygon_List(iROI).Poly_PlotH)
            if isempty(mwHandles)
                if isvalid(Polygon_List(iROI).Poly_PlotH)
                    set(handles.Polygon_List(iROI).Poly_PlotH, 'Visible', Show);
                    set(handles.Polygon_List(iROI).Title_PrintH, 'Visible', Show);
                else
                    handles.Polygon_List(iROI).Poly_PlotH = [];
                    handles.Polygon_List(iROI).Title_PrintH = [];
                end
            else
                if isvalid(Polygon_List(iROI).Poly_PlotH)
                    set(mwHandles.Polygon_List(iROI).Poly_PlotH, 'Visible', Show);
                    set(mwHandles.Polygon_List(iROI).Title_PrintH, 'Visible', Show);
                else
                    mwHandles.Polygon_List(iROI).Poly_PlotH = [];
                    mwHandles.Polygon_List(iROI).Title_PrintH = [];
                end
            end
        end
    end
end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_FigH, handles);