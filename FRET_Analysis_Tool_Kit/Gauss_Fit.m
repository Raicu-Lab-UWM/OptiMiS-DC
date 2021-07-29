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
function [Sigma, Mu, Amp, Data_Out, hHist_Figure] = Gauss_Fit(Data, Range, Plot_Fit)

% y = 1/(s·(2p)^0.5) · exp( -½ ( (x-m)/s )² )
% ln y = ln( 1/(s·(2p)^0.5) ) - ½ ( (x-m)/s )²
%      = Px² + Qx + R         
% 
% where the substitutions
% 
% P = -1/(2s²)
% Q = +2m/(2s²)    
% R = ln( 1/(s·(2p)^2) ) - ½(m/s)²
% 
% have been made. Now, solve for the linear system Ax=b with (these are Matlab statements):

% design matrix for least squares fit
[~, Low_Limit]  = min(abs(uint16(Data(:,1))-Range(1)));
[~, High_Limit] = min(abs(uint16(Data(:,1))-Range(2)));
xData = Data(Low_Limit:High_Limit,1);
yData = Data(Low_Limit:High_Limit,2);
A     = [xData.^2,  xData,  ones(size(xData))]; 

% log of your data 
b          = log(yData);
Min_Val    = min(b(b~=-inf));
b(b==-inf) = Min_Val;
% least-squares solution for x
Gauss_Param = A\b;                    

% The vector x you found this way will equal
% 
% x == [P Q R]
% 
% which you then have to reverse-engineer to find the mean ? and the standard-deviation ?:

Mu        = -Gauss_Param(2)/Gauss_Param(1)/2;
Sigma     = sqrt( -1/2/Gauss_Param(1) );
Amp       = exp(Gauss_Param(3)+0.5*(Mu/Sigma)^2);
Fit       = Amp*exp(-(xData-Mu).^2/2/Sigma^2);
Data_Out  = [xData, Fit];

if Plot_Fit
    Peaks(:,1)  = Fit;
    Peaks(:,2)  = yData;
    hHist_Figure = figure; plot(xData,Peaks(:,1), 'r-',xData,Peaks(:,2), 'bo', 'MarkerSize',4);
    legend(char({'Fit','Data'}),'Location','NorthEast');
end;