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
function [Self, hHist_Figure] = Calculate_Fit(Self, Plot_Fit, hHist_Figure)

if nargin < 4, hHist_Figure = []; elseif ~isempty(hHist_Figure), close(hHist_Figure); end;

nGaussians = Self.Fitting_Param.nGaussians;
Range      = Self.Fitting_Param.Range;
Self.Fitting_Param.Initial_Guass_Mean = [];
Self.Fitting_Param.Initial_Guass_STD  = [];
Self.Mu                               = [];
Self.Sigma                            = [];
Self.Amplitude                        = [];

for ii = 1:size(Self.Histogram, 2)
    Histogram_ = [Self.Bin_List, Self.Histogram(:,ii)];
    switch Self.Fitting_Param.Fit_Method
    case 'Gaussian (Analytic)'
        [Mu, Sigma, Amp, ~, hHist_Figure] = Gauss_Fit(double(Histogram_(2:end,:)), Range, Plot_Fit);
        Mu_In    = [];
        Sigma_In = [];
    case 'Gaussian (Iterative)'
        [~, Max_Hist_Pos] = max(Histogram_(:,2));
        Mu_In             = Histogram_(Max_Hist_Pos,1);
        dx                = Histogram_(2,1)-Histogram_(1,1);
        Sigma_In          = abs(size(Histogram_,1)*dx/8);
        for jj = 2:nGaussians
            Mu_In    = [Mu_In, Histogram_(round(end/jj),1)];
            Sigma_In = [Sigma_In, Histogram_(round(end/8*2^(jj-1)),1)];
        end;
        [~, Amp, Mu, Sigma, ~, hHist_Figure] = MultiGauss_Fit(double(Histogram_(2:end,:)'), double(Mu_In), double(Sigma_In), Plot_Fit);
%         UpTH        = Mu + 3*Sigma;
%         High_Intens = find(Self.Bin_List > UpTH);
%         New_Hist    = Histogram_(1:High_Intens(1)-1,:);
%         Mu_In       = Mu;
%         Sigma_In    = Sigma;
%         if Sigma_In > 0
%             [~, Amp, Mu, Sigma, ~, hHist_Figure] = MultiGauss_Fit(double(New_Hist'), double(Mu_In), double(Sigma_In), Plot_Fit);
%         end;
    case 'Poisson (Analytic)'
    
    otherwise
    end;
    Self.Fitting_Param.Initial_Guass_Mean = [Self.Fitting_Param.Initial_Guass_Mean Mu_In];
    Self.Fitting_Param.Initial_Guass_STD = [Self.Fitting_Param.Initial_Guass_STD Sigma_In];
    Self.Mu(ii)        = Mu(1);
    Self.Sigma(ii)     = Sigma(1);
    Self.Amplitude(ii) = Amp(1)/Sigma(1)/sqrt(2*pi);
end;
 
pause(0.01);