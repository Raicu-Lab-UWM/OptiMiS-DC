function [bin_origin, visibility, Optm_Metabins, Optm_Metahist, Optm_origin, Optm_pkposn] = Optimize_metaHist_origin_fixBinsize_func(handles, Normalize, Visibility_Type)
    bin_origin = 0:handles.Bin_origin:handles.Bin_size; % list of bin origin starts from 0 to bin size with increment entered in bin orgin.
    for ii = 1: length(bin_origin)
        meta_bin         = bin_origin(ii): handles.Bin_size : bin_origin(ii)+1;
        bin_cntr         = meta_bin+(handles.Bin_size/2); % midpoint position for each bins
        bin_cntr         = bin_cntr';
        meta_bins(:,ii)  = bin_cntr;
%         metaHist(:,ii)   = histc(Eapp_peaks,meta_bins(:,ii));
        metaHist(:,ii)   = histc(round(handles.Eapp_peaks*1000),round(meta_bin'*1000));
        % calculate visibility for each bin origin
        [Peaks_posn{ii}, Left_posn{ii},Right_posn{ii}, peak_visblty(ii), sldr_visblty(ii), area_visblty(ii)] = MetaHist_peakarea_selection_findExtrima(meta_bins(:,ii), metaHist(:,ii), Normalize);
    end
    % different types of visibility ( though we use visibility with peak
    % only)
    switch Visibility_Type
        case 'Visibility with peak only'
            visibility = peak_visblty;
        case 'Visibility with points betn minima'
            visibility = sldr_visblty;
        case 'Visibility with peak area'
            visibility = area_visblty;
        otherwise
    end            
    % find optimum metahistogram 
    [Optm_visblty,Optm_idx] = max(visibility);
    Optm_pkposn   = Peaks_posn{Optm_idx};
    Optm_Lfposn   = Left_posn{Optm_idx};
    Optm_Rtposn   = Right_posn{Optm_idx};
    Optm_origin   = bin_origin(Optm_idx);
    Optm_Metahist = metaHist(:,Optm_idx);
    Optm_Metabins = meta_bins(:,Optm_idx);
%     OptmMetahist_table   = [Optm_Metabins, Optm_Metahist];
%     AllMetahist_table    = [meta_bins, metaHist];
%     writematrix(AllMetahist_table,[fullname,'_OptmMetahist.txt'],'Delimiter','\t');

% plot visibility vs bin origin and optimized metahistogram side by side
    figure1 =figure;
    set(gcf, 'Position',  [100, 100, 1200, 400]);    
    subplot(1,2,1);
    plot(bin_origin, visibility,'-o','LineWidth',3,'MarkerSize',5,'Color',[0,0,1]);
    xlabel('Bin origin','FontSize', 16);
    ylabel(Visibility_Type,'FontSize', 16);
    title(sprintf('%s%.3f','Fix Bin size =  ', handles.Bin_size),'FontSize', 16);
    ax = gca(figure1);
    ax.FontSize = 16;

    subplot(1,2,2);
    plot(Optm_Metabins, Optm_Metahist, '-o','DisplayName','Histogram','LineWidth',3,'MarkerSize',5,'Color',[0,0,1]);
%     for jj = 1:length(Optm_pkposn)
%         xline(Optm_pkposn(jj),'--r','DisplayName','Visual Peaks','LineWidth',2);
%     end
    xlabel('Eapp','FontSize', 16);
    ylabel('Frequency','FontSize', 16);
    xlim([0,1]);
    xticks([0.2,0.4,0.6, 0.8, 1]);
    title('Optimized metahistogram', 'Fontsize', 16);
    ax = gca(figure1);
    ax.FontSize = 16;
%      saveas(figure1,[fullname,'_VisiblityandMetahist.png']);  
%     close(figure1);
end