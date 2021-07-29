%

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
function Image_Mat = Remove_HotPixels_Fcn(Image_Mat, TH)

if size(Image_Mat,3) > 1
    for ii = 1:size(Image_Mat,3)
        iiImage      = double(Image_Mat(:,:,ii));
        iimedImage   = medfilt2(iiImage,[3,3],'symmetric');
        iimedImage_2 = abs(iiImage - iimedImage);
        iimadImage   = medfilt2(iimedImage_2, [3,3],'symmetric');
        THImage      = iimedImage+TH*iimadImage;
        iiImage      = iiImage.*(iiImage<=THImage) + iimedImage.*(iiImage>THImage);
        if isa(Image_Mat,'double')
            Image_Mat(:,:,ii) = iiImage;
        else
            Image_Mat(:,:,ii) = uint32(iiImage);
        end;
    end;
else
    iiImage      = double(Image_Mat);
    iimedImage   = medfilt2(iiImage,[3,3],'symmetric');                         % Smoothen the Image using median filter
    iimedImage_2 = abs(iiImage - iimedImage);                                   % Calculate Pixel_Value - Local_Median_Value
    iimadImage   = medfilt2(iimedImage_2, [3,3],'symmetric');                   % find the second median moment using median filter
    THImage      = iimedImage+TH*iimadImage;                                    % Calculating the TH image ||Local_Median_Value||1 + TH*||Local_Median_Value||2  || ||1 - First Median Moment, || ||2 - Second Median Moement
    iiImage      = iiImage.*(iiImage<=THImage) + iimedImage.*(iiImage>THImage); % Reassigning the pixel value. If higher then TH assing the median value if lower or equal to TH dont change pixel value
    if isa(Image_Mat,'double')
        Image_Mat = iiImage;
    elseif isa(Image_Mat, 'uint16')
        Image_Mat = uint16(iiImage);
    elseif isa(Image_Mat, 'uint8')
        Image_Mat = uint8(iiImage);
    else
        Image_Mat = uint32(iiImage);
    end;
end;