function Obj = Calculate_Area(Obj, Image_Size, Error_MSG_List)

if nargin < 2, Image_Size = []; end

Function_Generated = cell(length(Obj),1);
if isempty(Image_Size)
    for ii = 1:length(Obj)
        if ~isempty(Obj(ii).Mask), Obj(ii).Area = length(Obj(ii).Mask(Obj(ii).Mask == 1));
        else
            Obj(ii).Area = [];
            Function_Generated{ii} = 'Polygon_O:Calculate_Area:l8';
        end
    end
elseif length(Image_Size) < 2
    for ii = 1:length(Obj)
        if ~isempty(Obj(ii).Mask), Obj(ii).Area = length(Obj(ii).Mask(Obj(ii).Mask == 1));
        else
            Obj(ii).Area = [];
            Function_Generated{ii} = 'Polygon_O:Calculate_Area:l7';
        end
    end
else
    for ii = 1:length(Obj)
        if ~isempty(Obj(ii).Mask), Obj(ii).Area = length(Obj(ii).Mask(Obj(ii).Mask == 1));
        %elseif ~isempty(Obj(ii).Polygon_Cords)
        elseif ~isempty(Obj(ii).Coordinates)
            Mask = poly2mask(Obj(ii).Coordinates(:,1),Obj(ii).Coordinates(:,2), Image_Size(1), Image_Size(2));
            Obj(ii).Area = length(Mask(Mask == 1));
        else
            Obj(ii).Area = [];
            Function_Generated{ii} = 'Polygon_O:Calculate_Area:l7';
        end
    end
end
for ii = 1:length(Function_Generated)
    if ~isempty(Function_Generated{ii})
        curError_MSG_List = Error_MSG_List.findErrorMSG('Function_Generated', Function_Generated{ii});
        curError_MSG_List.PrintErrorMessage(curError_MSG_List.Message_ID, ['ROI - ' Obj.Name ': Area was not calculated']);
    end
end

