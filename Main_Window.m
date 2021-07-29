function varargout = Main_Window(varargin)

addpath(genpath('.\eSpectra_Module'));
addpath(genpath('.\ROI_Manager'));
addpath(genpath('.\GUI_Standard_Windows_and_Tools'));
addpath(genpath('.\Unmix_Tool_Kit'));
addpath(genpath('.\FICoS_Tool_Kit'));
addpath(genpath('.\Settings'));
addpath(genpath('.\Peak_Selections_Software'));

Main_Console = figure('Name','FICoS Spectrometry Suite', 'Tag','Main_Console', 'Position',[700, 50, 170, 615], 'Menubar','none', ...
                      'Toolbar','none', 'numbertitle','off', 'CloseRequestFcn',{@Main_Console_CloseRequestFcn});
                           
handles = guihandles(Main_Console);
handles = Initiate_mainWindow(handles);

Settings_Menu = uimenu(Main_Console, 'Label', 'Settings', 'Callback', {@Settings_Menu_Callback});
handles.Settings_Menu = Settings_Menu;

Button_Height = 128;
Button_length = 128;

[eSpect_Icon_Image, ~] = imread('.\Icons\Elementary_Spectra_Icon_128x128_2.png');
eSpect_pButton         = uicontrol('Parent',Main_Console, 'Tag','eSpect_pButton', ...
                                   'Style','pushbutton',...
                                   'cdata',eSpect_Icon_Image, 'TooltipString','Elementary Sepctra Generator', ...
                                   'Position',[21, 468, Button_length, Button_Height], 'Units','pixels',...
                                   'Visible','on', 'FontSize',10,...
                                   'Callback',{@eSpect_pButton_Callback});
handles.eSpect_pButton = eSpect_pButton;

[UnMix_Icon_Image, ~] = imread('.\Icons\Unmix_Icon_3_128x128.png');
UnMix_pButton         = uicontrol('Parent',Main_Console, 'Tag','UnMix_pButton', ...
                                  'Style','pushbutton',...
                                  'cdata',UnMix_Icon_Image, 'TooltipString','Un-Mixing', ...
                                  'Position',[21, 319, Button_length, Button_Height], 'Units','pixels',...
                                  'Visible','on', 'FontSize',10,...
                                  'Callback',{@UnMix_pButton_Callback});
handles.UnMix_pButton = UnMix_pButton;

[ROI_Manager_Icon, ~] = imread('.\Icons\Polygon_128x128_3.png');
ROI_Manager_pButton = uicontrol('Parent',Main_Console, 'Tag','ROI_Manager_pButton', ...
                                'Style','pushbutton',...
                                'cdata',ROI_Manager_Icon, 'TooltipString','ROI Manager and Segmentation', ...
                                'Position',[21, 170, Button_length, Button_Height], 'Units','pixels',...
                                'Visible','on', 'FontSize',10,...
                                'Callback',{@ROI_Manager_pButton_Callback});
handles.ROI_Manager_pButton = ROI_Manager_pButton;

[FICoS_Calc_Icon_Image, ~] = imread('.\Icons\Plotting_Menu_pButton_128x128_2.png');
FICoS_Calc_pButton = uicontrol('Parent',Main_Console, 'Tag','FICoS_Calc_pButton', ...
                               'Style','pushbutton',...
                               'cdata',FICoS_Calc_Icon_Image, 'TooltipString','FICoS Calculator', ...
                               'Position',[21, 21, Button_length, Button_Height], 'Units','pixels',...
                               'Visible','on', 'FontSize',10,...
                               'Callback',{@FICoS_Calc_pButton_Callback});
handles.FICoS_Calc_pButton = FICoS_Calc_pButton;

handles.output = Main_Console;
Licensed = Check_License; 
if ~Licensed
    set(handles.eSpect_pButton,      'Enable', 'off');
    set(handles.UnMix_pButton,       'Enable', 'off');
    set(handles.ROI_Manager_pButton, 'Enable', 'off');
    set(handles.FICoS_Calc_pButton,  'Enable', 'off');
    set(handles.Settings_Menu,       'Enable', 'off');
end %**************************** Remember to uncomment ******

guidata(Main_Console, handles);

varargout{1} = Main_Console;

function Main_Console_CloseRequestFcn(hObject, eventdata)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles = guidata(hObject);

delete(hObject);