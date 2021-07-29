function [Em_Peak_Image, iPeakWL] = Find_Peak_Image (Spect_Images, First, Last)

if nargin < 3, Last = size(Spect_Images,3); elseif isempty(Last), Last = size(Spect_Images,3); end;
if nargin < 2, First = 1; elseif isempty(First), First = 1; end;

MaxMean = 0;
Show_Wait_Bar = waitbar(0,'Loading the images. Please Wait.');
for ii = First : Last 
    Image = Spect_Images(:,:,ii-First+1);
    Mean  = mean2(Image);
    if MaxMean < Mean
        MaxMean       = Mean;
        iPeakWL       = ii;
        Em_Peak_Image = Image;
    end;
    waitbar((ii-First+1) / (Last-First+1), Show_Wait_Bar);
end
close(Show_Wait_Bar);