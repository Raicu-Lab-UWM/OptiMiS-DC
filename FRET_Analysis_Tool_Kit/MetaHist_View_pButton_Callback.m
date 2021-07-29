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
function MetaHist_View_pButton_Callback (hObject, eventdata)
handles = guidata(hObject);

Meta_Hist_Bin = handles.FRET_MetaHist_Bin;
if handles.FRET_List(1).Bin_List(end) > 1
    handles.FRET_List(1).Bin_List = handles.FRET_List(1).Bin_List/100;
end;
Meta_Bin_List               = [handles.FRET_List(1).Bin_List(1):Meta_Hist_Bin:handles.FRET_List(1).Bin_List(end)]';
handles.Meta_Histogram      = zeros(length(Meta_Bin_List), 2);
handles.Meta_Histogram(:,1) = Meta_Bin_List(1:end);
Meta_Hist_Peaks             = {handles.FRET_List.Eapp};
Meta_Hist_Peaks             = cell2mat(Meta_Hist_Peaks)';
Meta_Hist_Peaks(Meta_Hist_Peaks == 0) = [];
Meta_Hist_Peaks(Meta_Hist_Peaks > 1)  = [];
handles.Meta_Histogram(:,2) = hist(Meta_Hist_Peaks, Meta_Bin_List-1e-10);

guidata(hObject, handles);
Meta_Hist_Plot(hObject);