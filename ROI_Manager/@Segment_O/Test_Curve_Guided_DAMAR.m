% x and y are polygon coordinates
x         = [10,100,40,80,10];
y         = [10,10,60,60,100];
ROI       = [x',y']';
Offset    = 5;
Seg_Type  = 'area';
Seg_Value = 500;

segments = Curve_Guided_DAMAR(ROI, Offset, Seg_Type, Seg_Value);