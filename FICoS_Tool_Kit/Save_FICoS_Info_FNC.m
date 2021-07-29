function handles = Save_FICoS_Info_FNC(handles, FICoS_Setting_Struct, Disp_Setting_Struct)

Hist2D   = handles.Capp_Hist_2D;
Capp_Bin = handles.Capp_BinSize;

mwHandles = guidata(handles.mwFigureH);
if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    Hist2D   = [[-1:Capp_Bin:1]', Hist2D];
else
    Hist2D   = [[0:Capp_Bin:1]', Hist2D];
end

[Name, handles.Ana_Path] = uiputfile([handles.Ana_Path '\*.xlsx;*.xls;*.fics;*.txt'], 'Save FICoS Data to:');

Period_Loc = strfind(Name, '.');
File_Type  = Name(Period_Loc(end)+1:end);

switch File_Type
    case {'xlsx', 'xls'}
        writetable(struct2table(FICoS_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'FICoS_Settings', 'Range', 'B3');
        writetable(struct2table(Disp_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'Disp_Settings', 'Range', 'B3');
        xlswrite([handles.Ana_Path '\' Name], handles.FICoS_Molecular_Info, 'FICoS_Molecular_Info', 'A2');
        xlswrite([handles.Ana_Path '\' Name], {'Capp', 'Concentration'}, 'FICoS_Molecular_Info', 'A1');
        xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Capp_Conc_2D-Hist', 'B1');
        xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Capp_Conc_2D-Hist', 'A2');
        xlswrite([handles.Ana_Path '\' Name], {'Conc.', 'Capp'}, 'Scatter_Plot_Info', 'A1');
        xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
    case 'fics'
        FICoS_List_Struct = handles.FICoS_List;
        save([handles.Ana_Path '\' Name], 'FICoS_List_Struct', '-mat');
        save([handles.Ana_Path '\' Name], 'FICoS_Setting_Struct', '-mat', '-append');
        save([handles.Ana_Path '\' Name], 'Disp_Setting_Struct', '-mat', '-append');
        FICoS_Molecular_Info = handles.FICoS_Molecular_Info;
        save([handles.Ana_Path '\' Name], 'FICoS_Molecular_Info', '-mat', '-append');
        save([handles.Ana_Path '\' Name], 'Hist2D', '-mat', '-append');
        Scatter_Plot_Info = handles.Scatter_Plot_Info;
        save([handles.Ana_Path '\' Name], 'Scatter_Plot_Info', '-mat', '-append');
    case 'txt'
    otherwise
end