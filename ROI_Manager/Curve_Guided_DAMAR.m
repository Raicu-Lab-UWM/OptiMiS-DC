%ROI membrane segmentation code originally written in imagej macro
%inputs are membrane width (offset), segment area (segpixels)
%@dnbadu: June 25, 2019 3:21pm

function Segments_Polygons = Curve_Guided_DAMAR(ROI, Offset, Seg_Type, Seg_Value)

if nargin <2, Offset=12; elseif isempty(Offset),Offset=16; end
if nargin <3, Seg_Type='area'; Seg_Value=500; elseif isempty(Seg_Type),Seg_Type='area'; Seg_Value=500; end
if nargin <4 && strcmp(Seg_Type,'area'), Seg_Value=500; elseif nargin <4 && strcmp(Seg_Type,'number segments'), Seg_Value=1; end

x(1,:)  = ROI(:,1);
y(1,:)  = ROI(:,2);
dist    = sqrt((x(2:end) - x(1:end-1)).^2 + (y(2:end) - y(1:end-1)).^2); dist(end+1) = sqrt((x(1) - x(end)).^2 + (y(1) - y(end)).^2);
xlnth   = x(2:end) - x(1:end-1); xlnth(end+1) = x(1) - x(end);
ylnth   = y(2:end) - y(1:end-1); ylnth(end+1) = y(1) - y(end);
normx   = ylnth./dist;
normy   = -xlnth./dist;
prodc   = xlnth(1:end-1).*(y(2:end)+y(1:end-1)); prodc(end+1) = xlnth(end)*(y(1)+y(end));
slope   = ylnth./xlnth;
slope(isinf(slope)) = 0;
yintcpt = y - slope.*x;

%sum of prodc will help to determine clockwise anticlokwise polygon
sumprodc = sum(prodc);

%membrane width=offset
Offset = sign(sumprodc)*Offset;

%in1 are 1st end of offset side
xin1 = x + Offset.*normx;
yin1 = y + Offset.*normy;
xin2 = x(2:end) + Offset*normx(1:end-1); xin2(end+1) = x(1) + Offset*normx(end);
yin2 = y(2:end) + Offset*normy(1:end-1); yin2(end+1) = y(1) + Offset*normy(end);
a    = yin2 - yin1;
b    = xin1 - xin2;
c    = xin2.*yin1 - yin2.*xin1;
det  = a(1:end-1).*b(2:end) - a(2:end).*b(1:end-1); det(end+1) = a(end)*b(1) - a(1)*b(end);

% to find point of intersection of offset sides: det=a1b2-a2b1
xoff = (b(1:end-1).*c(2:end)-b(2:end).*c(1:end-1))./det(1:end-1); xoff(end+1) = (b(end).*c(1)-b(1).*c(end))./det(end);
xoff(det == 0) = xin2(det == 0);
yoff = (c(1:end-1).*a(2:end)-c(2:end).*a(1:end-1))./det(1:end-1); yoff(end+1) = (c(end).*a(1)-c(1).*a(end))./det(end);
yoff(det == 0) = yin2(det == 0);

%make order of vertex match with original polygon
xof  = circshift(xoff, [0, 1]);
yof  = circshift(yoff, [0, 1]);

%yintercept, xlength, ylength of sides of offset polygon
yintof = yof - slope.*xof;
xlnof  = xof(2:end) - xof(1:end-1); xlnof(end+1) = xof(1) - xof(end);
ylnof  = yof(2:end) - yof(1:end-1); ylnof(end+1) = yof(1) - yof(end);

A      = polyarea(x,y);
Aof    = polyarea(xof,yof);
pixels = A-Aof;

%gives whole membrane
if strcmp(Seg_Type, 'area')
    segpixels = Seg_Value;
    nsegment  = round(pixels/segpixels); %segmentation based on area (can input specific number)
elseif strcmp(Seg_Type, 'number segments')
    nsegment = Seg_Value;
end

