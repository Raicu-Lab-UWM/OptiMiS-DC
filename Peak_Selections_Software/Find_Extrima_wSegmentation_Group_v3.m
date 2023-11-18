function [Maxima, Left_Minima, Right_Minima] = Find_Extrima_wSegmentation_Group_v3(Curve_In,Start_Pos,Min_Pk_Hight)
% latest version of the function modified on March 7,2023 changes are made
% on line 44  (Dammar Badu)
Curve = Curve_In(Start_Pos:end);
[Peaks, Left_Dips, Right_Dips, ~, ~] = Find_Extrima_new(Curve,[],1);

% to avoid error in Find_Extrima_new when there is single peak and one zero
% at left (DB)
if ~isempty(Peaks)
    if length(Peaks)==1
        Curve_Left       = Curve(1:Peaks);
        Curve_Left_nZero = nonzeros(Curve_Left);
        [~, Left_Dips]   = min(Curve_Left_nZero);
        Left_Zeros       = length(Curve_Left) - length(Curve_Left_nZero);
        if Left_Zeros ~=0
            Left_Dips =Left_Zeros;
        end
    end

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
    Left_STD        = stdPeaks + std_lDips; 
    Right_STD       = stdPeaks + std_rDips;
    Left_Legit      = zeros(size(Left_Amplitude));
    Right_Legit     = zeros(size(Right_Amplitude));
    Left_Legit(Left_Amplitude > Left_STD)    = 1;  % assingn index 1 for passing threshold for left amp and 2 for right amp
    Right_Legit(Right_Amplitude > Right_STD) = 2;  % index 0 not passing threshold for both left and right

    % combine index of left and right pass and fail
    % put the index in correct order (alternate position)
    if size(Left_Legit,2) ~=1
        Left_Legit = Left_Legit';
    end
    if size(Right_Legit,2) ~=1
        Right_Legit = Right_Legit';
    end
    if size(Left_Dips_ReOrder,2) ~=1
        Left_Dips_ReOrder = Left_Dips_ReOrder';
    end
    if size(Right_Legit,2) ~=1
        Right_Dips_ReOrder = Right_Dips_ReOrder';
    end
    Left_Right_Legit_Alt   = reshape([Left_Legit Right_Legit]',[],1);% added by Dammar Badu on March 7, 2023
    Left_Right_minPos_Alt  = reshape([Left_Dips_ReOrder Right_Dips_ReOrder]',[],1); % position of left and right dips
    % find index of nonzeros in list of left and right
    NonZero_idx  = find(Left_Right_Legit_Alt~=0);
    NonZero_Val  = Left_Right_Legit_Alt(NonZero_idx);
    NonZero_Pos  = Left_Right_minPos_Alt(NonZero_idx);
    NonZero_Uniq = unique(NonZero_Pos,'First');
    % start and stop at left or right legitimate amplitude
    if length(NonZero_Val)>2
        if NonZero_Uniq(1)~= 1  
            Group_Start = [1; NonZero_Uniq(1:end)];
            Group_End   = [NonZero_Uniq(1:end);length(Curve)];
        else  % in case minimum starts from first point
            Group_Start = NonZero_Uniq(1:end);
            Group_End   = [NonZero_Uniq(2:end);length(Curve)];
        end

        for ii = 1:length(Group_Start)
            Group_Val= Curve(Group_Start(ii):Group_End(ii));
            [Max_val(ii), Posn]      = max(Group_Val);
            Group_Maxima(ii) = Group_Start(ii) + Posn-1;    
        end 
        Maxima            = Group_Maxima;
        Left_Minima       = Group_Start;
        Right_Minima      = Group_End;
        % apply maximum value threshold
        [One_val, One_idx]    = find(Max_val <= Min_Pk_Hight);
        Maxima(One_idx)       = [];
        Left_Minima(One_idx)  = [];
        Right_Minima(One_idx) = [];
    else
         [~, Maxima]       = max(Curve);
         Left_Minima       = min(Left_Dips_ReOrder);
         Right_Minima      = max(Right_Dips_ReOrder);
         % apply maximum value threshold
        Pk_val    = Curve(Maxima);
        [One_val, One_idx]    = find(Pk_val <= Min_Pk_Hight);
        Maxima(One_idx)       = [];
        Left_Minima(One_idx)  = [];
        Right_Minima(One_idx) = [];
    end
else 
         Maxima              = Peaks;
         Left_Minima         = Left_Dips;
         Right_Minima        = Right_Dips;
end
    