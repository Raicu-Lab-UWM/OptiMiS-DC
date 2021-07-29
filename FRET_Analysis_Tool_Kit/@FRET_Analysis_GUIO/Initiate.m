function handles = Initiate(handles, FRET_Obj_Param)

% retrieving all the needed information from the Polygon Console (ROI Manager)
if isfield(FRET_Obj_Param,'Polygon_List'), handles.Polygon_List = FRET_Obj_Param.Polygon_List; else handles.Polygon_List = []; end;
if isfield(FRET_Obj_Param,'Segment_List'), handles.Segment_List = FRET_Obj_Param.Segment_List; else handles.Segment_List = []; end;
if isfield(FRET_Obj_Param,'FOV_List'), handles.FOV_List = FRET_Obj_Param.FOV_List; else handles.FOV_List = []; end;
if isfield(FRET_Obj_Param,'curr_Path'), handles.curr_Path = FRET_Obj_Param.curr_Path; else handles.curr_Path = '.\'; end;
if isfield(FRET_Obj_Param,'Ana_Path'), handles.Ana_Path = FRET_Obj_Param.Ana_Path; else handles.Ana_Path = '.\'; end;
if isfield(FRET_Obj_Param,'ImPoly_figHand'), handles.ImPoly_figHand = FRET_Obj_Param.ImPoly_figHand; else handles.ImPoly_figHand = []; end;
if isfield(FRET_Obj_Param,'Image_Stack_Axes'), handles.Image_Stack_Axes = FRET_Obj_Param.Image_Stack_Axes; else handles.Image_Stack_Axes = []; end;
if isfield(FRET_Obj_Param,'FOV_hImage'), handles.FOV_hImage = FRET_Obj_Param.FOV_hImage; else handles.FOV_hImage = []; end;
if isfield(FRET_Obj_Param,'handPoly'), handles.handPoly = FRET_Obj_Param.handPoly; else handles.handPoly = []; end;
if isfield(FRET_Obj_Param,'handText'), handles.handText = FRET_Obj_Param.handText; else handles.handText = []; end;
if isfield(FRET_Obj_Param,'Current_Polygon_Index'), handles.Current_Polygon_Index = FRET_Obj_Param.Current_Polygon_Index; else handles.Current_Polygon_Index = 1; end;

% % retrieving all the needed information from the Main Window
% if isfield(FRET_Obj_Param,'pcFigureH'), handles.pcFigureH = FRET_Obj_Param.pcFigureH; end;
% if isfield(FRET_Obj_Param,'output'), handles.mwFigureH = FRET_Obj_Param.output; end;

% if isfield(FRET_Obj_Param,'FRET_List')
%     if isfiled(handles, 'Accum_Data')
%         if handles.Accum_Data, handles.FRET_List = FRET_Obj_Param.FRET_List; else handles.FRET_List = FRET_Analysis_O; end
%     end
% end
% if ~isfield(handles, 'FRET_List'), handles.FRET_List = FRET_Analysis_O; elseif isempty(handles.FRET_List), handles.FRET_List = FRET_Analysis_O;
% else if isfield(handles, 'Accum_Data'), if ~handles.Accum_Data, handles.FRET_List = FRET_Analysis_O; end; end
% end;
if isfield(FRET_Obj_Param,'FRET_List'), handles.FRET_List = FRET_Obj_Param.FRET_List; end
if ~isfield(handles, 'FRET_List'), handles.FRET_List = FRET_Analysis_O; elseif isempty(handles.FRET_List), handles.FRET_List = FRET_Analysis_O; end;
if isfield(FRET_Obj_Param,'FRET_Hist_Bin'), handles.FRET_Hist_Bin = FRET_Obj_Param.FRET_Hist_Bin; end;
if ~isfield(handles, 'FRET_Hist_Bin'), handles.FRET_Hist_Bin = 0.01; elseif isempty(handles.FRET_Hist_Bin), handles.FRET_Hist_Bin = 0.01; end;
if isfield(FRET_Obj_Param,'FRET_nGaussians'), handles.FRET_nGaussians = FRET_Obj_Param.FRET_nGaussians; end;
if ~isfield(handles, 'FRET_nGaussians'), handles.FRET_nGaussians = 1; elseif isempty(handles.FRET_nGaussians), handles.FRET_nGaussians = 1; end;
if isfield(FRET_Obj_Param,'FRET_Fit_Method'), handles.FRET_Fit_Method = FRET_Obj_Param.FRET_Fit_Method; end;
if ~isfield(handles, 'FRET_Fit_Method'), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; elseif isempty(handles.FRET_Fit_Method), handles.FRET_Fit_Method = 'Gaussian (Iterative)'; end;
if isfield(FRET_Obj_Param,'FRET_Fit_Range'), handles.FRET_Fit_Range = FRET_Obj_Param.FRET_Fit_Range; end;
if ~isfield(handles, 'FRET_Fit_Range'), handles.FRET_Fit_Range = [0, 1]; elseif isempty(handles.FRET_Fit_Range), handles.FRET_Fit_Range = [0, 1]; end;
if isfield(FRET_Obj_Param,'FRET_Method'), handles.FRET_Method = FRET_Obj_Param.FRET_Method; end;
if ~isfield(handles, 'FRET_Method'), handles.FRET_Method = 'Peak Pecking'; elseif isempty(handles.FRET_Method), handles.FRET_Method = 'Peak Pecking'; end;
if isfield(FRET_Obj_Param,'SEW_Eapp'), handles.SEW_Eapp = FRET_Obj_Param.SEW_Eapp; end;
if ~isfield(handles, 'SEW_Eapp'), handles.SEW_Eapp = 1; elseif isempty(handles.SEW_Eapp), handles.SEW_Eapp = 1; end;
if ~isfield(handles, 'Hist_Info'), handles.Hist_Info = []; end;
if isfield(FRET_Obj_Param,'Calc_2D_FRET_Switch'), handles.Calc_2D_FRET_Switch = FRET_Obj_Param.Calc_2D_FRET_Switch; end;
if ~isfield(handles, 'Calc_2D_FRET_Switch'), handles.Calc_2D_FRET_Switch = 0; elseif isempty(handles.Calc_2D_FRET_Switch), handles.Calc_2D_FRET_Switch = 0; end;