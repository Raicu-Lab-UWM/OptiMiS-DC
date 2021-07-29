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
function Self = Calculate_Sample_Param(Self)

Self.Eapp    = [];
switch Self.Analysis_Method
    case 'Gaussian Fitting'
        for ii = 1:length(Self.Mu)
            Mu    = Self.Mu(ii);
            Mu    = round(Mu/Self.Hist_Bin)*Self.Hist_Bin;
            Index = find(Self.Bin_List >= Mu, 1);
            if ~isempty(Index), Self.Eapp(ii) = Self.Bin_List(Index); else Self.Eapp(ii) = 0; end;
        end
    case 'Peak Pecking'
        for ii = 1:size(Self.Histogram, 2)
            crrHistogram = Self.Histogram(:,ii);
            FRET_Tool_Kit_FigH = findobj('Tag', 'FRET_Tool_Kit_FigH');
            handles      = guidata(FRET_Tool_Kit_FigH);
            if Self.Bin_List(end) > 1, Self.Bin_List = Self.Bin_List/100; end;
            [Eapp_Peak_Ind, ~, ~, ~] = Choosing_Peaks_Fcn ([Self.Bin_List, crrHistogram], 'TH with STD', handles.FRET_nGaussians, 0);
            if ~isempty(Eapp_Peak_Ind), Self.Eapp(:,ii) = Eapp_Peak_Ind; else Self.Eapp(ii) = 0; end;
        end
    case 'Mode'
        for ii = 1:size(Self.Histogram, 2)
            if ~isempty(Self.Histogram)
                [Value, Index] = max(Self.Histogram(2:end,ii));
                if Value == 0
                    Self.Eapp(ii) = 0;
                else
                    Self.Eapp(ii) = Self.Bin_List(Index + 1);
                end;
            end;
        end;
    otherwise
end;
nEapp_Values = length(Self.Eapp(:));
if length(Self.TEW_Eapp) < nEapp_Values
    TEW_Eapp = zeros(size(Self.Eapp)); TEW_FD = zeros(size(Self.Eapp)); TEW_FA = zeros(size(Self.Eapp));
    TEW_Eapp(1,1:length(Self.TEW_Eapp)) = Self.TEW_Eapp; TEW_Eapp(1,length(Self.TEW_Eapp) + 1:end) = NaN;
    TEW_FD(1,1:length(Self.TEW_Eapp))   = Self.TEW_FD;   TEW_FD(1,length(Self.TEW_Eapp) + 1:end)   = NaN;
    TEW_FA(1,1:length(Self.TEW_Eapp))   = Self.TEW_FA;   TEW_FA(1,length(Self.TEW_Eapp) + 1:end)   = NaN;
    for ii = 2:size(TEW_Eapp,1)
        TEW_Eapp(ii,:) = TEW_Eapp(1,:);
        TEW_FD(ii,:)   = TEW_FD(1,:);
        TEW_FA(ii,:)   = TEW_FA(1,:);
    end
    Eapp_List(1,:) = Self.Eapp(:);
    Self.Eapp      = Eapp_List;
    Self.TEW_Eapp  = TEW_Eapp(:);
    Self.TEW_FD    = TEW_FD(:);
    Self.TEW_FA    = TEW_FA(:);
end;