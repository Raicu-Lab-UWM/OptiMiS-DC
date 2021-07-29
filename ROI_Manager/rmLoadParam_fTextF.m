function handles = rmLoadParam_fTextF(hObject, fName)
handles                       = guidata(hObject);

if nargin < 2, fName = 'rmDefault_Values.txt'; elseif isempty(fName), fName = 'rmDefault_Values.txt'; end
Path                          = '.\Config\';
fID                           = fopen([Path fName]);
if fID == -1
    fName = 'rmDefault_Values.txt';
    [fName, Path] = uigetfile([Path fName], 'Load parameters file');
end
fID                           = fopen([Path fName]);

defParams = fgetl(fID); handles.curr_Path             = defParams;
defParams = fgetl(fID); handles.Image_Frame_Index     = str2double(defParams);
defParams = fgetl(fID); handles.Include_SubFolders    = logical(defParams-'0');
defParams = fgetl(fID); handles.Image_Type_Loaded     = defParams;
defParams = fgetl(fID); handles.Polygon_Type          = defParams;
defParams = fgetl(fID); handles.Current_Polygon_Index = str2double(defParams);

defParams = fgetl(fID); handles.Seg_Membrane_Thckness = str2double(defParams);
defParams = fgetl(fID); handles.Seg_Method            = defParams;
defParams = fgetl(fID); handles.Seg_Type              = defParams;
defParams = fgetl(fID); handles.Seg_Split_Value       = str2num(defParams);
defParams = fgetl(fID); handles.Seg_nIterations       = str2double(defParams);
defParams = fgetl(fID); handles.Seg_Intensity_Weight  = str2double(defParams);
defParams = fgetl(fID); handles.Seg_nVert_inPoly      = str2double(defParams);

defParams = fgetl(fID); handles.Flt_Method            = defParams;
defParams = fgetl(fID); handles.Flt_LowCut            = str2double(defParams);
defParams = fgetl(fID); handles.Flt_HighCut           = str2double(defParams);
defParams = fgetl(fID); handles.Remove_HotPixels      = logical(defParams-'0');

fclose(fID);