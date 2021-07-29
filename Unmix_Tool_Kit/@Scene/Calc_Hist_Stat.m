function [Value_Hist, Value, Value_Statistics] = Calc_Hist_Stat(Value, Freq, Mask)

[Value_Hist, Value]  = hist(Freq(Mask == 1),Value);
Sum_Value_Hist       = sum(Value_Hist(2:end),2);
if Sum_Value_Hist == 0, Sum_Value_Hist = 1e-9; end;
if size(Value,1) > 1, Value = Value'; end;
if size(Value_Hist,1) > 1, Value_Hist = Value_Hist'; end;
Mean_Value_Hist      = sum(Value(2:end).*Value_Hist(2:end),2)/Sum_Value_Hist;
STD_Value_Hist       = sqrt(sum((Value(2:end)-Mean_Value_Hist).^2.*Value_Hist(2:end),2)/Sum_Value_Hist);
[~, Mode_Value_Hist] = max(Value_Hist(2:end));
Value_Statistics     = [Sum_Value_Hist, Mean_Value_Hist, STD_Value_Hist, Mode_Value_Hist];