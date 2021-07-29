function varargout = AddRemove_Tags(varargin)
% ADDREMOVE_TAGS MATLAB code for AddRemove_Tags.fig
%      ADDREMOVE_TAGS, by itself, creates a new ADDREMOVE_TAGS or raises the existing
%      singleton*.
%
%      H = ADDREMOVE_TAGS returns the handle to a new ADDREMOVE_TAGS or the handle to
%      the existing singleton*.
%
%      ADDREMOVE_TAGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ADDREMOVE_TAGS.M with the given input arguments.
%
%      ADDREMOVE_TAGS('Property','Value',...) creates a new ADDREMOVE_TAGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AddRemove_Tags_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AddRemove_Tags_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AddRemove_Tags

% Last Modified by GUIDE v2.5 14-May-2014 10:11:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AddRemove_Tags_OpeningFcn, ...
                   'gui_OutputFcn',  @AddRemove_Tags_OutputFcn, ...
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


% --- Executes just before AddRemove_Tags is made visible.
function AddRemove_Tags_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AddRemove_Tags (see VARARGIN)

% Choose default command line output for AddRemove_Tags
handles.output = hObject;

handles.eSpectra = varargin{1};
handles.Ana_Path = varargin{2};
handles.currPath = handles.Ana_Path;
if isempty(handles.eSpectra)
    handles.ES_Names = {};
elseif isempty(handles.eSpectra(1).Name) && length(handles.eSpectra) == 1
    handles.ES_Names = {};
else
    handles.ES_Names = {handles.eSpectra.Name};
end;

% Background_Image            = imread('Background_Optimis_Image.jpg','jpeg');
% axes(handles.Background_Axes);
% imagesc(Background_Image);
% set(handles.Background_Axes,'xtick',[],'ytick',[])
% uistack(handles.Background_Axes, 'bottom')

set(handles.Tags_LBox, 'String',handles.ES_Names);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AddRemove_Tags wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AddRemove_Tags_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.eSpectra;

% The GUI is no longer waiting, just close it
delete(hObject);


% --- Executes on selection change in Tags_LBox.
function Tags_LBox_Callback(hObject, eventdata, handles)
% hObject    handle to Tags_LBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Tags_LBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Tags_LBox
handles.Chosen_ES = get(hObject,'Value');

hFigure     = get(handles.Tags_LBox,'parent');
Mouse_Click = get(hFigure,'selectiontype');

if strcmp(Mouse_Click,'open') && numel(handles.Chosen_ES) == 1
    UM_getES_Data(hObject, eventdata);
%     handles.eSpectra(handles.Chosen_ES) = Tag_Update_Info(handles.eSpectra(handles.Chosen_ES));
end;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Tags_LBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tags_LBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on Tags_LBox and none of its controls.
function Tags_LBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Tags_LBox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'insert'
        [File_Name, handles.currPath] = uigetfile([handles.currPath '\*.tag'],'Load Elementary Spectrum');
        if isempty(handles.eSpectra)
            Temp             = Elementary_Spectrum_O;
            handles.eSpectra = Temp;
            handles.eSpectra = handles.eSpectra.loadobj(handles.currPath, File_Name);
            handles.ES_Names = {handles.eSpectra.Name};
        elseif isempty(handles.eSpectra(1).Name) && length(handles.eSpectra) == 1
            handles.eSpectra = handles.eSpectra.loadobj(handles.currPath, File_Name);
            handles.ES_Names = {handles.eSpectra.Name};
        else
            Num_of_ES                   = length(handles.eSpectra) + 1;
            handles.eSpectra(Num_of_ES) = Elementary_Spectrum_O;
            handles.eSpectra(Num_of_ES) = handles.eSpectra(Num_of_ES).loadobj(handles.currPath, File_Name);
            handles.ES_Names            = [handles.ES_Names handles.eSpectra(Num_of_ES).Name];
        end;

        set(handles.Tags_LBox, 'String', handles.ES_Names, 'Value', 1);
    case 'delete'
        handles.eSpectra(handles.Chosen_ES) = [];
        handles.ES_Names(handles.Chosen_ES) = [];
        handles.Num_of_ES                   = length(handles.eSpectra) - size(handles.Chosen_ES,2);

        set(handles.Tags_LBox, 'String', handles.ES_Names, 'Value', 1);
end;

guidata(hObject, handles);


% --------------------------------------------------------------------
function Add_Tag_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Add_Tag_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[File_Name, handles.currPath] = uigetfile([handles.currPath '\*.tag'],'Load Elementary Spectrum');
if isempty(handles.eSpectra)
    Temp             = Elementary_Spectrum_O;
    handles.eSpectra = Temp;
    handles.eSpectra = handles.eSpectra.loadobj(handles.currPath, File_Name);
    handles.ES_Names = {handles.eSpectra.Name};
elseif isempty(handles.eSpectra(1).Name) && length(handles.eSpectra) == 1
    handles.eSpectra = handles.eSpectra.loadobj(handles.currPath, File_Name);
    handles.ES_Names = {handles.eSpectra.Name};
else
    Num_of_ES                   = length(handles.eSpectra) + 1;
    handles.eSpectra(Num_of_ES) = Elementary_Spectrum_O;
    handles.eSpectra(Num_of_ES) = handles.eSpectra(Num_of_ES).loadobj(handles.currPath, File_Name);
    handles.ES_Names            = [handles.ES_Names handles.eSpectra(Num_of_ES).Name];
end;

set(handles.Tags_LBox, 'String', handles.ES_Names, 'Value', 1);

guidata(hObject, handles);


% --------------------------------------------------------------------
function Remove_Tag_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Remove_Tag_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.eSpectra(handles.Chosen_ES) = [];
handles.ES_Names(handles.Chosen_ES) = [];
handles.Num_of_ES                   = length(handles.eSpectra) - size(handles.Chosen_ES,2);

set(handles.Tags_LBox, 'String', handles.ES_Names, 'Value', 1);

guidata(hObject, handles);

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


% --- Executes on button press in Save_Exit_PButton.
function Save_Exit_PButton_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Exit_PButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end
