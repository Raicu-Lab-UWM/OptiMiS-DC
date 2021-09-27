function Obj = Save_Analyzied_Stacks(Obj, Elem_Spect, Path, Saving_Param)

Background     = Saving_Param.Background;
Threshold      = Saving_Param.Threshold;
Threshold_Method_Index = Saving_Param.Threshold_Method_Index;
Save_TH_Images = Saving_Param.Save_TH_Images;
Save_List      = Saving_Param.File_List_toSave;
Hor_Shift      = Saving_Param.Hor_Shift;
nScenes        = length(Obj);

Spectrum       = [Elem_Spect.Spectrum];
if isempty(Obj(1).currImage_Stack)
    Name           = Obj(1).Name;
    if strcmp(Name(end-3:end),'.dat')
        Last   = 999 + length(Obj(1).Wavelength);
        Obj(1) = Obj(1).Load_Dat_Images(Obj(1).Path, 1000, Last, Hor_Shift);
    else Obj(1).currImage_Stack = Obj(1).Load_Tiff_Image(Name, Obj(1).Path, [], Hor_Shift, 0);
    end
end

if size(Spectrum,1) < size(Obj(1).currImage_Stack,3)
    h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
    return;
end

Bin_Size             = size(Spectrum,1)/size(Obj(1).currImage_Stack,3);
Spectrum             = Bin_Spectrum(Spectrum, Bin_Size);

Eapp_Stack              = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
FDonly_Stack            = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
FDonly_TH_Stack         = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
Capp_Stack              = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
D_Plus_A_Stack          = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
thD_Plus_A_Stack        = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
Chi2_Stack              = zeros(size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
Unmixed_Images_Stack    = zeros(length(Elem_Spect), size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
Unmixed_Images_TH_Stack = zeros(length(Elem_Spect), size(Obj(1).currImage_Stack,1), size(Obj(1).currImage_Stack,2), nScenes);
h = waitbar(0,'Wrting Image to File - 0%');
for hh = 1:nScenes
    if isempty(Obj(hh).currImage_Stack)
        Name        = Obj(hh).Name;
        if strcmp(Name(end-3:end),'.dat')
            Last    = 999 + length(Obj(hh).Wavelength);
            Obj(hh) = Obj(hh).Load_Dat_Images(Obj(hh).Path, 1000, Last, Hor_Shift);
        else Obj(hh).currImage_Stack = Obj(hh).Load_Tiff_Image(Name, Obj(hh).Path, [], Hor_Shift, 0);
        end
    end
    Scene_Thresh                 = Calculate_Threshold (Obj(hh), Spectrum, Background, Threshold, Threshold_Method_Index, Elem_Spect);
    [Eapp, FDonly, FDonly_TH]    = Calculate_FRET(Scene_Thresh, Obj(hh), Elem_Spect, Threshold);
    Eapp_Stack(:,:,hh)           = Eapp;
    FDonly_Stack(:,:,hh)         = FDonly;
    FDonly_TH_Stack(:,:,hh)      = FDonly_TH;
    [Capp, D_Plus_A, thD_Plus_A] = Calculate_FICoS(Scene_Thresh, Obj(hh), Elem_Spect, Threshold);
    Capp_Stack(:,:,hh)           = Capp;
    D_Plus_A_Stack(:,:,hh)       = D_Plus_A;
    thD_Plus_A_Stack(:,:,hh)     = thD_Plus_A;
    
    if Save_List.Basic || Save_List.Basic_FICoS
        Unmixed_Images   = Obj(hh).currUnmix_Images;
        if Save_List.Chi2
            Measured         = Obj(hh).currImage_Stack;
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
            Unmixed_Images_Stack(ii,:,:,hh) = Unmixed_Images(ii,:,:);
        end
    end

    if Save_List.Chi2
%         Dark_Noise_Array = ones(size(Fit))*std2(Obj(hh).currImage_Stack(:,:,1));
%         Chi2 = abs(sum((Measured - Fit).^2./max((Fit-Bias), Dark_Noise_Array)/(size(Measured,3)-length(Elem_Spect)), 3));
        Chi2 = abs(sum((Measured - Fit).^2./(Fit-Bias)/(size(Measured,3)-length(Elem_Spect)), 3));
        Chi2(Chi2>2^31-1) = 2^31-1;
        Chi2_Stack(:,:,hh) = Chi2;
    end

    if Save_TH_Images
        Unmixed_Images = Scene_Thresh.currUnmix_Images;
        for ii = 1:length(Elem_Spect)
            Unmixed_Images(ii,:,:) = Unmixed_Images(ii,:,:)*Elem_Spect(ii).Spectral_Integral;
            Unmixed_Images_TH_Stack(ii,:,:,hh) = Unmixed_Images(ii,:,:);
        end
    end
    waitbar(hh/nScenes, h, ['Wrting Image to File - ' num2str(round(hh/nScenes*100)) '%']);
end

if Save_List.Eapp, Write_Tiff_File_2(Eapp_Stack,  Path, 'Eapp', ['TH-' num2str(Threshold)], 32); end;
if Save_List.Capp, Write_Tiff_File_2(Capp_Stack,  Path, 'Capp', ['TH-' num2str(Threshold)], 32); end;

if Save_List.Basic
    Write_Tiff_File_2(FDonly_Stack, Path, 'FDonly', [], 32);
    for ii = 1:length(Elem_Spect)
        Write_Tiff_File_2(squeeze(Unmixed_Images_Stack(ii,:,:,:)), Path, Elem_Spect(ii).Name, [], 32);
    end
end

if Save_List.Basic_FICoS
    Write_Tiff_File_2(D_Plus_A_Stack, Path, 'D_pA', [], 32);
    for ii = 1:length(Elem_Spect)
        Write_Tiff_File_2(squeeze(Unmixed_Images_Stack(ii,:,:,:)), Path, Elem_Spect(ii).Name, [], 32);
    end
end

if Save_List.Chi2, Write_Tiff_File_2(Chi2_Stack, Path, 'Chi_Square', [], 32); end;

if Save_TH_Images
    if Save_List.Basic
        Write_Tiff_File_2(FDonly_TH_Stack, Path, 'FDonly_TH-', [num2str(Threshold)], 32);
        for ii = 1:length(Elem_Spect)
            Write_Tiff_File_2(squeeze(Unmixed_Images_TH_Stack(ii,:,:,:)), Path, Elem_Spect(ii).Name, ['TH-' num2str(Threshold)], 32);
        end
    end
    if Save_List.Basic_FICoS
        Write_Tiff_File_2(thD_Plus_A_Stack, Path, 'D_pA_TH-', [num2str(Threshold)], 32);
        for ii = 1:length(Elem_Spect)
            Write_Tiff_File_2(squeeze(Unmixed_Images_TH_Stack(ii,:,:,:)), Path, Elem_Spect(ii).Name, ['TH-' num2str(Threshold)], 32);
        end
    end
end
close(h);
