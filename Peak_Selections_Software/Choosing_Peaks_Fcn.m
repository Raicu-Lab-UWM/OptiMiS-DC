function [Eapp_Peak_Ind, Peak_Height, Peak_Amp, Fit_Model] = Choosing_Peaks_Fcn (Histogram, Find_Peaks_Method, nPeaks, Thresh_Peak)
if nargin < 4, Thresh_Peak = 5;       end;
if nargin < 3, nPeaks = 3;            end;
if nargin < 2, Find_Peaks_Method = 3; end;

Eapp_Peak_Ind = zeros(nPeaks, length(Thresh_Peak));
Peak_Height   = zeros(nPeaks, length(Thresh_Peak));
Peak_Amp      = zeros(nPeaks, length(Thresh_Peak));
for ii = 1:length(Thresh_Peak)
    switch Find_Peaks_Method
        case 'TH with STD'
            [Maxima, Left_Minima, Right_Minima, ~, ~] = Find_Extrima_wSegmentation(Histogram(:,2)', 'Legitimate_Peaks', 1);
            Maxima_Vect       = Maxima;
            Left_Minima_Vect  = Left_Minima;
            Right_Minima_Vect = Right_Minima;
            [Maxima, Left_Minima, Right_Minima, ~, ~] = Find_Extrima_wSegmentation(Histogram(:,2)', 'Curve_Trand_change', 2);
            
            Left_Minima_Vect(ismember(Maxima_Vect, Maxima))  = [];
            Right_Minima_Vect(ismember(Maxima_Vect, Maxima)) = [];
            Maxima_Vect(ismember(Maxima_Vect, Maxima))       = [];
            Maxima_Vect       = [Maxima_Vect; Maxima];
            Left_Minima_Vect  = [Left_Minima_Vect; Left_Minima];
            Right_Minima_Vect = [Right_Minima_Vect; Right_Minima];
            lAmplitude        = Histogram(Maxima_Vect,2) - Histogram(Left_Minima_Vect,2);
            rAmplitude        = Histogram(Maxima_Vect,2) - Histogram(Right_Minima_Vect,2);
            Amplitude         = min([lAmplitude,rAmplitude],[],2);
            [Amplitude, Sorted_Amp_Ind] = sort(Amplitude, 1, 'descend');
            Maxima            = Maxima_Vect(Sorted_Amp_Ind);
            Minima_Left       = Left_Minima_Vect(Sorted_Amp_Ind);
            Minima_Right      = Right_Minima_Vect(Sorted_Amp_Ind);
            Mean_Out          = Histogram(Maxima,1)';
            Peak_Val          = Histogram(Maxima,2)';
            if ii == 1
                Fit_Model = Fit_Model_Curve(Maxima(1:min([nPeaks,length(Maxima)])), Minima_Left(1:min([nPeaks,length(Maxima)])), Minima_Right(1:min([nPeaks,length(Maxima)])), Histogram);
            end;
        case 'Use Smothening'
            Smoothen_Curve = xCorr_Fit_1D(Histogram(:,2)', [], 1);
            [Peaks, Left_Dips, Right_Dips, Amplitude, Peak_Val] = Find_Extrima(Smoothen_Curve', nPeaks, 2);
            Peaks(Amplitude < Thresh_Peak(ii))      = [];
            Peak_Val(Amplitude < Thresh_Peak(ii))   = [];
            Amplitude (Amplitude < Thresh_Peak(ii)) = [];
            Mean_Out                                = Histogram(Peaks,1)';
            if ii == 1
                Fit_Model = Fit_Model_Curve(Peaks, Left_Dips, Right_Dips, Histogram);
            end;
        case 'Select Hist. Peaks'
            [Peaks, Left_Dips, Right_Dips, Amplitude, Peak_Val] = Find_Extrima(Histogram(:,2)', nPeaks, 2);
            Peaks(Amplitude < Thresh_Peak(ii))      = [];
            Peak_Val(Amplitude < Thresh_Peak(ii))   = [];
            Amplitude (Amplitude < Thresh_Peak(ii)) = [];
            Mean_Out                                = Histogram(Peaks,1)';
            if ii == 1
                Fit_Model = Fit_Model_Curve(Peaks, Left_Dips, Right_Dips, Histogram);
            end;
        case 'Gaussian Fit'
            [Maxima, Left_Minima, Right_Minima, ~, ~] = Find_Extrima_wSegmentation(Histogram(:,2)', 'Curve_Trand_change', 2);
            lAmplitude        = Histogram(Maxima,2) - Histogram(Left_Minima,2);
            rAmplitude        = Histogram(Maxima,2) - Histogram(Right_Minima,2);
            Amplitude         = min([lAmplitude,rAmplitude],[],2);
            [~, Sorted_Amp_Ind] = sort(Amplitude, 1, 'descend');
            Maxima            = Maxima(Sorted_Amp_Ind);
            Left_Minima       = Left_Minima(Sorted_Amp_Ind);
            Right_Minima      = Right_Minima(Sorted_Amp_Ind);
            Peaks             = Maxima(1:min([nPeaks, length(Maxima)]));
            Dips_Left         = Left_Minima(1:min([nPeaks, length(Maxima)]));
            Dips_Right        = Right_Minima(1:min([nPeaks, length(Maxima)]));
            
            Hist_Bin   = Histogram(2,1)-Histogram(1,1);
            Mean_In    = [Histogram(Peaks,1)', round(size(Histogram,1)/2)*Hist_Bin];
            if length(Mean_In) == 1
                STD_In     = [size(Histogram,1)/4]*Hist_Bin;
            else
                STD_In     = [mean([Peaks'-Dips_Left'; Dips_Right'-Peaks'],1)/3, size(Histogram,1)/4]*Hist_Bin;
            end;
            Init_Guess = [Mean_In', STD_In'];
            [Mean_Out, Fit_Model] = Fit_Gaussians(Histogram', Init_Guess, 2);
%             Mean_Out   = sort(Mean_Out,2,'ascend');
            Mean_Out(Mean_Out > 1) = 0;
            Eapp_Peak_Position = zeros(length(Mean_Out),1);
            for jj = 1:length(Mean_Out)
                Eapp_Peak_Position(jj) = round(Mean_Out(jj)/Hist_Bin)+1;
            end;
            if isempty(Eapp_Peak_Position)
                Peak_Val = 0;
            else
                Peak_Val   = Histogram(Eapp_Peak_Position,2)';
            end
            Amplitude  = Peak_Val';
        otherwise
    end;
    
    if length(Mean_Out) < nPeaks
        Zero_Peak       = nPeaks - length(Mean_Out);
        crEapp_Peak_Ind = padarray(Mean_Out,[0,Zero_Peak],NaN,'post');
        crEapp_Height   = padarray(Peak_Val,[0,Zero_Peak],NaN,'post');
        crAmplitude     = padarray(Amplitude',[0,Zero_Peak],NaN,'post');
    else 
        crEapp_Peak_Ind = Mean_Out(1:nPeaks);
        crEapp_Height   = Peak_Val(1:nPeaks);
        crAmplitude     = Amplitude(1:nPeaks)';
    end;
    
    Eapp_Peak_Ind(:,ii) = crEapp_Peak_Ind;
    Peak_Height(:,ii)   = crEapp_Height;
    Peak_Amp(:,ii)      = crAmplitude;
end;

function Fit_Model = Fit_Model_Curve(Peaks, Left_Dips, Right_Dips, Histogram)

Fit_Model = zeros(size(Histogram,1),1);
for jj = 1:length(Peaks)
    % Remove the case were the gaussian fit try to fit a peak as
    % well as a high value in the first cell of the Histogram curve.
    if Left_Dips(jj) > 1
        xData = Histogram(Left_Dips(jj):Right_Dips(jj),1);
        yData = Histogram(Left_Dips(jj):Right_Dips(jj),2);
    else
        xData = Histogram(Left_Dips(jj)+1:Right_Dips(jj),1);
        yData = Histogram(Left_Dips(jj)+1:Right_Dips(jj),2);
    end;
    A     = [xData.^2, xData, ones(length(xData),1)];
    b     = log(yData+1e-10*(yData==0));
    Xx    = A\b;
    mu    = -Xx(2)/Xx(1)/2;
    sigma = sqrt( -1/2/Xx(1));
    xx    = Histogram(:,1);
    if imag(sigma) ~= 0
        sigma = 1e-4;
        mu    = Histogram(Peaks(jj),1);
    end;
    % Eliminating the case were we have only peak and no dips at all.
    if length(xData) == 1
        ccGaussian = 0*exp(-0.5*((xx-mu)/sigma).^2);
        ccGaussian(Peaks(jj)) = Histogram(Peaks(jj),2);
    else
        ccGaussian = Histogram(Peaks(jj),2)*exp(-0.5*((xx-mu)/sigma).^2);
    end;
    Fit_Model = max([Fit_Model, ccGaussian],[],2);
end;
Fit_Model = Fit_Model(2:end);