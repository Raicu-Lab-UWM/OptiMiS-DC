function handles = Initiate_Window_Param(handles, mwParams)

if isfield(mwParams, 'General_Params'), General_Param = mwParams.General_Params; else General_Param = []; end;
if isfield(mwParams, 'UM_Params'), UM_Param = mwParams.UM_Params; else UM_Param = []; end;
if isfield(mwParams, 'TH_Params'), TH_Param = mwParams.TH_Params; else TH_Param = []; end;

if isfield(General_Param, 'Ana_Path'), handles.Ana_Path = General_Param.Ana_Path; end
if ~isfield(handles, 'Ana_Path'), handles.Ana_Path = '.\'; elseif isempty(handles.Ana_Path), handles.Ana_Path = '.\'; end;
if isfield(General_Param, 'currPath'), handles.currPath = General_Param.currPath; end
if ~isfield(handles, 'currPath'), handles.currPath = '.\'; elseif isempty(handles.currPath), handles.currPath = '.\'; end;
if isfield(General_Param, 'Hor_Shift'), handles.Hor_Shift = General_Param.Hor_Shift; end
if ~isfield(handles, 'Hor_Shift'), handles.Hor_Shift = 0; elseif isempty(handles.Hor_Shift), handles.Hor_Shift = 0; end;
if isfield(General_Param, 'Separate_Dir'), handles.Separate_Dir = General_Param.Separate_Dir; end
if ~isfield(handles, 'Separate_Dir'), handles.Separate_Dir = 1; elseif isempty(handles.Separate_Dir), handles.Separate_Dir = 1; end;
if isfield(General_Param, 'Pen_Size'), handles.Pen_Size = General_Param.Pen_Size; end
if ~isfield(handles, 'Pen_Size'), handles.Pen_Size = 1; elseif isempty(handles.Pen_Size), handles.Pen_Size = 1; end;
if isfield(General_Param, 'Inc_Sub_Dir'), handles.Inc_Sub_Dir = General_Param.Inc_Sub_Dir; end
if ~isfield(handles, 'Inc_Sub_Dir'), handles.Inc_Sub_Dir = 1; elseif isempty(handles.Inc_Sub_Dir), handles.Inc_Sub_Dir = 1; end;
if isfield(General_Param, 'Show_Warnings'), handles.Show_Warnings = General_Param.Show_Warnings; end
if ~isfield(handles, 'Show_Warnings'), handles.Show_Warnings = 0; elseif isempty(handles.Show_Warnings), handles.Show_Warnings = 0; end;

if isfield(UM_Param, 'Syst_Correct'), handles.Syst_Correct = UM_Param.Syst_Correct; end
if ~isfield(handles, 'Syst_Correct'), handles.Syst_Correct = ''; elseif isempty(handles.Syst_Correct), handles.Syst_Correct = ''; end;
if isfield(UM_Param, 'Unmix_Method_Index'), handles.Unmix_Method_Index = UM_Param.Unmix_Method_Index; end
if ~isfield(handles, 'Unmix_Method_Index'), handles.Unmix_Method_Index = 1; elseif isempty(handles.Unmix_Method_Index), handles.Unmix_Method_Index = 1; end;
Unmix_Method_Menu = {'Analytic', 'Iterative'};
if isfield(UM_Param, 'Unmix_Method'), handles.Unmix_Method = UM_Param.Unmix_Method; end
if ~isfield(handles, 'Unmix_Method'), handles.Unmix_Method = Unmix_Method_Menu{1}; elseif isempty(handles.Unmix_Method), handles.Unmix_Method = Unmix_Method_Menu{1}; end;
if isfield(UM_Param, 'Use_Fitted_Spect'), handles.Use_Fitted_Spect = UM_Param.Use_Fitted_Spect; end
if ~isfield(handles, 'Use_Fitted_Spect'), handles.Use_Fitted_Spect = 0; elseif isempty(handles.Use_Fitted_Spect), handles.Use_Fitted_Spect = 0; end;

if isfield(TH_Param, 'Threshold_Method_Index'), handles.Threshold_Method_Index = TH_Param.Threshold_Method_Index; end
if ~isfield(handles, 'Threshold_Method_Index'), handles.Threshold_Method_Index = 1; elseif isempty(handles.Threshold_Method_Index), handles.Threshold_Method_Index = 1; end;
TH_Method_Menu = {'Donor & Acceptor', 'Donor Only', 'Reduced Chi Square'};
if isfield(TH_Param, 'Threshold_Method'), handles.Threshold_Method = TH_Param.Threshold_Method; end
if ~isfield(handles, 'Threshold_Method'), handles.Threshold_Method = TH_Method_Menu{1}; elseif isempty(handles.Threshold_Method), handles.Threshold_Method = TH_Method_Menu{1}; end;
if isfield(TH_Param, 'TH_Value'), handles.TH_Value = TH_Param.TH_Value; end
if ~isfield(handles, 'TH_Value'), handles.TH_Value = [0,0,1]; elseif isempty(handles.TH_Value), handles.TH_Value = [0,0,1]; end;
if isfield(TH_Param, 'Save_TH_Images'), handles.Save_TH_Images = TH_Param.Save_TH_Images; end
if ~isfield(handles, 'Save_TH_Images'), handles.Save_TH_Images = 0; elseif isempty(handles.Save_TH_Images), handles.Save_TH_Images = 0; end;

handles.Scene_Index      = 1;
handles.iFrame           = 1;
handles.Background       = 0;
handles.eSpectra         = Elementary_Spectrum_O;
