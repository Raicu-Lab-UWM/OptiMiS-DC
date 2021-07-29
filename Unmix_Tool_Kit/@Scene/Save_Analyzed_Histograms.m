function [fName, Sheet_Name, Xc, Yc] = Save_Analyzed_Histograms(Eapp_Hist, FDonly_Hist, Polygon_Cord, Rows_Names_Eapp, Histogram_BinRes, Path, Name, Name_Tag, Statistics, Loop_Index, Polygon_Lable)

Xc = num2str(round(mean(Polygon_Cord(:,1))));
Yc = num2str(round(mean(Polygon_Cord(:,2))));

Rows_Names_FDonly = {'FDonly', 'THLD-0'};
               
fName      = [Name '_Histograms.xls'];
Sheet_Name = [Name_Tag ' at x' Xc 'y' Yc '-' Polygon_Lable];
Histogram_Data_Excel                = {};
Histogram_Data_Excel(1,2:Loop_Index+2)            = Rows_Names_Eapp;
Histogram_Data_Excel(1,Loop_Index+3:Loop_Index+4) = Rows_Names_FDonly;
Histogram_Data_Excel_Val            = num2cell([Eapp_Hist, FDonly_Hist]);
END                                 = size(FDonly_Hist,1)-1;
Histogram_Data_Excel(2:END/Histogram_BinRes+2,2:Loop_Index+4) = Histogram_Data_Excel_Val;
Histogram_Data_Excel(END/Histogram_BinRes+3:END/Histogram_BinRes+6,1) = {'Total', 'Average', 'STD', 'Mode'};
Histogram_Data_Excel(END/Histogram_BinRes+3:END/Histogram_BinRes+6,[3:Loop_Index+2,Loop_Index+4]) = num2cell(Statistics');
[Status, Message]                   = xlswrite([Path '\' fName],Histogram_Data_Excel, Sheet_Name, 'B3');
Success                             = Status;
Trial                               = 1;
while ~Success && Trial <=3
    h                 = msgbox(Message.message,'Saving Issues');
    waitfor(h);
    [Status, Message] = xlswrite([Path '\' fName],Histogram_Data_Excel, Sheet_Name, 'B3');
    Success           = Status;
    Trial             = Trial + 1;
end;