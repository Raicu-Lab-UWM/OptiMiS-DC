function varargout = Tag_Display(varargin)
% TAG_DISPLAY MATLAB code for Tag_Display.fig
%      TAG_DISPLAY, by itself, creates a new TAG_DISPLAY or raises the existing
%      singleton*.
%
%      H = TAG_DISPLAY returns the handle to a new TAG_DISPLAY or the handle to
%      the existing singleton*.
%
%      TAG_DISPLAY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TAG_DISPLAY.M with the given input arguments.
%
%      TAG_DISPLAY('Property','Value',...) creates a new TAG_DISPLAY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tag_Display_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tag_Display_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tag_Display

% Last Modified by GUIDE v2.5 22-Nov-2016 16:54:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tag_Display_OpeningFcn, ...
                   'gui_OutputFcn',  @Tag_Display_OutputFcn, ...
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


% --- Executes just before Tag_Display is made visible.
function Tag_Display_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tag_Display (see VARARGIN)

% Choose default command line output for Tag_Display
handles.output = hObject;

handles.StandAlone = true;
mwFigureH             = [];
if nargin == 4, mwFigureH = varargin{1}; end
if isvalid(mwFigureH), handles.StandAlone = false; end
if ~handles.StandAlone, handles.mwFigureH = mwFigureH; mwHandles = guidata(mwFigureH); end

handles.Path                   = '.\';
handles.Horizontal_Shift       = 0.02;
handles.Sample_Type            = 'Cells';
if ~handles.StandAlone
    handles.Path             = mwHandles.curr_Path;
    handles.Horizontal_Shift = mwHandles.Hor_Shift;
    handles.Sample_Type      = mwHandles.Sample_Type;
end
% Background_Image_Logo (handles.Background_Axes);
cla(handles.Image_Stack_Axes);

[handles.Name, handles.Path]   = uigetfile([handles.Path '\*.tif;*.tiff;*.dat'],'Load Elementary Spectrum Measured Image');
handles.Stack_Title            = {};
handles.ES_Obj                 = Elementary_Spectrum_O;
handles.ES_Obj.Path            = handles.Path;
handles.ES_Obj.Name            = handles.Name;
handles.ES_Obj                 = handles.ES_Obj.getWavelength;
handles.Wavelength             = handles.ES_Obj.Wavelength;
handles.WL_Index               = handles.ES_Obj.iOriginal_WL;
First                          = 1000;
Last                           = length(handles.WL_Index) + 999;
[handles.Image_Stack, ~, ~, ~] = Loading_Spectral_Files (handles.Path, handles.Name, 'any', handles.WL_Index, First, Last, handles.Horizontal_Shift);
Image_to_Plot                  = handles.Image_Stack(:,:,1);
handles.imHandle               = Plot_Data(handles.Image_Stack_Axes, Image_to_Plot, [0,0,0,0]);

nWavelength = size(handles.Image_Stack,3);
set(handles.Image_Stack_Slider, 'Min', 1);
set(handles.Image_Stack_Slider, 'Max', nWavelength);
set(handles.Image_Stack_Slider, 'Value', 1);
set(handles.Image_Stack_Slider, 'SliderStep', [1/nWavelength, 10/nWavelength]);
set(handles.output, 'Name', [handles.Name ' - Frame 1']);

set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@Image_Stack_Axes_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Tag_Display wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tag_Display_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Image_Stack_Name_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Stack_Name_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Image_Stack_Name_Edit as text
%        str2double(get(hObject,'String')) returns contents of Image_Stack_Name_Edit as a double


% --- Executes during object creation, after setting all properties.
function Image_Stack_Name_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Stack_Name_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function Image_Stack_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to Image_Stack_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
Image_Number     = get(hObject,'Value');

xLim             = get(handles.Image_Stack_Axes, 'xlim');
yLim             = get(handles.Image_Stack_Axes, 'ylim');

Coordiantes      = [xLim(1) xLim(2) yLim(1) yLim(2)];
Image_to_Plot    = handles.Image_Stack(:,:,round(Image_Number));
handles.imHandle = Plot_Data(handles.Image_Stack_Axes, Image_to_Plot, Coordiantes);
set(handles.output, 'Name', [handles.Name ' - Frame ' num2str(round(Image_Number))]);

set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@Image_Stack_Axes_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Image_Stack_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Image_Stack_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function Ellipse_Icon_OnCallback(hObject, eventdata, handles)
% hObject    handle to Ellipse_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Free_Hand_Icon, 'State', 'off');
set(handles.Polygon_Icon, 'State', 'off');
zoom off;
pan off;
handles.Editing_Tool   = 'Ellipse';
set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@Image_Stack_Axes_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Free_Hand_Icon_OnCallback(hObject, eventdata, handles)
% hObject    handle to Free_Hand_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Ellipse_Icon, 'State', 'off');
set(handles.Polygon_Icon, 'State', 'off');
zoom off;
pan('off');
handles.Editing_Tool   = 'Freehand';
set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@Image_Stack_Axes_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Polygon_Icon_OnCallback(hObject, eventdata, handles)
% hObject    handle to Polygon_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.Ellipse_Icon, 'State', 'off');
set(handles.Free_Hand_Icon, 'State', 'off');
zoom off;
pan('off');
handles.Editing_Tool   = 'Polygon';
set(handles.Image_Stack_Axes, 'ButtonDownFcn', {@Image_Stack_Axes_ButtonDownFcn, handles});

