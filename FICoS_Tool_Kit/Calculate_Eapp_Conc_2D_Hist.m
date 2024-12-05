function [handles, Stack_Conc_Bin] = Calculate_Eapp_Conc_2D_Hist(handles, Plot_Type)

mwHandles = guidata(handles.mwFigureH);

FRET_List = handles.FRET_List;
Polygon_List=handles.Polygon_List;
Segment_List=handles.Segment_List;

TEW_FDA_L1    = [];
TEW_FAD_L1    = [];
TEW_FAD_L2    = [];
TEW_Polygon_frame=[];
TEW_Polygon_number=[];
TEW_Segment_coord=[];
TEW_PolygonNames=[];
Eapp          = [];

Peak_FDA1     = []; % added by DB April 24, 2022 for Peak level Conc calc
Peak_FAD1     = [];
Peak_FAD2     = [];
for ii = 1:length(FRET_List)
    FRET_Item  = FRET_List(ii);


    %added %241204_MS
    Polygon_Item=handles.Polygon_List(ii); 
    Segment_Item=handles.Segment_List(ii); 

    

    FDA_L1 = []; FDA_L1(:,1) = FRET_Item.TEW_FDA_L1; 
    TEW_FDA_L1 = [TEW_FDA_L1; FDA_L1]; 
    FAD_L1 = []; FAD_L1(:,1) = FRET_Item.TEW_FAD_L1; 
    TEW_FAD_L1 = [TEW_FAD_L1; FAD_L1];
    FAD_L2 = []; FAD_L2(:,1) = FRET_Item.TEW_FAD_L2;
    TEW_FAD_L2 = [TEW_FAD_L2; FAD_L2];
    
    no_segments=size(FAD_L2,1);
    Polygon_number=ones(no_segments,1)*ii;
    TEW_Polygon_number = [TEW_Polygon_number; Polygon_number];

    Polygon_frame=ones(no_segments,1)*Polygon_Item.Image_Frame_Index;
    TEW_Polygon_frame = [TEW_Polygon_frame; Polygon_frame];

    for jj=1:no_segments
        mean_Coordinates=mean(Segment_Item.Polygons{1,jj},1);
        TEW_Segment_coord=[TEW_Segment_coord; mean_Coordinates];
    
    end

    Names = repmat(Polygon_Item.Name, no_segments, 1); % Repeat the name 11,000 times
    Names = cellstr(Names);
    TEW_PolygonNames=[TEW_PolygonNames; Names]; %
    
    %end of add %241204_MS


    Eapp2           = FRET_Item.Eapp;
    Eapp            = [Eapp; Eapp2];
    
    Peak_FDA1       = [Peak_FDA1; FRET_Item.Peak_FDA1];
    Peak_FAD1       = [Peak_FAD1; FRET_Item.Peak_FAD1];
    Peak_FAD2       = [Peak_FAD2; FRET_Item.Peak_FAD2];
end;
Eapp(Eapp == 0) = NaN;

UM_Params = mwHandles.UM_Params;
if isfield(UM_Params, 'SlopD'), SlopD = UM_Params.SlopD; else SlopD = 37985.4; end
if isfield(UM_Params, 'SlopA'), SlopA = UM_Params.SlopA; else SlopA = 7440.1; end
if isfield(UM_Params, 'psfD'), psfD = UM_Params.psfD; else psfD = 5.65E-20; end
if isfield(UM_Params, 'psfA'), psfA = UM_Params.psfA; else psfA = 4.71E-20; end
if isfield(UM_Params, 'qD'), qD = UM_Params.qD; else qD = 0.55; end
if isfield(UM_Params, 'qA'), qA = UM_Params.qA; else qA = 0.61; end
if isfield(UM_Params, 'rowD'), rowD = UM_Params.rowD; else rowD = 4.4351; end
if isfield(UM_Params, 'rowA'), rowA = UM_Params.rowA; else rowA = 0.056; end

% rQuant_Yield = qD/qA;
% FA1   = (TEW_FAD_L1-(TEW_FAD_L2*rowD))/(1-(rowD/rowA));
% FD    = TEW_FDA_L1 + (rQuant_Yield*TEW_FAD_L1)-(rQuant_Yield*FA1);                                    % from Prof. Raicu's paper titled "Ab initio derivation
% FA    = (TEW_FAD_L2-(TEW_FAD_L1/rowD))/(1-(rowA/rowD));                                         % of the FRET equations resolves old puzzles and 
%                                                         
% TEW_Eapp   = 1./(1+((TEW_FDA_L1*qA/qD)./(TEW_FAD_L1-(FA*rowA))));
% 
% SlopD = SlopD*1000/(6.022*10^23); % converted from Int/uM to m3/count
% SlopA = SlopA*1000/(6.022*10^23);
% Dconc = FD*psfD/SlopD;
% Aconc = FA*psfA/SlopA;
% Conc  = Dconc+Aconc;
% xA    = Aconc./Conc;
[TEW_Eapp, Dconc, Aconc, Conc, xA] = TwoWL_Conc_Eapp_Calc(TEW_FDA_L1, TEW_FAD_L1, TEW_FAD_L2, qD, qA, rowD, rowA, SlopD, SlopA, psfD, psfA);
%handles.TEW_Molecular_Info  = [Conc, xA, TEW_Eapp, TEW_FDA_L1, TEW_FAD_L1, TEW_FAD_L2, Eapp];
handles.TEW_Molecular_Info  = [Conc, xA, TEW_Eapp, TEW_FDA_L1, TEW_FAD_L1, TEW_FAD_L2, Eapp,TEW_Polygon_number,TEW_Polygon_frame, TEW_Segment_coord]; %241204_MS
handles.FOV_List  = TEW_PolygonNames; %241204_MS
handles.TEW_Eapp_Conc_Info  = [Dconc, Aconc, Conc, xA, Eapp];

