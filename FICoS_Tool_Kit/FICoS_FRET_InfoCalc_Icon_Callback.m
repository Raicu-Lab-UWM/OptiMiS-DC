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
function handles = FICoS_FRET_InfoCalc_Icon_Callback(hObject, eventdata)

handles = guidata(hObject);
handles.Hist_Info = [];

% Looking for ROI Manager whether it is open
mwHandles = guidata(handles.mwFigureH);
if isfield(mwHandles, 'pcFigureH')
    if ~isempty(mwHandles.pcFigureH)
        pcHandles = guidata(mwHandles.pcFigureH);
        handles   = FICoS_Initiate(handles, mwHandles);
    end
else
    msgbox('Open ROI Manager', 'Error');
end;

% % Sets the image in the ROI manager to 1 if frame number was not found on
% % the current frame object. deleting any segment image handles.
% current_Frame    = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(1)).Image_Frame_Index;
% if isempty(current_Frame), current_Frame = 1; end;
% set(pcHandles.FOV_hImage, 'CData', pcHandles.FOV_List(current_Frame).raw_Data);
% Image_Stack_sBar = findobj('Tag', 'Image_Stack_sBar');
% set(Image_Stack_sBar, 'Value', current_Frame);
% if isfield(pcHandles, 'handSegment'), delete(pcHandles.handSegment); end; guidata(mwHandles.pcFigureH, pcHandles);

if strcmp(mwHandles.UM_Params.Analysis_Type,'FICoS')
    handles = calc_FICoS_Data_FNC(handles, mwHandles, pcHandles);
else
    handles = calc_FRET_Data_FNC(handles, mwHandles, pcHandles);
end

guidata(hObject, handles);