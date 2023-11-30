function varargout = Calculate_Tag(varargin)
% CALCULATE_TAG MATLAB code for Calculate_Tag.fig
%      CALCULATE_TAG, by itself, creates a new CALCULATE_TAG or raises the existing
%      singleton*.
%
%      H = CALCULATE_TAG returns the handle to a new CALCULATE_TAG or the handle to
%      the existing singleton*.
%
%      CALCULATE_TAG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATE_TAG.M with the given input arguments.
%
%      CALCULATE_TAG('Property','Value',...) creates a new CALCULATE_TAG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calculate_Tag_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calculate_Tag_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Calculate_Tag

% Last Modified by GUIDE v2.5 13-May-2014 10:49:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Calculate_Tag_OpeningFcn, ...
                   'gui_OutputFcn',  @Calculate_Tag_OutputFcn, ...
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


% --- Executes just before Calculate_Tag is made visible.
function Calculate_Tag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calculate_Tag (see VARARGIN)

% Choose default command line output for Calculate_Tag
handles.output          = hObject;

handles.Spectrum        = varargin{1};
handles.Spect_Name_List = varargin{2};
handles.ES_Obj          = varargin{3};
handles.StandAlone      = true;
if nargin == 7, handles.mwFigureH = varargin{4};
    if isvalid(handles.mwFigureH), handles.StandAlone = false; end
end

handles.Chosen_ES       = [];
handles.Num_of_ES       = length(handles.Spect_Name_List);

handles.ES_Saved        = 0;

% Background_Image_Logo (handles.Background_Axes);

set(handles.Spectra_LBox,'String',handles.Spect_Name_List);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calculate_Tag wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calculate_Tag_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles.ES_Saved;
% 
% delete(hObject);


% --- Executes on selection change in Spectra_LBox.
function Spectra_LBox_Callback(hObject, eventdata, handles)
% hObject    handle to Spectra_LBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Spectra_LBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Spectra_LBox
handles.Chosen_ES = get(hObject,'Value');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Spectra_LBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Spectra_LBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on Spectra_LBox and none of its controls.
function Spectra_LBox_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Spectra_LBox (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'delete'
        handles.Spectrum(:,handles.Chosen_ES)      = [];
        handles.Spect_Name_List(handles.Chosen_ES) = [];
        
        set(handles.Spectra_LBox, 'String', handles.Spect_Name_List, 'Value', 1);
    otherwise
end;

guidata(hObject, handles);


% --------------------------------------------------------------------
function Plot_Spect_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot_Spect_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.Spectra_Plot_Axes);
Spectra = handles.Spectrum(:,handles.Chosen_ES);
plot(handles.ES_Obj.Wavelength, Spectra);
set(handles.Spectra_Plot_Axes,'Color',[[0.941 0.941] 0.941]);
legend(char([handles.Spect_Name_List(handles.Chosen_ES)]),'Location','northwest');
axis tight;


% --------------------------------------------------------------------
function Save_Tag_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Save_Tag_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ES_Obj  = handles.ES_Obj;
if ~handles.StandAlone, mwHandles = guidata(handles.mwFigureH); end
Spectra         = handles.Spectrum(:,handles.Chosen_ES);
ES_Obj.Spectrum = mean(Spectra,2);
ES_Obj.Spectrum = ES_Obj.Spectrum/max(ES_Obj.Spectrum);
ES_Obj.nSpectra = size(handles.Spectrum(:,handles.Chosen_ES),2);
Spc             = ES_Obj.Spectrum;
WL              = ES_Obj.Wavelength;

%{
Edited by Thomas Killeen 2022-11-08
(-)     D_WL            = WL(2:end)-WL(1:end-1);
(-)     ES_Obj.Spectral_Integral = sum(D_WL.*(Spc(1:end-1)+Spc(2:end))/2);
(+)     ES_Obj.Spectral_Integral = sum((Spc(1:end-1)+Spc(2:end))/2);

Edited by Thomas Killeen 2023-05-01
Reverted back to the old spectral integral method.
(+)     D_WL            = WL(2:end)-WL(1:end-1);
(+)     ES_Obj.Spectral_Integral = sum(D_WL.*(Spc(1:end-1)+Spc(2:end))/2);
(-)     ES_Obj.Spectral_Integral = sum((Spc(1:end-1)+Spc(2:end))/2);
%}

ES_Obj.Spectral_Integral = sum((Spc(1:end-1)+Spc(2:end))/2);

ES_Obj.Spectral_Integral(ES_Obj.Spectral_Integral<0) = -ES_Obj.Spectral_Integral;
handles.ES_Item_Folder   = uigetdir('','Save Spectrum to');
ES_Obj.Path     = handles.ES_Item_Folder;

if ~handles.StandAlone, mwHandles.ES_Obj = ES_Obj;
    guidata(handles.mwFigureH, mwHandles);
end
handles.ES_Obj = ES_Obj;
guidata(hObject, handles);

ES_Info_pButton_Callback(hObject, eventdata);
ES_Info          = findobj('Tag', 'ES_Info_FigH');
uiwait(ES_Info); 

handles          = guidata(hObject);
handles.ES_Obj.saveobj;
handles.ES_Saved = 1;

guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The GUI is no longer waiting, just close it
delete(hObject);
