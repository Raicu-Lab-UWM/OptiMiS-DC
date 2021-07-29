function ES_Info_pButton_Callback(hObject, eventdata)

ES_Info_FigH = figure('units','pixels', 'Tag', 'ES_Info_FigH', ...
                      'position',[750 500 400 320],...
                      'menubar','none',...
                      'name','Elementary Sepctra Info',...
                      'numbertitle','off');
set(ES_Info_FigH, 'Units', 'normalized');
rowNames     = {'Name', 'Description', 'Quantum Yield', 'Spectral Integral', 'Gamma', 'Maker', 'Date of Prep', 'Method of Prep'};
colNames     = {'Values'};

handles = guidata(hObject);

StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end

if StandAlone, ES_Obj = handles.ES_Obj; else ES_Obj = mwHandles.ES_Obj; end
if isempty(ES_Obj), ES_Obj = Elementary_Spectrum_O; end;

Display_Info = struct('Name', ES_Obj.Name, 'Description', ES_Obj.Description, ...
                      'Quantum_Yield', ES_Obj.Quantum_Yield, 'Spectral_Integral', ES_Obj.Spectral_Integral, ...
                      'rIntensity', ES_Obj.rIntensity, 'Maker', ES_Obj.Maker, ...
                      'Date_of_Prep', ES_Obj.Date_of_Prep, 'Method_of_Prep', ES_Obj.Method_of_Prep, ...
                      'Spectrum', ES_Obj.Spectrum, 'Wavelength', ES_Obj.Wavelength);
Display_Info_Table   = struct2cell(Display_Info);
Display_Info_uiTable = uitable('Parent', ES_Info_FigH, 'Data', Display_Info_Table(1:length(rowNames),1), 'ColumnName', colNames, 'RowName', rowNames, ...
                               'Units', 'normalized', 'Position',[0 0 1 1], 'Tag', 'Display_Info_uiTable', 'ColumnWidth', {248}, ...
                               'ColumnEditable', true, ... , 'FontUnits', 'Normalized'
                               'CellEditCallback', {@Display_Info_uiTable_CellEditCallback, hObject});
Organize_uiTable (Display_Info_uiTable, 150);
% end

[Spectrum_Displ_Image, ~] = imread('.\Icons\Spetrum_Displ_pButton.png');
Spectrum_Displ_pButtom = uicontrol('Parent', ES_Info_FigH, 'Tag', 'Spectrum_Displ_pButton', ...
                                   'Style','pushbutton', 'cdata', Spectrum_Displ_Image, ... 
                                   'TooltipString', 'Disply Spectrum', ...
                                   'Units', 'normalized', 'Position',[0.3, 0.05, 0.13, 0.16], 'Units','pixels',...
                                   'Visible','on',...
                                   'Callback', {@Spectrum_Displ_pButton_Callback, hObject});

[Fit_Displ_Image, ~] = imread('.\Icons\Spetrum_Displ_pButton.png');
Fit_Displ_pButtom    = uicontrol('Parent', ES_Info_FigH, 'Tag', 'Fit_Displ_pButton', ...
                                 'Style','pushbutton', 'cdata', Fit_Displ_Image, ... 
                                 'TooltipString', 'Disply Fitted Spectrum', ...
                                 'Units', 'normalized', 'Position',[0.6, 0.05, 0.13, 0.16], 'Units','pixels',...
                                 'Visible','on',...
                                 'Callback', {@Fit_Displ_pButton_Callback, hObject});
handles              = guidata(hObject);

guidata(hObject, handles);
end

function Display_Info_uiTable_CellEditCallback(hObject, eventdata, ES_Tool_Kit_FigH)
handles = guidata(ES_Tool_Kit_FigH);

StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end

rowNames = {'Name', 'Description', 'Quantum_Yield', 'Spectral_Integral', 'rIntensity', 'Maker', 'Date_of_Prep', 'Method_of_Prep'};
Data = get(hObject, 'Data');
ES_Struct = cell2struct(Data, rowNames, 1);

if StandAlone, ES_Obj = handles.ES_Obj; else ES_Obj = mwHandles.ES_Obj; end
if isempty(ES_Obj), ES_Obj = Elementary_Spectrum_O; end;
Field_Names = fieldnames(ES_Struct);
for ii = 1:size(Field_Names,1)
   if strcmp(Field_Names{ii},'Fabricator')
       ES_Obj.Maker = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Date_of_prep')
       ES_Obj.Date_of_Prep = ES_Struct.(Field_Names{ii});
   elseif strcmp(Field_Names{ii},'Quantum_Yield')
       if ~isa(ES_Struct.(Field_Names{ii}),'double'), ES_Obj.Quantum_Yield = str2double(ES_Struct.(Field_Names{ii}));
       else ES_Obj.Quantum_Yield = ES_Struct.(Field_Names{ii});
       end
   elseif strcmp(Field_Names{ii},'rIntensity')
       if ~isa(ES_Struct.(Field_Names{ii}),'double'), ES_Obj.rIntensity = str2double(ES_Struct.(Field_Names{ii}));
       else ES_Obj.rIntensity = ES_Struct.(Field_Names{ii});
       end
   else
       ES_Obj.(Field_Names{ii}) = ES_Struct.(Field_Names{ii});
   end;
end;
if StandAlone, handles.ES_Obj = ES_Obj; else mwHandles.ES_Obj = ES_Obj; end

guidata(handles.mwFigureH, mwHandles);
guidata(ES_Tool_Kit_FigH, handles);
end

function Spectrum_Displ_pButton_Callback(hObject, eventdata, ES_Tool_Kit_FigH)

handles = guidata(ES_Tool_Kit_FigH);
StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end
if StandAlone, ES_Obj = handles.ES_Obj; else ES_Obj = mwHandles.ES_Obj; end

Spectrum_Disp_FigureH = Plot_Window_Generic ([ES_Obj.Name ' - Spectrum'], ES_Tool_Kit_FigH);
Spectrum_Disp_AxesH   = axes('Parent', Spectrum_Disp_FigureH, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85], 'Tag', 'Spectrum_Disp_AxesH');
plot(Spectrum_Disp_AxesH, ES_Obj.Wavelength, ES_Obj.Spectrum);
xlabel(Spectrum_Disp_AxesH, 'Wavelength [nm]');
ylabel(Spectrum_Disp_AxesH, 'N. Power Spectrum');
end

function Fit_Displ_pButton_Callback(hObject, eventdata, ES_Tool_Kit_FigH)

handles = guidata(ES_Tool_Kit_FigH);
StandAlone = true; mwHandles = [];
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end
if StandAlone, ES_Obj = handles.ES_Obj; else ES_Obj = mwHandles.ES_Obj; end

Fit_Disp_FigureH = Plot_Window_Generic ([ES_Obj.Name ' - Fit'], ES_Tool_Kit_FigH);
Fit_Disp_AxesH   = axes('Parent', Fit_Disp_FigureH, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.85, 0.85], 'Tag', 'Fit_Disp_AxesH');
plot(Fit_Disp_AxesH, ES_Obj.Wavelength, ES_Obj.Fit);
xlabel(Fit_Disp_AxesH, 'Wavelength [nm]');
ylabel(Fit_Disp_AxesH, 'N. Power Spectrum');
end