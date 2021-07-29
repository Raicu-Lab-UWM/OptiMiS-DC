function Obj = Load_Dat_Images(Obj, Path, First, Last, varargin)
            
if nargin > 4, Hor_Shift = varargin{1}; else Hor_Shift = 0; end;
            
nChannels          = Last - First + 1;
Name               = strcat(Path, '\', num2str(First), '.dat');
currImage          = dlmread(Name);
[xx,yy]            = size(currImage);
Image_Stack        = zeros(xx,yy,nChannels);
Image_Stack(:,:,1) = currImage;
        
h                  = waitbar(0,'Loading the images. Please Wait.');    
for ii = First+1:Last
    currChannel_No              = num2str(ii);
    Name                        = strcat(Path,'\',currChannel_No,'.dat');
    currImage                   = dlmread(Name);
    if Hor_Shift ~= 0
        Image_Stack(:,:,ii-First+1) = circshift(currImage,[0,-round((ii-First)*200/nChannels/Hor_Shift)]);
    else
        Image_Stack(:,:,ii-First+1) = currImage;
    end;
                                
    waitbar((ii-First+1) / nChannels);
end
close(h);
Image_Stack         = Image_Stack(:,:,Obj.wlOrder);
Obj.Bias            = min(Image_Stack(:))*0.95;
Obj.currImage_Stack = Image_Stack - Obj.Bias;       