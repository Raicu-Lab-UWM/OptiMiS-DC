function handles = FRET_Initiate(handles, FRET_Obj_Param)

if isfield(FRET_Obj_Param, 'FICoS_Params'), FRET_Param = FRET_Obj_Param.FICoS_Params; else FRET_Param = []; end;
if isfield(FRET_Obj_Param, 'Disp_Params'), Disp_Param = FRET_Obj_Param.Disp_Params; else Disp_Param = []; end;
if isfield(FRET_Obj_Param, 'General_Params'), General_Param = FRET_Obj_Param.General_Params; else General_Param = []; end;

if isfield(FRET_Param,'FICoS_Hist_Bin'), handles.FICoS_Hist_Bin = FRET_Param.FICoS_Hist_Bin; end;
if ~isfield(handles, 'FICoS_Hist_Bin'), handles.FICoS_Hist_Bin = 0.001; elseif isempty(handles.FICoS_Hist_Bin), handles.FICoS_Hist_Bin = 0.001; end;
if isfield(FRET_Param,'FICoS_MetaHist_Bin'), handles.FICoS_MetaHist_Bin = FICoS_Param.FICoS_MetaHist_Bin; end;
if ~isfield(handles, 'FICoS_MetaHist_Bin'), handles.FICoS_MetaHist_Bin = 0.02; elseif isempty(handles.FICoS_MetaHist_Bin), handles.FICoS_MetaHist_Bin = 0.02; end;
if isfield(FRET_Param,'FICoS_nGaussians'), handles.FICoS_nGaussians = FICoS_Param.FICoS_nGaussians; end;
if ~isfield(handles, 'FICoS_nGaussians'), handles.FICoS_nGaussians = 1; elseif isempty(handles.FICoS_nGaussians), handles.FICoS_nGaussians = 1; end;
if isfield(FRET_Param,'FICoS_Fit_Method'), handles.FICoS_Fit_Method = FICoS_Param.FICoS_Fit_Method; end;
if ~isfield(handles, 'FICoS_Fit_Method'), handles.FICoS_Fit_Method = 'Gaussian (Iterative)'; elseif isempty(handles.FICoS_Fit_Method), handles.FICoS_Fit_Method = 'Gaussian (Iterative)'; end;
if isfield(FRET_Param,'FICoS_Fit_Range'), handles.FICoS_Fit_Range = FICoS_Param.FICoS_Fit_Range; end;
if ~isfield(handles, 'FICoS_Fit_Range'), handles.FICoS_Fit_Range = [-1, 1]; elseif isempty(handles.FICoS_Fit_Range), handles.FICoS_Fit_Range = [-1, 1]; end;
if isfield(FRET_Param,'FICoS_Method'), handles.FICoS_Method = FICoS_Param.FICoS_Method; end;
if ~isfield(handles, 'FICoS_Method'), handles.FICoS_Method = 'Peak Pecking'; elseif isempty(handles.FICoS_Method), handles.FICoS_Method = 'Peak Pecking'; end;
if isfield(FICoS_Param,'SEW_Capp'), handles.SEW_Capp = FICoS_Param.SEW_Capp; end;
if ~isfield(handles, 'SEW_Capp'), handles.SEW_Capp = 1; elseif isempty(handles.SEW_Capp), handles.SEW_Capp = 1; end;
if ~isfield(handles, 'Hist_Info'), handles.Hist_Info = []; end;
if isfield(FICoS_Param,'Calc_2D_FRET_Switch'), handles.Calc_2D_FICoS_Switch = FICoS_Param.Calc_2D_FICoS_Switch; end;
if ~isfield(handles, 'Calc_2D_FICoS_Switch'), handles.Calc_2D_FICoS_Switch = 0; elseif isempty(handles.Calc_2D_FICoS_Switch), handles.Calc_2D_FICoS_Switch = 0; end;

if isfield(Disp_Param,'Capp_minRange'), handles.Capp_minRange = Disp_Param.Capp_minRange; end;
if ~isfield(handles, 'Capp_minRange'), handles.Capp_minRange = 0; elseif isempty(handles.Capp_minRange), handles.Capp_minRange = 0; end;
if isfield(Disp_Param,'Capp_maxRange'), handles.Capp_maxRange = Disp_Param.Capp_maxRange; end;
if ~isfield(handles, 'Capp_maxRange'), handles.Capp_maxRange = 1; elseif isempty(handles.Capp_maxRange), handles.Capp_maxRange = 1; end;
if isfield(Disp_Param,'Capp_BinSize'), handles.Capp_BinSize = Disp_Param.Capp_BinSize; end;
if ~isfield(handles, 'Capp_BinSize'), handles.Capp_BinSize = 0.02; elseif isempty(handles.Capp_BinSize), handles.Capp_BinSize = 0.02; end;
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
if isfield(FICoS_Obj_Param,'Polygon_List'), handles.Polygon_List = FICoS_Obj_Param.Polygon_List; else handles.Polygon_List = []; end;
if isfield(FICoS_Obj_Param,'Segment_List'), handles.Segment_List = FICoS_Obj_Param.Segment_List; else handles.Segment_List = []; end;
if isfield(FICoS_Obj_Param,'FOV_List'), handles.FOV_List = FICoS_Obj_Param.FOV_List; else handles.FOV_List = []; end;
if isfield(FICoS_Obj_Param,'ImPoly_figHand'), handles.ImPoly_figHand = FICoS_Obj_Param.ImPoly_figHand; else handles.ImPoly_figHand = []; end;
if isfield(FICoS_Obj_Param,'Image_Stack_Axes'), handles.Image_Stack_Axes = FICoS_Obj_Param.Image_Stack_Axes; else handles.Image_Stack_Axes = []; end;
if isfield(FICoS_Obj_Param,'FOV_hImage'), handles.FOV_hImage = FICoS_Obj_Param.FOV_hImage; else handles.FOV_hImage = []; end;
if isfield(FICoS_Obj_Param,'handPoly'), handles.handPoly = FICoS_Obj_Param.handPoly; else handles.handPoly = []; end;
if isfield(FICoS_Obj_Param,'handText'), handles.handText = FICoS_Obj_Param.handText; else handles.handText = []; end;
if isfield(FICoS_Obj_Param,'Current_Polygon_Index'), handles.Current_Polygon_Index = FICoS_Obj_Param.Current_Polygon_Index; else handles.Current_Polygon_Index = 1; end;

if isfield(General_Param,'curr_Path'), handles.curr_Path = General_Param.curr_Path; else handles.curr_Path = '.\'; end;
if isfield(General_Param,'Ana_Path'), handles.Ana_Path = General_Param.Ana_Path; else handles.Ana_Path = '.\'; end;

if isfield(FICoS_Obj_Param, 'UM_Params')
    if strcmp(FICoS_Obj_Param.UM_Params.Analysis_Type,'FICoS')
        if ~handles.Accum_Data, handles.FICoS_List = FICoS_Analysis_O; end;
        if ~isfield(handles, 'FICoS_List'), handles.FICoS_List = FICoS_Analysis_O; elseif isempty(handles.FICoS_List), handles.FICoS_List = FICoS_Analysis_O; end;
    else
        if ~handles.Accum_Data, handles.FRET_List = FRET_Analysis_O; end;
        if ~isfield(handles, 'FRET_List'), handles.FRET_List = FRET_Analysis_O; elseif isempty(handles.FRET_List), handles.FRET_List = FRET_Analysis_O; end;
    end
end
% if isfield(FICoS_Param,'FICoS_List'), handles.FICoS_List = FICoS_Param.FICoS_List; end