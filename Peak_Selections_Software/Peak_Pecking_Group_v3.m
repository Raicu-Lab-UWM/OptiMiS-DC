function [Peaks_idx, Selected_Peaks] = Peak_Pecking_Group_v3(Hist_Posn, Hist_Freq, nPeaks, Min_Pk_Hight)
%     Hist_Posn = Hist(1,:);
%     Hist_Freq = Hist(2,:);
    [Maxima, Left_Minima, Right_Minima] = Find_Extrima_new_Group_v3_merge(Hist_Freq, 1, Min_Pk_Hight);
    if ~isempty(Maxima)
        Peaks_Values    = Hist_Freq(Maxima);
        Peaks_Posn      = Hist_Posn(Maxima);
        [Peaks_ReOrder, Peaks_ReOrder_Index] = sort(Peaks_Values,'descend');
        Peaks_Posn_ReOrder = Peaks_Posn(Peaks_ReOrder_Index);
        Maxima_ReOrder     = Maxima(Peaks_ReOrder_Index);
        if nPeaks <= length(Peaks_ReOrder)
            Selected_Peaks = Peaks_Posn_ReOrder(1:nPeaks);
            Peaks_idx      = Maxima_ReOrder(1:nPeaks);
        else
            Selected_Peaks = [Peaks_Posn_ReOrder'; zeros(nPeaks - length(Peaks_Posn_ReOrder),1)];
            Peaks_idx      = [Maxima_ReOrder; zeros(nPeaks - length(Maxima_ReOrder),1)];
        end
    else
        Selected_Peaks = zeros(nPeaks,1);
        Peaks_idx      = zeros(nPeaks,1);
    end
end