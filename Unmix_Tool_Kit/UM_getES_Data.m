function UM_getES_Data(hObject, eventdata)

UM_ES_Info_FigH = figure('units','pixels', 'Tag', 'ES_Info_FigH', ...
                      'position',[750 500 400 320],...
                      'menubar','none',...
                      'name','Elementary Sepctra Info',...
                      'numbertitle','off');
set(UM_ES_Info_FigH, 'Units', 'normalized');

handles = guidata(hObject);

csnES = handles.eSpectra(handles.Chosen_ES);
if ~isfield(handles, 'eSpectra'), handles.eSpectra = Elementary_Spectrum_O; elseif isempty(handles.eSpectra), handles.eSpectra = Elementary_Spectrum_O; end;

Display_Info = struct('Name', csnES.Name, 'Description', csnES.Description, ...
                      'Quantum_Yield', csnES.Quantum_Yield, 'Spectral_Integral', csnES.Spectral_Integral, ...
                      'rIntensity', csnES.rIntensity, 'Maker', csnES.Maker, ...
                      'Date_of_Prep', csnES.Date_of_Prep, 'Method_of_Prep', csnES.Method_of_Prep, ...
                      'Spectrum', csnES.Spectrum, 'Wavelength', csnES.Wavelength);
rowNames             = {'Name', 'Description', 'Quantum Yield', 'Spectral Integral', 'Gamma', 'Maker', 'Date of Prep', 'Method of Prep'};
colNames             = {'Values'};
Display_Info_Table   = struct2cell(Display_Info);
Display_Info_uiTable = uitable('Parent', UM_ES_Info_FigH, 'Data', Display_Info_Table(1:length(rowNames),1), 'ColumnName', colNames, 'RowName', rowNames, ...
                               'Units', 'normalized', 'Position',[0 0 1 1], 'Tag', 'Display_Info_uiTable', 'ColumnWidth', {248}, ...
                               'ColumnEditable', true, ... , 'FontUnits', 'Normalized'
                               'CellEditCallback', {@Display_Info_uiTable_CellEditCallback, hObject});
Organize_uiTable (Display_Info_uiTable, 150);

[Spectrum_Displ_Image, ~] = imread('.\Icons\Spetrum_Displ_pButton.png');
Spectrum_Displ_pButtom = uicontrol('Parent', UM_ES_Info_FigH, 'Tag', 'Spectrum_Displ_pButton', ...
                                   'Style','pushbutton', 'cdata', Spectrum_Displ_Image, ... 
                                   'TooltipString', 'Disply Spectrum', ...
                                   'Units', 'normalized', 'Position',[0.3, 0.05, 0.13, 0.16], 'Units','pixels',...
                                   'Visible','on',...
                                   'Callback', {@Spectrum_Displ_pButton_Callback, hObject});

[Fit_Displ_Image, ~] = imread('.\Icons\Spetrum_Displ_pButton.png');
Fit_Displ_pButtom    = uicontrol('Parent', UM_ES_Info_FigH, 'Tag', 'Fit_Displ_pButton', ...
                                 'Style','pushbutton', 'cdata', Fit_Displ_Image, ... 
                                 'TooltipString', 'Disply Fitted Spectrum', ...
                                 'Units', 'normalized', 'Position',[0.6, 0.05, 0.13, 0.16], 'Units','pixels',...
                                 'Visible','on',...
                                 'Callback', {@Fit_Displ_pButton_Callback, hObject});
handles              = guidata(hObject);

guidata(hObject, handles);
end

function Display_Info_uiTable_CellEditCallback(hObject, eventdata, Main_FigureH)
handles = guidata(Main_FigureH);
rowNames = {'Name', 'Description', 'Quantum_Yield', 'Spectral_Integral', 'rIntensity', 'Maker', 'Date_of_Prep', 'Method_of_Prep'};
Data = get(hObject, 'Data');
ES_Struct = cell2struct(Data, rowNames, 1);

if ~isfield(handles, 'eSpectra'), handles.eSpectra = Elementary_Spectrum_O; elseif isempty(handles.eSpectra), handles.eSpectra = Elementary_Spectrum_O; end;
Field_Names = fieldnames(ES_Struct);
for ii = 1:size(Field_Names,1)
   if strcmp(Field_Names{ii},'Fabricator')
       handles.eSpectra(handles.Chosen_ES).Maker = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Date_of_prep')
       handles.eSpectra(handles.Chosen_ES).Date_of_Prep = ES_Struct.(Field_Names{ii});
   else
       handles.eSpectra(handles.Chosen_ES).(Field_Names{ii}) = ES_Struct.(Field_Names{ii});
   end;
end;
guidata(Main_FigureH, handles);
end

function Spectrum_Displ_pButton_Callback(hObject, eventdata, Main_FigureH)

handles = guidata(Main_FigureH);

Spectrum_Disp_FigureH = Plot_Window_Generic ([handles.eSpectra(handles.Chosen_ES).Name ' - Spectrum'], Main_FigureH);
Spectrum_Disp_AxesH   = axes('Parent', Spectrum_Disp_FigureH, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85], 'Tag', 'Spectrum_Disp_AxesH');
plot(Spectrum_Disp_AxesH, handles.eSpectra(handles.Chosen_ES).Wavelength, handles.eSpectra(handles.Chosen_ES).Spectrum);
xlabel(Spectrum_Disp_AxesH, 'Wavelength [nm]');
ylabel(Spectrum_Disp_AxesH, 'N. Power Spectrum');
end

function Fit_Displ_pButton_Callback(hObject, eventdata, Main_FigureH)

handles = guidata(Main_FigureH);

Fit_Disp_FigureH = Plot_Window_Generic ([handles.eSpectra(handles.Chosen_ES).Name ' - Fit'], Main_FigureH);
Fit_Disp_AxesH   = axes('Parent', Fit_Disp_FigureH, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85], 'Tag', 'Fit_Disp_AxesH');
plot(Fit_Disp_AxesH, handles.eSpectra(handles.Chosen_ES).Wavelength, handles.eSpectra(handles.Chosen_ES).Fit);
xlabel(Fit_Disp_AxesH, 'Wavelength [nm]');
ylabel(Fit_Disp_AxesH, 'N. Power Spectrum');
end