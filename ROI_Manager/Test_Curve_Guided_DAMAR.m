% x and y are polygon coordinates
x         = [10,100,40,80,10];
y         = [10,10,60,60,100];
ROI       = [x',y'];
Offset    = 5;
Seg_Type  = 'area';
Seg_Value = 100;

segments = Curve_Guided_DAMAR(ROI, Offset, Seg_Type, Seg_Value);

figure;
for ii=1:size(segmatx,2)
    segmat  = segments{ii};
    segmatx = segmat(:,1);
    segmaty = segmat(:,2);
    plot(segmatx,segmaty,'-o','LineWidth',2,'MarkerSize',2);
    if ii==1
        hold on
    end    
end
hold off