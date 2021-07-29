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
function [Model, Amp, Mean_Out, STD_Out, Height, hHist_Figure] = MultiGauss_Fit(Data, Mean_In, STD_In, Plot_Fit)

global c

x         = Data(1,:);
y         = Data(2,:);

% Perform an iterative fit using the FMINSEARCH function
options   = optimset('TolFun',0.00001,'MaxFunEvals',1e10); % Determines how close the model must fit the data

Parameter = fminsearch(@(Variables)(fitgauss3(Variables,x,y)),[Mean_In,STD_In],options);

% Compute a model and plot it (blue line) along with 
% the original data (red points)
Mean_Out  = Parameter(1:length(Mean_In));
STD_Out   = Parameter(length(Mean_In)+1:2*length(Mean_In));
% STD_Out(Mean_Out<0)  = [];
% Mean_Out(Mean_Out<0) = [];
Amp       = c;

Height    = zeros(length(Mean_Out),1);
Peaks     = zeros(length(x),length(Mean_Out));
for ii = 1:length(Mean_Out)
    Peaks(:,ii) = c(ii).*Gaussian_Fun(x,Mean_Out(ii),STD_Out(ii));
    Height(ii)  = max(Peaks(:,ii));
end;

Model     = sum(Peaks,2)';

% Model     = Peaks(:,1) + max(Peaks(:,2));

% [~, Max_Pos] = max(Peaks(:,ii));
% Height_2     = Peaks(Max_Pos,2)/2;
% Amp_1p2      = Amp(1) + Height_2*STD_Out(2)*sqrt(2*pi);
% Model        = Amp(1)*Gaussian_Fun(x,Mean_Out(1),STD_Out(1));

if Plot_Fit
    if length(Mean_In) == 1
        Peaks(:,2) = y;
        hHist_Figure = figure; plot(x, Peaks(:,1), 'r-', x, Peaks(:,2), 'bo', 'MarkerSize', 4);
        legend(char({'Fit','Data'}),'Location','NorthEast');
    else
        Peaks(:,length(Mean_In)+1) = Model;
        Peaks(:,length(Mean_In)+2) = y;
        hHist_Figure = figure; plot(x, Peaks); 
        Legend_Text = {};
        for ii = 1:length(Mean_In)
            Base        = ['Gauss No.' num2str(ii)];
            Legend_Text = [Legend_Text, Base];
        end;
        legend(char([Legend_Text,'Fit','Data']),'Location','NorthEast');
    end;
else 
    hHist_Figure = [];
end;

