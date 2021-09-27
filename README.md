# OptiMiS-DC
Optical Micro-Spectroscopy Data Cruncher for the analysis of images resulting from the OptiMiS microscope
Update1 by Damar: Segmentation: a new option for segmentation 'Curved Guided Shift' is added in program with making following changes;
OptiMiS-DC/ROI-Mananger/@Segment_O/Add_segment_tolist.m: case for 'Curve Guided Shift' is added in line 68 to 70 similar to 'Curve Guided' case.
OptiMiS-DC/ROI-Mananger/@Segment_O/Segment_O.m: a line is added at line 51 for 'Curve Guided Shift' similar to for 'Curve Guided'.
OptiMiS-DC/ROI-Mananger/@Segment_O/Seg-Setting_Changed.m: two lines at line 38 and 39 are added for 'Curved Guided Shift' similar to 'Curved Guided'
OptiMiS-DC/ROI-Mananger/Segment_setting-Tab_Changed.m: seg method menu in line 37 is updated for 'Curved Guided Shift' method.

20210903_DB: the naming 'Curve Guided' and 'Curve Guided Shift' are changed to 'Contour Guided Single Sample' and 'Contour Guided Multiple Sample' respectively
in required files, Add_segment_tolist.m, Seg-Setting_Changed.m,Segment_setting-Tab_Changed.m.

20210906_DB: fitgauss3.m and Gaussian_Fun.m were uploaded to @Ficos_Tool_kit
20210927_DB: saveastiff_wLabels.m is uploaded to Unmix_Toolkit folder.

20210927_DB: UMD_Save_Icon_ClickedCallback.m, few lines are added from line 13 to 18 to avoid error on saving unmixed images.

