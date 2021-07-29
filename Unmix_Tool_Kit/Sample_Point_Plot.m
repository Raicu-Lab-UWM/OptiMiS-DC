function varargout = Sample_Point_Plot(varargin)
% SAMPLE_POINT_PLOT MATLAB code for Sample_Point_Plot.fig
%      SAMPLE_POINT_PLOT, by itself, creates a new SAMPLE_POINT_PLOT or raises the existing
%      singleton*.
%
%      H = SAMPLE_POINT_PLOT returns the handle to a new SAMPLE_POINT_PLOT or the handle to
%      the existing singleton*.
%
%      SAMPLE_POINT_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE_POINT_PLOT.M with the given input arguments.
%
%      SAMPLE_POINT_PLOT('Property','Value',...) creates a new SAMPLE_POINT_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Sample_Point_Plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Sample_Point_Plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Sample_Point_Plot

% Last Modified by GUIDE v2.5 30-Oct-2012 12:45:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Sample_Point_Plot_OpeningFcn, ...
                   'gui_OutputFcn',  @Sample_Point_Plot_OutputFcn, ...
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


% --- Executes just before Sample_Point_Plot is made visible.
function Sample_Point_Plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Sample_Point_Plot (see VARARGIN)

% Choose default command line output for Sample_Point_Plot
handles.output = hObject;

mHandles                   = varargin{1};
handles.Image              = mHandles.Image;
handles.Background_Obj     = mHandles.Background_Obj;
handles.Threshold          = mHandles.Threshold;
handles.Coeff              = mHandles.Coeff;
handles.Tags_For_Unmix     = mHandles.Tags_For_Unmix;
handles.Tags_Names         = mHandles.Tags_Names;
handles.Ana_Path           = mHandles.Ana_Path;
handles.Number_of_Tags     = mHandles.Number_of_Tags;
handles.Indiv_Folder_Image = mHandles.Indiv_Folder_Image;
handles.Auto_BKGD          = mHandles.Auto_BKGD;
handles.Wavelength         = mHandles.Wavelength;
handles.Image_Info         = mHandles.Image_Info(mHandles.Image_Counter);
handles.x                  = varargin{2};
handles.y                  = varargin{3};
handles.FM                 = [];
handles.Pushed             = 0;
handles.Zero_Neg           = mHandles.Zero_Neg;
handles.Unmix_Method       = mHandles.Unmix_Method;

set(handles.BackGround_Slider,    'Min',    min(min(min(handles.Image))));
set(handles.Min_BackGround_Edit,  'String', min(min(min(handles.Image))));
set(handles.BackGround_Slider,    'Max',    max(max(max(handles.Image))));
set(handles.Max_Background_Edit,  'String', max(max(max(handles.Image))));
set(handles.Value_Background_Edit,'String', handles.Background_Obj.Value);
set(handles.BackGround_Slider,    'Value',  handles.Background_Obj.Value);

handles                    = Plot_Rep_Pixels_UnSave (handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Sample_Point_Plot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Sample_Point_Plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Save_PButton.
function Save_PButton_Callback(hObject, eventdata, handles)
% hObject    handle to Save_PButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strx      = int2str(int16(handles.x));
stry      = int2str(int16(handles.y));
nColunms  = size(handles.Tags_For_Unmix,2)+4;
nRows     = size(handles.Wavelength,1);

Image_Name = handles.Image_Info.Extract_imName;
if handles.Indiv_Folder_Image
    [Success,Messege,Message_ID] = mkdir(handles.Ana_Path,Image_Name);
    Path_Name                    = [handles.Ana_Path '\' Image_Name];
else
    Path_Name                    = handles.Ana_Path;
end;
t    = strcat(Path_Name,'\',Image_Name, '_FM_x_', strx, '_y_', stry);
print(handles.figure1,'-dtiff',t);
dlmwrite([Path_Name '\' Image_Name '_FM_x_' strx '_y_' stry '.txt'], [handles.Wavelength handles.FM], 'delimiter', '\t', 'precision', 6);

fName                                      = ['Point_Unmixings.xls'];
Sheet_Name                                 = [Image_Name(10:15) '_TH_' num2str(handles.Threshold) '_Pix_x' strx '_y' stry];
pUnmixing_Data_Excel                       = {};
pUnmixing_Data_Excel(1,1:nColunms)         = ['Wavelength', 'Row Data', handles.Tags_Names, 'Fitted Curve', 'Background'];
if handles.Auto_BKGD
    pUnmixing_Data_Excel_Val = mat2cell([handles.Wavelength, handles.FM, handles.Background_Obj.Image_Value(uint16(handles.y),uint16(handles.x))*ones(size(handles.Wavelength))],ones(nRows,1),ones(1,nColunms));
else
    pUnmixing_Data_Excel_Val = mat2cell([handles.Wavelength, handles.FM, handles.Background_Obj.Image_Value*ones(size(handles.Wavelength))],ones(nRows,1),ones(1,nColunms));
end;
pUnmixing_Data_Excel(2:nRows+1,1:nColunms) = pUnmixing_Data_Excel_Val;
xlswrite([Path_Name '\' fName],pUnmixing_Data_Excel, Sheet_Name, 'B3');

% --- Executes on button press in Close_PButton.
function Close_PButton_Callback(hObject, eventdata, handles)
% hObject    handle to Close_PButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0, 'BackGround', handles.Background_Obj.Value);

delete(handles.figure1)
% --- Executes on slider movement.
function BackGround_Slider_Callback(hObject, eventdata, handles)
% hObject    handle to BackGround_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.Background_Obj.Value = get(hObject,'Value');
set(handles.Value_Background_Edit ,'String', handles.Background_Obj.Value);

handles       = Calculate_UnMixing_Data(handles);
handles       = Calculate_Threshold(handles);
handles       = Plot_Rep_Pixels_UnSave (handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function BackGround_Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BackGround_Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Max_Background_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Max_Background_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Max_Background_Edit as text
%        str2double(get(hObject,'String')) returns contents of Max_Background_Edit as a double


% --- Executes during object creation, after setting all properties.
function Max_Background_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Max_Background_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Value_Background_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Value_Background_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Value_Background_Edit as text
%        str2double(get(hObject,'String')) returns contents of Value_Background_Edit as a double
handles.Background_Obj.Value = str2double(get(hObject,'String'));
set(handles.BackGround_Slider ,'Value', handles.Background_Obj.Value);

handles = Calculate_UnMixing_Data(handles);
handles = Calculate_Threshold(handles);
handles = Plot_Rep_Pixels_UnSave (handles);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function Value_Background_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Value_Background_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Min_BackGround_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Min_BackGround_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Min_BackGround_Edit as text
%        str2double(get(hObject,'String')) returns contents of Min_BackGround_Edit as a double


% --- Executes during object creation, after setting all properties.
function Min_BackGround_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Min_BackGround_Edit (see GCBO)
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

delete(hObject)

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
