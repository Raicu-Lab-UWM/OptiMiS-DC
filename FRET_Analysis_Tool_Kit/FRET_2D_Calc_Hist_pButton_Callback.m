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
function handles = FRET_2D_Calc_Hist_pButton_Callback(hObject, eventdata, FRET_FigureH)

handles = guidata(FRET_FigureH);
handles.Hist_Info = [];
mwHandles = guidata(handles.Main_FigureH);
if isfield(mwHandles, 'pcFigureH')
    if ~isempty(mwHandles.pcFigureH)
        pcHandles = guidata(mwHandles.pcFigureH);
        handles   = handles.FRET_.Initiate(handles, pcHandles);
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

if isempty(handles.FRET_Fit_Range)
    Image_    = [pcHandles.FOV_List.raw_Data];
    Fit_Range = [min(Image_(:)), max(Image_(:))];
else
    Fit_Range = handles.FRET_Fit_Range;
end;

[fName, mwHandles.curr_Path] = uigetfile([mwHandles.curr_Path pcHandles.FOV_List(1).Name(1:21) 'KDA_815.tif']);
KDA_L1_Image_Stack = Load_Image(mwHandles.curr_Path, fName);
KAD_L1_Image_Stack = Load_Image(mwHandles.curr_Path, [pcHandles.FOV_List(1).Name(1:21) 'KAD_815.tif']);
KAD_L2_Image_Stack = Load_Image(mwHandles.curr_Path, [pcHandles.FOV_List(1).Name(1:21) 'KAD_960.tif']);

if ~isfield(mwHandles, 'eSpectra')
    mwHandles.eSpectra = Elementary_Spectrum_O;
    mwHandles.eSpectra = AddRemove_Tags(mwHandles.eSpectra, mwHandles.curr_Path);
elseif isempty(mwHandles.eSpectra(1).Name) && length(mwHandles.eSpectra) == 1
    mwHandles.eSpectra = AddRemove_Tags(mwHandles.eSpectra, mwHandles.curr_Path);
end
guidata(handles.Main_FigureH, mwHandles);

h = waitbar(0, 'Calculating Histograms ...');
for ii = 1:length(mwHandles.Current_Polygon_Index)
    FRET_Item                = FRET_Analysis_O;
    
    Polygon                  = mwHandles.Polygon_List(uint16(mwHandles.Current_Polygon_Index(ii)));
    Found                    = handles.FRET_List.Find_FRET_Item(Polygon.Name);
    FRET_Item.Master_Polygon = Polygon.Name;
    
    % Calculating The histograms. Multiple for Segments and one for patch.
    [Related_Segment, Segment_Found] = mwHandles.Segment_List.Segment_MasterPoly_Query('Master_Polygon', Polygon.Name);
    if ~isempty(Segment_Found)
        FRET_Item = FRET_Item.Calculate_TEW_Info(Related_Segment.Polygons, handles.FRET_Hist_Bin, KDA_L1_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                                  KAD_L1_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                                  KAD_L2_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                                  mwHandles.eSpectra);
    else
        FRET_Item = FRET_Item.Calculate_TEW_Info(Polygon.Coordinates, handles.FRET_Hist_Bin, KDA_L1_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                             KAD_L1_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                             KAD_L2_Image_Stack(:,:,uint16(Polygon.Image_Frame_Index)), ...
                                                                                             mwHandles.eSpectra);
    end;
    
    % calculate fit to the histogram
    FRET_Item.Fitting_Param = struct('Fit_Method', handles.FRET_Fit_Method, 'Range', Fit_Range, 'nGaussians', handles.FRET_nGaussians, ...
                                      'TolFun',0.00001,'MaxFunEvals',1e10);
    FRET_Item.Analysis_Method = handles.FRET_Method;
    if ii == 1
        [FRET_Item, hHist_Figure] = FRET_Item.Calculate_Fit(0);
    else
        [FRET_Item, hHist_Figure] = FRET_Item.Calculate_Fit(0, hHist_Figure);
    end;
    
    % Calculate FRET and Concentration
    FRET_Item = FRET_Item.Calculate_Sample_Param;
    
    % Add a FRET instance to the fluctuation list
    nFRET_Items = length(handles.FRET_List); if nFRET_Items == 1 && isempty(handles.FRET_List.Master_Polygon), nFRET_Items = 0; end;
    if Found == 0
        handles.FRET_List(nFRET_Items+1) = FRET_Item;
    else
        handles.FRET_List(Found).TEW_Eapp = FRET_Item.TEW_Eapp;
        handles.FRET_List(Found).TEW_FD   = FRET_Item.TEW_FD;
        handles.FRET_List(Found).TEW_FA   = FRET_Item.TEW_FA;
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
for ii = 1:length(handles.FRET_List)
    FRET_Item = handles.FRET_List(ii);
    handles.Hist_Info = [handles.Hist_Info; FRET_Item.Histogram'];
end;
close(h);

guidata(FRET_FigureH, handles);