[Peak_Eapp12, Peak_Dconc, Peak_Aconc, Peak_Conc, Peak_xA] = TwoWL_Conc_Eapp_Calc(Peak_FDA1, Peak_FAD1, Peak_FAD2, qD, qA, rowD, rowA, SlopD, SlopA, psfD, psfA);
handles.Peak_Molecular_Info = [Peak_Conc, Peak_xA, Peak_Eapp12, Peak_FDA1, Peak_FAD1, Peak_FAD2, Eapp];
handles.Peak_Eapp_Conc_Info = [Peak_Dconc, Peak_Aconc, Peak_Conc, Peak_xA, Eapp];
% Sort the pixels according to cncentration
[Conc_Sorted, Ind] = sort(Conc,'ascend');
xA_Sorted          = xA(Ind);
% TEW_nD_Sorted      = TEW_nD(Ind);
if ~isfield(handles, 'Conc_minRange'), handles.Conc_minRange = 0; end;
if ~isfield(handles, 'Conc_maxRange'), handles.Conc_maxRange = max(Conc); end;
if ~isfield(handles, 'Conc_BinSize'), handles.Conc_BinSize = 10; end;

% 3D Histogram claculation
% if isfield(handles, 'SEW_Eapp')
%     if handles.SEW_Eapp
Eapp_Sorted     = Eapp;
TEW_Eapp_Sorted = TEW_Eapp;
%     else Eapp_Sorted = TEW_Eapp;
%     end
% end
Eapp_Sorted = Eapp_Sorted(Ind);
if ~isfield(handles, 'Capp_minRange'), handles.Capp_minRange = 0; end;
if ~isfield(handles, 'Capp_maxRange'), handles.Capp_maxRange = 1; end;
if ~isfield(handles, 'Capp_BinSize'), handles.Capp_BinSize = 0.01; end;

Conc_Sect        = Conc_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
xA_Sect          = xA_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Eapp_Sect        = Eapp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
TEW_Eapp_Sect    = TEW_Eapp_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
% TEW_nD_Sect      = TEW_nD_Sorted(Conc_Sorted > handles.Conc_minRange & Conc_Sorted <= handles.Conc_maxRange);
Conc_Sect        = Conc_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
xA_Sect          = xA_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
% TEW_nD_Sect      = TEW_nD_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
Eapp_Sect        = Eapp_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
TEW_Eapp_Sect    = TEW_Eapp_Sect(Eapp_Sect > handles.Capp_minRange & Eapp_Sect <= handles.Capp_maxRange);
Conc_Sect        = Conc_Sect(xA_Sect >= 0 & xA_Sect <= 1);
Eapp_Sect        = Eapp_Sect(xA_Sect >= 0 & xA_Sect <= 1);
TEW_Eapp_Sect    = TEW_Eapp_Sect(xA_Sect >= 0 & xA_Sect <= 1);
% TEW_nD_Sect      = TEW_nD_Sect(xA_Sect >= 0 & xA_Sect <= 1);
xA_Sect          = xA_Sect(xA_Sect >= 0 & xA_Sect <= 1);
handles.Eapp_Val = [handles.Capp_minRange:handles.Capp_BinSize:handles.Capp_maxRange]';
Stack_Conc_Bin   = double(handles.Conc_BinSize);
switch Plot_Type
    case 'Stack'
        if handles.Conc_BinSize*8 < handles.Conc_maxRange - handles.Conc_minRange
            if handles.Conc_maxRange > 80
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8,-1));
            elseif handles.Conc_maxRange > 8
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8));
            else
                Stack_Conc_Bin = double(round(double(handles.Conc_maxRange - handles.Conc_minRange)/8,1));
            end
        end;
    case 'Surf'
    case 'Image'
    case 'Scatter'
    otherwise
end;
handles.Conc_Val         = [handles.Conc_minRange:Stack_Conc_Bin:handles.Conc_maxRange + Stack_Conc_Bin]' - Stack_Conc_Bin/2;
handles.Eapp_Hist_2D     = zeros(length(handles.Eapp_Val),length(handles.Conc_Val)-1);
handles.TEW_Eapp_Hist_2D = zeros(length(handles.Eapp_Val),length(handles.Conc_Val)-1);
for jj = 1:length(handles.Conc_Val)-1
    Eapp_Conc_Sect             = Eapp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.Eapp_Hist_2D(:,jj) = hist(Eapp_Conc_Sect, handles.Eapp_Val)';
    TEW_Eapp_Conc_Sect         = TEW_Eapp_Sect(Conc_Sect > handles.Conc_Val(jj) & Conc_Sect <= handles.Conc_Val(jj+1));
    handles.TEW_Eapp_Hist_2D(:,jj) = hist(TEW_Eapp_Conc_Sect, handles.Eapp_Val)';
end;
handles.Scatter_Plot_Info = [Conc_Sect, xA_Sect, Eapp_Sect, TEW_Eapp_Sect];