function varargout = Curve_Plot(varargin)
% CURVE_PLOT MATLAB code for Curve_Plot.fig
%      CURVE_PLOT, by itself, creates a new CURVE_PLOT or raises the existing
%      singleton*.
%
%      H = CURVE_PLOT returns the handle to a new CURVE_PLOT or the handle to
%      the existing singleton*.
%
%      CURVE_PLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CURVE_PLOT.M with the given input arguments.
%
%      CURVE_PLOT('Property','Value',...) creates a new CURVE_PLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Curve_Plot_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Curve_Plot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Curve_Plot

% Last Modified by GUIDE v2.5 27-Feb-2015 23:05:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Curve_Plot_OpeningFcn, ...
                   'gui_OutputFcn',  @Curve_Plot_OutputFcn, ...
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


% --- Executes just before Curve_Plot is made visible.
function Curve_Plot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Curve_Plot (see VARARGIN)

% Choose default command line output for Curve_Plot
handles.output = hObject;

xAxis      = varargin{1};
yAxis      = varargin{2};
Titles     = varargin{3};
xLabel     = Titles{1};
yLabel     = Titles{2};
Plot_Title = Titles{3};
Legend     = varargin{4};
if nargin < 5, handles.Path = '.';    else handles.Path = varargin{5}; end;
if nargin < 6, handles.Name = 'Plot'; else handles.Name = varargin{6}; end;

cla(handles.Sample_Plot_Axes);

axes(handles.Sample_Plot_Axes);
if size(yAxis,2) > 1
    plot(xAxis,yAxis(:,1),'*'); hold on;
    plot(xAxis,yAxis(:,2:end)); hold off;
    legend(Legend,'Location','Best');
    legend('boxoff');
else
    plot(xAxis,yAxis);
end;

axis tight; ylabel(yLabel); xlabel(xLabel);
title(Plot_Title{2});
set(hObject, 'Name', ['Single Pixel UnMixing - ' Plot_Title{1}])

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Curve_Plot wait for user response (see UIRESUME)
% uiwait(handles.Curve_Plot_Fig);


% --- Outputs from this function are returned to the command line.
function varargout = Curve_Plot_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function Save_Icon_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to Save_Icon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

print(handles.Curve_Plot_Fig, '-dpng', [handles.Path '\' handles.Name '.png']);

% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close Curve_Plot_Fig.
function Curve_Plot_Fig_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to Curve_Plot_Fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