% Update handles structure
guidata(hObject, handles);


% --- Executes on mouse press over axes background.
function Image_Stack_Axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Image_Stack_Axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
if isfield (handles, 'Editing_Tool')
    [handles.currSpectrum, handles.Polygon] = Signal_Select_Tool_Fcn(handles.Image_Stack_Axes,handles.Image_Stack, handles.Wavelength, handles.Editing_Tool, handles.Sample_Type);

    xLim = get(handles.Image_Stack_Axes, 'xlim');
    yLim = get(handles.Image_Stack_Axes, 'ylim');

    handles.xMin_Image_Stack = xLim(1);
    handles.xMax_Image_Stack = xLim(2);
    handles.yMin_Image_Stack = yLim(1);
    handles.yMax_Image_Stack = yLim(2);
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function New_Tag_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to New_Tag_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.Name, handles.Path] = uigetfile([handles.Path '\*.tif;*.tiff;*.dat'],'Load Elementary Spectrum Measured Image');
handles.Stack_Title          = {};
handles.Spectrum             = [];

handles.ES_Obj      = Elementary_Spectrum_O;
handles.ES_Obj.Path = handles.Path;
handles.ES_Obj.Name = handles.Name;
handles.ES_Obj      = handles.ES_Obj.getWavelength;
handles.Wavelength  = handles.ES_Obj.Wavelength;
handles.WL_Index    = handles.ES_Obj.iOriginal_WL;

[handles.Image_Stack, ~, ~, ~] = Loading_Spectral_Files (handles.Path, handles.Name, 'any', handles.WL_Index, [], [], handles.Horizontal_Shift);
Image_to_Plot                = handles.Image_Stack(:,:,1);
handles.imHandle             = Plot_Data(handles.Image_Stack_Axes, Image_to_Plot, [0,0,0,0]);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function Load_Tag_Image_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Load_Tag_Image_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[handles.Name, handles.Path] = uigetfile([handles.Path '\*.tif;*.tiff;*.dat'],'Load Elementary Spectrum Measured Image');

if ~isfield(handles, 'ES_Obj')
    handles.ES_Obj               = Elementary_Spectrum_O;
    handles.ES_Obj.Path          = Path;
    handles.ES_Obj.Name          = handles.Name;
    [Wavelength, WL_Index, ~, ~] = handles.ES_Obj.getWavelength;
    handles.ES_Obj.Wavelength    = Wavelength;
    handles.Wavelength           = Wavelength;
    handles.WL_Index             = WL_Index;
end;

[handles.Image_Stack, ~, ~, ~] = Loading_Spectral_Files (handles.Path, handles.Name, 'any', handles.WL_Index, [], [], handles.Horizontal_Shift);

Image_to_Plot                = handles.Image_Stack(:,:,1);
handles.imHandle             = Plot_Data(handles.Image_Stack_Axes, Image_to_Plot, [0,0,0,0]);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function Plot_Spect_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Plot_Spect_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles, 'currSpectrum')
    figure; plot(handles.Wavelength,handles.currSpectrum);
end;

% --------------------------------------------------------------------
function Add_Spect_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Add_Spect_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isfield(handles, 'Spectrum')
    handles.Spectrum = [];
end;

xCord = num2str(round(mean(handles.Polygon(:,1))));
yCord = num2str(round(mean(handles.Polygon(:,2))));

if strcmp(handles.Name(end-2:end),'dat')
    BS          = strfind(handles.Path, '\');
    Stack_Title = [handles.Path(BS(end-1)+1:BS(end-1)+15) '_x' xCord '_y' yCord];
else
    Stack_Title = [handles.Name(1:15) '_x' xCord '_y' yCord];
end;

Found_Spect_Title   = strcmp(Stack_Title, handles.Stack_Title);
if isempty(find(Found_Spect_Title))
    handles.Stack_Title = [handles.Stack_Title, Stack_Title];
    handles.Spectrum    = [handles.Spectrum handles.currSpectrum];
    h = msgbox('Spectrum Added', 'Check');
else
    h = msgbox('The spectrum already exists', 'Warning');
end;

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Calc_Tag_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Calc_Tag_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.StandAlone
    handles.Calc_Tag_fHandle = Calculate_Tag(handles.Spectrum, handles.Stack_Title, handles.ES_Obj, handles.output);
else
    handles.Calc_Tag_fHandle = Calculate_Tag(handles.Spectrum, handles.Stack_Title, handles.ES_Obj, handles.mwFigureH);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% The GUI is no longer waiting, just close it
delete(hObject);
