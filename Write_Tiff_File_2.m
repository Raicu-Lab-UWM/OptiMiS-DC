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
function Write_Tiff_File_2 (Image, Path, Name, Image_Type, Bit_Rate, Big)

if isempty(Image_Type)
    Image_File_Name = [Name '.tif'];
else
    Image_File_Name = [Name '_' Image_Type '.tif'];
end

if nargin < 6, Big = false; end
options.Big = Big;

switch Bit_Rate
    case 8
        saveastiff_2(int8(Image), Path, Image_File_Name, options);
    case 16
        saveastiff_2(uint16(Image), Path, Image_File_Name, options);
    case 32
        saveastiff_2(single(Image), Path, Image_File_Name, options);
    otherwise
end;