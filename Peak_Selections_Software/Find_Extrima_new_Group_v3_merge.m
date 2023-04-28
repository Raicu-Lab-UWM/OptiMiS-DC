function [Legit_Maxima, Legit_Left, Legit_Right] = Find_Extrima_new_Group_v3_merge(Curve_In,Start_Pos,Min_Pk_Hight)

Curve = Curve_In(Start_Pos:end);
[Peaks, Left_Dips, Right_Dips] = Find_Extrima_wSegmentation_Group_v3(Curve,Start_Pos,Min_Pk_Hight);

% to avoid error in Find_Extrima_new when there is single peak and one zero
% at left (DB)
if length(Peaks)==1
    Curve_Left       = Curve(1:Peaks);
    Curve_Left_nZero = nonzeros(Curve_Left);
    [~, Left_Dips]   = min(Curve_Left_nZero);
    Left_Zeros       = length(Curve_Left) - length(Curve_Left_nZero);
    if Left_Zeros ~=0
        Left_Dips =Left_Zeros;
    end
end

if Peaks ~= 1  % to avoid Peaks =1 bcz in some cases when all are zeros
    Peaks = Peaks';
    Left_Dips = Left_Dips';
    Right_Dips = Right_Dips';
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
    % test whether left or right amplitude are greater than one event or not.
    Left_Legit      = zeros(size(Left_Amplitude));
    Right_Legit     = zeros(size(Right_Amplitude));
    Left_Legit(Left_Amplitude > Min_Pk_Hight)    = 1;
    Right_Legit(Right_Amplitude > Min_Pk_Hight)  = 1;
    Legit_Vect      = Left_Legit.*Right_Legit;
    % identify the peaks with one event right or left amplitude
    ilLegit_Vect             = Left_Legit+Right_Legit;
    ilLegit_Maxima           = Peaks_ReOrder(ilLegit_Vect<=2);

    if length(ilLegit_Maxima) > 1
        Peaks_Index             = 1:1:length(Peaks_ReOrder);
        ilLegit_Index           = Peaks_Index(ilLegit_Vect<=1);
        %completely ignore peak with peak value less than or equal to 2
        ilLegit_pkVal           = Peaks_Values(ilLegit_Index);
        [One_idx, One_val]      = find(ilLegit_pkVal <= Min_Pk_Hight);
        ilLegit_Maxima(One_idx) = [];
        ilLegit_Index(One_idx)  = [];

        % merge ilLegit peaks to the adjecent right or left legit peak
        for ii = length(ilLegit_Index):-1:1
            if Left_Amplitude(ilLegit_Index(ii))<=Min_Pk_Hight && ilLegit_Index(ii)~= 1
                Right_Dips_ReOrder(ilLegit_Index(ii)-1) = Right_Dips_ReOrder(ilLegit_Index(ii));
            elseif Left_Amplitude(ilLegit_Index(ii))<=Min_Pk_Hight && ilLegit_Index(ii)== 1
                Left_Dips_ReOrder(ilLegit_Index(ii)+1) = Left_Dips_ReOrder(ilLegit_Index(ii));
            end
        end
        for ii = 1:length(ilLegit_Index) 
            if (Right_Amplitude(ilLegit_Index(ii))<=Min_Pk_Hight) && (Left_Amplitude(ilLegit_Index(ii))> Min_Pk_Hight) && (ilLegit_Index(ii)~= length(Peaks_Index))
                Left_Dips_ReOrder(ilLegit_Index(ii)+1)  = Left_Dips_ReOrder(ilLegit_Index(ii));
            elseif(Right_Amplitude(ilLegit_Index(ii))<=Min_Pk_Hight) && (Left_Amplitude(ilLegit_Index(ii))> Min_Pk_Hight) && (ilLegit_Index(ii)== length(Peaks_Index))
                Right_Dips_ReOrder(ilLegit_Index(ii)-1) = Left_Dips_ReOrder(ilLegit_Index(ii));
            end
        end

        Legit_Maxima          = Peaks_ReOrder(ilLegit_Vect==2);
        Legit_Left            = Left_Dips_ReOrder(ilLegit_Vect==2);
        Legit_Right           = Right_Dips_ReOrder(ilLegit_Vect==2);

    else
         Legit_Maxima       = Peaks_ReOrder;
         Legit_Left         = Left_Dips_ReOrder;
         Legit_Right        = Right_Dips_ReOrder;
    end
else
         Legit_Maxima       = Peaks;
         Legit_Left         = Left_Dips;
         Legit_Right        = Right_Dips;
end


    