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
function handles = Settings_General_Tab_Fcn(handles)

Settings_General_Tab = handles.Settings_General_Tab;

Ana_Path_Text = uicontrol('Parent', Settings_General_Tab, 'Style', 'text', 'String', 'Analysis Path', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 295 115 25], 'FontSize', 10);
Ana_Path_Edit = uicontrol('Parent', Settings_General_Tab, 'Style', 'edit', 'Tag', 'Ana_Path_Edit', ...
                          'Units', 'Pixels', 'Position', [135 295 350 25], 'FontSize', 10, ...
                          'Callback', {@Ana_Path_Edit_Callback, handles.output});
Ana_Path_pButton = uicontrol('Parent', Settings_General_Tab, 'Style', 'push', 'String', '...', 'Tag', 'Ana_Path_pButton', ...
                             'Units', 'Pixels', 'Position', [495 295 25 25], 'FontSize', 10, ...
                             'Callback', {@Ana_Path_pButton_Callback, handles.output});
                         
Hor_Shift_Text = uicontrol('Parent', Settings_General_Tab, 'Style', 'text', 'String', 'Horizontal Shift', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 255 115 25], 'FontSize', 10);
Hor_Shift_Edit = uicontrol('Parent', Settings_General_Tab, 'Style', 'edit', 'Tag', 'Hor_Shift_Edit', ...
                          'Units', 'Pixels', 'Position', [135 255 50 25], 'FontSize', 10, ...
                          'Callback', {@Hor_Shift_Edit_Callback, handles.output});

