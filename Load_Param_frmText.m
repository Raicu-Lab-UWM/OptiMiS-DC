function Init_Params = Load_Param_frmText(Path, Name)

if nargin < 2, Name = 'MainWindow_Params.txt'; elseif isempty(Name), Name = 'MainWindow_Params.txt'; end
if nargin < 1, Path = '.\Config'; elseif isempty(Path), Path = '.\Config'; end
fileID = fopen([Path '\' Name]);
C      = textscan(fileID,'%s %s', 'Delimiter',',');
fclose(fileID);

Field_Names = C{1};
Values      = C{2};

for ii = 1:length(Field_Names)
    Init_Params.(Field_Names{ii}) = Values{ii};
end

Init_Params.Polygon_List       = Polygon_O;
Init_Params.Segment_List       = Segment_O;
Init_Params.ES_Obj             = Elementary_Spectrum_O;
Init_Params.Image_Stack_Axes   = [];
Init_Params.currPolygon_Coords = {};
