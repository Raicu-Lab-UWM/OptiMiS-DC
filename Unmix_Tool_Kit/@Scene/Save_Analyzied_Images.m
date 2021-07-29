function [Eapp, FDonly, FDonly_TH] = Save_Analyzied_Images(Obj, Elem_Spect, Path, Name, Saving_Param)

Background     = Saving_Param.Background;
Threshold      = Saving_Param.Threshold;
Threshold_Method_Index = Saving_Param.Threshold_Method_Index;
Save_TH_Images = Saving_Param.Save_TH_Images;
Save_List      = Saving_Param.File_List_toSave;

Spectrum       = [Elem_Spect.Spectrum];
if size(Spectrum,1) < size(Obj(1).currImage_Stack,3)
    h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
    return;
end

Bin_Size                     = size(Spectrum,1)/size(Obj(1).currImage_Stack,3);
Spectrum                     = Bin_Spectrum(Spectrum, Bin_Size);

Scene_Thresh                 = Calculate_Threshold (Obj, Spectrum, Background, Threshold, Threshold_Method_Index, Elem_Spect);
[Eapp, FDonly, FDonly_TH]    = Calculate_FRET(Scene_Thresh, Obj, Elem_Spect, Threshold);
[Capp, D_Plus_A, thD_Plus_A] = Calculate_FICoS(Scene_Thresh, Obj, Elem_Spect, Threshold);

if Save_List.Eapp, Write_Tiff_File(Eapp,  Path, Name, ['Eapp_TH-' num2str(Threshold)], 32); end
if Save_List.Capp
    Write_Tiff_File_2(Capp,  Path, Name, ['Capp_TH-' num2str(Threshold)], 32);
end

if Save_List.Basic || Save_List.Basic_FICoS
    if Save_List.Basic
        Write_Tiff_File_2(FDonly, Path, Name, 'FDonly', 32);
    end
    if Save_List.Basic_FICoS
        Write_Tiff_File_2(D_Plus_A, Path, Name, 'D_pA', 32);
    end
    Unmixed_Images   = Obj.currUnmix_Images;
    if Save_List.Chi2
        Measured         = Obj.currImage_Stack;
        Fit              = zeros(size(Measured));
        [~, bgTag_Index] = Elem_Spect.findBias_eSpect;
        Bias             = reshape(squeeze(Unmixed_Images(bgTag_Index,:,:)), size(Unmixed_Images,2)*size(Unmixed_Images,3), 1);
        Bias             = reshape(Bias*Elem_Spect(bgTag_Index).Spectrum', size(Unmixed_Images,2), size(Unmixed_Images,3), length(Elem_Spect(bgTag_Index).Spectrum));
    end
    for ii = 1:length(Elem_Spect)
        if Save_List.Chi2
            Unmixed_Images_Curr    = reshape(squeeze(Unmixed_Images(ii,:,:)), size(Unmixed_Images,2)*size(Unmixed_Images,3), 1);
            Unmixed_Images_Spect   = Unmixed_Images_Curr*Elem_Spect(ii).Spectrum';
            Fit                    = Fit + reshape(Unmixed_Images_Spect, size(Unmixed_Images,2), size(Unmixed_Images,3), length(Elem_Spect(ii).Spectrum));
        end
        Unmixed_Images(ii,:,:) = Unmixed_Images(ii,:,:)*Elem_Spect(ii).Spectral_Integral;
        Write_Tiff_File_2(squeeze(Unmixed_Images(ii,:,:)), Path, Name, Elem_Spect(ii).Name, 32);
    end
end

if Save_List.Chi2
%     Dark_Noise_Array = ones(size(Fit))*std2(Obj.currImage_Stack(:,:,1));
%     Chi2 = abs(sum((Measured - Fit).^2./max((Fit-Bias), Dark_Noise_Array)/(size(Measured,3)-length(Elem_Spect)), 3));
    Chi2 = abs(sum((Measured - Fit).^2./(Fit-Bias)/(size(Measured,3)-length(Elem_Spect)), 3));
    Chi2(Chi2>2^31-1) = 2^31-1;
    Write_Tiff_File_2(Chi2, Path, Name, 'Chi_Square', 32);
end

if Save_TH_Images
    if Save_List.Basic
        Write_Tiff_File_2(FDonly_TH, Path, Name, ['FDonly_TH-' num2str(Threshold)], 32);
    end
    if Save_List.Basic_FICoS
        Write_Tiff_File_2(thD_Plus_A, Path, Name, ['D_pA_TH-' num2str(Threshold)], 32);
    end
    Unmixed_Images = Scene_Thresh.currUnmix_Images;
    for ii = 1:length(Elem_Spect)
        Unmixed_Images(ii,:,:) = Unmixed_Images(ii,:,:)*Elem_Spect(ii).Spectral_Integral;
        Write_Tiff_File_2(squeeze(Unmixed_Images(ii,:,:)), Path, Name, [Elem_Spect(ii).Name '_TH-' num2str(Threshold)], 32);
    end
end