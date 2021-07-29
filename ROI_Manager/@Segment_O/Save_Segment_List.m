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
function Save_Segment_List(Obj, Path, Name)

if nargin < 2, [Name, Path] = uiputfile('.\*.mroi', 'Save Polygon List'); 
elseif nargin < 3, [Name, Path] = uiputfile([Path '\*.mroi'], 'Save Polygon List');
% else [Name, Path] = uiputfile([Path '\' Name], 'Save Polygon List');
end;

Segment_List_Struct = Obj;
save([Path '\' Name], 'Segment_List_Struct', '-mat', '-v7.3');

fileID = [];
Name = [Name(1:end-5) '_Seg.txt'];
for ii = 1:length(Obj)
    fileID = Obj(ii).Save_SegList_toTextFile(Path, Name, fileID, ii);
    fprintf(fileID, '%s\n', '');
end;
fclose(fileID);