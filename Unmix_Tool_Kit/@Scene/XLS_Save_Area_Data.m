function Calc_Value = XLS_Save_Area_Data(Path, Name, Calculate, Tags, Tags_Names, Scene_Inst, Unmix_Method_Index, Area_Unmix, Polygon, Background)
Wavelength        = Scene_Inst.Wavelength;
Basic_Spect       = [Tags.Spectrum];
Image_Stack       = Scene_Inst.currImage_Stack;
[Unmix_Data, Raw_Data_Spect, Area] = Scene_Inst.Area_Unmixing_Func(Image_Stack, Tags, Unmix_Method_Index, Area_Unmix, Polygon, Wavelength, Background);

if size(Basic_Spect,1) >= size(Image_Stack,3)
    Bin_Size         = size(Basic_Spect,1)/size(Image_Stack,3);
    Basic_Spect      = Bin_Spectrum(Basic_Spect, Bin_Size);
end;
            
Fit               = Basic_Spect*Unmix_Data;
Res               = (Raw_Data_Spect(:,2)-Fit).^2./Fit;
Sum_Res           = abs(sum(Res));

xCenter           = mean(Polygon(:,1));
yCenter           = mean(Polygon(:,2));
Sheet             = [Scene_Inst.Name(10:15) '_x' num2str(round(xCenter)) '_y' num2str(round(yCenter))];

Calc_Text         = {};
Calc_Value        = {};

Quantum_Yield     = [Tags.Quantum_Yield];
Qd                = Quantum_Yield(1);
Qa                = Quantum_Yield(2);
Spectral_Integral = [Tags.Spectral_Integral];
Wd                = Spectral_Integral(1);
Wa                = Spectral_Integral(2);
KDA               = Unmix_Data(1);
KAD               = Unmix_Data(2);

for ii = 1:length(Calculate)
    switch Calculate{ii}
        case 'FAD/NADH Ratio'
            Calc_Text  = [Calc_Text, 'Ratio'];
            Calc_Value = [Calc_Value, Unmix_Data(2)/Unmix_Data(1)];
        case 'Red/(Green+Red) Ratio'
            Calc_Text  = [Calc_Text, 'R&G Ratio'];
            Calc_Value = [Calc_Value, Unmix_Data(2)/(Unmix_Data(2) + Unmix_Data(1)*Wd/Wa)];
        case 'EApp'
            Calc_Text  = [Calc_Text, 'E Apparent'];
            Calc_Value = [Calc_Value, KAD/(KAD + KDA*Qa/Qd*Wd/Wa)*100];
        case 'FdOnly'
            Calc_Text  = [Calc_Text, 'FD Only'];
            Calc_Value = [Calc_Value, KDA*Wd+KAD*Wa*Qd/Qa];
        case 'FDA'
            Calc_Text  = [Calc_Text, 'FDA'];
            Calc_Value = [Calc_Value, KDA*Wd];
        case 'FAD'
            Calc_Text  = [Calc_Text, 'FAD'];
            Calc_Value = [Calc_Value, KAD*Wa];
        case 'Area'
            Calc_Text  = [Calc_Text, 'Area'];
            Calc_Value = [Calc_Value, Area];
        otherwise
    end;
end;
Unmix_Values  = ['Unmix Values', num2cell(Unmix_Data'), Background, ' ', Sum_Res, Calc_Value];
Title         = ['Wavelength', Tags_Names, 'Signal', 'Fit', 'Res', Tags_Names];
Tags_Spect    = zeros(size(Basic_Spect,1), length(Tags_Names));
for ii = 1:length(Tags_Names)
    Tags_Spect(:,ii) = Basic_Spect(:,ii)*Unmix_Data(ii);
end;
Intensities   = num2cell([Wavelength, Basic_Spect, Raw_Data_Spect(:,2) Fit, Res, Tags_Spect]);
Total_Data    = [Title; Intensities];

xlswrite([Path '\' Name], Total_Data, Sheet, 'C3');
Column        = char('C'+length(Unmix_Data)+1);
xlswrite([Path '\' Name], ['Background', ' ', 'Residual',Calc_Text], Sheet, [Column '1']);
xlswrite([Path '\' Name], Unmix_Values, Sheet, 'C2');
[~,Sheets]    = xlsfinfo([Path '\' Name]);
Summary_Sheet = strfind(Sheets,'Summary');
Sheets(find(~cellfun(@isempty, Summary_Sheet))) = [];
Sheets{1}     = 'Sheet';
xlswrite([Path '\' Name], Sheets', 'Summary', 'C3');
xlswrite([Path '\' Name], Calc_Value, 'Summary', ['D' num2str(2+length(Sheets))]);
xlswrite([Path '\' Name], Calc_Text, 'Summary', 'D3');