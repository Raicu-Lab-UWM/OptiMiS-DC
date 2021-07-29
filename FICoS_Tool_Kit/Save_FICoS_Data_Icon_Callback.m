function Save_FICoS_Data_Icon_Callback(hObject, eventdata)
handles = guidata(hObject);

FICoS_Setting_Struct = struct('FICoS_Hist_Bin', handles.FICoS_Hist_Bin, 'FICoS_MetaHist_Bin', handles.FICoS_MetaHist_Bin, ...
                             'FICoS_nGaussians', handles.FICoS_nGaussians, 'FICoS_Fit_Method', handles.FICoS_Fit_Method, ...
                             'FICoS_Fit_Range', handles.FICoS_Fit_Range, 'FICoS_Method', handles.FICoS_Method, ...
                             'SEW_Capp', handles.SEW_Capp);

Disp_Setting_Struct = struct('Capp_minRange', handles.Capp_minRange, 'Capp_maxRange', handles.Capp_maxRange, ...
                             'Capp_BinSize', handles.Capp_BinSize, 'Conc_minRange', handles.Conc_minRange, ...
                             'Conc_maxRange', handles.Conc_maxRange, 'Conc_BinSize', handles.Conc_BinSize, ...
                             'Pixel_Size', handles.Pixel_Size, 'Pr_MultFact', handles.Pr_MultFact, ...
                             'Accum_Data', handles.Accum_Data);

% [Name, handles.Ana_Path] = uiputfile([handles.Ana_Path '\*.xlsx;*.xls;*.mfrt;*.txt'], 'Save FICoS Data to:');
% 
% Period_Loc = strfind(Name, '.');
% File_Type  = Name(Period_Loc(end)+1:end);

mwHandles = guidata(handles.mwFigureH);
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS'), handles = Save_FICoS_Info_FNC(handles, FICoS_Setting_Struct, Disp_Setting_Struct);
else handles = Save_FRET_Info_FNC(handles, FICoS_Setting_Struct, Disp_Setting_Struct);
end

% switch File_Type
%     case 'xlsx'
%         writetable(struct2table(FICoS_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'FICoS_Settings', 'Range', 'B3');
%         writetable(struct2table(Disp_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'Disp_Settings', 'Range', 'B3');
%         if handles.Calc_2D_FICoS_Switch
%             Capp_Hist_2D = handles.Capp_Hist_2D;
%             Hist2D       = Capp_Hist_2D;
%             Capp_Bin     = handles.Capp_BinSize;
%             Hist2D       = [[0:Capp_Bin:1]', Hist2D];
% %             Name         = 'TEW_FICoS_Data_Summary.xlsx';
%             xlswrite([handles.Ana_Path '\' Name], handles.TEW_Molecular_Info, 'TEW_Molecular_Info', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'Capp', '<Capp>', 'Concentration', '2 Ex FD', '2 Ex FA', 'xA'}, 'TEW_Molecular_Info', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Capp_Conc_2D-Hist', 'B1');
%             xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Capp_Conc_2D-Hist', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'Conc.', 'xA', 'nD', 'Capp'}, 'Scatter_Plot_Info', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'xA', 'Capp', 'xA-STD', 'Capp-STD'}, 'Capp_vs_xA', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Capp_vsXA_Info, 'Capp_vs_xA', 'A2');
%         else
%         end;
%     case 'xls'
%         writetable(struct2table(FICoS_Setting_Struct, [handles.Ana_Path '\' Name]), 'Sheet', 'FICoS_Settings', 'Range', 'B3');
%         writetable(struct2table(Disp_Setting_Struct, [handles.Ana_Path '\' Name]), 'Sheet', 'Disp_Settings', 'Range', 'B3');
%         if handles.Calc_2D_FICoS_Switch
%             Capp_Hist_2D = handles.Capp_Hist_2D;
%             Hist2D       = Capp_Hist_2D;
%             Capp_Bin     = handles.Capp_BinSize;
%             Hist2D       = [[0:Capp_Bin:1]', Hist2D];
%             xlswrite([handles.Ana_Path '\' Name], handles.TEW_Molecular_Info, 'TEW_Molecular_Info', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'Capp', '<Capp>', 'Concentration', '2 Ex FD', '2 Ex FA', 'xA'}, 'TEW_Molecular_Info', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Capp_Conc_2D-Hist', 'B1');
%             xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Capp_Conc_2D-Hist', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'Conc.', 'xA', 'nD', 'Capp'}, 'Scatter_Plot_Info', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
%             xlswrite([handles.Ana_Path '\' Name], {'xA', 'Capp', 'xA-STD', 'Capp-STD'}, 'Capp_vs_xA', 'A1');
%             xlswrite([handles.Ana_Path '\' Name], handles.Capp_vsXA_Info, 'Capp_vs_xA', 'A2');
%         else
%         end;
%     case 'mfrt'
%         FICoS_List_Struct = handles.FICoS_List;
%         save([handles.Ana_Path '\' Name], 'FICoS_List_Struct', '-mat');
%         save([handles.Ana_Path '\' Name], 'FICoS_Setting_Struct', '-mat', '-append');
%         save([handles.Ana_Path '\' Name], 'Disp_Setting_Struct', '-mat', '-append');
%         if handles.Calc_2D_FICoS_Switch
%             TEW_Molecular_Info = handles.TEW_Molecular_Info;
%             save([handles.Ana_Path '\' Name], 'TEW_Molecular_Info', '-mat', '-append');
%             Capp_Hist_2D = handles.Capp_Hist_2D;
%             save([handles.Ana_Path '\' Name], 'Capp_Hist_2D', '-mat', '-append');
%             Scatter_Plot_Info = handles.Scatter_Plot_Info;
%             save([handles.Ana_Path '\' Name], 'Scatter_Plot_Info', '-mat', '-append');
%             Capp_vsXA_Info = handles.Capp_vsXA_Info;
%             save([handles.Ana_Path '\' Name], 'Capp_vsXA_Info', '-mat', '-append');
%         end;
%     case 'txt'
%     otherwise
% end
% 
guidata(hObject, handles);
% end