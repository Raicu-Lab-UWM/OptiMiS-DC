function varargout = Metahist_gui(varargin)
% addpath(genpath('.\'));
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Metahist_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Metahist_gui_OutputFcn, ...
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


% --- Executes just before Metahist_gui is made visible.
function Metahist_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Metahist_gui (see VARARGIN)

% Choose default command line output for Metahist_gui
handles.output = hObject;

default(hObject, handles); % call the default function which is at the end of this code.
handles.Bin_origin  = str2double(get(handles.Bin_origin,'String'));  % extract value from structure
handles.Bin_size    = str2double(get(handles.Bin_size,'String'));
handles.Xa_min      = str2double(get(handles.Xa_min,'String'));
handles.Xa_max      = str2double(get(handles.Xa_max,'String'));
handles.Conc_min    = str2double(get(handles.Conc_min,'String'));
handles.Conc_max    = str2double(get(handles.Conc_max,'String'));


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Metahist_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Metahist_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Optimize_pushbutton.
function Optimize_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Optimize_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Eapp_peaks  = Sort_EappPeaks_wConc_andXa_peakLevel(handles);
[bin_origin, visibility, Optm_Metabins, Optm_Metahist,Optm_origin, Optm_pkposn] = Optimize_metaHist_origin_fixBinsize_func(handles, 'Not Normalized', 'Visibility with peak only');
handles.Optm_MetaHist_plot = [Optm_Metabins, Optm_Metahist];
handles.Visibility_plot    = [bin_origin', visibility'];
handles.Optm_origin        = Optm_origin;
guidata(hObject,handles);

function Xa_max_Callback(hObject, eventdata, handles)
% hObject    handle to Xa_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Xa_max = str2double(get(hObject,'String')); 
handles.Xa_max = Xa_max;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Xa_max as text
%        str2double(get(hObject,'String')) returns contents of Xa_max as a double


% --- Executes during object creation, after setting all properties.
function Xa_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xa_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xa_min_Callback(hObject, eventdata, handles)
% hObject    handle to Xa_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Xa_min = str2double(get(hObject,'String')); 
if isnan(Xa_min)
  set(handles.Xa_min,'String','0');
end
handles.Xa_min = Xa_min;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Xa_min as text
%        str2double(get(hObject,'String')) returns contents of Xa_min as a double


% --- Executes during object creation, after setting all properties.
function Xa_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xa_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Conc_min_Callback(hObject, eventdata, handles)
% hObject    handle to Conc_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Conc_min = str2double(get(hObject,'String')); 
if isnan(Conc_min)
  set(handles.Conc_min,'String','0');
end
handles.Conc_min = Conc_min;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Conc_min as text
%        str2double(get(hObject,'String')) returns contents of Conc_min as a double


% --- Executes during object creation, after setting all properties.
function Conc_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Conc_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Conc_max_Callback(hObject, eventdata, handles)
% hObject    handle to Conc_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Conc_max = str2double(get(hObject,'String')); 
if isnan(Conc_max)
  set(handles.Conc_max,'String','8');
end
handles.Conc_max = Conc_max;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Conc_max as text
%        str2double(get(hObject,'String')) returns contents of Conc_max as a double


% --- Executes during object creation, after setting all properties.
function Conc_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Conc_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bin_size_Callback(hObject, eventdata, handles)
% hObject    handle to Bin_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Bin_size = str2double(get(hObject,'String')); 
% if isnan(Bin_size)
%   Bin_size = set(handles.Bin_size,'String',0.015);
% end
handles.Bin_size = Bin_size;
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of Bin_size as text
%        str2double(get(hObject,'String')) returns contents of Bin_size as a double


% --- Executes during object creation, after setting all properties.
function Bin_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bin_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Bin_origin_Callback(hObject, eventdata, handles)
% hObject    handle to Bin_origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Bin_origin as text
%        str2double(get(hObject,'String')) returns contents of Bin_origin as a double
Bin_origin = str2double(get(hObject,'String')); 
% if isnan(Bin_origin)
%   set(handles.Bin_origin,'String','0.005');
% end
handles.Bin_origin = Bin_origin;
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Bin_origin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Bin_origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Plot_pushbutton.
function Plot_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Eapp_peaks  = Sort_EappPeaks_wConc_andXa_peakLevel(handles); %randn(100,1);
meta_bin         = handles.Bin_origin:handles.Bin_size :handles.Bin_origin+1;
metaHist         = histc(round(handles.Eapp_peaks*1000),round(meta_bin*1000));
bin_cntr         = meta_bin+(handles.Bin_size/2); % midpoint position for each bins
axes(handles.axes)
hold( handles.axes, 'on' )   % will not remove last plot
if length(handles.Selc_data) == 1 % data name when only one data is selcted from data list
    data_name = handles.Selc_data{1}(1:end-5);
    data_name = split(data_name,'_');
    data_name = data_name{end};
else
    data_name = [];
end
leg_name = sprintf('%s%s%d%s%d%s%.3f%s%.3f',data_name,'-Conc',handles.Conc_min,'-',handles.Conc_max,'-Bin',...
    handles.Bin_size,'-Origin', handles.Bin_origin);
handles.plot1 = plot(bin_cntr, metaHist,'o-', 'LineWidth', 2, 'DisplayName',leg_name);
xlabel('Eapp','FontSize', 16);
ylabel('No of peaks','FontSize', 16);
xlim([0,1]);
legend('Location','Northoutside', 'FontSize', 8)
handles.Plot_metaHist = [bin_cntr', metaHist];

TotalEvents = sum(metaHist);
set(handles.TotalEvents, 'String',num2str(TotalEvents));

guidata(hObject,handles);

% --- Executes on selection change in DataList.
function DataList_Callback(hObject, eventdata, handles)
% hObject    handle to DataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.DataList,'Max',100,'Min',1);
Load_data = {};  % otherwise incase of single file Load_data will not be cell array
Load_data = [Load_data, get(handles.DataList,'String')];
Selc_data = Load_data(get(handles.DataList,'Value'));

handles.Selc_data = Selc_data;
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns DataList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from DataList


% --- Executes during object creation, after setting all properties.
function DataList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DataList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in AddData_pushbutton.
function AddData_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AddData_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[name, Path]      = uigetfile('.\*.xls;*.xlsx', 'Load Excel file',...
    'MultiSelect', 'on');
set(handles.DataList, 'String',name);

% handles.name = name;
handles.Path = Path;
guidata(hObject,handles);


% --- Executes on button press in RemoveData_pushbutton.
function RemoveData_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveData_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = {};
a = [a, get(handles.DataList,'String')];
c = get(handles.DataList,'Value');
% selected = a(c);
choice   = a(1:end ~=c);
% choice(c,:) = [];
set(handles.DataList,'Value',1)
set(handles.DataList,'String',choice)

% --------------------------------------------------------------------
function Save_MetaHist_Callback(hObject, eventdata, handles)
% hObject    handle to Save_MetaHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Plot_data_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Plot_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Name, selpath] = uiputfile({'*.txt';'*.*'},'Save Plot data to: and write data name');
myName = sprintf('%s%d%s%d%s%.3f%s%.3f','EappMetaHist_Conc',handles.Conc_min,'-',handles.Conc_max,'BinSize',...
    handles.Bin_size,'BinOrigin', handles.Bin_origin, Name);
writematrix(handles.Plot_metaHist,[selpath '\' myName],'Delimiter','\t');

% --------------------------------------------------------------------
function Save_Optimized_data_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Optimized_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Name, sel_path] = uiputfile({'*.txt';'*.*'},'Save Optimized data to: and write data name');
myName = sprintf('%s%d%s%d%s%.3f%s%.3f','Optimized_EappMetaHist_Conc',handles.Conc_min,'-',handles.Conc_max,'BinSize',...
    handles.Bin_size,'BinOrigin', handles.Optm_origin, Name);
mysecName = sprintf('%s%d%s%d%s%.3f','Visibility_Conc',handles.Conc_min,'-',handles.Conc_max,'BinSize',...
    handles.Bin_size, Name);
writematrix(handles.Optm_MetaHist_plot,[sel_path '\' myName],'Delimiter','\t');
writematrix(handles.Visibility_plot,[sel_path '\' mysecName],'Delimiter','\t');



function TotalEvents_Callback(hObject, eventdata, handles)
% hObject    handle to TotalEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of TotalEvents as text
%        str2double(get(hObject,'String')) returns contents of TotalEvents as a double



% --- Executes during object creation, after setting all properties.
function TotalEvents_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearPlot_pbutton.
function ClearPlot_pbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearPlot_pbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 

% delete(handles.plot1); % clear last plot only
cla(handles.axes); % clear all plots plotted in axes.
set(handles.TotalEvents, 'String', '') 
% --------------------------------------------------------------------
function Settings_Metahist_Callback(hObject, eventdata, handles)
% hObject    handle to Settings_Metahist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subgui_handle      = Setting_window;
subgui_data_handle =guidata(subgui_handle); %points to the handles of the subgui
subgui_data_handle.main_gui_handle=hObject; %hObject=handle to main gui
guidata(subgui_handle, subgui_data_handle); %update subgui's handles

function default(hObject, handles)
    set(handles.Conc_min, 'string', 0);
    set(handles.Conc_max, 'string', 16);
    set(handles.Xa_min, 'string', 0);
    set(handles.Xa_max, 'string', 1);
    set(handles.Bin_size, 'string', 0.015);
    set(handles.Bin_origin, 'string', 0.005);
guidata(hObject, handles);

