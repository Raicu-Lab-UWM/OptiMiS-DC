% UnMix is a function that calculate the unmixed pixel level coefficients
% of the emission from different fluorescent molecules. Thus, this function
% separate the emissions from different molecules when using the mixed
% measured spectral images and the elementary spectra of the individual
% molecules.
%
% Input Parameters:
%
% Image_Stack  : Mixed raw data images measured by the Optimis System. These
%              raw data image are saved as tiff stacks with different chanels for
%              different wavelengts
% Spectrum     : Elementaey spectra
% UnMix_Method : Method of unmixing the user can choose between 1. Linear
%              Regression (non itarative method) 2. 'Regularize NLR
%              Negative Pixels' (i)
%
% output Parameters
%
% Eapp         : is the FRET efficiency map calculated using the unmixed data.
% FDonly       : is the Donor intensity in the absance of the acceptor
%              calculated using FRET data.
% thFDonly (Optional) : is the Donor intensity in the absance of the acceptor
%              calculated using FRET data after thresholding.
% Shift (Optional)    : is the color contrast map calculated using the unmixed
%              images
% D_Plus_A (Optional) : Total concentration of proteins calculated using
%              the the color contrast information.
%-----------------------------------------------------------------------------------
% Written by Gabriel Biener, 11/12/2014 Modified at 11/03/2017 older
% version can be found in Optimis_DC folder.
%-----------------------------------------------------------------------------------
function currUnmix_Images = UnMix(Image_Stack, Spectrum, Unmix_Method_Index, Background)

xx          = size(Image_Stack,1);
yy          = size(Image_Stack,2);
Image_Stack = Image_Stack - Background;
%Image_Stack1 = Image_Stack(:,:,1); % a check for TK
switch Unmix_Method_Index
    case 1 % 'Analytic'
        if size(Spectrum,1) >= size(Image_Stack,3)
            Bin_Size         = size(Spectrum,1)/size(Image_Stack,3);
            Spectrum         = Bin_Spectrum(Spectrum, Bin_Size);

            vImage_Stack     = reshape(Image_Stack,xx*yy,size(Image_Stack,3));
%             FMxF             = reshape(Spectrum'*vImage_Stack',size(Spectrum,2),xx,yy);
%             F_Mat            = Spectrum'*Spectrum;
%             currUnmix_Images = reshape(F_Mat\FMxF(:,:),size(FMxF));
%             currUnmix_Images = reshape(Spectrum\vImage_Stack',size(Spectrum,2), size(Image_Stack,1), size(Image_Stack,2));
            currUnmix_Images = reshape(pinv(Spectrum)*vImage_Stack',size(Spectrum,2), size(Image_Stack,1), size(Image_Stack,2));
        else h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
        end;
    case 2 % 'Iterative'
        Options_LSQ = optimset('MaxIter',1000, 'TolFun',1e-3, 'Display','off');
        if size(Spectrum,1) >= size(Image_Stack,3)
            Bin_Size         = size(Spectrum,1)/size(Image_Stack,3);
            Spectrum         = Bin_Spectrum(Spectrum, Bin_Size);

            currUnmix_Images = zeros(size(Spectrum,2),xx,yy);
            h                = waitbar(0,'Unmixing please wait...');
            for ii = 1:xx
                for jj = 1:yy
                    curUnmix_Data             = lsqnonneg(Spectrum,squeeze(Image_Stack(ii,jj,:)), Options_LSQ);
                    currUnmix_Images(:,ii,jj) = curUnmix_Data;            
                    waitbar((jj+yy*(ii-1))/xx/yy,h);
                end;
            end;
        else h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
        end;
        close(h);
    case 3 % 'Regularize NLR Negative Pixels'
        if size(Spectrum,1) >= size(Image_Stack,3)
            Bin_Size         = size(Spectrum,1)/size(Image_Stack,3);
            Spectrum         = Bin_Spectrum(Spectrum, Bin_Size);

            vImage_Stack     = reshape(Image_Stack,xx*yy,size(Image_Stack,3));
            FMxF             = reshape(Spectrum'*vImage_Stack',size(Spectrum,2),xx,yy);
            F_Mat            = Spectrum'*Spectrum;
            currUnmix_Images = reshape(F_Mat\FMxF(:,:),size(FMxF));
            UnMix_Min        = squeeze(min(currUnmix_Images,[],1));
            [mXX,mYY]        = find (UnMix_Min < 0);
            h                = waitbar(0,'Unmixing please wait...');
            for ii = 1:length(mXX)
                [curUnmix_Data,~,~]                       = l1_ls_nonneg(Spectrum(:,1:end-1), squeeze(Image_Stack(mXX(ii),mYY(ii),:))-currUnmix_Images(end,mXX(ii),mYY(ii)), 0.001, 1e-3,1);
                currUnmix_Images(1:end-1,mXX(ii),mYY(ii)) = curUnmix_Data;
                waitbar(ii/length(mXX),h);
            end;
        else h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
        end;
        close(h);
    case 4 % 'L1 Regularized Method'
        if size(Spectrum,1) >= size(Image_Stack,3)
            Bin_Size         = size(Spectrum,1)/size(Image_Stack,3);
            Spectrum         = Bin_Spectrum(Spectrum, Bin_Size);

            currUnmix_Images = zeros(size(Spectrum,2),xx,yy);
            h                = waitbar(0,'Unmixing please wait...');
            for ii = 1:xx
                for jj = 1:yy
                    [curUnmix_Data,~,~]       = l1_ls_nonneg(Spectrum, squeeze(Image_Stack(ii,jj,:)), 0.001, 1e-3,1);
                    currUnmix_Images(:,ii,jj) = curUnmix_Data;            
                    waitbar((jj+yy*(ii-1))/xx/yy,h);
                end;
            end;
        else h = msgbox('Elementary spectra doesn''t fit the data spectrum','Error');
        end;
        close(h);
    otherwise
end;