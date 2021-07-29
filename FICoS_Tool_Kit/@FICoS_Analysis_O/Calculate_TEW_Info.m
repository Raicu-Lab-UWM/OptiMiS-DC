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
function Self = Calculate_TEW_Info(Self, Poly_Cords, Hist_Bin, imFDA_L1, imFAD_L1, imFAD_L2, eSpectra)

% Self.Hist_Bin = Hist_Bin;
% 
% if nargin < 5, Self.Bin_List = [min(imFDA_L1(:)):Hist_Bin:max(imFDA_L1(:))]'; 
% elseif isempty(Bin_Range), Self.Bin_List = [min(imFDA_L1(:)):Hist_Bin:max(imFDA_L1(:))]';
% else Self.Bin_List = [Bin_Range(1):Hist_Bin:Bin_Range(2)]';
% end;

rQuant_Yield = eSpectra(1).Quantum_Yield/eSpectra(2).Quantum_Yield;
gD           = eSpectra(1).rIntensity; if ischar(gD), gD = str2double(gD); end;
gA           = eSpectra(2).rIntensity; if ischar(gA), gA = str2double(gA); end;
if iscell(Poly_Cords)
    for ii = 1:length(Poly_Cords)
        Segment_ROI       = Poly_Cords{ii};
        Mask              = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(imFDA_L1,1), size(imFDA_L1,2));
        FDA_L1            = mean(imFDA_L1(Mask == 1));
        FAD_L1            = mean(imFAD_L1(Mask == 1));
        FAD_L2            = mean(imFAD_L2(Mask == 1));
%         Self.TEW_FD(ii)   = FDA_L1 + rQuant_Yield*FAD_L1 - rQuant_Yield*gA*((FAD_L2 - FAD_L1/gD)/(1 - gA/gD));
%         Self.TEW_FA(ii)   = (FAD_L2 - FAD_L1/gD)/(1-gA/gD);
%         Self.TEW_Capp(ii) = 1-FDA_L1/Self.TEW_FD(ii);
        Self.TEW_FD(ii)   = FDA_L1 + rQuant_Yield*FAD_L1;                                    % from Prof. Raicu's paper titled "Ab initio derivation
        Self.TEW_FA(ii)   = (FAD_L2 - FAD_L1/gD);                                            % of the FICoS equations resolves old puzzles and 
        Self.TEW_Capp(ii) = (1 + (FDA_L1*(1-gA/gD)/(FAD_L1 - FAD_L2*gA))/rQuant_Yield)^(-1); % suggests measurement strategies" EQ. 53, 54 and 45'.
    end
else
    Mask          = poly2mask(Poly_Cords(:,1), Poly_Cords(:,2), size(imFDA_L1,1), size(imFDA_L1,2));
    FDA_L1        = mean(imFDA_L1(Mask == 1));
    FAD_L1        = mean(imFAD_L1(Mask == 1));
    FAD_L2        = mean(imFAD_L2(Mask == 1));
%     Self.TEW_FD   = FDA_L1 + rQuant_Yield*FAD_L1 - rQuant_Yield/gA*((FAD_L2 - gD*FAD_L1)/(1 - gD/gA));
%     Self.TEW_Capp = 1-FDA_L1/Self.TEW_FD;
%     Self.TEW_FA   = (FAD_L2 - gD*FAD_L1)/(1-gD/gA);
    Self.TEW_FD   = FDA_L1 + rQuant_Yield*FAD_L1;
    Self.TEW_FA   = (FAD_L2 - FAD_L1/gD);
    Self.TEW_Capp = (1 + (FDA_L1*(1-gA/gD)/(FAD_L1 - FAD_L2*gA))/rQuant_Yield)^(-1);    
end;