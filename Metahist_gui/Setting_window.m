function varargout = Setting_window(varargin)
% SETTING_WINDOW MATLAB code for Setting_window.fig
%      SETTING_WINDOW, by itself, creates a new SETTING_WINDOW or raises the existing
%      singleton*.
%
%      H = SETTING_WINDOW returns the handle to a new SETTING_WINDOW or the handle to
%      the existing singleton*.
%
%      SETTING_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SETTING_WINDOW.M with the given input arguments.
%
%      SETTING_WINDOW('Property','Value',...) creates a new SETTING_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Setting_window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Setting_window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Setting_window

% Last Modified by GUIDE v2.5 07-Jun-2022 10:12:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Setting_window_OpeningFcn, ...
                   'gui_OutputFcn',  @Setting_window_OutputFcn, ...
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


% --- Executes just before Setting_window is made visible.
function Setting_window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Setting_window (see VARARGIN)

% Choose default command line output for Setting_window
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Setting_window wait for user response (see UIRESUME)
% uiwait(handles.Settings);


% --- Outputs from this function are returned to the command line.
function varargout = Setting_window_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
contents = cellstr(get(hObject,'String'));
Conc_method  = contents{get(hObject,'Value')};
% insert handle from setting_window gui to main_handle
main_handle = guidata(handles.main_gui_handle);
main_handle.Conc_method = Conc_method;
guidata(handles.main_gui_handle, main_handle); %update main_gui_handle;


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
