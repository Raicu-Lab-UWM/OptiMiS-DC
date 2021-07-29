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
function Obj = Load_Poly_fromXLS(Obj, Path, Name, Polygon_Prop, PolyXLS_Param)

if nargin < 4
    Circle_Mode       = 'Polygon';
    Polygon_Type      = 'Patch';
    Images_Related    = [];
    Image_Drawn       = [];
    Image_Frame_Index = 1;
else
    Circle_Mode       = Polygon_Prop.Circle_Mode;
    Polygon_Type      = Polygon_Prop.Polygon_Type;
    Images_Related    = Polygon_Prop.Images_Related;
    Image_Drawn       = Polygon_Prop.Image_Drawn;
    Image_Frame_Index = Polygon_Prop.Image_Frame_Index;
end;

if nargin < 5
    Sheet_Name   = 'All_Sheets';
    Start_Cell   = 'B5';
else
    Sheet_Name   = PolyXLS_Param.Sheet_Name;
    Start_Cell   = PolyXLS_Param.Start_Cell;
end

Excel           = actxserver('Excel.Application');

if strcmp(Sheet_Name,'All_Sheets')
    set(Excel, 'Visible', 1);
    Workbooks       = Excel.Workbooks;
    exlFile         = Workbooks.Open([Path '\' Name]);
    eSheets         = exlFile.Sheets;
    for ii = 1:eSheets.Count
        curr_eSheet = eSheets.get('Item', ii);
        Sheet_Name  = curr_eSheet.Name;
        if ~isempty(strfind(Sheet_Name, 'Poly'))
            curr_eSheet.Activate;
            rowEnd    = curr_eSheet.Range(Start_Cell).End('xlDown').Row;
            colEnd    = curr_eSheet.Range(Start_Cell).End('xlToRight').Column;
            rowStr    = curr_eSheet.Range(Start_Cell).Row;
            colEndSTR = Num2ASCII(colEnd);
            Cell_Val  = curr_eSheet.Range([colEndSTR num2str(rowStr)]).value;
            while ~isnan(Cell_Val);
                Poly_colStr_STR = Num2ASCII(colEnd-1);
                xlRange      = [Poly_colStr_STR num2str(rowStr) ':' colEndSTR num2str(rowEnd)];
                Range        = get(curr_eSheet,'Range',xlRange);
                Polygon      = Range.value;
                Poly_Coords  = cell2mat(Polygon);
                Polygon_Prop = struct('Circle_Mode', Circle_Mode, 'Polygon_Type', Polygon_Type, 'Images_Related', Images_Related, 'Image_Drawn', Image_Drawn,...
                                      'Image_Frame_Index', Image_Frame_Index);
                Obj          = Obj.Add_Polygon_toList(Poly_Coords, Polygon_Prop);
                
                Next_colSTR  = Num2ASCII(colEnd+2);
                rowEnd       = curr_eSheet.Range([Next_colSTR num2str(rowStr)]).End('xlDown').Row;
                colEnd       = curr_eSheet.Range([Next_colSTR num2str(rowStr)]).End('xlToRight').Column;
                colEndSTR    = Num2ASCII(colEnd);
                Cell_Val     = curr_eSheet.Range([colEndSTR num2str(rowStr)]).value;
            end;
        end;
    end;
    % Save the workbook
    exlFile.Save();
    % Close the workbook.
    exlFile.Close(false);
else
    [Polygons, ~, ~] = xlsread([Path '\' Name], Sheet_Name);
    nPolygons = round((size(Polygons,2)+1)/3);
    for ii = 1:nPolygons
        Poly_Coords      = Polygons(:,(ii-1)*3+1:(ii-1)*3+2);
        if ~isempty(find(isnan(Poly_Coords),1))
            Poly_Coords(isnan(Poly_Coords)) = [];
            Poly_Coords  = reshape(Poly_Coords,length(Poly_Coords)/2,2);
            Polygon_Prop = struct('Circle_Mode', Circle_Mode, 'Polygon_Type', Polygon_Type, 'Images_Related', Images_Related, 'Image_Drawn', Image_Drawn,...
                          'Image_Frame_Index', Image_Frame_Index);
            Obj          = Obj.Add_Polygon_toList(Poly_Coords, Polygon_Prop);
        end;
    end;
end;
% Shut down Excel.
Excel.Quit;