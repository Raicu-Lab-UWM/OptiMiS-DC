function Eapp_peaks = Sort_EappPeaks_wConc_andXa(handles)
    for ii = 1:length(handles.Selc_data)
        fname             = [handles.Path '\' handles.Selc_data{ii}];
        sheet_name        = sheetnames(fname);
        data         = sheet_name(2); 
        xlfile    = xlsread(fname,data);
        Dconc     = xlfile(:,1);
        Aconc     = xlfile(:,2);
        Peak1{ii} = xlfile(:,4);
        Peak2{ii} = xlfile(:,5);        
        DpA{ii}   = Dconc+Aconc;
        Xas{ii}   = Aconc./(Dconc+Aconc);
    end
    
    Eapp_pk1  = cell2mat(Peak1');
    Eapp_pk2  = cell2mat(Peak2');
    DpAconc   = cell2mat(DpA');
    Xa        = cell2mat(Xas');
    Eapp_pks  = [Eapp_pk1 Eapp_pk2];
    
    XaRange   = [handles.Xa_min handles.Xa_max];
    concRange = [handles.Conc_min handles.Conc_max];
    sortedEapp_pks = ConcXa_metahist(DpAconc,concRange,Xa,XaRange,Eapp_pks);
    Eapp_peaks = sortedEapp_pks(sortedEapp_pks>0.005);     %nonzeros(sortedEapp_pks);
end