function [Image_Stack, Bias] = Load_Tiff_Image(Name, Path, wlOrder, Hor_Shift, Show_wBar, Remove_HotPixels)

if nargin < 6, Remove_HotPixels = 1; end;
if nargin < 5, Show_wBar = 1; end;
if nargin < 4, Hor_Shift = 0; end;

Info_Structure  = imfinfo([Path '\' Name]);
Depth           = length(Info_Structure);
TifLink         = Tiff([Path '\' Name], 'r+');
xSize           = Info_Structure.Width;
ySize           = Info_Structure.Height;
Image_Stack     = zeros(ySize,xSize,Depth, 'single');
        
if Depth > 1
    if Show_wBar, h = waitbar(0,'Loading the images. Please Wait.'); end
    for ii = 1:Depth
        TifLink.setDirectory(ii);
        if Hor_Shift ~= 0
%             Image_Stack(:,:,ii) = floatingCircShift(TifLink.read(),[0,-(ii-1)*Hor_Shift]);
            Image_Stack(:,:,ii) = circshift(TifLink.read(),[0,-round((ii-1)*Hor_Shift)]);
            %CheckImage = Image_Stack(:,:,ii);  %a check for TK
        else
            Image_Stack(:,:,ii) = TifLink.read();
            %CheckImage = Image_Stack(:,:,1);   %a check for TK
        end;
        %CheckImage = Image_Stack(:,:,1);       %a check for TK
        if Show_wBar, waitbar(ii/Depth); end
    end;
    if Show_wBar, close(h); end
    
    if nargin < 3
        wlOrder = 1:Depth;
    elseif isempty(wlOrder)
        wlOrder = 1:Depth;
    end;
    Image_Stack = Image_Stack(:,:,wlOrder);
elseif Depth == 1
    TifLink.setDirectory(1);
    Image_Stack(:,:) = TifLink.read();
end;
TifLink.close();
%Bias        = min(Image_Stack(:))*0.95; % Commented out by TK 20240503
Bias = 0;   % Added by TK 20240503
Image_Stack = Image_Stack - Bias;
if Remove_HotPixels
    TH        = 8;
    Image_Stack = Remove_HotPixels_Fcn(Image_Stack, TH);
end;