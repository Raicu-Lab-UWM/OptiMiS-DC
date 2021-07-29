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
function handles = General_Setting_Tab_Fcn(FRET_FigureH)
handles = guidata(FRET_FigureH);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

General_Setting_Tab = handles.General_Setting_Tab;

Analysis_Path_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Analysis Path', ...
                              'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [20 310 105 25], 'FontSize', 10);
Analysis_Path_Edit = uicontrol('Parent', General_Setting_Tab, 'Style', 'edit', 'Tag', 'Analysis_Path_Edit',...
                               'Units', 'Pixels', 'Position', [130 310 250 25], 'FontSize', 10, ...
                               'Callback', {@Ana_Path_Edit_Callback, FRET_FigureH});
Ana_Path_pButton = uicontrol('Parent', General_Setting_Tab, 'Style', 'pushbutton', 'String', '...', 'Units', 'pixels', ...
                             'Position', [385 310 30 25], 'Visible', 'on', 'FontSize', 10, 'callback', {@Ana_Path_pButton_Callback, handles.output});

Include_SubFolders_cBox = uicontrol('Parent', General_Setting_Tab, 'Style', 'checkbox', 'String', 'Include images from sub-directories', ...
                            'Units', 'Pixels', 'Position', [20 270 300 25], 'FontSize', 10, ...
                            'Callback', {@Include_SubFolders_cBox_Callback, FRET_FigureH});

Image_Type_Menu = {'Tagged Image File Format (tiff)', 'Portable Network Graphic (png)', 'Zeiss File Format (lsm)'};
Image_Type_Loaded_Text = uicontrol('Parent', General_Setting_Tab, 'Style', 'text', 'String', 'Image Format', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [20 230 105 25], 'FontSize', 10);
Image_Type_Loaded_popMenu = uicontrol('Parent', General_Setting_Tab, 'Style', 'popupmenu', 'String', Image_Type_Menu, ...
                                      'Units', 'Pixels', 'Position', [130 230 260 25], 'FontSize', 10, ...
                                      'Callback', {@Image_Type_Loaded_popMenu_Callback, FRET_FigureH});
                        
if isempty(mwHandles)
    set(Analysis_Path_Edit, 'String', handles.Ana_Path);
    set(Include_SubFolders_cBox, 'Value', handles.Include_SubFolders);
    File_Type_Index = find(~cellfun(@isempty, strfind(Image_Type_Menu, handles.Image_Type_Loaded)));
else
    set(Analysis_Path_Edit, 'String', mwHandles.Ana_Path);
    set(Include_SubFolders_cBox, 'Value', mwHandles.Include_SubFolders);
    File_Type_Index = find(~cellfun(@isempty, strfind(Image_Type_Menu, mwHandles.Image_Type_Loaded)));
end
set(Image_Type_Loaded_popMenu, 'Value', File_Type_Index);
end

%------------------------- Callbacks for the Plot Setting Tab widgets --------------------------
% Callback function for the "Analysis path selection" Field. this callback saves values into handles.
function Ana_Path_Edit_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Ana_Path = str2double(get(hObject, 'String')); else mwHandles.Ana_Path = str2double(get(hObject, 'String')); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Analysis path selection" button. this callback opens the open folder dialog box 
% and saves the selected path namme into handles.
function Ana_Path_pButton_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), Ana_Path = handles.Ana_Path; else Ana_Path = mwHandles.Ana_Path; end
Ana_Path           = uigetdir(Ana_Path, 'Select Analysis Path');
Analysis_Path_Edit = findobj('Tag', 'Analysis_Path_Edit');
set(Analysis_Path_Edit, 'String', Ana_Path);
if isempty(mwHandles), handles.Ana_Path = Ana_Path; else mwHandles.Ana_Path = Ana_Path; end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Include sub folders" check box. this callback saves values into handles.
function Include_SubFolders_cBox_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles), handles.Include_SubFolders = get(hObject, 'Value'); else mwHandles.Include_SubFolders = get(hObject, 'Value'); end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end
guidata(Main_Figure, handles);
end

% Callback function for the "Include sub folders" check box. this callback saves values into handles.
function Image_Type_Loaded_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

content = get(hObject, 'String');
if isempty(mwHandles), handles.Image_Type_Loaded = content{get(hObject, 'Value')}; else mwHandles.Image_Type_Loaded = content{get(hObject, 'Value')}; end

if ~isempty(mwHandles), guidata(handles.mwFigureH, mwHandles); end;
guidata(Main_Figure, handles);
end