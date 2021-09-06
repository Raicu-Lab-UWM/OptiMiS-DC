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
function g = Gaussian_Fun(x,Mean,Std)
%  gaussian(x,pos,wid) = gaussian peak centered on pos, half-width=wid
%  x may be scalar, vector, or matrix, pos and wid both scalar
% Example: gaussian([1 2 3],1,2) gives result [0.5000    1.0000    0.5000]
g = 1/Std/sqrt(2*pi)*exp(-((x-Mean)./(sqrt(2).*Std)) .^2);