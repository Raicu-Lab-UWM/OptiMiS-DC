function [hist_freq, avg_arr] = Histogram_and_corres_arr(bins, hist_data, arr)
    arr_mat = [hist_data arr];
    if size(arr_mat,2) ~= 2
        arr_mat = arr_mat';
    else
        arr_mat = arr_mat;
    end
    %ascend matrix based on hist_data
    mat_ascend = sortrows(arr_mat,1,{'ascend'});
    %make histogram from hist_data and bins
    hist_freq  = histcounts(mat_ascend(:,1), bins);
    %cumulative frequency of non zero freq
    freq_nonzero = nonzeros(hist_freq);
    cum_freq   = cumsum(freq_nonzero);
    cum_freq   = [0; cum_freq];
    arr_ascend = mat_ascend(:,2);
    for ii = 1:length(cum_freq)-1
        avg_arr_nonzero(ii)  =  median(arr_ascend((cum_freq(ii)+1):cum_freq(ii+1)));
    end 
    %construct an array with same size as hist_freq for average_arr
    avg_arr = hist_freq; %hist_freq as reference
    %replace all teh nonzeros in avg_arr with avg_arr_nonzero
    avg_arr(avg_arr~=0) = avg_arr_nonzero;
end
