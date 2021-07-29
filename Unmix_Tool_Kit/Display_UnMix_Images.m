function Display_UnMix_Images(Image_Stack, Main_FigureH)

handles        = guidata(Main_FigureH);
handles.iFrame = uint16(1);
handles.Single_Pixel_UM_On = 0;
guidata(Main_FigureH, handles);
% Creating the colorbar for the donor and accepor
Green  = zeros(256,3); Green(:,2) = 0:1/255:1;
Yellow = zeros(256,3); Yellow(:,1) = 0:1/255:1; Yellow(:,2) = 0:1/255:1;

% Creating the figure ploting the FDA and FAD images
Length = size(Image_Stack,3); % calculating the figure length according to the length of the FDA image
Height = size(Image_Stack,2); % calculating the figure height according to the FDa or FAD image height
UM_Image_Disp_FigureH = figure('Name', 'Unmixed Images', 'Tag', 'UM_Image_Disp_FigureH', 'Position', [500, 400, round(Length/0.467), round(Height/0.93)], ...
                               'NumberTitle','off', 'MenuBar', 'none', 'ToolBar', 'figure');

% removing un wanted toolbar icons
addToolbarExplorationButtons(UM_Image_Disp_FigureH)
Legend_Icon = findall(UM_Image_Disp_FigureH, 'ToolTipString', 'Insert Legend'); set(Legend_Icon, 'Visible', 'off');
Rotate_Icon = findall(UM_Image_Disp_FigureH, 'ToolTipString', 'Rotate 3D'); set(Rotate_Icon, 'Visible', 'off');
Open_Icon   = findall(UM_Image_Disp_FigureH, 'ToolTipString', 'Open File'); set(Open_Icon, 'Visible', 'off');
Print_Icon  = findall(UM_Image_Disp_FigureH, 'ToolTipString','Print Figure'); set(Print_Icon, 'Visible', 'off');

% coding the functions of needed toolbat icons
UM_Cursor_Icon   = datacursormode(UM_Image_Disp_FigureH);
% UM_Cursor_Icon.Enable = 'on';
% UM_Cursor_Icon.UpdateFcn = {@UM_Cursor_Icon_OnCallback, Main_FigureH};
UM_Cursor_Icon   = findall(UM_Image_Disp_FigureH, 'ToolTipString','Data Tips');     % single pixel unmixing graph
set(UM_Cursor_Icon, 'OnCallback', {@UM_Cursor_Icon_OnCallback, Main_FigureH}, 'OffCallback', {@UM_Cursor_Icon_OffCallback, Main_FigureH}, ...
    'ToolTipString', 'Single Pixel Unmixing','ClickedCallback', '');
UM_Contrast_Icon = findall(UM_Image_Disp_FigureH, 'ToolTipString','Insert Colorbar'); % COntrast dajusment button
set(UM_Contrast_Icon, 'ClickedCallback', {@UM_Contrast_Icon_ClickedCallback, Main_FigureH}, 'ToolTipString', 'Contrast Control');
UMD_Save_Icon    = findall(UM_Image_Disp_FigureH, 'ToolTipString','Save Figure');     % Saving unmixed image and also FRET images.
set(UMD_Save_Icon, 'ClickedCallback', {@UMD_Save_Icon_ClickedCallback, Main_FigureH}, 'ToolTipString', 'Lay The Eggs');

% generating the axeses displaying each image (FDA and FAD or KDA and KAD)
Donor_Display_Axes    = axes('Parent', UM_Image_Disp_FigureH, 'Tag', 'Donor_Display_Axes', 'Position', [0.03, 0.07, 0.467, 0.93]);
Acceptor_Display_Axes = axes('Parent', UM_Image_Disp_FigureH, 'Tag', 'Acceptor_Display_Axes', 'Position', [0.503, 0.07, 0.467, 0.93]);

Donor_Image           = mat2gray(squeeze(Image_Stack(1,:,:,1)));                                   % converting matrix image to an intensity image
Donor_ImageH          = imagesc(Donor_Image, 'Parent', Donor_Display_Axes, 'Tag', 'Donor_ImageH', 'HitTest', 'off'); % ploting the donor image in the axes
colormap(Donor_Display_Axes, Green);  set(Donor_Display_Axes, 'XTick', [], 'YTick', []);           % setting the colormap of the image to green scale and removing ticks
set(Donor_Display_Axes, 'ButtonDownFcn', {@Display_Axes_Callback, Main_FigureH}, 'HitTest', 'on');
Donor_Display_Axes.Toolbar.Visible = 'off';

Acceptor_Image        = mat2gray(squeeze(Image_Stack(2,:,:,1)));                                   % converting matrix image to an intensity image
Acceptor_ImageH       = imagesc(Acceptor_Image, 'Parent', Acceptor_Display_Axes, 'Tag', 'Acceptor_ImageH', 'HitTest', 'off'); % ploting the acceptor image in the second axes
colormap(Acceptor_Display_Axes, Yellow); set(Acceptor_Display_Axes, 'XTick', [], 'YTick', []);     % setting the colormap of the image to yellow scale and removing ticks
set(Acceptor_Display_Axes, 'ButtonDownFcn', {@Display_Axes_Callback, Main_FigureH}, 'HitTest', 'on');
Acceptor_Display_Axes.Toolbar.Visible = 'off';

% Adding the scroll bar to scroll between unmixed scenes
if size(Image_Stack,4) > 1
    UM_Stack_sBar         = uicontrol('Style', 'Slider', 'Parent', UM_Image_Disp_FigureH, 'Units', 'normalized', 'Position', [0 0 1 0.07], ...
                                      'Value', 1, 'Min', 1, 'Max', 6, 'Tag', 'UM_Stack_sBar', ...
                                      'SliderStep', [1/(6-1), 10/(6-1)], ...
                                      'Callback',{@UM_Stack_sBar_Callback, Main_FigureH});
end