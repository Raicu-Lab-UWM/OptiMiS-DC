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
function Self = Calculate_TEW_Info(Self, Poly_Cords, Hist_Bin, imFDA_L1, imFAD_L1, imFAD_L2)

% Self.Hist_Bin = Hist_Bin;
% 
% if nargin < 5, Self.Bin_List = [min(imFDA_L1(:)):Hist_Bin:max(imFDA_L1(:))]'; 
% elseif isempty(Bin_Range), Self.Bin_List = [min(imFDA_L1(:)):Hist_Bin:max(imFDA_L1(:))]';
% else Self.Bin_List = [Bin_Range(1):Hist_Bin:Bin_Range(2)]';
% end;
if iscell(Poly_Cords)
    Self.TEW_FDA_L1      = zeros(length(Poly_Cords), 1);
    Self.TEW_FAD_L1      = zeros(length(Poly_Cords), 1);
    Self.TEW_FAD_L2      = zeros(length(Poly_Cords), 1);
    for ii = 1:length(Poly_Cords)
        Segment_ROI       = Poly_Cords{ii};
        Mask              = poly2mask(Segment_ROI(:,1), Segment_ROI(:,2), size(imFDA_L1,1), size(imFDA_L1,2));
        
        imFDA_L1_Mask    = imFDA_L1(Mask == 1);
        imFAD_L1_Mask    = imFAD_L1(Mask == 1);
        imFAD_L2_Mask    = imFAD_L2(Mask == 1);
        
        imFDA_L1_nzero   = nonzeros(imFDA_L1_Mask);  % added bu DB 20220413
        imFAD_L1_nzero   = nonzeros(imFAD_L1_Mask);
        imFAD_L2_nzero   = nonzeros(imFAD_L2_Mask);
        
        if ~isempty(imFDA_L1_nzero)
            FDA_L1            = mean(imFDA_L1_nzero);
            FAD_L1            = mean(imFAD_L1_nzero);
            FAD_L2            = mean(imFAD_L2_nzero);
        else
            FDA_L1            = 0;
            FAD_L1            = 0;
            FAD_L2            = 0;
        end
%         FDA_L1            = mean(imFDA_L1(Mask == 1));
%         FAD_L1            = mean(imFAD_L1(Mask == 1));
%         FAD_L2            = mean(imFAD_L2(Mask == 1));
                                       % of the FRET equations resolves old puzzles and 
        Self.TEW_FDA_L1(ii,:) = FDA_L1;                                                          % Donor emission at excitation of wavelength 1
        Self.TEW_FAD_L1(ii,:) = FAD_L1;                                                          % Acceptor emission at excitation of wavelength 1
        Self.TEW_FAD_L2(ii,:) = FAD_L2;                                                         % Acceptor emission at excitation of wavelength 2
%         Self.TEW_Eapp(ii,1)   = (1 + (FDA_L1*(1-gA/gD)/(FAD_L1 - FAD_L2*gA))/rQuant_Yield)^(-1); % suggests measurement strategies" EQ. 53, 54 and 45'.
    end
else
    Mask          = poly2mask(Poly_Cords(:,1), Poly_Cords(:,2), size(imFDA_L1,1), size(imFDA_L1,2));
    imFDA_L1_Mask    = imFDA_L1(Mask == 1);
    imFAD_L1_Mask    = imFAD_L1(Mask == 1);
    imFAD_L2_Mask    = imFAD_L2(Mask == 1);

    imFDA_L1_nzero   = nonzeros(imFDA_L1_Mask);   % added bu DB 20220413
    imFAD_L1_nzero   = nonzeros(imFAD_L1_Mask);
    imFAD_L2_nzero   = nonzeros(imFAD_L2_Mask);

    if ~isempty(imFDA_L1_nzero)
        FDA_L1            = mean(imFDA_L1_nzero);
        FAD_L1            = mean(imFAD_L1_nzero);
        FAD_L2            = mean(imFAD_L2_nzero);
    else
        FDA_L1            = 0;
        FAD_L1            = 0;
        FAD_L2            = 0;
    end
%     FDA_L1        = mean(imFDA_L1(Mask == 1));
%     FAD_L1        = mean(imFAD_L1(Mask == 1));
%     FAD_L2        = mean(imFAD_L2(Mask == 1)); 
    Self.TEW_FDA_L1 = FDA_L1;                                                          % Donor emission at excitation of wavelength 1
    Self.TEW_FAD_L1 = FAD_L1;                                                          % Acceptor emission at excitation of wavelength 1
    Self.TEW_FAD_L2 = FAD_L2;
%     Self.TEW_Eapp   = (1 + (FDA_L1*(1-gA/gD)/(FAD_L1 - FAD_L2*gA))/rQuant_Yield)^(-1);    
end;