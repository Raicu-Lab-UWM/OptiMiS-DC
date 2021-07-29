function varargout = Load_fromExcel(varargin)
% LOAD_FROMEXCEL MATLAB code for Load_fromExcel.fig
%      LOAD_FROMEXCEL, by itself, creates a new LOAD_FROMEXCEL or raises the existing
%      singleton*.
%
%      H = LOAD_FROMEXCEL returns the handle to a new LOAD_FROMEXCEL or the handle to
%      the existing singleton*.
%
%      LOAD_FROMEXCEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOAD_FROMEXCEL.M with the given input arguments.
%
%      LOAD_FROMEXCEL('Property','Value',...) creates a new LOAD_FROMEXCEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Load_fromExcel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Load_fromExcel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Load_fromExcel

% Last Modified by GUIDE v2.5 08-May-2014 00:47:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Load_fromExcel_OpeningFcn, ...
                   'gui_OutputFcn',  @Load_fromExcel_OutputFcn, ...
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


% --- Executes just before Load_fromExcel is made visible.
function Load_fromExcel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Load_fromExcel (see VARARGIN)

% Choose default command line output for Load_fromExcel
handles.output = hObject;

handles.Path   = varargin{1};

if isempty(handles.Path)
    handles.Path = '.\';
end;

% Background_Image_Logo (handles.Background_Axes);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Load_fromExcel wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Load_fromExcel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.Path;
varargout{3} = handles.Excel_File_Name;
varargout{4} = handles.Sheet_Name;
varargout{5} = handles.Upper_Left;
varargout{6} = handles.Lower_Right;

% The GUI is no longer waiting, just close it
delete(hObject);


function File_Name_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to File_Name_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of File_Name_Edit as text
%        str2double(get(hObject,'String')) returns contents of File_Name_Edit as a double
handles.Excel_File_Name = get(hObject,'String');
[~, Sheets]             = xlsfinfo(handles.Excel_File_Name);
handles.Sheet_Name      = Sheets{1};

set(handles.Excel_File_Name, 'String', handles.Sheet);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function File_Name_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to File_Name_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_File_PButton.
function Load_File_PButton_Callback(hObject, eventdata, handles)
% hObject    handle to Load_File_PButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)[Name, handles.Path]    = uigetfile([handles.Path '*.xls; *.xlsx']);
[Name, handles.Path]    = uigetfile([handles.Path '*.xls; *.xlsx']);
handles.Excel_File_Name = [handles.Path Name];
[~, Sheets]             = xlsfinfo([handles.Path Name]);
handles.Sheet_Name      = Sheets{1};

set(handles.File_Name_Edit, 'String', handles.Excel_File_Name);
set(handles.Sheet_Edit,           'String', handles.Sheet_Name);

% Update handles structure
guidata(hObject, handles);


function Up_Left_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Up_Left_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Up_Left_Edit as text
%        str2double(get(hObject,'String')) returns contents of Up_Left_Edit as a double
handles.Upper_Left = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Up_Left_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Up_Left_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Low_Right_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Low_Right_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Low_Right_Edit as text
%        str2double(get(hObject,'String')) returns contents of Low_Right_Edit as a double
handles.Lower_Right = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Low_Right_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Low_Right_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Sheet_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Sheet_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sheet_Edit as text
%        str2double(get(hObject,'String')) returns contents of Sheet_Edit as a double
handles.Sheet_Name = get(hObject,'String');

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Sheet_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sheet_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
