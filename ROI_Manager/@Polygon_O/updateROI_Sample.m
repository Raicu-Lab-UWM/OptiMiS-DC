function Self = updateROI_Sample(Self, Tree, Image_List)

selectedNodes   = Tree.getSelectedNodes;
selectedNode    = selectedNodes(1);
selectedSample  = selectedNode.getParent;

if nargin < 3, Image_List = Image_O; elseif Image_List.isEmpty, Image_List = Image_O; end

[~, Image_Index] = Image_List.findImage_Brunch(Tree);
if Image_Index > 0
    for ii = 1:length(Self), Self(ii).Sample_Name = selectedSample.getValue; end
end