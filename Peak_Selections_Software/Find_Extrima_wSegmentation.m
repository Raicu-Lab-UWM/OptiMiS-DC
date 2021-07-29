function [Maxima, Left_Minima, Right_Minima, Curve_Segments, Legit_Vect] = Find_Extrima_wSegmentation(Curve_In, Segmentation_Type, Start_Pos)

Curve = Curve_In(Start_Pos:end);
[Peaks, Left_Dips, Right_Dips, ~, ~] = Find_Extrima(Curve, length(Curve), 1);
[Peaks_ReOrder, Peaks_ReOrder_Index] = sort(Peaks,'ascend');
Left_Dips_ReOrder  = Left_Dips(Peaks_ReOrder_Index);
Right_Dips_ReOrder = Right_Dips(Peaks_ReOrder_Index);

Peaks_Values    = Curve(Peaks_ReOrder);
lDips_Values    = Curve(Left_Dips_ReOrder);
rDips_Values    = Curve(Right_Dips_ReOrder);
stdPeaks        = sqrt(Peaks_Values);
std_lDips       = sqrt(lDips_Values);
std_rDips       = sqrt(rDips_Values);
Left_Amplitude  = Peaks_Values - lDips_Values;
Right_Amplitude = Peaks_Values - rDips_Values;
Left_STD        = stdPeaks + std_lDips;
Right_STD       = stdPeaks + std_rDips;
Left_Legit      = zeros(size(Left_Amplitude));
Right_Legit     = zeros(size(Right_Amplitude));
Left_Legit(Left_Amplitude > Left_STD)    = 1;
Right_Legit(Right_Amplitude > Right_STD) = 1;
Legit_Vect      = Left_Legit.*Right_Legit;

switch Segmentation_Type
    case 'Legitimate_Peaks'
        Legit_Peak_Pos  = Left_Dips_ReOrder(Legit_Vect==1);
        Segments_Length = [Legit_Peak_Pos, length(Curve)] - [0, Legit_Peak_Pos];
    case 'Curve_Trand_change'
        Max_Hight_Sign_Vector  = sign(Peaks_Values - [Peaks_Values(2:end), 0]);
        Sign_Change_Vector     = [0, Max_Hight_Sign_Vector(1:end-1)] > Max_Hight_Sign_Vector;
        Noisy_Curve_Minima_Pos = Left_Dips_ReOrder(Sign_Change_Vector > 0);
        Segments_Length        = [Noisy_Curve_Minima_Pos, length(Curve)] - [0, Noisy_Curve_Minima_Pos];
    otherwise
end;
Curve_Segments    = mat2cell(Curve', Segments_Length, 1);
Starting_Segement_Index = [0, cumsum(Segments_Length(1:end-1))];
[~, Maxima]       = cellfun(@max, Curve_Segments, 'UniformOutput', false);
[~, Left_Minima]  = cellfun(@(x,y) min(x(1:y)), Curve_Segments, Maxima, 'UniformOutput', false);
[~, Right_Minima] = cellfun(@(x,y) min(x(y:end)), Curve_Segments, Maxima, 'UniformOutput', false);
Right_Minima      = cellfun(@(x,y) x+y-1, Right_Minima, Maxima, 'UniformOutput', false);
Maxima            = cellfun(@(x,y) x+y, Maxima, num2cell(Starting_Segement_Index')) + Start_Pos - 1;
Left_Minima       = cellfun(@(x,y) x+y, Left_Minima, num2cell(Starting_Segement_Index')) + Start_Pos - 1;
Right_Minima      = cellfun(@(x,y) x+y, Right_Minima, num2cell(Starting_Segement_Index')) + Start_Pos - 1;

Peaks_Values    = Curve_In(Maxima);
lDips_Values    = Curve_In(Left_Minima);
rDips_Values    = Curve_In(Right_Minima);
stdPeaks        = sqrt(Peaks_Values);
std_lDips       = sqrt(lDips_Values);
std_rDips       = sqrt(rDips_Values);
Left_Amplitude  = Peaks_Values - lDips_Values;
Right_Amplitude = Peaks_Values - rDips_Values;
Left_STD        = stdPeaks + std_lDips;
Right_STD       = stdPeaks + std_rDips;
Left_Legit      = zeros(size(Left_Amplitude));
Right_Legit     = zeros(size(Right_Amplitude));
Left_Legit(Left_Amplitude > Left_STD)    = 1;
Right_Legit(Right_Amplitude > Right_STD) = 1;
Legit_Vect      = Left_Legit.*Right_Legit;

Maxima(Legit_Vect == 0) = [];
Left_Minima(Legit_Vect == 0) = [];
Right_Minima(Legit_Vect == 0) = [];
if isempty(Maxima)
    [~, Maxima] = max(Curve_In);
    [~, Left_Minima] = min(Curve_In(1:Maxima));
    [~, Right_Minima] = min(Curve_In(Maxima:end));
end;
    