function handles = Save_FRET_Info_FNC(handles, FICoS_Setting_Struct, Disp_Setting_Struct)

if isfield(handles, 'Eapp_Hist_2D')
    if ~isempty(handles.Eapp_Hist_2D)
        Hist2D   = handles.Eapp_Hist_2D;
        Eapp_Bin = handles.Capp_BinSize;
        Hist2D   = [[0:Eapp_Bin:1]', Hist2D];
        noConc = false;
    else Hist2D = [];
        noConc = true;
        Eapp_Peak_List = [handles.FRET_List.Eapp]';
    end
else Hist2D = [];
    noConc = true;
    if size(handles.FRET_List(1).Eapp,2) == 1
        Eapp_Peak_List = cell2mat(cellfun(@transpose,{handles.FRET_List.Eapp}, 'UniformOutput', false))';
    else
        Eapp_Peak_List = [handles.FRET_List.Eapp]';
    end
end

[Name, handles.Ana_Path] = uiputfile([handles.Ana_Path '\*.xlsx;*.xls;*.mfrt;*.txt'], 'Save FRET Data to:');

if ~noConc, Eapp_vsXA_Info = Calc_Eapp_vsXA(handles.output); end

Period_Loc = strfind(Name, '.');
File_Type  = Name(Period_Loc(end)+1:end);

switch File_Type
    case {'xlsx', 'xls'}
        writetable(struct2table(FICoS_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'FICoS_Settings', 'Range', 'B3');
        writetable(struct2table(Disp_Setting_Struct), [handles.Ana_Path '\' Name], 'Sheet', 'Disp_Settings', 'Range', 'B3');
        if ~noConc
            xlswrite([handles.Ana_Path '\' Name], handles.TEW_Molecular_Info, 'TEW_Molecular_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Concentration', 'xA', '<Eapp>', 'FDA-1', 'FAD-1', 'FAD-2', 'Eapp'}, 'TEW_Molecular_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Conc_Val(1:size(Hist2D,2)-1)', 'Eapp_Conc_2D-Hist', 'B1');
            xlswrite([handles.Ana_Path '\' Name], Hist2D, 'Eapp_Conc_2D-Hist', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'Concentration', 'xA', 'Eapp', '<Eapp>'}, 'Scatter_Plot_Info', 'A1');
            xlswrite([handles.Ana_Path '\' Name], handles.Scatter_Plot_Info, 'Scatter_Plot_Info', 'A2');
            xlswrite([handles.Ana_Path '\' Name], {'xA', 'Eapp', 'xA-STD', 'Eapp-STD'}, 'Eapp_vs_xA', 'A1');
            xlswrite([handles.Ana_Path '\' Name], Eapp_vsXA_Info, 'Eapp_vs_xA', 'A2');
        else
            xlswrite([handles.Ana_Path '\' Name], Eapp_Peak_List, 'Eapp_Peak_List', 'A2');
        end
    case 'mfrt'
        FRET_List_Struct = handles.FRET_List;
        save([handles.Ana_Path '\' Name], 'FRET_List_Struct', '-mat');
        save([handles.Ana_Path '\' Name], 'FICoS_Setting_Struct', '-mat', '-append');
        save([handles.Ana_Path '\' Name], 'Disp_Setting_Struct', '-mat', '-append');
        if ~noConc
            TEW_Molecular_Info = handles.TEW_Molecular_Info;
            save([handles.Ana_Path '\' Name], 'TEW_Molecular_Info', '-mat', '-append');
            save([handles.Ana_Path '\' Name], 'Hist2D', '-mat', '-append');
            Scatter_Plot_Info = handles.Scatter_Plot_Info;
            save([handles.Ana_Path '\' Name], 'Scatter_Plot_Info', '-mat', '-append');
            save([handles.Ana_Path '\' Name], 'Eapp_vsXA_Info', '-mat', '-append');
        end
    case 'txt'
    otherwise
end