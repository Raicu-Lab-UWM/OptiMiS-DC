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
function [FOV_List, Path] = Load_From_Multiple_Folders(handles)
StandAlone = true;
if isfield(handles, 'mwFigureH'), if isvalid(handles.mwFigureH), mwHandles = guidata(handles.mwFigureH); StandAlone = false; end; end

if StandAlone, curr_Path = handles.curr_Path; mwHandles = []; else curr_Path = mwHandles.curr_Path; end
Path = uigetdir(curr_Path,'Load Images Root Path');

if StandAlone, Image_Type_Loaded = handles.Image_Type_Loaded; else Image_Type_Loaded = mwHandles.Image_Type_Loaded; end % Choose the Path of the data to load
Root_Data_Info      = dir(Path);                                                                                        % Create folder structure including all the infor about the image sub folders
Dirs_in_Root        = [Root_Data_Info.isdir];                                                                           % Select in the folder structure only the folders
Total_Dir_in_Root   = length(Dirs_in_Root(Dirs_in_Root == 1)) - 2;
Bar_Handle          = waitbar(0);
Images_List         = Gen_Image_List_Names(Path, Path, {}, Total_Dir_in_Root, Bar_Handle); % run the recursion function to load all the image file naems in all the sub folders and add to list including path and file name
imList_Path         = Images_List(:,1);
imList_Name         = Images_List(:,2);
imList_Width        = Images_List(:,3);
imList_Height       = Images_List(:,4);
imList_Depth        = Images_List(:,5);
if size(Images_List,2) == 6, imList_Third_Dim = Images_List(:,6); end;
FOV_List(length(imList_Path))       = Field_ofView_O;             % Create an array of empty scenes. The number of scene objects is the same as the number of images.
FOV_List(length(imList_Path)+1:end) = [];                         % incase the number of scenes is larger thenthe number of image from earlier analysis we remove the excess scenes
Number_of_Files                     = 1;                          % count valid images

% populate the empty FOV array with file names and file paths.
curr_imWidth  = imList_Width{1};
curr_imHeight = imList_Height{1};
for ii = 1:length(imList_Path)
    % Check whether an image is valid or not by checking if it has a valid readme file
    if curr_imWidth == imList_Width{ii}, curr_imWidth = imList_Width{ii};
    else waitfor(warndlg('Images are not the same size make sure to check images sizes','Worning')); break;
    end;
    if curr_imHeight == imList_Height{ii}, curr_imHeight = imList_Height{ii};
    else waitfor(warndlg('Images are not the same size make sure to check images sizes','Worning')); break;
    end

    curr_imName                    = imList_Name{ii};
    FOV_List(Number_of_Files).Name = curr_imName;
    FOV_List(Number_of_Files).Path = imList_Path{ii};
    FOV_List(Number_of_Files).FOV_Dimensions = [imList_Width{ii}, imList_Height{ii}, imList_Depth{ii}];
    curr_Image                     = Load_Image(imList_Path{ii}, curr_imName);
    switch Image_Type_Loaded
        case 'Tagged Image File Format (tiff)'
            if strcmp(curr_imName(end-2:end),'tif') || strcmp(curr_imName(end-3:end),'tiff')
                if imList_Depth{ii} > 1, FOV_List(Number_of_Files).raw_Data = mean(curr_Image,3); 
                else FOV_List(Number_of_Files).raw_Data = curr_Image;
                end;
            end;
        case 'Portable Network Graphic (png)'
            if strcmp(curr_imName(end-2:end),'png'),  FOV_List(Number_of_Files).raw_Data = rgb2gray(curr_Image); end;
        case 'Zeiss File Format (lsm)'
            if strcmp(curr_imName(end-2:end),'lsm')
                FOV_List(Number_of_Files).FOV_Type = imList_Third_Dim{ii};
                if imList_Depth{ii} > 1, FOV_List(Number_of_Files).raw_Dat = mean(curr_Image,3);
                else FOV_List(Number_of_Files).raw_Data = curr_Image;
                end;
            end;
        otherwise
    end;
    Number_of_Files = Number_of_Files + 1;
end;
FOV_List(Number_of_Files:end) = [];