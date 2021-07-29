function Self = loadFOV_List(Self, Path, Name, Image_, Remove_HotPixels)

if nargin < 5, Remove_HotPixels = 1; end
if nargin < 3, Name = []; end
if nargin < 2, Path = '.'; elseif isempty(Path), Path = '.'; end
if isempty(Name), [Name, Path] = uigetfile([Path '\*.tiff; *.tif; *.png'], 'Locate image file'); end

if nargin < 4, Image_ = Load_Image(Path, Name, [], Remove_HotPixels); elseif isempty(Image_), Image_ = Load_Image(Path, Name, [], Remove_HotPixels); end

FOV_inStruct = struct('Name', Name, 'Path', Path, 'Width', size(Image_,1),...
                      'Height', size(Image_,2), 'Depth', size(Image_,3));
for ii = 1:size(Image_,3);
    FOV_inStruct.Frame_Number = ii;
    Self = Self.Add_FOV_toList(Image_(:,:,ii), FOV_inStruct);
end;