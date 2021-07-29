function Save_FRET_Data_Icon_Callback(hObject, eventdata)
handles = guidata(hObject);

FRET_Setting_Struct = struct('FRET_Hist_Bin', handles.FRET_Hist_Bin, 'FRET_MetaHist_Bin', handles.FRET_MetaHist_Bin, ...
                             'FRET_nGaussians', handles.FRET_nGaussians, 'FRET_Fit_Method', handles.FRET_Fit_Method, ...
                             'FRET_Fit_Range', handles.FRET_Fit_Range, 'FRET_Method', handles.FRET_Method, ...
                             'SEW_Eapp', handles.SEW_Eapp);

Disp_Setting_Struct = struct('Eapp_minRange', handles.Eapp_minRange, 'Eapp_maxRange', handles.Eapp_maxRange, ...
                             'Eapp_BinSize', handles.Eapp_BinSize, 'Conc_minRange', handles.Conc_minRange, ...
                             'Conc_maxRange', handles.Conc_maxRange, 'Conc_BinSize', handles.Conc_BinSize, ...
                             'Pixel_Size', handles.Pixel_Size, 'Pr_MultFact', handles.Pr_MultFact, ...
                             'Accum_Data', handles.Accum_Data);

[Name, handles.Ana_Path] = uiputfile([handles.Ana_Path '\*.xlsx;*.xls;*.mfrt;*.txt'], 'Save FRET Data to:');

Period_Loc = strfind(Name, '.');
File_Type  = Name(Period_Loc(end)+1:end);
switch File_Type
    case 'xlsx'
        writetable(struct2table(FRET_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'FRET_Settings', 'Range', 'B3');
        writetable(struct2table(Disp_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'Disp_Settings', 'Range', 'B3');
        if handles.Calc_2D_FRET_Switch
            Eapp_Hist_2D = handles.Eapp_Hist_2D;
%             Norm_Factor  = max(max(Eapp_Hist_2D));
%             Hist2D       = Eapp_Hist_2D/Norm_Factor;
            Hist2D       = Eapp_Hist_2D;
            Eapp_Bin     = handles.Eapp_BinSize;
            Hist2D       = [[0:Eapp_Bin:1]', Hist2D];
%             Name         = 'TEW_FRET_Data_Summary.xlsx';
            xlswrite([handles.Ana_Path '\' Name], handles.TEW_Molecular_Info, 'TEW_Molecular_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Eapp', '<Eapp>', 'Concentration', '2 Ex FD', '2 Ex FA', 'xA'}, 'TEW_Molecular_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Eapp_Conc_2D-Hist', 'B1');
            xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Eapp_Conc_2D-Hist', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Conc.', 'xA', 'nD', 'Eapp'}, 'Scatter_Plot_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'xA', 'Eapp', 'xA-STD', 'Eapp-STD'}, 'Eapp_vs_xA', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Eapp_vsXA_Info, 'Eapp_vs_xA', 'A2');
        else
        end;
    case 'xls'
        writetable(struct2table(FRET_Setting_Struct, [handles.Ana_Path '\' Name]), 'Sheet', 'FRET_Settings', 'Range', 'B3');
        writetable(struct2table(Disp_Setting_Struct, [handles.Ana_Path '\' Name]), 'Sheet', 'Disp_Settings', 'Range', 'B3');
        if handles.Calc_2D_FRET_Switch
            Eapp_Hist_2D = handles.Eapp_Hist_2D;
            Hist2D       = Eapp_Hist_2D;
            Eapp_Bin     = handles.Eapp_BinSize;
            Hist2D       = [[0:Eapp_Bin:1]', Hist2D];
            xlswrite([handles.Ana_Path '\' Name], handles.TEW_Molecular_Info, 'TEW_Molecular_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Eapp', '<Eapp>', 'Concentration', '2 Ex FD', '2 Ex FA', 'xA'}, 'TEW_Molecular_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Eapp_Conc_2D-Hist', 'B1');
            xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Eapp_Conc_2D-Hist', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Conc.', 'xA', 'nD', 'Eapp'}, 'Scatter_Plot_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'xA', 'Eapp', 'xA-STD', 'Eapp-STD'}, 'Eapp_vs_xA', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Eapp_vsXA_Info, 'Eapp_vs_xA', 'A2');
        else
        end;
    case 'mfrt'
        FRET_List_Struct = handles.FRET_List;
        save([handles.Ana_Path '\' Name], 'FRET_List_Struct', '-mat');
        save([handles.Ana_Path '\' Name], 'FRET_Setting_Struct', '-mat', '-append');
        save([handles.Ana_Path '\' Name], 'Disp_Setting_Struct', '-mat', '-append');
        if handles.Calc_2D_FRET_Switch
            TEW_Molecular_Info = handles.TEW_Molecular_Info;
            save([handles.Ana_Path '\' Name], 'TEW_Molecular_Info', '-mat', '-append');
            Eapp_Hist_2D = handles.Eapp_Hist_2D;
            save([handles.Ana_Path '\' Name], 'Eapp_Hist_2D', '-mat', '-append');
            Scatter_Plot_Info = handles.Scatter_Plot_Info;
            save([handles.Ana_Path '\' Name], 'Scatter_Plot_Info', '-mat', '-append');
            Eapp_vsXA_Info = handles.Eapp_vsXA_Info;
            save([handles.Ana_Path '\' Name], 'Eapp_vsXA_Info', '-mat', '-append');
        end;
    case 'txt'
    otherwise
end

guidata(hObject, handles);
end