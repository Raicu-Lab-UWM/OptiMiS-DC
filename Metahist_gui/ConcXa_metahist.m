function result = ConcXa_metahist(tot,Tlim,Xa,Xalim,pkposn)
result = [];
for ii = 1:size(pkposn,2)
    cpkposn = pkposn(:,ii);
    result  = [result;cpkposn(tot>=Tlim(1)& tot<Tlim(2)& Xa>=Xalim(1) & Xa<Xalim(2))];
end
%sortedEapp_pks = ConcXa_metahist(DpAconc,concRange,Xa,XaRange,Eapp_pks);
%metaHist       = histc(sortedEapp_pks,meta_bins);
% DpAconc  = Dconc+Aconc;
% Xa       = Aconc./DpAconc;
