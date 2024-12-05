Optimis_DC_version_2.0 
11/12/2022 @Raicu Lab

Create elementary Spectra
Spectral unmixing of fluorescence image
draw ROI and segmentation, multiple segmentation
construction of histogram, peak selection, calculation of donor and accepotor concentration save data in excel file
concentration is calculated in two ways: one taking  average value of all pixels in ROI another from median value of pixels associated with peak value
construction of metahistogram (by loading saved excel file in previous step), can choose concentration calculated from any calculation method
and optimization of bin origin of metahistograms.

Optimis_DC_version_2.1
11/15/2022 @Raicu Lab
Spectral integral calculation is corrected
in "Calculate_Tag.m" file

"Load_ES_pButton_Callback.m" file is edited.
Can read "channel_wavelength calibration.txt" file by loading it in Elementary spectra module "open folder icon"
to generate "background" or "bias.tag". (instead of loading xlsx file for bias.tag as in previous version)

"Peak_Pecking_new.m" is replaced with "Peak_Pecking_Group_v3.m"
changes are made on Find_Extrim_wSegmentation_Group_v3.m", 
segmentation was not occuring at correct places.

Optimis_DC_version_4.0
2023/04/28 @Raicu Lab
Spectral integral calculation is reverted to version 2.1 calculation in "Calculate_Tag.m" file.