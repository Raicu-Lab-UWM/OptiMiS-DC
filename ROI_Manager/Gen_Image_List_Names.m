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
function Images_Names_List = Gen_Image_List_Names(Path, Data_Path, Images_Names_List, Total_Dir_in_Root, Bar_Handle)

Image_Dir_Info = dir(Path);
Third_Dim_Type = 'CZT';
for ii = 1:length(Image_Dir_Info)
    if ~strcmp(Image_Dir_Info(ii).name,'.') && ~strcmp(Image_Dir_Info(ii).name,'..')
        if Image_Dir_Info(ii).isdir
            Images_Names_List = Gen_Image_List_Names([Path '\' Image_Dir_Info(ii).name], Data_Path, Images_Names_List, Total_Dir_in_Root, Bar_Handle);
        elseif strcmp(Image_Dir_Info(ii).name(end-3:end),'tiff') || strcmp(Image_Dir_Info(ii).name(end-2:end),'tif')
            Image_Param       = imfinfo([Path '\' Image_Dir_Info(ii).name]);
            Depth             = length(Image_Param);
            Image_Name        = {Path, Image_Dir_Info(ii).name, Image_Param(1).Width, Image_Param(1).Height, Depth};
            Images_Names_List = [Images_Names_List; Image_Name];
        elseif strcmp(Image_Dir_Info(ii).name(end-2:end),'png')
            Image_Param       = imfinfo([Path '\' Image_Dir_Info(ii).name]);
            Image_Name        = {Path, Image_Dir_Info(ii).name, Image_Param(1).Width, Image_Param(1).Height, 3};
            Images_Names_List = [Images_Names_List; Image_Name];
        elseif strcmp(Image_Dir_Info(ii).name(end-2:end),'lsm')
            Image_Param        = lsmread([Path '\' Image_Dir_Info(ii).name],'InfoOnly');
            [Depth, Third_Dim] = max([Image_Param.dimC, Image_Param.dimZ, Image_Param.dimT]);
            Image_Name         = {Path, Image_Dir_Info(ii).name, Image_Param.dimX, Image_Param.dimY, Depth, Third_Dim_Type(Third_Dim)};
            Images_Names_List  = [Images_Names_List; Image_Name];
        end;
    end;
    if strcmp(Path, Data_Path)
        waitbar(ii/Total_Dir_in_Root, Bar_Handle, Image_Dir_Info(ii).name);
    end;
end;
if strcmp(Path, Data_Path)
    close(Bar_Handle);
end;