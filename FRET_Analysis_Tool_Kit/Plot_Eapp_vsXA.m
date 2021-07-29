function Plot_Eapp_vsXA(hObject)
handles  = guidata(hObject);
xA_Bin   = handles.xA_Bin;

E        = handles.Scatter_Plot_Info(:,4);
xA       = handles.Scatter_Plot_Info(:,2);

meanxA   = zeros(round(1/xA_Bin),1);
meanEapp = zeros(round(1/xA_Bin),1);
stdxA    = zeros(round(1/xA_Bin),1);
stdEapp  = zeros(round(1/xA_Bin),1);
for xA_Range = xA_Bin:xA_Bin:1
    currE_Range  = E(xA>(xA_Range-xA_Bin) & xA<=xA_Range);
    currxA_Range = xA(xA>(xA_Range-xA_Bin) & xA<=xA_Range);
    meanEapp(round(xA_Range/xA_Bin),1) = mean(currE_Range);
    stdEapp(round(xA_Range/xA_Bin),1)  = std(currE_Range);
    meanxA(round(xA_Range/xA_Bin),1)   = mean(currxA_Range);
    stdxA(round(xA_Range/xA_Bin),1)    = std(currxA_Range);
end
handles.Eapp_vsXA_Info = [meanxA, meanEapp, stdxA, stdEapp]; guidata(hObject, handles);
% figure;plot(meanxA,meanEapp);