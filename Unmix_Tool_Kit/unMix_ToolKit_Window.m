function varargout = unMix_ToolKit_Window(varargin)

UM_TK_FigureH   = figure('Name','UnMix Toolkit','NumberTitle','off', ...
                         'MenuBar', 'none', 'ToolBar', 'none', 'Units', 'Pixels', ...
                         'Position', [100, 100, 500, 700], 'Tag', 'UM_TK_FigureH');

handles           = guihandles(UM_TK_FigureH);
if nargin > 0, mwHandles = guidata(varargin{1}); handles.mwFigureH = varargin{1}; handles.StandAlone = false; 
else mwHandles = []; handles.StandAlone = true;
end;
handles.output    = UM_TK_FigureH;
guidata(UM_TK_FigureH, handles);
Scene_List_lBox   = uicontrol('Style', 'listbox', 'Parent', UM_TK_FigureH, 'Value', 1, 'Units', 'normalized', ...
                              'Position', [0 0 1 1], 'Max', 5, 'Tag', 'Scene_List_lBox', ...
                              'FontSize', 10, 'Callback',@Scene_List_lBox_Callback);
handles.Scene_List_lBox = Scene_List_lBox;

UM_TK_Toolbar            = uitoolbar(UM_TK_FigureH);
Load_Scene_Icon          = uipushtool(UM_TK_Toolbar,'TooltipString','Load',...
                                      'ClickedCallback', @Load_Scene_Icon_Callback);
Load_Scene_Icon_cData    = imread('.\Icons\open_icon.png');
Load_Scene_Icon.CData    = Load_Scene_Icon_cData;

Load_ES_Icon             = uipushtool(UM_TK_Toolbar,'TooltipString','Load Elementary Spectra',...
                                      'ClickedCallback', @Load_ES_Icon_Callback);
Load_ES_Icon_cData       = imread('.\Icons\Elementar_Spectra_Icon_16x16.png');
Load_ES_Icon.CData       = Load_ES_Icon_cData;

UnMix_Icon               = uipushtool(UM_TK_Toolbar,'TooltipString','Pixel Level Unmixing',...
                                      'ClickedCallback', @UnMix_Icon_Callback);
UnMix_Icon_cData         = imread('.\Icons\UnMix_16x16.png');
UnMix_Icon.CData         = UnMix_Icon_cData;

UM_Del_Scenes_Icon       = uipushtool(UM_TK_Toolbar,'TooltipString','Delete Scenes',...
                                      'ClickedCallback', @UM_Del_Scenes_Icon_Callback);
[Minus_Image,~]           = imread('.\Icons\Minus_16x16_2.png');
Minus_Image(Minus_Image == 255) = 240;
UM_Del_Scenes_Icon.CData = Minus_Image;

UM_Settings_Icon         = uipushtool(UM_TK_Toolbar,'TooltipString','Settings',...
                                     'ClickedCallback', @UM_Settings_Icon_Callback);
UM_Settings_Icon_cData   = imread('.\Icons\Settings_16x16.png');
UM_Settings_Icon_cData(UM_Settings_Icon_cData == 255) = 240; %   = 255-UM_Settings_Icon_cData;
UM_Settings_Icon.CData   = UM_Settings_Icon_cData;


handles = Initiate_Window_Param(handles, mwHandles);

guidata(UM_TK_FigureH, handles);

varargout{1} = UM_TK_FigureH;
end

function Scene_List_lBox_Callback(hObject, eventdata)
handles = guidata(hObject);

handles.Scene_Index = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);
end

function Load_ES_Icon_Callback(hObject, eventdata)
handles = guidata(hObject);

if handles.StandAlone, eSpectra = handles.eSpectra; Use_Fitted_Spect = handles.Use_Fitted_Spect; 
else mwHandles = guidata(handles.mwFigureH);
    if isfield(mwHandles, 'eSpectra'), eSpectra = mwHandles.eSpectra; else eSpectra = []; end
    Use_Fitted_Spect = mwHandles.UM_Params.Use_Fitted_Spect;
end
    
% handles.eSpectra = AddRemove_Tags(handles.eSpectra, handles.currPath);
% handles.currPath = handles.eSpectra(end).Path;
% handles.Spectrum = [handles.eSpectra.Spectrum];
% for ii = 1:size(handles.Spectrum,2)
%     if handles.Use_Fitted_Spect
%         if ~isempty(handles.eSpectra(ii).Fit)
%             handles.Spectrum(:,ii) = handles.eSpectra(ii).Fit;
%         end
%     end
% end
% esWavelength     = [handles.eSpectra.Wavelength];
eSpectra = AddRemove_Tags(eSpectra, handles.currPath);
currPath = eSpectra(end).Path;
Spectrum = [eSpectra.Spectrum];
for ii = 1:size(Spectrum,2)
    if Use_Fitted_Spect
        if ~isempty(eSpectra(ii).Fit)
            Spectrum(:,ii) = eSpectra(ii).Fit;
        end
    end
end
esWavelength     = [eSpectra.Wavelength];
handles.Spectrum = Spectrum;
if isfield(handles, 'Scene_Inst')
    if ~isempty(handles.Scene_Inst) && ~(length(handles.Scene_Inst) == 1 && isempty(handles.Scene_Inst(handles.Scene_Index).Wavelength))
        imWavelength     = handles.Scene_Inst(handles.Scene_Index).Wavelength;
%         for ii = 1:length(handles.eSpectra)
        for ii = 1:length(eSpectra)
            if sum(esWavelength(:,ii)-imWavelength) ~= 0
%                 handles.Spectrum(:,ii)          = interp1(esWavelength(:,ii),handles.Spectrum(:,ii), imWavelength, 'cubic', 'extrap');
%                 handles.eSpectra(ii).Spectrum   = handles.Spectrum(:,ii);
%                 handles.eSpectra(ii).Wavelength = imWavelength;
                Spectrum(:,ii)          = interp1(esWavelength(:,ii), Spectrum(:,ii), imWavelength, 'cubic', 'extrap');
                handles.Spectrum(:,ii)  = Spectrum(:,ii);
                eSpectra(ii).Spectrum   = Spectrum(:,ii);
                eSpectra(ii).Wavelength = imWavelength;
            end;
        end;
    end
end;
% handles.ES_Names = {handles.eSpectra.Name};
handles.ES_Names = {eSpectra.Name};

if handles.StandAlone, handles.eSpectra = eSpectra; handles.currPath = currPath;
else mwHandles.eSpectra = eSpectra; mwHandles.curr_Path = currPath; guidata(handles.mwFigureH, mwHandles);
end

% Update handles structure
guidata(hObject, handles);

end