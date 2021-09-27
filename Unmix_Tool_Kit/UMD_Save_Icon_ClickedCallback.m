function UMD_Save_Icon_ClickedCallback(hObject, eventdata, Main_FigureH)

handles    = guidata(Main_FigureH);

if ~handles.StandAlone, mwHandles = guidata(handles.mwFigureH);
    eSpectra = mwHandles.eSpectra;
else, eSpectra = handles.eSpectra;
end

Low_TH_Val = handles.TH_Value(1); High_TH_Val = handles.TH_Value(2); Inc_TH_Val = handles.TH_Value(3);
if High_TH_Val < Low_TH_Val, High_TH_Val = Low_TH_Val; end

if strcmp(mwHandles.UM_Params.Analysis_Type,'FRET') % from line 13 to 17 added by Dammar with help of Gabby on 9/27/2020 to avoid error while compiling.
     File_List_toSave = struct('Basic', 1, 'Eapp', 1, 'Basic_FICoS', 0, 'Capp', 0, 'Chi2', 1);
else
     File_List_toSave = struct('Basic', 0, 'Eapp', 0, 'Basic_FICoS', 1, 'Capp', 1, 'Chi2', 1);
end

if handles.Separate_Dir
    nScenes    = length(handles.Scene_Index);
    h          = waitbar(0,'Wrting Image to File - 0%');
    for ii = 1:nScenes
        if strcmp(mwHandles.UM_Params.Analysis_Type,'FRET')
            File_List_toSave = struct('Basic', 1, 'Eapp', 1, 'Basic_FICoS', 0, 'Capp', 0, 'Chi2', 1);
        else
            File_List_toSave = struct('Basic', 0, 'Eapp', 0, 'Basic_FICoS', 1, 'Capp', 1, 'Chi2', 1);
        end
        currScene   = handles.Scene_Inst(handles.Scene_Index(ii));
        Name        = currScene.Name;
        if strcmp(Name(end-3:end),'.dat')
            Last      = 999 + length(currScene.Wavelength);
            currScene = currScene.Load_Dat_Images(currScene.Path, 1000, Last, handles.Hor_Shift);
        else, currScene.currImage_Stack = currScene.Load_Tiff_Image(Name, currScene.Path, [], handles.Hor_Shift, 0);
        end
        Path        = Create_Image_Folder(handles.Ana_Path, Name, handles.Separate_Dir);
        for Thresh_Val = Low_TH_Val:Inc_TH_Val:High_TH_Val
            if Thresh_Val > Low_TH_Val
                if strcmp(mwHandles.UM_Params.Analysis_Type,'FRET')
                    File_List_toSave.Basic = 0;
                    File_List_toSave.Chi2  = 0;
                else
                    File_List_toSave.Basic_FICoS = 0;
                    File_List_toSave.Chi2  = 0;
                end
            end
            Saving_Param = struct('Threshold', Thresh_Val, 'Threshold_Method_Index', handles.Threshold_Method_Index, ...
                                  'Background', handles.Background, 'Save_TH_Images', handles.Save_TH_Images, ...
                                  'File_List_toSave', File_List_toSave);
            [~, ~, ~]    = currScene.Save_Analyzied_Images(eSpectra, Path, Name, Saving_Param);
        end
        waitbar(ii/nScenes, h, ['Wrting Image to File - ' num2str(round(ii/nScenes*100)) '%']);
    end
    close(h);
else
    for Thresh_Val = Low_TH_Val:Inc_TH_Val:High_TH_Val
        if Thresh_Val > Low_TH_Val
            if strcmp(mwHandles.UM_Params.Analysis_Type,'FRET')
                File_List_toSave.Basic = 0;
                File_List_toSave.Chi2  = 0;
            else
                File_List_toSave.Basic_FICoS = 0;
                File_List_toSave.Chi2  = 0;
            end
        end
        Saving_Param = struct('Threshold', Thresh_Val, 'Threshold_Method_Index', handles.Threshold_Method_Index, ...
                              'Background', handles.Background, 'Save_TH_Images', handles.Save_TH_Images, ...
                              'File_List_toSave', File_List_toSave, 'Hor_Shift', handles.Hor_Shift);
        handles.Scene_Inst(handles.Scene_Index) = handles.Scene_Inst(handles.Scene_Index).Save_Analyzied_Stacks(eSpectra, handles.Ana_Path, Saving_Param);
    end
end

guidata(Main_FigureH, handles);
