function ListROI_inImageO(Self, Main_FigureH)
handles = guidata(Main_FigureH);

selectedNodes   = handles.FIF_Tree.Tree.getSelectedNodes;
selectedNode    = selectedNodes(1);
Selected_Image  = Image_O;
selectedSample  = selectedNode.getParent;

Image_List      = Image_O;
if isfield(handles, 'Image_List')
    if ~handles.Image_List.isEmpty
        Image_List = handles.Image_List;
    end
end

Image_Index    = 0;
[Sample_SubList, Sample_Index] = Image_List.findImage('Sample_Name', selectedSample.getValue);
if ~isempty(Sample_Index), [~, Image_Index]  = Sample_SubList.findImage('Image_Name', selectedNode.getValue);
    if ~isempty(Image_Index)
        Image_Index    = Sample_Index(Image_Index);
        Selected_Image = Image_List(Image_Index);
    else
        Selected_Image.Sample_Name = Self(1).Sample_Name;
        Selected_Image.Image_Name  = Self(1).Image_Drawn;
    end
else
    Selected_Image.Sample_Name = Self(1).Sample_Name;
    Selected_Image.Image_Name  = Self(1).Image_Drawn;
end
Selected_Image.ROI_List = {Self.Name};
if handles.Image_List.isEmpty
    handles.Image_List = Selected_Image;
elseif Image_Index == 0
    if ~isempty(Sample_Index)
        Image_Index = Sample_Index(1);
        handles.Image_List(Image_Index) = Selected_Image;
    end
else
    handles.Image_List(Image_Index) = Selected_Image;
end

if ~isempty(Self(1).Image_Drawn)
    selectedNode.setValue(Self(1).Image_Drawn);
    selectedNode.setName(Self(1).Image_Drawn);
    handles.FIF_Tree.Tree.reloadNode(selectedNode);
end
for ii = 1:length(Self), Self(ii).Sample_Name = selectedSample.getValue; end
handles.Image_List(Image_Index).Image_Name = selectedNode.getValue;

guidata(Main_FigureH, handles);