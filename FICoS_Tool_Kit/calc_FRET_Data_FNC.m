function handles = calc_FRET_Data_FNC(handles, mwHandles, pcHandles)

current_Frame    = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(1)).Image_Frame_Index;
if isempty(current_Frame), current_Frame = 1; end;
set(pcHandles.FOV_hImage, 'CData', pcHandles.FOV_List(current_Frame).raw_Data);
Image_Stack_sBar = findobj('Tag', 'Image_Stack_sBar');
set(Image_Stack_sBar, 'Value', current_Frame);
if isfield(pcHandles, 'handSegment'), delete(pcHandles.handSegment); end; guidata(mwHandles.pcFigureH, pcHandles);

if isempty(handles.FICoS_Fit_Range)
    Fit_Range = [0, 1];
    handles.FICoS_Fit_Range = Fit_Range;
    if handles.FICoS_Hist_Bin >= 1, FICoS_Hist_Bin = handles.FICoS_Hist_Bin/100; else FICoS_Hist_Bin = handles.FICoS_Hist_Bin; end;
else
    if max(handles.FICoS_Fit_Range) <= 1
        if handles.FICoS_Hist_Bin >= 1, FICoS_Hist_Bin = handles.FICoS_Hist_Bin/100; else FICoS_Hist_Bin = handles.FICoS_Hist_Bin; end;
        Fit_Range = handles.FICoS_Fit_Range;
    else
        FICoS_Hist_Bin = handles.FICoS_Hist_Bin;
        Fit_Range     = handles.FICoS_Fit_Range;
    end;
end;

if isfield(handles, 'Accum_Data'), if ~handles.Accum_Data, handles.FRET_List = FRET_Analysis_O; end; end

if ~isfield(handles, 'Eapp_Map')
    handles.Eapp_Map = zeros(size(pcHandles.FOV_List(1).raw_Data, 1), size(pcHandles.FOV_List(1).raw_Data, 2), length(pcHandles.FOV_List));
    Eapp_Map_isEmpty = 1;
elseif isempty(handles.Eapp_Map)
    handles.Eapp_Map = zeros(size(pcHandles.FOV_List(1).raw_Data, 1), size(pcHandles.FOV_List(1).raw_Data, 2), length(pcHandles.FOV_List));
    Eapp_Map_isEmpty = 1;
else
    Eapp_Map_isEmpty = 0;
end

h = waitbar(0, 'Calculating Histograms ...');
for ii = 1:length(mwHandles.Current_Polygon_Index)
    Polygon = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii));
    Found   = handles.FRET_List.Find_FRET_Item(Polygon.Name);
    if Found == 0
        FRET_Item                = FRET_Analysis_O;
        FRET_Item.Master_Polygon = Polygon.Name;
    else
        FRET_Item = handles.FRET_List(Found);
    end
    
    % Calculating The histograms. Multiple for Segments and one for patch.
    [Related_Segment, Segment_Found] = handles.Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon.Name);
    if Eapp_Map_isEmpty
        curEapp_Map = pcHandles.FOV_List(uint16(Polygon.Image_Frame_Index)).raw_Data;
        handles.Eapp_Map(:,:,ii) = curEapp_Map;
    else
        curEapp_Map = handles.Eapp_Map(:,:,uint16(Polygon.Image_Frame_Index));
    end
    
    if ~isfield(handles, 'FDA_WL1_Map'), curFDA_WL1_Map = []; else curFDA_WL1_Map = handles.FDA_WL1_Map(:,:,uint16(Polygon.Image_Frame_Index)); end
    if ~isfield(handles, 'FAD_WL1_Map'), curFAD_WL1_Map = []; else curFAD_WL1_Map = handles.FAD_WL1_Map(:,:,uint16(Polygon.Image_Frame_Index)); end
    if ~isfield(handles, 'FAD_WL2_Map'), curFAD_WL2_Map = []; else curFAD_WL2_Map = handles.FAD_WL2_Map(:,:,uint16(Polygon.Image_Frame_Index)); end
    
    if max(curEapp_Map(:)) > Fit_Range(2), curEapp_Map = curEapp_Map/100; end;
    if ~isempty(Segment_Found)
        FRET_Item = FRET_Item.Calculate_Histogram(Related_Segment.Polygons, FICoS_Hist_Bin, curEapp_Map, curFDA_WL1_Map, curFAD_WL1_Map, curFAD_WL2_Map, Fit_Range); % mwHandles.eSpectra removed from function input
    else
        FRET_Item = FRET_Item.Calculate_Histogram(Polygon.Coordinates, FICoS_Hist_Bin, curEapp_Map, curFDA_WL1_Map, curFAD_WL1_Map, curFAD_WL2_Map, Fit_Range);
    end
    if ~isempty(curFDA_WL1_Map) && ~isempty(curFAD_WL1_Map) && ~isempty(curFAD_WL2_Map)
        if ~isempty(Segment_Found)
            FRET_Item = FRET_Item.Calculate_TEW_Info(Related_Segment.Polygons, handles.FICoS_Hist_Bin, curFDA_WL1_Map, curFAD_WL1_Map, curFAD_WL2_Map);
        else
            FRET_Item = FRET_Item.Calculate_TEW_Info(Polygon.Coordinates, handles.FICoS_Hist_Bin, curFDA_WL1_Map, curFAD_WL1_Map, curFAD_WL2_Map);
        end
    end
    
    % calculate fit to the histogram
    FRET_Item.Fitting_Param = struct('Fit_Method', handles.FICoS_Fit_Method, 'Range', Fit_Range, 'nGaussians', handles.FICoS_nGaussians, ...
                                      'TolFun',0.00001,'MaxFunEvals',1e10);
    FRET_Item.Analysis_Method = handles.FICoS_Method;
    if ii == 1
        [FRET_Item, hHist_Figure] = FRET_Item.Calculate_Fit(0);
    else
%TK 2024/12/05        [FRET_Item, hHist_Figure] = FRET_Item.Calculate_Fit(0, hHist_Figure);
    end
    
    % Calculate FICoS and Concentration
    FRET_Item = FRET_Item.Calculate_Sample_Param;
    
    % Add a FICoS instance to the FICoS list
    nFRET_Items = length(handles.FRET_List); if nFRET_Items == 1 && isempty(handles.FRET_List.Master_Polygon), nFRET_Items = 0; end;
    if Found == 0
        handles.FRET_List(nFRET_Items+1) = FRET_Item;
    else
        handles.FRET_List(Found) = FRET_Item;
    end
    
    %ploting the Cells ROIs
    if current_Frame ~= mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Image_Frame_Index
        current_Frame = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Image_Frame_Index;
    end
    set(pcHandles.FOV_hImage, 'CData', pcHandles.FOV_List(uint16(current_Frame)).raw_Data);
    set(Image_Stack_sBar, 'Value', current_Frame);
    handPoly = [mwHandles.Polygon_List.Poly_PlotH];
    handText = [mwHandles.Polygon_List.Title_PrintH];
    set(handPoly, 'Visible', 'off');
    set(handText, 'Visible', 'off');
    set(mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Poly_PlotH, 'Visible', 'on');
    set(mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Title_PrintH, 'Visible', 'on');
    waitbar(ii/length(mwHandles.Current_Polygon_Index), h);
end
for ii = 1:length(handles.FRET_List)
    FRET_Item = handles.FRET_List(ii);
    handles.Hist_Info = [handles.Hist_Info; FRET_Item.Histogram'];
end
close(h);