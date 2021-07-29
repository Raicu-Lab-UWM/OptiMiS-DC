function [Unmix_Data, Raw_Data_Spect, Area] = Area_Unmixing_Func(Image_Stack, Tags, Unmix_Method_Index, Area_Unmix, Polygon, Wavelength, Background)
Scene_Inst          = Scene;
Basic_Spect         = [Tags.Spectrum];
Unmix_Data          = zeros(length(Tags),1);
Mask                = poly2mask(Polygon(:,1),Polygon(:,2),size(Image_Stack,1),size(Image_Stack,2));
Area                = sum(Mask(Mask==1));
Raw_Data_Spect      = zeros(size(Image_Stack,3),3);
Raw_Data_Spect(:,1) = Wavelength;
for ii = 1:size(Image_Stack,3);
    Current_Image        = Image_Stack(:,:,ii);
    Raw_Data_Spect(ii,2) = mean2(Current_Image(Mask==1));
    Raw_Data_Spect(ii,3) = std2(Current_Image(Mask==1));
end;
Raw_Data_Spect(:,2) = Raw_Data_Spect(:,2)-Background;
switch Area_Unmix
    case 1
        switch Unmix_Method_Index
            case 1
                FMxF       = Basic_Spect'*Raw_Data_Spect(:,2);
                F_Mat      = Basic_Spect'*Basic_Spect;
                Unmix_Data = F_Mat\FMxF;
            case 2
                Options_LSQ = optimset('MaxIter',1000, 'TolFun',1e-3, 'Display','off');
                Unmix_Data  = lsqnonneg(Basic_Spect,Raw_Data_Spect(:,2), Options_LSQ);
            case 3
                Options_LSQ = optimset('MaxIter',1000, 'TolFun',1e-3, 'Display','off');
                Unmix_Data  = lsqnonneg(Basic_Spect,Raw_Data_Spect(:,2), Options_LSQ);
            case 4
                [Unmix_Data,~,~] = l1_ls_nonneg(Basic_Spect,Raw_Data_Spect(:,2),0.001,1e-3,1);
            otherwise
        end;
    case 2
        currUnmix_Images = Scene_Inst.UnMix(Image_Stack, Basic_Spect, Unmix_Method_Index, Background);
        for ii = 1:size(currUnmix_Images,1);
            Unmix_Data(ii) = mean2(currUnmix_Images(ii,(Mask==1)));
        end;
        Unmix_Data = Unmix_Data';
    otherwise
end;