Sample_Type_Menu = {'Cells', 'Solution'};
Sample_Type_Text = uicontrol('Parent', Settings_General_Tab, 'Style', 'text', 'String', 'Sample Type', ...
                             'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 215 115 25], 'FontSize', 10);
Sample_Type_popMenu = uicontrol('Parent', Settings_General_Tab, 'Style', 'popupmenu', 'Tag', 'Sample_Type_Edit', ...
                                'Units', 'Pixels', 'Position', [135 215 180 25], 'String', Sample_Type_Menu, 'FontSize', 10, ...
                                'Callback', {@Sample_Type_popMenu_Callback, handles.output});

Pen_Size_Text = uicontrol('Parent', Settings_General_Tab, 'Style', 'text', 'String', 'Pen Size', ...
                          'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 175 115 25], 'FontSize', 10);
Pen_Size_Edit = uicontrol('Parent', Settings_General_Tab, 'Style', 'edit', 'Tag', 'Pen_Size_Edit', ...
                          'Units', 'Pixels', 'Position', [135 175 50 25], 'FontSize', 10, ...
                          'Callback', {@Pen_Size_Edit_Callback, handles.output});

Separate_Dir_cBox = uicontrol('Parent', Settings_General_Tab, 'Style', 'checkbox', 'String', 'Separate Paths', ...
                              'Units', 'Pixels', 'Position', [5 135 200 25], 'FontSize', 10, 'Tag', 'Separate_Dir_cBox', ...
                              'Callback', {@Separate_Dir_cBox_Callback, handles.output});
Inc_Sub_Dir_cBox = uicontrol('Parent', Settings_General_Tab, 'Style', 'checkbox', 'String', 'Include Sub Directories', ...
                              'Units', 'Pixels', 'Position', [5 95 200 25], 'FontSize', 10, 'Tag', 'Inc_Sub_Dir_cBox', ...
                              'Callback', {@Inc_Sub_Dir_cBox_Callback, handles.output});
Show_Warnings_cBox = uicontrol('Parent', Settings_General_Tab, 'Style', 'checkbox', 'String', 'Show Warnings', ...
                              'Units', 'Pixels', 'Position', [5 55 200 25], 'FontSize', 10, 'Tag', 'Show_Warnings_cBox', ...
                              'Callback', {@Show_Warnings_cBox_Callback, handles.output});

Image_Type_Menu = {'Tagged Image File Format (tiff)', 'Portable Network Graphic (png)', 'Zeiss File Format (lsm)'};
Image_Type_Loaded_Text = uicontrol('Parent', Settings_General_Tab, 'Style', 'text', 'String', 'Image Format', ...
                                   'HorizontalAlignment', 'left', 'Units', 'Pixels', 'Position', [5 15 105 25], 'FontSize', 10);
Image_Type_Loaded_popMenu = uicontrol('Parent', Settings_General_Tab, 'Style', 'popupmenu', 'String', Image_Type_Menu, ...
                                      'Units', 'Pixels', 'Position', [135 15 260 25], 'FontSize', 10, ...
                                      'Callback', {@Image_Type_Loaded_popMenu_Callback, handles.output});

if ~isfield(handles, 'General_Params'), handles.General_Params = struct('Ana_Path', '.\', 'Hor_Shift', 0, 'Sample_Type', 'Cells', ...
                                                                        'Pen_Size', 1, 'Separate_Dir', 1, 'Inc_Sub_Dir', 1, 'Show_Warnings', 0, ...
                                                                        'Image_Type_Loaded', 'Tagged Image File Format (tiff)');
elseif isempty(handles.General_Params), handles.General_Params = struct('Ana_Path', '.\', 'Hor_Shift', 0, 'Sample_Type', 'Cells', ...
                                                                        'Pen_Size', 1, 'Separate_Dir', 1, 'Inc_Sub_Dir', 1, 'Show_Warnings', 0, ...
                                                                        'Image_Type_Loaded', 'Tagged Image File Format (tiff)');
end;
if ~isfield(handles.General_Params, 'Ana_Path'), handles.General_Params.Ana_Path = '.\'; 
elseif isempty(handles.General_Params.Ana_Path), handles.General_Params.Ana_Path = '.\';
end;
if ~isfield(handles.General_Params, 'Hor_Shift'), handles.General_Params.Hor_Shift = 0;
elseif isempty(handles.General_Params.Hor_Shift), handles.General_Params.Hor_Shift = 0;
end;
if ~isfield(handles.General_Params, 'Sample_Type'), handles.General_Params.Sample_Type = 'Cells';
elseif isempty(handles.General_Params.Sample_Type), handles.General_Params.Sample_Type = 'Cells';
end;
if ~isfield(handles.General_Params, 'Pen_Size'), handles.General_Params.Pen_Size = 1;
elseif isempty(handles.General_Params.Pen_Size), handles.General_Params.Pen_Size = 1;
end;
if ~isfield(handles.General_Params, 'Separate_Dir'), handles.General_Params.Separate_Dir = 1;
elseif isempty(handles.General_Params.Separate_Dir), handles.General_Params.Separate_Dir = 1;
end;
if ~isfield(handles.General_Params, 'Inc_Sub_Dir'), handles.General_Params.Inc_Sub_Dir = 1;
elseif isempty(handles.General_Params.Inc_Sub_Dir), handles.General_Params.Inc_Sub_Dir = 1;
end;
if ~isfield(handles.General_Params, 'Show_Warnings'), handles.General_Params.Show_Warnings = 0;
elseif isempty(handles.General_Params.Show_Warnings), handles.General_Params.Show_Warnings = 0;
end;
if ~isfield(handles.General_Params, 'Image_Type_Loaded'), handles.General_Params.Image_Type_Loaded = 'Tagged Image File Format (tiff)';
elseif isempty(handles.General_Params.Image_Type_Loaded), handles.General_Params.Image_Type_Loaded = 'Tagged Image File Format (tiff)';
end;

set(Ana_Path_Edit, 'String', num2str(handles.General_Params.Ana_Path));
set(Hor_Shift_Edit, 'String', num2str(handles.General_Params.Hor_Shift));
handles.General_Params.Sample_Type_Index = find(~cellfun(@isempty, strfind(Sample_Type_Menu, handles.General_Params.Sample_Type)));
set(Sample_Type_popMenu, 'Value', handles.General_Params.Sample_Type_Index);
set(Pen_Size_Edit, 'String', num2str(handles.General_Params.Pen_Size));
set(Separate_Dir_cBox, 'Value', handles.General_Params.Separate_Dir);
set(Inc_Sub_Dir_cBox, 'Value', handles.General_Params.Inc_Sub_Dir);
set(Show_Warnings_cBox, 'Value', handles.General_Params.Show_Warnings);
File_Type_Index = find(~cellfun(@isempty, strfind(Image_Type_Menu, handles.General_Params.Image_Type_Loaded)));
set(Image_Type_Loaded_popMenu, 'Value', File_Type_Index);
end

%------------------------- Callbacks for the General Setting Tab widgets --------------------------
% Callback function for the "Setting Analysis Path" Field. this callback saves values into handles.
function Ana_Path_Edit_Callback (hObject, eventdata, Main_Figure)
handles            = guidata(Main_Figure);
handles.General_Params.Ana_Path = get(hObject, 'String');

UM_TK_FigureH      = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles          = guidata(UM_TK_FigureH);
        umHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(UM_TK_FigureH, umHandles);
    end
end

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        rmHandles          = guidata(ROI_Manager_FigureH);
        rmHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(ROI_Manager_FigureH, rmHandles);
    end
end

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles          = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Setting Analysis Path" Push button. this callback saves values into handles.
function Ana_Path_pButton_Callback (hObject, eventdata, Main_Figure)
handles            = guidata(Main_Figure);
handles.General_Params.Ana_Path = uigetdir(handles.Ana_Path, 'Select Analysis Path');
Ana_Path_Edit      = findobj('Tag', 'Ana_Path_Edit');
set(Ana_Path_Edit, 'String', num2str(handles.General_Params.Ana_Path));

UM_TK_FigureH      = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles          = guidata(UM_TK_FigureH);
        umHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(UM_TK_FigureH, umHandles);
    end
end

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        rmHandles          = guidata(ROI_Manager_FigureH);
        rmHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(ROI_Manager_FigureH, rmHandles);
    end
end

FICoS_Tool_Kit_FigH      = findobj('Tag', 'FICoS_Tool_Kit_FigH');
if ~isempty(FICoS_Tool_Kit_FigH)
    if isvalid(FICoS_Tool_Kit_FigH)
        fretHandles          = guidata(FICoS_Tool_Kit_FigH);
        fretHandles.Ana_Path = handles.General_Params.Ana_Path;
        guidata(FICoS_Tool_Kit_FigH, fretHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Horizontal Shift" Field. this callback saves values into handles.
function Hor_Shift_Edit_Callback (hObject, eventdata, Main_Figure)
handles             = guidata(Main_Figure);
handles.General_Params.Hor_Shift = str2double(get(hObject, 'String'));

UM_TK_FigureH       = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles           = guidata(UM_TK_FigureH);
        umHandles.Hor_Shift = handles.General_Params.Hor_Shift;
        guidata(UM_TK_FigureH, umHandles);
    end
end

ES_Tool_Kit_FigH         = findobj('Tag', 'ES_Tool_Kit_FigH');
if ~isempty(ES_Tool_Kit_FigH)
    if isvalid(ES_Tool_Kit_FigH)
        esHandles                = guidata(ES_Tool_Kit_FigH);
        esHandles.ES_Hor_Shift = handles.General_Params.Hor_Shift;
        guidata(ES_Tool_Kit_FigH, esHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Histogram Bin Size" Field. this callback saves values into handles.
function Sample_Type_popMenu_Callback (hObject, eventdata, Main_Figure)
handles                            = guidata(Main_Figure);
content                            = get(hObject, 'String');
handles.General_Params.Sample_Type = content{get(hObject, 'Value')};

ES_Tool_Kit_FigH         = findobj('Tag', 'ES_Tool_Kit_FigH');
if ~isempty(ES_Tool_Kit_FigH)
    if isvalid(ES_Tool_Kit_FigH)
        esHandles                = guidata(ES_Tool_Kit_FigH);
        esHandles.ES_Sample_Type = handles.General_Params.Sample_Type;
        guidata(ES_Tool_Kit_FigH, esHandles);
    end
end

UM_TK_FigureH                      = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles             = guidata(UM_TK_FigureH);
        umHandles.Sample_Type = handles.General_Params.Sample_Type;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Pen Size" Field. this callback saves values into handles.
function Pen_Size_Edit_Callback (hObject, eventdata, Main_Figure)
handles            = guidata(Main_Figure);
handles.General_Params.Pen_Size = str2double(get(hObject, 'String'));

UM_TK_FigureH      = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles          = guidata(UM_TK_FigureH);
        umHandles.Pen_Size = handles.General_Params.Pen_Size;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Separate Path for each image" check box. this callback saves values into handles.
function Separate_Dir_cBox_Callback (hObject, eventdata, Main_Figure)
handles                = guidata(Main_Figure);
handles.General_Params.Separate_Dir = get(hObject, 'Value');

UM_TK_FigureH          = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles              = guidata(UM_TK_FigureH);
        umHandles.Separate_Dir = handles.General_Params.Separate_Dir;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "include Sub Directories" check box. this callback saves values into handles.
function Inc_Sub_Dir_cBox_Callback (hObject, eventdata, Main_Figure)
handles               = guidata(Main_Figure);
handles.General_Params.Inc_Sub_Dir = get(hObject, 'Value');

UM_TK_FigureH         = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles             = guidata(UM_TK_FigureH);
        umHandles.Inc_Sub_Dir = handles.General_Params.Inc_Sub_Dir;
        guidata(UM_TK_FigureH, umHandles);
    end
end

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        rmHandles             = guidata(ROI_Manager_FigureH);
        rmHandles.Include_SubFolders = handles.General_Params.Inc_Sub_Dir;
        guidata(ROI_Manager_FigureH, rmHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Show Warnings" check box. this callback saves values into handles.
function Show_Warnings_cBox_Callback (hObject, eventdata, Main_Figure)
handles                 = guidata(Main_Figure);
handles.General_Params.Show_Warnings = get(hObject, 'Value');

UM_TK_FigureH           = findobj('Tag', 'UM_TK_FigureH');
if ~isempty(UM_TK_FigureH)
    if isvalid(UM_TK_FigureH)
        umHandles               = guidata(UM_TK_FigureH);
        umHandles.Show_Warnings = handles.General_Params.Show_Warnings;
        guidata(UM_TK_FigureH, umHandles);
    end
end

guidata(Main_Figure, handles);
end

% Callback function for the "Include sub folders" check box. this callback saves values into handles.
function Image_Type_Loaded_popMenu_Callback (hObject, eventdata, Main_Figure)
handles = guidata(Main_Figure);
content = get(hObject, 'String');
handles.General_Params.Image_Type_Loaded = content{get(hObject, 'Value')};

ROI_Manager_FigureH      = findobj('Name', 'ROI Manager');
if ~isempty(ROI_Manager_FigureH)
    if isvalid(ROI_Manager_FigureH)
        rmHandles                   = guidata(ROI_Manager_FigureH);
        rmHandles.Image_Type_Loaded = handles.General_Params.Image_Type_Loaded;
        guidata(ROI_Manager_FigureH, rmHandles);
    end
end

guidata(Main_Figure, handles);
end