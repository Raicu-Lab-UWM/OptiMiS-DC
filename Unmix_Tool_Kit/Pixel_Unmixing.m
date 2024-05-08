function Pixel_Curves = Pixel_Unmixing (Scene_Inst, Image_Stack, Tags, Background, x, y, Path, Name, Pen_Size, Unmix_Method, Use_Fitted_Spect)

%Current_Image        = Image_Stack(:,:,1); % Added by TK to check the raw data. 20240503

if nargin < 11, Use_Fitted_Spect = 0; elseif isempty(Use_Fitted_Spect), Use_Fitted_Spect = 0; end
Number_of_Tags    = length(Tags);
[~, bgTag_Index]  = Tags.findBias_eSpect;
Spectrum          = [Tags.Spectrum];
for ii = 1:size(Spectrum,2)
    if Use_Fitted_Spect
        if ~isempty(Tags(ii).Fit)
            Spectrum(:,ii) = Tags(ii).Fit;
        end
    end
end
esWavelength      = [Tags.Wavelength];
imWavelength      = Scene_Inst.Wavelength;
Dark_Image        = Image_Stack(:,:,1);
Dark_Nosie_STD    = std2(Dark_Image)/2;
if size(Spectrum,1) >= size(Image_Stack,3)
    Bin_Size         = size(Spectrum,1)/size(Image_Stack,3);
    Spectrum         = Bin_Spectrum(Spectrum, Bin_Size);
    for ii = 1:length(Tags)
        if sum(esWavelength(:,ii)-imWavelength) ~= 0
            Spectrum(:,ii) = interp1(esWavelength(:,ii),Spectrum(:,ii), imWavelength);
        end
    end
    Tags_Names       = {Tags.Name};
    Image_Path_Name  = Scene_Inst.Name;
    Pixel_Curves     = zeros(size(Spectrum,1),Number_of_Tags+2);
    
    Polygon = [max(x-Pen_Size+0.5,1), max(y-Pen_Size+0.5,1);...
               max(x-Pen_Size+0.5,1), min(y+Pen_Size-0.5,size(Image_Stack,2));...
               min(x+Pen_Size-0.5,size(Image_Stack,2)), min(y+Pen_Size-0.5,size(Image_Stack,2));...
               min(x+Pen_Size-0.5,size(Image_Stack,2)), max(y-Pen_Size+0.5,1);...
               max(x-Pen_Size+0.5,1), max(y-Pen_Size+0.5,1)];
    [Unmix_Data, Raw_Data_Spect, ~] = Scene_Inst.Area_Unmixing_Func(Image_Stack, Tags, Unmix_Method, 1, Polygon, Scene_Inst.Wavelength, Background);
    Pixel_Curves(:,1) = Raw_Data_Spect(:,2);
    if bgTag_Index ~=0
        Pixel_Curves(:,1)       = Pixel_Curves(:,1) - Unmix_Data(bgTag_Index);
        Tags_Names(bgTag_Index) = [];
    end;

    for ii = 1:Number_of_Tags
        Pixel_Curves(:,ii+1) = Unmix_Data(ii)*Spectrum(:,ii);
        Pixel_Curves(:,Number_of_Tags+2) = Pixel_Curves(:,Number_of_Tags+2) + Pixel_Curves(:,ii+1)*(ii~=bgTag_Index);
    end;
    if bgTag_Index ~=0
        Pixel_Curves(:,bgTag_Index+1) = [];
    end;
    fmData            = Pixel_Curves(:,1);
    Var               = Raw_Data_Spect(:,3).^2;
    fmFit             = Pixel_Curves(:,Number_of_Tags+1);
    Dark_Noise_Array  = ones(size(fmFit))*Dark_Nosie_STD;
    Chi2 = sum(((fmData-fmFit).^2)./max(fmFit,Dark_Noise_Array))/(length(fmData)-Number_of_Tags);

    Title_STR         = ['Pixels - x = ' int2str(int16(x)) ' y = ' int2str(int16(y)) ' - \chi^2 = ' num2str(Chi2)];
    Title_Labels      = {'Wavelength [nm]', 'Intensity', {Image_Path_Name; Title_STR}};

    Curve_Plot(Scene_Inst.Wavelength, Pixel_Curves, Title_Labels, ['Measured',Tags_Names,'Fit'], Path, Name)
end;