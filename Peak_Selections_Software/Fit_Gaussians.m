function [Peaks, Model] = Fit_Gaussians(Data, First_Iter, Data_Start_Point)

Mean_In = First_Iter(:,1);
STD_In  = First_Iter(:,2);
Data    = Data(:,Data_Start_Point:end);

[Model, ~, Peaks, ~, Height] = MultiGauss_Fit(Data, Mean_In', STD_In');
% Amp                    = Amp(1:length(Peaks));
Height(Peaks<0)        = [];
Peaks(Peaks<0)         = [];
[~, Sorted_Amp_Ind]    = sort(Height,1,'descend');
Peaks                  = Peaks(Sorted_Amp_Ind);
Peaks                  = Peaks(1:min([size(First_Iter,1), length(Peaks)]));
% Bin                    = Data(1,2)-Data(1,1);
% Peaks                  = Sorted_Amp_Ind(1:min([size(First_Iter,1), length(Peaks)]))*Bin;
if isempty(Peaks)
    [~,Peaks_Ind] = max(Data(2,:));
    Peaks         = Data(1,Peaks_Ind);
end;