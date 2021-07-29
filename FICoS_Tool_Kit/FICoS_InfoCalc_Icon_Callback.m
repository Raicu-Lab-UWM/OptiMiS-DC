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
function handles = FICoS_InfoCalc_Icon_Callback(hObject, eventdata)

handles = guidata(hObject);
handles.Hist_Info = [];
mwHandles = guidata(handles.mwFigureH);
if isfield(mwHandles, 'pcFigureH')
    if ~isempty(mwHandles.pcFigureH)
        pcHandles = guidata(mwHandles.pcFigureH);
        handles   = FICoS_Initiate(handles, mwHandles);
    end
else
    msgbox('Open Polygon Console', 'Error');
end;

current_Frame    = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(1)).Image_Frame_Index;
if isempty(current_Frame), current_Frame = 1; end;
set(pcHandles.FOV_hImage, 'CData', pcHandles.FOV_List(current_Frame).raw_Data);
Image_Stack_sBar =  findobj('Tag', 'Image_Stack_sBar');
set(Image_Stack_sBar, 'Value', current_Frame);
if isfield(pcHandles, 'handSegment'), delete(pcHandles.handSegment); end; guidata(mwHandles.pcFigureH, pcHandles);

if isempty(handles.FICoS_Fit_Range)
    Fit_Range = [-1, 1];
    handles.FICoS_Fit_Range = Fit_Range;
    if handles.FICoS_Hist_Bin >= 1, FICoS_Hist_Bin = handles.FICoS_Hist_Bin/100; else FICoS_Hist_Bin = handles.FICoS_Hist_Bin; end;
else
    if max(handles.FICoS_Fit_Range) <= 1
        if handles.FICoS_Hist_Bin >= 1, FICoS_Hist_Bin = handles.FICoS_Hist_Bin/100; else FICoS_Hist_Bin = handles.FICoS_Hist_Bin; end;
        Fit_Range = handles.FICoS_Fit_Range;
    else
        FICoS_Hist_Bin = handles.FICoS_Hist_Bin;
        Fit_Range     = handles.FICoS_Fit_Range;
    end;
end;

if isfield(handles, 'Accum_Data'), if ~handles.Accum_Data, handles.FICoS_List = FICoS_Analysis_O; end; end

h = waitbar(0, 'Calculating Histograms ...');
for ii = 1:length(mwHandles.Current_Polygon_Index)
    Polygon = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii));
    Found   = handles.FICoS_List.Find_FICoS_Item(Polygon.Name);
    if Found == 0
        FICoS_Item                = FICoS_Analysis_O;
        FICoS_Item.Master_Polygon = Polygon.Name;
    else
        FICoS_Item = handles.FICoS_List(Found);
    end
    
    % Calculating The histograms. Multiple for Segments and one for patch.
    [Related_Segment, Segment_Found] = handles.Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon.Name);
    Current_Image = pcHandles.FOV_List(uint16(Polygon.Image_Frame_Index)).raw_Data;
    if max(Current_Image(:)) > Fit_Range(2), Current_Image = Current_Image/100; end;
    if ~isempty(Segment_Found)
        FICoS_Item = FICoS_Item.Calculate_Histogram(Related_Segment.Polygons, FICoS_Hist_Bin, Current_Image, Fit_Range);
    else
        FICoS_Item = FICoS_Item.Calculate_Histogram(Polygon.Coordinates, FICoS_Hist_Bin, Current_Image, Fit_Range);
    end;
    
    % calculate fit to the histogram
    FICoS_Item.Fitting_Param = struct('Fit_Method', handles.FICoS_Fit_Method, 'Range', Fit_Range, 'nGaussians', handles.FICoS_nGaussians, ...
                                      'TolFun',0.00001,'MaxFunEvals',1e10);
    FICoS_Item.Analysis_Method = handles.FICoS_Method;
    if ii == 1
        [FICoS_Item, hHist_Figure] = FICoS_Item.Calculate_Fit(0);
    else
        [FICoS_Item, hHist_Figure] = FICoS_Item.Calculate_Fit(0, hHist_Figure);
    end;
    
    % Calculate FICoS and Concentration
    FICoS_Item = FICoS_Item.Calculate_Sample_Param;
    
    % Add a FICoS instance to the FICoS list
    nFICoS_Items = length(handles.FICoS_List); if nFICoS_Items == 1 && isempty(handles.FICoS_List.Master_Polygon), nFICoS_Items = 0; end;
    if Found == 0
        handles.FICoS_List(nFICoS_Items+1) = FICoS_Item;
    else
        handles.FICoS_List(Found) = FICoS_Item;
    end;
    
    %ploting the Cells ROIs
    if current_Frame ~= mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Image_Frame_Index
        current_Frame = mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Image_Frame_Index;
    end;
    set(pcHandles.FOV_hImage, 'CData', pcHandles.FOV_List(uint16(current_Frame)).raw_Data);
    set(Image_Stack_sBar, 'Value', current_Frame);
    handPoly = [mwHandles.Polygon_List.Poly_PlotH];
    handText = [mwHandles.Polygon_List.Title_PrintH];
    set(handPoly, 'Visible', 'off');
    set(handText, 'Visible', 'off');
    set(mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Poly_PlotH, 'Visible', 'on');
    set(mwHandles.Polygon_List(mwHandles.Current_Polygon_Index(ii)).Title_PrintH, 'Visible', 'on');
    waitbar(ii/length(mwHandles.Current_Polygon_Index), h);
end;
for ii = 1:length(handles.FICoS_List)
    FICoS_Item = handles.FICoS_List(ii);
    handles.Hist_Info = [handles.Hist_Info; FICoS_Item.Histogram'];
end;
close(h);

guidata(hObject, handles);