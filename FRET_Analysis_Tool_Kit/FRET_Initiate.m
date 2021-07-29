function handles = FRET_Initiate(handles, FRET_Obj_Param)

if isfield(FRET_Obj_Param, 'FRET_Params'), FRET_Param = FRET_Obj_Param.FRET_Params; else FRET_Param = []; end;
if isfield(FRET_Obj_Param, 'Disp_Params'), Disp_Param = FRET_Obj_Param.Disp_Params; else Disp_Param = []; end;
if isfield(FRET_Obj_Param, 'General_Params'), General_Param = FRET_Obj_Param.General_Params; else General_Param = []; end;

if isfield(FRET_Param,'FRET_Hist_Bin'), handles.FRET_Hist_Bin = FRET_Param.FRET_Hist_Bin; end;
if ~isfield(handles, 'FRET_Hist_Bin'), handles.FRET_Hist_Bin = 0.001; elseif isempty(handles.FRET_Hist_Bin), handles.FRET_Hist_Bin = 0.001; end;
if isfield(FRET_Param,'FRET_MetaHist_Bin'), handles.FRET_MetaHist_Bin = FRET_Param.FRET_MetaHist_Bin; end;
if ~isfield(handles, 'FRET_MetaHist_Bin'), handles.FRET_MetaHist_Bin = 0.02; elseif isempty(handles.FRET_MetaHist_Bin), handles.FRET_MetaHist_Bin = 0.02; end;
if isfield(FRET_Param,'FRET_nGaussians'), handles.FRET_nGaussians = FRET_Param.FRET_nGaussians; end;
if ~isfield(handles, 'FRET_nGaussians'), handles.FRET_nGaussians = 1; elseif isempty(handles.FRET_nGaussians), handles.FRET_nGaussians = 1; end;
if isfield(FRET_Param,'FRET_Fit_Method'), handles.FRET_Fit_Method = FRET_Param.FRET_Fit_Method; end;
if ~isfield(handles, 'FRET_Fit_Method'), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; elseif isempty(handles.FRET_Fit_Method), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; end;
if isfield(FRET_Param,'FRET_Fit_Range'), handles.FRET_Fit_Range = FRET_Param.FRET_Fit_Range; end;
if ~isfield(handles, 'FRET_Fit_Range'), handles.FRET_Fit_Range = [0, 1]; elseif isempty(handles.FRET_Fit_Range), handles.FRET_Fit_Range = [0, 1]; end;
if isfield(FRET_Param,'FRET_Method'), handles.FRET_Method = FRET_Param.FRET_Method; end;
if ~isfield(handles, 'FRET_Method'), handles.FRET_Method = 'Peak Pecking'; elseif isempty(handles.FRET_Method), handles.FRET_Method = 'Peak Pecking'; end;
if isfield(FRET_Param,'SEW_Eapp'), handles.SEW_Eapp = FRET_Param.SEW_Eapp; end;
if ~isfield(handles, 'SEW_Eapp'), handles.SEW_Eapp = 1; elseif isempty(handles.SEW_Eapp), handles.SEW_Eapp = 1; end;
if ~isfield(handles, 'Hist_Info'), handles.Hist_Info = []; end;
if isfield(FRET_Param,'Calc_2D_FRET_Switch'), handles.Calc_2D_FRET_Switch = FRET_Param.Calc_2D_FRET_Switch; end;
if ~isfield(handles, 'Calc_2D_FRET_Switch'), handles.Calc_2D_FRET_Switch = 0; elseif isempty(handles.Calc_2D_FRET_Switch), handles.Calc_2D_FRET_Switch = 0; end;

