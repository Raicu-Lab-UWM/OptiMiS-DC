classdef FRET_Analysis_O
    properties
        Master_Polygon;
        Hist_Bin;
        Bin_List;
        Histogram;
        Fitting_Param;
        Analysis_Method;
        Mu;
        Sigma;
        Amplitude;
        Eapp;
        TEW_Eapp;
        TEW_FD;
        TEW_FA;
        TEW_FDA_L1;
        TEW_FAD_L1;
        TEW_FAD_L2;
    end
    methods (Static)
    end
    methods
        Found = Find_FRET_Item(Self, Polygon_Name)
        Self  = Calculate_Histogram(Self, Poly_Cords, Hist_Bin, Eapp_Map, FDA_WL1_Map, FAD_WL1_Map, FAD_WL2_Map, Bin_Range, eSpectra)
        [Self, hHist_Figure] = Calculate_Fit(Self, Plot_Fit, hHist_Figure)
        Self  = Calculate_Sample_Param(Self)
        Self  = Calculate_TEW_Info(Self, Poly_Cords, Hist_Bin, imKDA_L1, imKAD_L1, imKDA_L2, eSpaectra)
    end
end