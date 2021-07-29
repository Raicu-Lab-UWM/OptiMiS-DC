function eSpect_pButton_Callback(hObject, eventdata, handles)

ES_Tool_Kit_FigH   = figure('units','pixels', 'Tag', 'ES_Tool_Kit_FigH', ...
                            'position',[750 500 250 160],...
                            'menubar','none',...
                            'name','Elementary Spectra Tool Kit',...
                            'numbertitle','off');

esHandles            = guihandles(ES_Tool_Kit_FigH);

esHandles.output     = ES_Tool_Kit_FigH;
esHandles.StandAlone = true;
if nargin > 0
    esHandles.mwFigureH  = hObject; 
    if isvalid(esHandles.mwFigureH)
        esHandles.StandAlone = false;
        guidata(ES_Tool_Kit_FigH, esHandles);
    end
end
esHandles            = ES_Initiate(ES_Tool_Kit_FigH); guidata(ES_Tool_Kit_FigH, esHandles);

Button_Height      = 50;
Button_length      = 50;

[New_ES_Icon_Image, ~] = imread('.\Icons\New_ES_Icon_50x50.png');
New_ES_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'New_ES_pButton', ...
                     'Style','pushbutton',...
                     'cdata', New_ES_Icon_Image, 'TooltipString', 'Create Elementary Sepctrum', ...
                     'Position',[30, 90, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@New_ES_pButton_Callback});

[ES_Info_Image, ~] = imread('.\Icons\ES_Info_Icon_Image_50x50.png');
ES_Info_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'ES_Info_pButton', ...
                     'Style','pushbutton',...
                     'cdata', ES_Info_Image, 'TooltipString', 'Elementary Spectrum Info', ...
                     'Position',[100, 90, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@ES_Info_pButton_Callback});

[Export_ES_Info_Icon_Image, ~] = imread('.\Icons\Export_ES_Icon_50x50.png');
Export_ES_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'Export_ES_pButton', ...
                     'Style','pushbutton',...
                     'cdata', Export_ES_Info_Icon_Image, 'TooltipString', 'Export Elementary Sepctrum Info', ...
                     'Position',[170, 90, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@Export_ES_pButton_Callback});

[Load_ES_Icon_Image, ~] = imread('.\Icons\Load_Curves_Icon_50x50_2.png');
Load_ES_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'Load_ES_pButton', ...
                     'Style','pushbutton',...
                     'cdata', Load_ES_Icon_Image, 'TooltipString', 'Load Elementary Spectrum Info', ...
                     'Position',[30, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@Load_ES_pButton_Callback});

[Save_ES_Info_Image, ~] = imread('.\Icons\Save_Button_50x50_6.png');
Save_FRET_Hist_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'Save_ES_pButton', ...
                     'Style','pushbutton',...
                     'cdata', Save_ES_Info_Image, 'TooltipString', 'Save Elementary Spectrum Info ', ...
                     'Position',[100, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@Save_ES_pButton_Callback});

[Settings_Icon_Image, ~] = imread('.\Icons\Setting_Icon_50x50_5.png');
Setting_pButton = uicontrol('Parent', ES_Tool_Kit_FigH, 'Tag', 'Setting_pButton', ...
                     'Style','pushbutton',...
                     'cdata', Settings_Icon_Image, 'TooltipString', 'Setting Elementary Spectrum Parameters', ...
                     'Position',[170, 20, Button_length, Button_Height], 'Units','pixels',...
                     'Visible','on',...
                     'FontSize', 10,...
                     'Callback', {@Setting_ES_pButton_Callback, ES_Tool_Kit_FigH});

guidata(ES_Tool_Kit_FigH, esHandles); 
end

function New_ES_pButton_Callback(hObject, eventdata)
handles    = guidata(hObject);

if handles.StandAlone, Tag_Display(handles.output); 
else Tag_Display(handles.mwFigureH);
end
end

function Save_ES_pButton_Callback(hObject, eventdata)
handles = guidata(hObject);

if handles.StandAlone, curr_Path = handles.curr_Path;
    ES_Obj = handles.ES_Obj;
else mwHandles = guidata(handles.mwFigureH); 
    curr_Path = mwHandles.curr_Path;
    ES_Obj    = mwHandles.ES_Obj;
end
if isempty(curr_Path), curr_Path = '.\'; end;
if isempty(ES_Obj.Path), curr_Path = uigetdir(curr_Path,'Save Elementary Spectrum at:');
    ES_Obj.Path = curr_Path;
else curr_Path = ES_Obj.Path;
end
ES_Obj.Spectrum = ES_Obj.Spectrum/max(ES_Obj.Spectrum);
if isempty(ES_Obj.Spectral_Integral) || isnan(ES_Obj.Spectral_Integral);
    Spc  = ES_Obj.Spectrum;
    WL   = ES_Obj.Wavelength;
    D_WL = WL(2:end)-WL(1:end-1);
    ES_Obj.Spectral_Integral = sum(D_WL.*(Spc(1:end-1)+Spc(2:end))/2);
    ES_Obj.Spectral_Integral(handles.ES_Obj.Spectral_Integral < 0) = -handles.ES_Obj.Spectral_Integral;
end
if handles.StandAlone
    handles.ES_Obj    = ES_Obj;
    handles.curr_Path = curr_Path;
    handles.ES_Obj.saveobj(curr_Path);
else mwHandles.ES_Obj   = ES_Obj;
    mwHandles.curr_Path = curr_Path;
    mwHandles.ES_Obj.saveobj(curr_Path);
    guidata(handles.mwFigureH, mwHandles);
end

guidata(hObject, handles);
end

function Export_ES_pButton_Callback(hObject, eventdata)
handles = guidata(hObject);

if handles.StandAlone, curr_Path = handles.curr_Path;
else mwHandles = guidata(handles.mwFigureH);
    curr_Path = mwHandles.curr_Path;
end
if isempty(curr_Path), curr_Path = '.\'; end;
curr_Path = uigetdir(curr_Path);
if handles.StandAlone, handles.ES_Obj.expElementart_Spectrum(curr_Path); else mwHandles.ES_Obj.expElementart_Spectrum(curr_Path); end
if handles.StandAlone, handles.curr_Path = curr_Path; else mwHandles.curr_Path = curr_Path; guidata(handles.mwFigureH, mwHandles); end

guidata(hObject, handles);
end