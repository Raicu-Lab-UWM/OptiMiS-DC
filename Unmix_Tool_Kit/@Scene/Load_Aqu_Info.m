function Aqu_Info = Load_Aqu_Info (Path, Name)
            
if nargin == 0, [Name, Path] = uigetfile('*.txt', 'Acquisition Information File');
elseif nargin == 1, [Name, Path] = uigetfile([Path '\*.txt'], 'Acquisition Information File');
end;
            
File_ID               = fopen([Path '\' Name]);
if File_ID ~= -1
    Dummy_Line            = fgetl(File_ID);
    DateTime_Line         = fgetl(File_ID);
    Temperature_Line      = fgetl(File_ID);
    Gain_Line             = fgetl(File_ID);
    DigiRate_Line         = fgetl(File_ID);
    Aqu_Info.scnMode      = fgetl(File_ID);
    ExposureTime_Line     = fgetl(File_ID);
    Dummy_Line            = fgetl(File_ID);
    Dummy_Line            = fgetl(File_ID);
    SpectRes_Line         = fgetl(File_ID);
    NoLines_Line          = fgetl(File_ID);
    NoXPixels_Line        = fgetl(File_ID);
    LaserPower_Line       = fgetl(File_ID);
    ExWavelength_Line     = fgetl(File_ID);

    Aqu_Info.Date         = DateTime_Line(11:18);
    Aqu_Info.Time         = DateTime_Line(20:25);
    Aqu_Info.Temp         = Temperature_Line(10:end);
    Aqu_Info.Gain         = Gain_Line(10:end);
    Aqu_Info.dgRate       = DigiRate_Line(19:end);
    Aqu_Info.tExposure    = ExposureTime_Line(20:end);
    Aqu_Info.SpectRes     = SpectRes_Line(21:end);
    Aqu_Info.NoLines      = NoLines_Line(25:end);
    Aqu_Info.NoXPix       = NoXPixels_Line(22:end);
    Aqu_Info.ExPower      = LaserPower_Line(35:end);
    Aqu_Info.ExWavelength = ExWavelength_Line(30:end);
else
    Aqu_Info = -1;
end;