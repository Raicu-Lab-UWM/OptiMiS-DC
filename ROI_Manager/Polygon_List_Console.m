function varargout = Polygon_List_Console(varargin)
% POLYGON_LIST_CONSOLE MATLAB code for Polygon_List_Console.fig
%      POLYGON_LIST_CONSOLE, by itself, creates a new POLYGON_LIST_CONSOLE or raises the existing
%      singleton*.
%
%      H = POLYGON_LIST_CONSOLE returns the handle to a new POLYGON_LIST_CONSOLE or the handle to
%      the existing singleton*.
%
%      POLYGON_LIST_CONSOLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POLYGON_LIST_CONSOLE.M with the given input arguments.
%
%      POLYGON_LIST_CONSOLE('Property','Value',...) creates a new POLYGON_LIST_CONSOLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Polygon_List_Console_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Polygon_List_Console_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Polygon_List_Console

% Last Modified by GUIDE v2.5 10-Feb-2019 19:38:18

% Begin initialization code - DO NOT EDIT
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

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Polygon_List_Console_OpeningFcn, ...
                   'gui_OutputFcn',  @Polygon_List_Console_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Polygon_List_Console is made visible.
function Polygon_List_Console_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Polygon_List_Console (see VARARGIN)

% Choose default command line output for Polygon_List_Console
handles.output = hObject; guidata(hObject, handles);

if nargin < 4
    handles = rmInitiate(hObject);
elseif isempty(varargin{1})
    handles = rmInitiate(hObject);
else
    handles   = rmInitiate(hObject, varargin{1});
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Polygon_List_Console wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Polygon_List_Console_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Polygon_List_ListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Polygon_List_ListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on Polygon_List_ListBox and none of its controls.
function Polygon_List_ListBox_KeyPressFcn(hObject, eventdata, handles)

% hObject    handle to Polygon_List_ListBox (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
handles.ListBox_KeyPressed = eventdata.Key;

guidata(hObject, handles);


function Extract_Membrane_Icon_OffCallback(hObject, eventdata, handles)
handles.Polygon_Type = 'Patch';

guidata(hObject, handles);


function Draw_Polygon_tTool_OnCallback(hObject, eventdata, handles)
handles.Draw_Polygon_On  = 1;

guidata(hObject, handles);


function Draw_Polygon_tTool_OffCallback(hObject, eventdata, handles)
handles.Draw_Polygon_On = 0;

guidata(hObject, handles);


% --------------------------------------------------------------------
function Filter_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Filter_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes when user attempts to close figure1.

if isfield(handles, 'mwFigureH'), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end
if isempty(mwHandles), curr_Path = handles.curr_Path; else curr_Path = mwHandles.curr_Path; end
answer = questdlg('Is the chi square image loaded', 'Load Chi Square Image', 'Yes','No','No');
% Handle response
switch answer
    case 'Yes'
        if isfield(handles, 'Chi_Square_Image')
            if isempty(handles.Chi_Square_Image)
                handles.Chi_Square_Image = zeros(size(handles.FOV_List(1).raw_Data,1),size(handles.FOV_List(1).raw_Data,2), length(handles.FOV_List));
                for ii = 1:length(handles.FOV_List)
                    handles.Chi_Square_Image(:,:,ii) = handles.FOV_List(ii).raw_Data;
                end
            end
        else
            handles.Chi_Square_Image = zeros(size(handles.FOV_List(1).raw_Data,1),size(handles.FOV_List(1).raw_Data,2), length(handles.FOV_List));
            for ii = 1:length(handles.FOV_List)
                handles.Chi_Square_Image(:,:,ii) = handles.FOV_List(ii).raw_Data;
            end
        end
    case 'No'
        handles.Chi_Square_Image = Load_Image(curr_Path);
end
guidata(hObject, handles);

handles = Filter_ROIs_wChiSquare (hObject, handles.Chi_Square_Image);

guidata(hObject, handles);


function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure

Answer = questdlg('Select ''Save'' to save changes to ROI Manager, ''Cancel'' to return without closing, or ''Discard'' to leave without saving ', 'Save ROIs', 'Save', 'Cancel', 'Discard', 'Save');
switch Answer
case 'Save'
    guidata(hObject, handles);
    Save_Poly_List_Icon_ClickedCallback(handles);
    mwFigureH                  = findobj('Name', 'Fluorescence Fluctuation Spectrometry Suide');
    mwHandles                  = guidata(mwFigureH);
    mwHandles.Polygon_List     = handles.Polygon_List;
    mwHandles.Segment_List     = handles.Segment_List;
    mwHandles.Polygon_Type     = mwHandles.Polygon_Type;
    mwHandles.Image_Stack_Axes = mwHandles.Image_Stack_Axes;
    guidata(mwFigureH, mwHandles);
case 'Cancel'
    return
otherwise
end;

delete(hObject);
