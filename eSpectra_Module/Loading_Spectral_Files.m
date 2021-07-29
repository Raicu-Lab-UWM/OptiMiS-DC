function [Images_Stack, BackGround, xx, yy] = Loading_Spectral_Files (Path, fName, fType, Spectral_Index, fstChannel, lstChannel, Horizontal_Shift)

if nargin < 1, [fName,Path]     = uigetfile('.\*.*') ;       end;
if nargin < 2, [fName,Path]     = uigetfile([Path '\*.*']) ; end;
if nargin < 3 || strcmp(fType,'any')
    if strcmp(fName(end-2:end),'dat'), fType = 'dat'; elseif strcmp(fName(end-2:end),'tif'), fType = 'tiff stack'; end;
end;
if nargin < 4, Spectral_Index   = [1:200];                   end;
if nargin < 5, fstChannel       = 1000; elseif isempty(fstChannel), fstChannel = 1000; end;
if nargin < 6, lstChannel       = 1199; elseif isempty(lstChannel), lstChannel = 1199; end;
if nargin < 7, Horizontal_Shift = 50;                        end;

switch char(fType)
    case 'dat'
        nChannels           = lstChannel - fstChannel + 1;
        fName               = strcat(Path, '\', num2str(fstChannel), '.dat');
        currImage           = dlmread(fName);
        [xx,yy]             = size(currImage);
        Images_Stack        = zeros(xx,yy,nChannels);
        Images_Stack(:,:,1) = currImage;
        
        BackGround          = mean(mean(currImage));
        BackGround          = round(BackGround);
        
        h                   = waitbar(0,'Loading the images. Please Wait.');    
        for ii = fstChannel+1:lstChannel
            currChannel          = num2str(ii);
            fName                = strcat(Path,'\',currChannel,'.dat');
            currImage            = dlmread (fName);
            if Horizontal_Shift > 0
                Images_Stack(:,:,ii-fstChannel+1) = circshift(currImage,[0,-round(1/Horizontal_Shift*(ii-fstChannel)*200/(lstChannel-fstChannel+1))]);
            else
                Images_Stack(:,:,ii-fstChannel+1) = currImage;
            end;
            waitbar((ii-fstChannel+1) / (nChannels));
        end
    case 'tiff stack'
        FileTif             = [Path '\' fName];
        InfoImage           = imfinfo(FileTif);
        yy                  = InfoImage(1).Width;
        xx                  = InfoImage(1).Height;
        nChannels           = length(InfoImage);
        Images_Stack        = zeros(xx,yy,nChannels);
        TifLink             = Tiff(FileTif, 'r');
        TifLink.setDirectory(1);
        Images_Stack(:,:,1) = TifLink.read();
                
        BackGround          = mean(mean(Images_Stack(:,:,1)));
        BackGround          = round(BackGround);
        h                   = waitbar(0,'Loading the images. Please Wait.');  
        for ii=1:nChannels
            TifLink.setDirectory(ii);
            currImage = TifLink.read();
            if Horizontal_Shift > 0
                Images_Stack(:,:,ii) = floatingCircShift(currImage,[0,-(ii-1)*Horizontal_Shift]);
            else
                Images_Stack(:,:,ii) = currImage;
            end;
            waitbar((ii) / (nChannels));
        end
        TifLink.close();
    otherwise
end;

Images_Stack = Images_Stack(:,:,Spectral_Index);
BackGround   = BackGround - 0.9*min(min(min(Images_Stack)));
Images_Stack = Images_Stack - 0.9*min(min(min(Images_Stack)));

% Spectral_Images_Mat = Avg_Filter(Spectral_Images_Mat,2);
close(h);