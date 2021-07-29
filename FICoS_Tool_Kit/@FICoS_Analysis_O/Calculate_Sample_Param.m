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

Self.Capp = [];
Self.Conc = [];
switch Self.Analysis_Method
    case 'Gaussian Fitting'
        for ii = 1:length(Self.Mu)
            Mu    = Self.Mu(ii);
            Mu    = round(Mu/Self.Hist_Bin)*Self.Hist_Bin;
            Index = find(Self.Bin_List >= Mu, 1);
            if ~isempty(Index), Self.Capp(ii) = Self.Bin_List(Index); else Self.Capp(ii) = 0; end
            FICoS_pixLevel = Self.FICoS_pixLevel{ii};
            if size(FICoS_pixLevel, 2) == 2, Self.Conc(ii) = mean(FICoS_pixLevel(:,2)); end
        end
    case 'Peak Pecking'
        for ii = 1:size(Self.Histogram, 2)
            crrHistogram        = Self.Histogram(:,ii);
            FICoS_Tool_Kit_FigH = findobj('Tag', 'FICoS_Tool_Kit_FigH');
            handles             = guidata(FICoS_Tool_Kit_FigH);
            if Self.Bin_List(end) > 1, Self.Bin_List = Self.Bin_List/100; end
            [Capp_Peak_Ind, ~, ~, ~] = Choosing_Peaks_Fcn ([Self.Bin_List, crrHistogram], 'TH with STD', handles.FICoS_nGaussians, 0);
            FICoS_pixLevel  = Self.FICoS_pixLevel{ii};
            if ~isempty(Capp_Peak_Ind)
                Self.Capp(:,ii) = Capp_Peak_Ind;
                if size(FICoS_pixLevel, 2) == 2, Self.Conc(:,ii) = ones(length(Capp_Peak_Ind),1)*mean(FICoS_pixLevel(:,2)); end
            else Self.Capp(ii) = 0;
                if size(FICoS_pixLevel, 2) == 2, Self.Conc(ii) = mean(FICoS_pixLevel(:,2)); end
            end
        end
    case 'Mode'
        if ~isempty(Self.Histogram)
            for ii = 1:size(Self.Histogram, 2)
                [Value, Index] = max(Self.Histogram(2:end,ii));
                if Value == 0, Self.Capp(ii) = 0;
                else Self.Capp(ii) = Self.Bin_List(Index + 1);
                end
                FICoS_pixLevel = Self.FICoS_pixLevel{ii};
                if size(FICoS_pixLevel, 2) == 2, Self.Conc(:,ii) = mean(FICoS_pixLevel(:,2)); end
            end
        end
    otherwise
end