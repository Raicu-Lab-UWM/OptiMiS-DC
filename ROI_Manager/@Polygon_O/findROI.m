function [Self, Found_Index] = findROI(Self, varargin)

Property    = varargin(1:2:end);
Value       = varargin(2:2:end);

Found_Index = [1:length(Self)];
Sub_List    = Self;
for ii = 1:length(Property)
    switch Property{ii}
        case 'Polygon_Name'
            All_Polygons_Names = {Sub_List.Name};
            if length(All_Polygons_Names) > 1 || (length(All_Polygons_Names) == 1 && ~isempty(All_Polygons_Names{1}))
                Polygon_Name = Value{ii};
%                 Items_Index  = find(~cellfun(@isempty, strcmp(All_Polygons_Names, Polygon_Name)));
                Items_Index  = find(strcmp(All_Polygons_Names, Polygon_Name));
                Found_Index  = Found_Index(Items_Index);
                Sub_List     = Sub_List(Items_Index);
            else
                Found_Index = [];
                Sub_List    = [];
            end
        case 'Polygon_Label'
            All_Polygons_Labels = [Sub_List.Label];
            if length(All_Polygons_Names) > 1 || (length(All_Polygons_Names) == 1 && ~isempty(All_Polygons_Names{1}))
                Polygon_Label = Value{ii};
                Items_Index   = find(~cellfun(@isempty, strcmp(All_Polygons_Labels, Polygon_Label)));
                Found_Index   = Found_Index(Items_Index);
                Sub_List      = Sub_List(Items_Index);
            else
                Found_Index = [];
                Sub_List    = [];
            end
        otherwise
    end
end
Self = Sub_List;