function handles = Filter_ROIs_wChiSquare (hObject, Chi_Square_Image)

handles      = guidata(hObject);

if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); else mwHandles = []; end; 
else mwHandles = [];
end

if isempty(mwHandles)
    Polygon_List = handles.Polygon_List;
    Segment_List = handles.Segment_List;
    Flt_LowCut   = handles.Flt_LowCut;
else
    Polygon_List = mwHandles.Polygon_List;
    Segment_List = mwHandles.Segment_List;
    Flt_LowCut   = mwHandles.Flt_LowCut;
end

for ii = length(Polygon_List):-1:1
    cPolygon           = Polygon_List(ii);
    iFrame             = cPolygon.Image_Frame_Index;
    cFrame             = Chi_Square_Image(:,:,iFrame);
    [~, Segment_Found] = Segment_List.Segment_MasterPoly_Query('Master_Polygon', cPolygon.Name);
    cSegment_List      = Segment_List(Segment_Found);
    Poly_Cords         = cSegment_List.Polygons;

    for jj = length(Poly_Cords):-1:1
        Segment_ROI = Poly_Cords{jj};
        Mask        = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(cFrame,1), size(cFrame,2));
        avgChi2     = mean(cFrame(Mask == 1));
        if avgChi2 > Flt_LowCut || isnan(avgChi2)
            if isempty(mwHandles), handles.Segment_List(Segment_Found).Polygons(jj) = [];
            else mwHandles.Segment_List(Segment_Found).Polygons(jj) = [];
            end
            Segment_List(Segment_Found).Polygons(jj) = [];
        end
    end
    
    if isempty(Segment_List(Segment_Found).Polygons)
        if isempty(mwHandles)
            handles.Current_Polygon_Index = ii;
            handles                       = Remve_Poly_fromList_Icon_ClickedCallback(hObject, [], handles);
            handles.Current_Polygon_Index = ii-1;
        else
            mwHandles.Current_Polygon_Index = ii;
            guidata(handles.mwFigureH, mwHandles);
            Remve_Poly_fromList_Icon_ClickedCallback(hObject, [], handles); mwHandles = guidata(handles.mwFigureH);
            mwHandles.Current_Polygon_Index = ii-1;
        end
    end
end;
guidata(handles.mwFigureH, mwHandles);