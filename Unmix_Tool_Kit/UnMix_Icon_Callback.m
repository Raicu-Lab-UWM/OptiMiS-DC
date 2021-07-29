function UnMix_Icon_Callback(hObject, eventdata)
handles = guidata(hObject);
mwHandles = guidata(handles.mwFigureH);

Selected_Scene   = handles.Scene_Inst(handles.Scene_Index);
currUnmix_Images = Selected_Scene(1).currUnmix_Images;
if isempty(currUnmix_Images)
    Name = Selected_Scene(1).Name;
    if strcmp(Name(end-3:end),'.dat')
        Last = 999+length(Selected_Scene(1).Wavelength);
        Selected_Scene(1) = Selected_Scene(1).Load_Dat_Images(Selected_Scene(1).Path, 1000, Last, handles.Hor_Shift);
    else
        Selected_Scene(1).currImage_Stack = Selected_Scene(1).Load_Tiff_Image(Name, Selected_Scene(1).Path, [], handles.Hor_Shift, 0, mwHandles.Remove_HotPixels);
    end
    currImage_Stack  = Selected_Scene(1).currImage_Stack;
    currUnmix_Images = Selected_Scene(1).UnMix(currImage_Stack, handles.Spectrum, handles.Unmix_Method_Index, handles.Background);
end
handles.Scene_Inst(handles.Scene_Index(1)).currUnmix_Images = currUnmix_Images;
UM_Image_Stack          = zeros(2, size(currUnmix_Images,2), size(currUnmix_Images,3), length(Selected_Scene));
UM_Image_Stack(:,:,:,1) = currUnmix_Images(1:2,:,:);

h = waitbar(0,'Unmixing Images - 0%');
for ii = 2:length(Selected_Scene)
    currUnmix_Images = Selected_Scene(ii).currUnmix_Images;
    if isempty(currUnmix_Images)
        Name = Selected_Scene(ii).Name;
        if strcmp(Name(end-3:end),'.dat')
            Last = 999+length(Selected_Scene(ii).Wavelength);
            Selected_Scene(ii) = Selected_Scene(ii).Load_Dat_Images(Selected_Scene(ii).Path, 1000, Last, handles.Hor_Shift);
        else
            Selected_Scene(ii).currImage_Stack = Selected_Scene(ii).Load_Tiff_Image(Name, Selected_Scene(ii).Path, [], handles.Hor_Shift, 0, mwHandles.Remove_HotPixels);
        end
        currImage_Stack  = Selected_Scene(ii).currImage_Stack;
        currUnmix_Images = Selected_Scene(ii).UnMix(currImage_Stack, handles.Spectrum, handles.Unmix_Method_Index, handles.Background);
    end
    handles.Scene_Inst(handles.Scene_Index(ii)).currUnmix_Images = currUnmix_Images;
    UM_Image_Stack(:,:,:,ii) = currUnmix_Images(1:2,:,:);
    waitbar(ii/length(Selected_Scene), h, ['Unmixing Images - ' num2str(round(ii/length(Selected_Scene)*100)) '%']);
end
close(h);

UM_Image_Disp_FigureH = findobj('Tag', 'UM_Image_Disp_FigureH');
if isvalid(UM_Image_Disp_FigureH)
    close(UM_Image_Disp_FigureH); clear('UM_Image_Disp_FigureH');
elseif ~isvalid(UM_Image_Disp_FigureH)
    clear('UM_Image_Disp_FigureH');
end
if isfield(handles, 'currImage_Stack')
    handles.currImage_Stack = [];
end
Display_UnMix_Images(UM_Image_Stack, handles.output);

% Update handles structure
guidata(hObject, handles);