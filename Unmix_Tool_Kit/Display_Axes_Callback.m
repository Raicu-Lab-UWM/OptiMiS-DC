function Display_Axes_Callback(hObject, eventdata, Main_FigureH)

handles = guidata(Main_FigureH);

if handles.StandAlone, Elem_Spect = handles.eSpectra; Use_Fitted_Spect = handles.Use_Fitted_Spect; 
else mwHandles = guidata(handles.mwFigureH);
    if isfield(mwHandles, 'eSpectra'), Elem_Spect = mwHandles.eSpectra; else Elem_Spect = []; end
    Use_Fitted_Spect = mwHandles.UM_Params.Use_Fitted_Spect;
end

if isfield(handles, 'Single_Pixel_UM_On')
    if handles.Single_Pixel_UM_On
        Scene_Inst   = handles.Scene_Inst(handles.Scene_Index(handles.iFrame));
        Image_Stack  = handles.currImage_Stack; 
%         Elem_Spect   = handles.eSpectra;
        Background   = handles.Background;

        Name         = Scene_Inst.Name;
        fExt_Index   = strfind(Name,'.tiff'); if ~isempty(fExt_Index), Name = Name(1:fExt_Index-1); end
        fExt_Index   = strfind(Name,'.tif');  if ~isempty(fExt_Index), Name = Name(1:fExt_Index-1); end

        if handles.Separate_Dir
            [Success, Messege, Message_ID] = mkdir(handles.Ana_Path, Name);
            Path                           = [handles.Ana_Path '\' Name];
        else Path = handles.Ana_Path;
        end;

        Pos          = get(hObject, 'CurrentPoint');
        x            = round(Pos(1,1)); y = round(Pos(1,2));
        Pen_Size     = handles.Pen_Size;
        Title        = [Name(1:15) '_x' int2str(int16(x)) '_y' int2str(int16(y))];
        Unmix_Method_Index = handles.Unmix_Method_Index;
        Pixel_Curves = Pixel_Unmixing (Scene_Inst, Image_Stack, Elem_Spect, Background, x, y, Path, Title, Pen_Size, Unmix_Method_Index, handles.Use_Fitted_Spect);
    end
end

% if ~handles.Show_All_Poly
%     if isfield(handles, 'handPoly'), set(handles.handPoly, 'Visible', 'off'); end;
%     if isfield(handles, 'handText'), set(handles.handText, 'Visible', 'off'); end;
% else
%     All_ROI_Frames    = {handles.Polygon_List.Image_Frame_Index};
%     ROI_subList_Index = find(cellfun(@(x) isequal(x, handles.Image_Frame_Index), All_ROI_Frames));
%     if isfield(handles, 'handPoly'), set(handles.handPoly(ROI_subList_Index), 'Visible', 'on'); end;
%     if isfield(handles, 'handText'), set(handles.handText(ROI_subList_Index), 'Visible', 'on'); end;
% end;
% Image_Drawn  = [handles.FOV_List(uint16(handles.Image_Frame_Index)).Path '\' handles.FOV_List(uint16(handles.Image_Frame_Index)).Name];
% Polygon_Prop = struct('Circle_Mode', 'Polygon', 'Polygon_Type', handles.Polygon_Type, 'Images_Related', [], ...
%                       'Image_Drawn', Image_Drawn, 'Image_Frame_Index', handles.Image_Frame_Index);
% if handles.Draw_Polygon_On
%     if isfield(handles, 'handSegment'), delete(handles.handSegment); end;
%     Poly_Hand = impoly(handles.Image_Stack_Axes); 
%     api = iptgetapi(Poly_Hand); 
%     Polygon_Coords = api.getPosition(); 
%     delete(Poly_Hand);
%     Polygon_Coords                  = [Polygon_Coords;Polygon_Coords(1,:)];
%     handles.currPolygon_Coords      = {Polygon_Coords};
%     [handles.Polygon_List, Polygon_Index] = handles.Polygon_List.Add_Polygon_toList(handles.currPolygon_Coords{1}, Polygon_Prop);
%     Image_                          = handles.FOV_List(uint16(handles.Image_Frame_Index)).raw_Data;
%     handles.Polygon_List(Polygon_Index).Mask = poly2mask(Polygon_Coords(:,1), Polygon_Coords(:,2), size(Image_,1), size(Image_,2));
%     set(handles.Polygon_List_ListBox, 'String', {handles.Polygon_List.Name});
%     handles.handPoly(Polygon_Index) = handles.Polygon_List(Polygon_Index).Draw_aPolygon(handles.Image_Stack_Axes);
%     handles.handText(Polygon_Index) = handles.Polygon_List(Polygon_Index).Plot_Poly_Label(handles.Image_Stack_Axes);
% end;

guidata(Main_FigureH, handles);