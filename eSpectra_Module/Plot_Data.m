function imHandle = Plot_Data (Axes_Handle, Image_to_Plot, Coordinates)

xMin = Coordinates(1);
xMax = Coordinates(2);
yMin = Coordinates(3);
yMax = Coordinates(4);

axes(Axes_Handle);
cla(Axes_Handle,'reset');
imHandle = imagesc(Image_to_Plot);
axis equal;
set(imHandle, 'HitTest', 'off');
if xMin ~= 0 && xMax ~= 0
    axis([xMin xMax yMin yMax]);
end;
axis(Axes_Handle, 'equal', 'tight');
set(Axes_Handle,'XTick',[],'YTick',[])