maxdist = max(dist);
sf      = round(dist*10/maxdist); %scale factor to nsteps (to make stepsize same for all sides)
nsteps  = sf*nsegment; %steps to intrapolate points in polygon side

% cumulative addintion of nsteps
nstepcf = cumsum(nsteps);

%x1 and y1 are intrapolation in sides of original polygon (new points)
x1     = [];
y1     = [];
deltax = abs(xlnth./nsteps);
deltay = abs(ylnth./nsteps);
x2     = [];
y2     = [];
delxof = abs(xlnof./nsteps);
delyof = abs(ylnof./nsteps);
for m = 1:length(x)
    xs      = []; ys = [];
    xf      = []; yf = [];
    xs(1,:) = x(m)*ones(nsteps(m), 1);
    ys(1,:) = y(m)*ones(nsteps(m), 1);
    xf(1,:) = xof(m)*ones(nsteps(m), 1);
    yf(1,:) = yof(m)*ones(nsteps(m), 1);
    if m<length(x)
        xs        = [0:nsteps(m)-1]*sign(x(m+1)-x(m))*deltax(m) + xs;
        eqX_Ys    = [0:nsteps(m)-1]*sign(y(m+1)-y(m))*deltay(m) + ys;
        ys(2:end) = double(x(m) == x(m+1))*eqX_Ys(1:end-1) + double(x(m) ~= x(m+1))*(slope(m)*xs(2:end) + yintcpt(m));
        xf        = [0:nsteps(m)-1]*sign(x(m+1)-x(m))*delxof(m) + xf;
        eqX_Yf    = [0:nsteps(m)-1]*sign(x(m+1)-y(m))*delyof(m) + yf;
        yf(2:end) = double(x(m) == x(m+1))*(eqX_Yf(1:end-1)) + double(x(m) ~= x(m+1))*(slope(m)*xf(2:end) + yintof(m));
    else
        xs        = [0:nsteps(m)-1]*sign(x(1)-x(m))*deltax(m) + xs;
        eqX_Ys    = [0:nsteps(m)-1]*sign(y(1)-y(m))*deltay(m) + ys;
        ys(2:end) = double(x(m) == x(1))*eqX_Ys(1:end-1) + double(x(m) ~= x(1))*(slope(m)*xs(2:end) + yintcpt(m));
        xf        = [0:nsteps(m)-1]*sign(x(1)-x(m))*delxof(m) + xf;
        eqX_Yf    = [0:nsteps(m)-1]*sign(x(1)-y(m))*delyof(m) + yf;
        yf(2:end) = double(x(m) == x(1))*(eqX_Yf(1:end-1)) + double(x(m) ~= x(1))*(slope(m)*xf(2:end) + yintof(m));
    end
    x1 = [x1, xs];
    y1 = [y1, ys];
    x2 = [x2, xf];
    y2 = [y2, yf];
end

% make matrix of segment coordinates (segmatx and segmaty)
segpoints = round(length(x1)/nsegment); %divide total newpoints eqully to all segments
matX1     = reshape(x1, segpoints, nsegment);
matY1     = reshape(y1, segpoints, nsegment);
matX2     = reshape(x2, segpoints, nsegment); matX2 = flipud(matX2);
matY2     = reshape(y2, segpoints, nsegment); matY2 = flipud(matY2);
endX1     = circshift(matX1(1,:),[0,-1]);
endY1     = circshift(matY1(1,:),[0,-1]);
endX2     = circshift(matX2(end,:),[0,-1]);
endY2     = circshift(matY2(end,:),[0,-1]);
endX3     = matX1(1,:);
endY3     = matY1(1,:);
segmatx   = [matX1',endX1',endX2',matX2', endX3']';
segmaty  = [matY1',endY1',endY2',matY2', endY3']';

segments(:,:,1)=segmatx;
segments(:,:,2)=segmaty;
Segments_Polygons = mat2cell(segments, size(segments,1), ones(size(segments,2),1), 2);