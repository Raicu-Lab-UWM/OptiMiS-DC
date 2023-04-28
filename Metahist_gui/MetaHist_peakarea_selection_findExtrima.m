% peak selection and visibility calculation
function [Peaks_posn, Left_min_posn, Right_min_posn, peak_visblty, sldr_visblty, area_visblty] = MetaHist_peakarea_selection_findExtrima(meta_bins, metaHist, Normalize)
    [Max_loc, Left_min_loc, Right_min_loc]   = Find_Extrima_new_Group_v3_merge(metaHist,1,2);
    switch Normalize
        case 'Normalized'
           metaHist      = metaHist/max(metaHist); 
        otherwise
    end 
    Max_val       = metaHist(Max_loc);
    Left_min_val  = metaHist(Left_min_loc);
    Right_min_val = metaHist(Right_min_loc);
    
    Peaks_posn     = meta_bins(Max_loc);
    Left_min_posn  = meta_bins(Left_min_loc);
    Right_min_posn = meta_bins(Right_min_loc);
%     Minima_posn    = [Left_min_posn; Right_min_posn(end)];
      
    Amp_left     = Max_val-Left_min_val;
    Amp_Right    = Max_val-Right_min_val;
%     Avg_Amp      = max([Amp_left',Amp_Right'],[],2);
    Avg_Amp      = (Amp_left+Amp_Right)/2;
    Peak_sd      = sqrt(Max_val);
    
    AvgAmp_sd    = Avg_Amp; %Avg_Amp./Peak_sd;
    % points contributing for a peak between left and right minima 
    shoulder_count = Right_min_loc-Left_min_loc-1; 
    if size(AvgAmp_sd,1) == size(shoulder_count,1)
        AvgAmp_sldr   = AvgAmp_sd.*shoulder_count;
    else
        AvgAmp_sldr   = AvgAmp_sd'.*shoulder_count;
    end
    
    for jj = 1:length(Max_loc)
        shoulder_loc       = (Left_min_loc(jj)+1):(Right_min_loc(jj)-1);
%         shoulder_loc       = (Left_min_loc(jj)):(Right_min_loc(jj));
        shoulder_val       = metaHist(shoulder_loc); 
        mi_value           = min(Left_min_val(jj), Right_min_val(jj));
        shoulder_Amp       = shoulder_val - mi_value;
        shoulder_sum       = sum(shoulder_Amp);
        max_value          = Max_val(jj);
        
        Peak_area(jj)      = shoulder_sum; %/(max_value-mi_value);  % infact Peak Area/bin size
    end
    if size(AvgAmp_sd,1) == size(Peak_area,1)
        AvgAmp_area    = AvgAmp_sd.*Peak_area;
    else
        AvgAmp_area    = AvgAmp_sd'.*Peak_area;
    end
    
    
%     % visibility
    tot_peaks    = length(Max_loc);

%     peak_visblty = sum(AvgAmp_sd)/tot_peaks;
%     sldr_visblty = sum(AvgAmp_sldr)/tot_peaks;
%     area_visblty = sum(AvgAmp_area)/tot_peaks;

    tot_points   = sum(shoulder_count);
% %     sldr_visblty = sum(AvgAmp_sldr)/(tot_peaks*tot_points);

    peak_visblty = sum(AvgAmp_sd);
    sldr_visblty = sum(AvgAmp_sldr);
    area_visblty = sum(AvgAmp_area);
end