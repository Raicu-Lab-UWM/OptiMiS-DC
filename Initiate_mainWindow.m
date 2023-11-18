function handles = Initiate_mainWindow(handles)

Init_Params = Load_Param_frmText;

handles.Ana_Path              = Init_Params.Ana_Path;
handles.Include_SubFolders    = logical(Init_Params.Inc_Sub_Dir - '0');
handles.Image_Type_Loaded     = Init_Params.Image_Type_Loaded;
handles.curr_Path             = Init_Params.curr_Path;
handles.Hor_Shift             = str2double(Init_Params.Hor_Shift);
handles.Sample_Type           = Init_Params.Sample_Type;
handles.Image_Frame_Index     = str2double(Init_Params.Image_Frame_Index);
handles.Polygon_Type          = Init_Params.Polygon_Type;
handles.Current_Polygon_Index = str2double(Init_Params.Current_Polygon_Index);
handles.Seg_Membrane_Thckness = str2double(Init_Params.Seg_Membrane_Thckness);
handles.Seg_Method            = Init_Params.Seg_Method;
handles.Seg_Type              = Init_Params.Seg_Type;
handles.Seg_Split_Value       = str2num(Init_Params.Seg_Split_Value);
handles.Seg_nIterations       = str2double(Init_Params.Seg_nIterations);
handles.Seg_Intensity_Weight  = str2double(Init_Params.Seg_Intensity_Weight);
handles.Seg_nVert_inPoly      = str2double(Init_Params.Seg_nVert_inPoly);
handles.Flt_Method            = Init_Params.Flt_Method;
handles.Flt_LowCut            = str2double(Init_Params.Flt_LowCut);
handles.Flt_HighCut           = str2double(Init_Params.Flt_HighCut);
handles.Remove_HotPixels      = logical(Init_Params.Remove_HotPixels - '0');
handles.Analysis_Type         = Init_Params.Analysis_Type;
handles.xA_Bin                = str2double(Init_Params.xA_Bin);
handles.SlopD                 = str2double(Init_Params.SlopD);
handles.SlopA                 = str2double(Init_Params.SlopA);
handles.psfD                  = str2double(Init_Params.psfD);
handles.psfA                  = str2double(Init_Params.psfA);
handles.qD                    = str2double(Init_Params.qD);
handles.qA                    = str2double(Init_Params.qA);
handles.rowD                  = str2double(Init_Params.rowD);
handles.rowA                  = str2double(Init_Params.rowA);
                            
handles.General_Params = struct('Ana_Path', Init_Params.Ana_Path, 'Hor_Shift', str2double(Init_Params.Hor_Shift), ...
                                'Sample_Type', Init_Params.Sample_Type, 'Pen_Size', str2double(Init_Params.Pen_Size), ...
                                'Separate_Dir', str2double(Init_Params.Separate_Dir), 'Inc_Sub_Dir', str2double(Init_Params.Inc_Sub_Dir), ...
                                'Show_Warnings', str2double(Init_Params.Show_Warnings), 'Image_Type_Loaded', Init_Params.Image_Type_Loaded, ...
                                'curr_Path', Init_Params.curr_Path);
handles.UM_Params      = struct('Unmix_Method', Init_Params.Unmix_Method, 'Syst_Correct', Init_Params.Syst_Correct, ...
                                'Use_Fitted_Spect', str2num(Init_Params.Use_Fitted_Spect), 'Analysis_Type', Init_Params.Analysis_Type, ...
                                'SlopD', handles.SlopD, 'SlopA', handles.SlopA,'psfD', handles.psfD, 'psfA', handles.psfA, ...
                                'qD', handles.qD, 'qA', handles.qA, 'rowD', handles.rowD, 'rowA', handles.rowA);
handles.TH_Params      = struct('Threshold_Method', Init_Params.Threshold_Method, 'TH_Value', str2num(Init_Params.TH_Value), ...
                                'Save_TH_Images', logical(str2double(Init_Params.Save_TH_Images)), 'Flt_Method', Init_Params.Flt_Method, ...
                                'Flt_LowCut', str2double(Init_Params.Flt_LowCut), 'Flt_HighCut', str2double(Init_Params.Flt_HighCut));
handles.Polygon_List       = Init_Params.Polygon_List;
handles.Segment_List       = Init_Params.Segment_List;
handles.ES_Obj             = Init_Params.ES_Obj;
handles.Image_Name         = [];
handles.Image_             = [];
handles.Image_Stack_Axes   = [];
handles.currPolygon_Coords = {};
handles.Seg_Params     = struct('Seg_Membrane_Thckness', str2double(Init_Params.Seg_Membrane_Thckness), 'Seg_Method', Init_Params.Seg_Method, ...
                                'Seg_Type', Init_Params.Seg_Type, 'Seg_Split_Value', str2num(Init_Params.Seg_Split_Value), ...
                                'Seg_nIterations', str2double(Init_Params.Seg_nIterations), 'Seg_Intensity_Weight', str2double(Init_Params.Seg_Intensity_Weight), ...
                                'Seg_nVert_inPoly', str2double(Init_Params.Seg_nVert_inPoly));
handles.FICoS_Params    = struct('FICoS_Hist_Bin', str2double(Init_Params.FICoS_Hist_Bin), 'FICoS_MetaHist_Bin', str2double(Init_Params.FICoS_MetaHist_Bin), ...
                                'FICoS_nGaussians', str2double(Init_Params.FICoS_nGaussians), 'FICoS_Fit_Method', Init_Params.FICoS_Fit_Method, ...
                                'FICoS_Fit_Range', str2num(Init_Params.FICoS_Fit_Range), 'FICoS_Method', Init_Params.FICoS_Method, ...
                                'SEW_Capp', logical(str2double(Init_Params.SEW_Capp)), 'xA_Bin', handles.xA_Bin);
handles.Disp_Params    = struct('Capp_minRange', str2double(Init_Params.Capp_minRange), 'Capp_maxRange', str2double(Init_Params.Capp_maxRange), ...
                                'Capp_BinSize', str2double(Init_Params.Capp_BinSize), 'Conc_minRange', str2double(Init_Params.Conc_minRange), ...
                                'Conc_maxRange', str2double(Init_Params.Conc_maxRange), 'Conc_BinSize', str2double(Init_Params.Conc_BinSize), ...
                                'Pr_MultFact', str2double(Init_Params.Pr_MultFact), 'Pixel_Size', str2double(Init_Params.Pixel_Size), ...
                                'Accum_Data', logical(str2double(Init_Params.Accum_Data)));