if isfield(Disp_Param,'Eapp_minRange'), handles.Eapp_minRange = Disp_Param.Eapp_minRange; end;
if ~isfield(handles, 'Eapp_minRange'), handles.Eapp_minRange = 0; elseif isempty(handles.Eapp_minRange), handles.Eapp_minRange = 0; end;
if isfield(Disp_Param,'Eapp_maxRange'), handles.Eapp_maxRange = Disp_Param.Eapp_maxRange; end;
if ~isfield(handles, 'Eapp_maxRange'), handles.Eapp_maxRange = 1; elseif isempty(handles.Eapp_maxRange), handles.Eapp_maxRange = 1; end;
if isfield(Disp_Param,'Eapp_BinSize'), handles.Eapp_BinSize = Disp_Param.Eapp_BinSize; end;
if ~isfield(handles, 'Eapp_BinSize'), handles.Eapp_BinSize = 0.02; elseif isempty(handles.Eapp_BinSize), handles.Eapp_BinSize = 0.02; end;
if isfield(Disp_Param,'Conc_minRange'), handles.Conc_minRange = Disp_Param.Conc_minRange; end;
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; elseif isempty(handles.Conc_minRange), handles.Conc_minRange = 0; end;
if isfield(Disp_Param,'Conc_maxRange'), handles.Conc_maxRange = Disp_Param.Conc_maxRange; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = 300; elseif isempty(handles.Conc_maxRange), handles.Conc_maxRange = 300; end;
if isfield(Disp_Param,'Conc_BinSize'), handles.Conc_BinSize = Disp_Param.Conc_BinSize; end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; elseif isempty(handles.Conc_BinSize), handles.Conc_BinSize = 10; end;
if isfield(Disp_Param,'Pixel_Size'), handles.Pixel_Size = Disp_Param.Pixel_Size; end;
if ~isfield(handles, 'Pixel_Size'), handles.Pixel_Size = 1; elseif isempty(handles.Pixel_Size), handles.Pixel_Size = 1; end;
if isfield(Disp_Param,'Pr_MultFact'), handles.Pr_MultFact = Disp_Param.Pr_MultFact; end;
if ~isfield(handles, 'Pr_MultFact'), handles.Pr_MultFact = 1; elseif isempty(handles.Pr_MultFact), handles.Pr_MultFact = 1; end;
if isfield(Disp_Param,'Accum_Data'), handles.Accum_Data = Disp_Param.Accum_Data; end;
if ~isfield(handles, 'Accum_Data'), handles.Accum_Data = 1; elseif isempty(handles.Accum_Data), handles.Accum_Data = 1; end;

% retrieving all the needed information from the Polygon Console (ROI Manager)
if isfield(FRET_Obj_Param,'Polygon_List'), handles.Polygon_List = FRET_Obj_Param.Polygon_List; else handles.Polygon_List = []; end;
if isfield(FRET_Obj_Param,'Segment_List'), handles.Segment_List = FRET_Obj_Param.Segment_List; else handles.Segment_List = []; end;
if isfield(FRET_Obj_Param,'FOV_List'), handles.FOV_List = FRET_Obj_Param.FOV_List; else handles.FOV_List = []; end;
if isfield(FRET_Obj_Param,'ImPoly_figHand'), handles.ImPoly_figHand = FRET_Obj_Param.ImPoly_figHand; else handles.ImPoly_figHand = []; end;
if isfield(FRET_Obj_Param,'Image_Stack_Axes'), handles.Image_Stack_Axes = FRET_Obj_Param.Image_Stack_Axes; else handles.Image_Stack_Axes = []; end;
if isfield(FRET_Obj_Param,'FOV_hImage'), handles.FOV_hImage = FRET_Obj_Param.FOV_hImage; else handles.FOV_hImage = []; end;
if isfield(FRET_Obj_Param,'handPoly'), handles.handPoly = FRET_Obj_Param.handPoly; else handles.handPoly = []; end;
if isfield(FRET_Obj_Param,'handText'), handles.handText = FRET_Obj_Param.handText; else handles.handText = []; end;
if isfield(FRET_Obj_Param,'Current_Polygon_Index'), handles.Current_Polygon_Index = FRET_Obj_Param.Current_Polygon_Index; else handles.Current_Polygon_Index = 1; end;

if isfield(General_Param,'curr_Path'), handles.curr_Path = General_Param.curr_Path; else handles.curr_Path = '.\'; end;
if isfield(General_Param,'Ana_Path'), handles.Ana_Path = General_Param.Ana_Path; else handles.Ana_Path = '.\'; end;

if ~handles.Accum_Data, handles.FRET_List = FRET_Analysis_O; end;
% if isfield(FRET_Param,'FRET_List'), handles.FRET_List = FRET_Param.FRET_List; end
if ~isfield(handles, 'FRET_List'), handles.FRET_List = FRET_Analysis_O; elseif isempty(handles.FRET_List), handles.FRET_List = FRET_Analysis_O; end;