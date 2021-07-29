function [Self, iSelf] = autoSelect_ROI(Self, FOV_List, Polygon_Type, Sample_Name, strEL_Radius, Axes, Find_Cells)

if nargin < 7, Find_Cells = false; elseif isempty(Find_Cells), Find_Cells = false; end;
nFrames = length(FOV_List);
St_El   = strel('disk', round(strEL_Radius(1)/2), 4);
St_El_2 = strel('disk', strEL_Radius(1), 4);
iSelf   = [];

for ii = 1:nFrames
    if Find_Cells
        TH   = graythresh(FOV_List(ii).raw_Data);
        Mask = im2bw(FOV_List(ii).raw_Data, TH);
        Mask = imdilate(Mask, St_El);
        Mask = imerode(Mask, St_El);
        Mask = imfill(Mask, 'holes');
        Mask = bwareaopen(Mask, strEL_Radius(1)*strEL_Radius(2), 4);
        [Polygons_Coords, ~] = bwboundaries(Mask, 4, 'noholes');
        for jj = 1:length(Polygons_Coords)
            boundary            = Polygons_Coords{jj};
            boundary            = fliplr(boundary);
            Polygons_Coords{jj} = boundary;

            Image_Drawn         = [FOV_List(ii).Path '\' FOV_List(ii).Name];
            Polygon_Prop        = struct('Circle_Mode',       'Polygon',    ...
                                         'Polygon_Type',      Polygon_Type, ...
                                         'Images_Related',    [],           ...
                                         'Image_Drawn',       Image_Drawn,  ...
                                         'Image_Frame_Index', ii,           ...
                                         'Sample_Name',       Sample_Name);
            [Self, Polygon_Index]            = Self.Add_Polygon_toList(boundary, Polygon_Prop);
            iSelf                            = [iSelf, Polygon_Index];
            Image_                           = FOV_List(ii).raw_Data;
            Self(Polygon_Index).Mask         = poly2mask(boundary(:,1), boundary(:,2), size(Image_,1), size(Image_,2));
            Self(Polygon_Index).Poly_PlotH   = Self(Polygon_Index).Draw_aPolygon(Axes);
            Self(Polygon_Index).Title_PrintH = Self(Polygon_Index).Plot_Poly_Label(Axes);
        end
    else
        Polygons_Coords{ii} = [1,1; ...
                               1,size(FOV_List(ii).raw_Data,2); ...
                               size(FOV_List(ii).raw_Data,1),size(FOV_List(ii).raw_Data,2); ...
                               size(FOV_List(ii).raw_Data,1),1; ...
                               1,1];
        Image_Drawn         = [FOV_List(ii).Path '\' FOV_List(ii).Name];
        Polygon_Prop        = struct('Circle_Mode',       'Polygon',    ...
                                     'Polygon_Type',      Polygon_Type, ...
                                     'Images_Related',    [],           ...
                                     'Image_Drawn',       Image_Drawn,  ...
                                     'Image_Frame_Index', ii,           ...
                                     'Sample_Name',       Sample_Name);
        boundary                         = Polygons_Coords{ii};
        [Self, Polygon_Index]            = Self.Add_Polygon_toList(boundary, Polygon_Prop);
        iSelf                            = [iSelf, Polygon_Index];
        Image_                           = FOV_List(ii).raw_Data;
        
        Self(Polygon_Index).Mask         = poly2mask(boundary(:,1), boundary(:,2), size(Image_,1), size(Image_,2));
        Self(Polygon_Index).Poly_PlotH   = Self(Polygon_Index).Draw_aPolygon(Axes);
        Self(Polygon_Index).Title_PrintH = Self(Polygon_Index).Plot_Poly_Label(Axes);
    end
end