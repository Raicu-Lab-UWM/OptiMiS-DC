function Eapp_peaks = Sort_EappPeaks_wConc_andXa_peakLevel(main_handle)
    for ii = 1:length(main_handle.Selc_data)
        fname        = [main_handle.Path '\' main_handle.Selc_data{ii}];
        sheet_name   = sheetnames(fname);
        
        switch main_handle.Conc_method
            case 'Segment pixels mean concentration'
                data         = sheet_name(3); 
                xlfile       = xlsread(fname,data);
                Dconc     = xlfile(:,1);
                Aconc     = xlfile(:,2);
                Peak1     = xlfile(:,5);
                Peak2     = xlfile(:,6);
                Dconc     = [Dconc; Dconc];
                Aconc     = [Aconc; Aconc];
    
                Eapp_pks{ii}     = [Peak1; Peak2];
                DpA{ii}          = Dconc+Aconc;
                Xas{ii}          = Aconc./(Dconc+Aconc);
            case 'Peak pixels median concentration'
                data         = sheet_name(5); 
                xlfile       = xlsread(fname,data);
                Dconc_pk1    = xlfile(:,1);
                Dconc_pk2    = xlfile(:,2);
                Aconc_pk1    = xlfile(:,3);
                Aconc_pk2    = xlfile(:,4);
                Peak1        = xlfile(:,9);
                Peak2        = xlfile(:,10);
                Dconc        = [Dconc_pk1; Dconc_pk2];
                Aconc        = [Aconc_pk1; Aconc_pk2];
    
                Eapp_pks{ii} = [Peak1; Peak2];
                DpA{ii}      = Dconc+Aconc;
                Xas{ii}      = Aconc./(Dconc+Aconc);
        end
    end
    
    Eapp_pks  = cell2mat(Eapp_pks');
    DpAconc   = cell2mat(DpA');
    Xa        = cell2mat(Xas');
    
    XaRange   = [main_handle.Xa_min main_handle.Xa_max];
    concRange = [main_handle.Conc_min main_handle.Conc_max];
    sortedEapp_pks = ConcXa_metahist(DpAconc,concRange,Xa,XaRange,Eapp_pks);
    Eapp_peaks = sortedEapp_pks(sortedEapp_pks>0.005);     %nonzeros(sortedEapp_pks);
end