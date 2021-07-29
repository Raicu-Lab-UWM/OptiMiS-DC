function [Spectrum, sPolygon_Cord] = Signal_Select_Tool_Fcn (hAxes, Image, Wavelength, Editing_Tool, Sample_Type)

Spectrum     = zeros(size(Image,3),1);
switch Editing_Tool
    case 'Ellipse'
        Hand_sPolygon = imellipse(hAxes);
        sPolygon_Cord = wait(Hand_sPolygon);
        if strcmp(Sample_Type,'Cells'), Hand_Polygon  = imellipse(hAxes); Polygon_Cord  = wait(Hand_Polygon); end;
    case 'Freehand'
        Hand_sPolygon = imfreehand(hAxes);
        sPolygon_Cord = wait(Hand_sPolygon);
        if strcmp(Sample_Type,'Cells'), Hand_Polygon  = imfreehand(hAxes); Polygon_Cord  = wait(Hand_Polygon); end;
    case 'Polygon'
        Hand_sPolygon = impoly(hAxes);
        sPolygon_Cord = wait(Hand_sPolygon);
        if strcmp(Sample_Type,'Cells'), Hand_Polygon  = impoly(hAxes); Polygon_Cord  = wait(Hand_Polygon); end;
    otherwise
        sPolygon_Cord = [];
end;
delete(Hand_sPolygon);
if strcmp(Sample_Type,'Cells'), delete(Hand_Polygon); end;

ROI_Sgnl = poly2mask(sPolygon_Cord(:,1),sPolygon_Cord(:,2),size(Image,1),size(Image,2));
if strcmp(Sample_Type,'Cells')
    ROI_Bkgd = poly2mask(Polygon_Cord(:,1),Polygon_Cord(:,2),size(Image,1),size(Image,2));
    for ii = 1 : size(Image,3)
        currImage    = squeeze(Image(:,:,ii));
        Spectrum(ii) = mean2(currImage(ROI_Sgnl==1))-mean2(currImage(ROI_Bkgd==1));
    end;
elseif strcmp(Sample_Type,'Solutions')
    currImage      = squeeze(Image(:,:,1));
    BackGround_Val = mean2(currImage(ROI_Sgnl==1));
    for ii = 1 : size(Image,3)
        currImage    = squeeze(Image(:,:,ii));
        Spectrum(ii) = mean2(currImage(ROI_Sgnl==1))-BackGround_Val;
    end;
end;
Spectrum(Spectrum<0) = 0;
Spectrum        = Spectrum/max(Spectrum);
figure; plot(Wavelength,Spectrum);