% Load_Image is a function that Loads an Image from different formats including tiff stacks with 32bit. 
%
% IMAGE_MAT = Load_Image
% IMAGE_MAT is a two dimensional matrix containing the image data. when a
% file is not specified the function will prompet the user to choose a file
% by opening the file open dialog box.
%
% IMAGE_MAT = Load_Image(PATH)
% PATH is the path containing the file of interest. the user will again be
% asked to choose the file containing the desired image.
%
% IMAGE_MAT = Load_Image(PATH, NAME)
% NAME is the file name containg the desired image.
%
% IMAGE_MAT = Load_Image(PATH, NAME, EXTENSION)
% EXTENSION is the file format. 
%------------------------------------------------------------------------

% Copyright (C) 2018  Raicu Lab.
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU Affero General Public License as
%     published by the Free Software Foundation, either version 3 of the
%     License, or (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU Affero General Public License for more details.
% 
%     You should have received a copy of the GNU Affero General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%------------------------------------------------------------------------------
% Writen By: Gabriel Biener, PhD 
% Advisor and Group Leader: Prof. Valerica Raicu
% For technical questions contact biener@uwm.edu
%------------------------------------------------------------------------------
function Image_Mat = Load_Image(Path, Name, Extension, Remove_HotPixels)

% Input parameters are examind incase one or more are missing they are
% assigned avalue based on the input from the user. If PATH and NAME or
% just NAME is missing the function will ask the user to choose a file
% using the open file dialog box.
if nargin < 1, Path = '.\'; end
if ~strcmp(Path(end), '\'), Path = [Path '\']; end;
if nargin < 2, Name = []; end
if isempty(Name)
    [Name, Path] = uigetfile([Path '*.tif;*.tiff;*.bmp;*.png;*.cur;*.gif;'...
                              '*.hdf;*.ico;*.jpg;*.jpeg;*.lsm;*.pbm;*.pcx;'...
                              '*.pgm;*.*.ppm;*.ras', 'Load Image']);
end;
% In case the Image type input parameter (EXTENSION) is not entered the
% file extansion is assigned to the parameter.
if nargin < 3
    Period_Loc = strfind(Name(end-4:end), '.');
    if Period_Loc == 2, Extension = Name(end-2:end); else Extension = Name(end-3:end); end;
elseif isempty(Extension)
    Period_Loc = strfind(Name(end-4:end), '.');
    if Period_Loc == 2, Extension = Name(end-2:end); else Extension = Name(end-3:end); end;
end;

if nargin < 4, Remove_HotPixels = 0; elseif isempty(Remove_HotPixels), Remove_HotPixels = 0; end;
    
% tiff image handaling is different from the other image types as tiff can
% have a stack as well.
if strcmp(Extension,'tif') || strcmp(Extension,'tiff')
    if ~exist([Path Name], 'file')
        if exist(Path, 'dir')
            [Name, Path] = uigetfile([Path '\*.tif;*.tiff;*.bmp;*.png;*.cur;*.gif;'...
                                      '*.hdf;*.ico;*.jpg;*.jpeg;*.lsm;*.pbm;*.pcx;'...
                                      '*.pgm;*.*.ppm;*.ras', 'Load Image']);
        else
            [Name, Path] = uigetfile(['.\*.tif;*.tiff;*.bmp;*.png;*.cur;*.gif;'...
                                      '*.hdf;*.ico;*.jpg;*.jpeg;*.lsm;*.pbm;*.pcx;'...
                                      '*.pgm;*.*.ppm;*.ras', 'Load Image']);
        end;
    end;
    Info_Structure = imfinfo([Path Name]);
    Depth          = length(Info_Structure);
    TifLink        = Tiff([Path Name], 'r');
    ySize          = Info_Structure(1).Width;
    xSize          = Info_Structure(1).Height;
    BitDepth       = Info_Structure(1).BitDepth;
    if BitDepth == 32
        Image_Mat      = zeros(xSize,ySize,Depth, 'double');
    else
        Image_Mat      = zeros(xSize,ySize,Depth, ['uint' num2str(BitDepth)]);
    end
    
% Loading a Stack
    if Depth > 1
        h = waitbar(0,'Loading the stack. Please Wait.');
        for ii = 1:Depth
            TifLink.setDirectory(ii);
            Image_Mat(:,:,ii) = TifLink.read();
            waitbar((ii) / (Depth));
        end;
        close(h);
    elseif Depth==1
        TifLink.setDirectory(1);
        Image_Mat(:,:) = TifLink.read();
    end;
    TifLink.close();
% Loading an image that is different than a tiff type.
elseif strcmp(Extension,'lsm')
    Data = lsmread([Path '\' Name]);
    Image_Mat = fliplr(rot90(squeeze(Data(1,1,1,:,:)),-1));
else
    Image_Mat = imread([Path Name], Extension);
end;
if Remove_HotPixels
    TH        = 8;
    Image_Mat = Remove_HotPixels_Fcn(Image_Mat, TH);
end;