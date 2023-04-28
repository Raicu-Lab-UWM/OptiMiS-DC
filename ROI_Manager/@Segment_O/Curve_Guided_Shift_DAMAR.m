%ROI membrane segmentation code originally written in imagej macro
%inputs are membrane width (offset), segment area (segpixels)
%@dnbadu: June 25, 2019 3:21pm

% modified Curve_Guided_DAMAR.m such that starting point of polygon roi
%is shifted to qurartile position and resegmented for each shift (0,q1,q2,q3)
% and total segments added by three times.
%@dnbadu: Aug 22, 2021 1:54am; 

function Self = Curve_Guided_Shift_DAMAR(Self, ROI, Image_, Offset)

Seg_Type  = Self.Segment_Type;
Seg_Value = Self.Segment_Param_Value;

if nargin <2, Offset=12; elseif isempty(Offset),Offset=16; end
if nargin <3, Seg_Type='area'; Seg_Value=500; elseif isempty(Seg_Type),Seg_Type='area'; Seg_Value=500; end
if nargin <4 && strcmp(Seg_Type,'area'), Seg_Value=500; elseif nargin <4 && strcmp(Seg_Type,'number segments'), Seg_Value=1; end

x(1,:)  = ROI(:,1); if x(1) == x(end), x(end) = []; end
y(1,:)  = ROI(:,2); if y(1) == y(end), y(end) = []; end

dist    = sqrt((x(2:end) - x(1:end-1)).^2 + (y(2:end) - y(1:end-1)).^2); dist(end+1)  = sqrt((x(1) - x(end)).^2 + (y(1) - y(end)).^2);
xlnth   = x(2:end) - x(1:end-1);                                         xlnth(end+1) = x(1) - x(end);
ylnth   = y(2:end) - y(1:end-1);                                         ylnth(end+1) = y(1) - y(end);
normx   = ylnth./dist;                                                   normy        = -xlnth./dist;
prodc   = xlnth(1:end-1).*(y(2:end)+y(1:end-1));                         prodc(end+1) = xlnth(end)*(y(1)+y(end));
slope   = ylnth./xlnth;                                                  slope(isinf(slope)) = 0;
yintcpt = y - slope.*x;

%sum of prodc will help to determine clockwise anticlokwise polygon
sumprodc = sum(prodc);

%membrane width=offset
Offset  = sign(sumprodc)*Offset;

%in1 are 1st end of offset side
xin1 = x + Offset.*normx;                           yin1 = y + Offset.*normy;
xin2 = x(2:end) + Offset*normx(1:end-1);            xin2(end+1) = x(1) + Offset*normx(end);
yin2 = y(2:end) + Offset*normy(1:end-1);            yin2(end+1) = y(1) + Offset*normy(end);
a    = yin2 - yin1;                                 b    = xin1 - xin2;                     c    = xin2.*yin1 - yin2.*xin1;
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
if strcmp(Seg_Type, 'Area')
    segpixels = Seg_Value(1);
    nsegment  = round(pixels/segpixels); %segmentation based on area (can input specific number)
elseif strcmp(Seg_Type, 'Number of Segments')
    nsegment = Seg_Value(1);
end

maxdist = max(dist);
sf      = round(dist*10/maxdist); %scale factor to nsteps (to make stepsize same for all sides)
nsteps  = sf*nsegment; %steps to intrapolate points in polygon side
nsteps(nsteps == 0) = 1;

%x1 and y1 are intrapolation in sides of original polygon (new points)
x1     = [];
y1     = [];
deltax = abs(xlnth./nsteps);
deltay = abs(ylnth./nsteps);
x2     = [];
y2     = [];
delxof = abs(xlnof./nsteps);
delyof = abs(ylnof./nsteps);
for m = 1:length(x)-1
    vSteps    = [0:nsteps(m)-1];
    sameX     = double(x(m) == x(m+1));
    xs(1,:)   = x(m)*ones(nsteps(m), 1);     ys(1,:) = y(m)*ones(nsteps(m), 1);
    xf(1,:)   = xof(m)*ones(nsteps(m), 1);   yf(1,:) = yof(m)*ones(nsteps(m), 1);
    signX     = sign(x(m+1)-x(m));           signY   = sign(y(m+1)-y(m));
    xs        = vSteps*signX*deltax(m) + xs; ys      = vSteps*signY*deltay(m) + ys;
    ys(2:end) = sameX*ys(1:end-1) + (1-sameX)*(slope(m)*xs(2:end) + yintcpt(m));
    xf        = vSteps*signX*delxof(m) + xf; yf      = vSteps*signY*delyof(m) + yf;
    yf(2:end) = sameX*yf(1:end-1) + (1-sameX)*(slope(m)*xf(2:end) + yintof(m));
    x1        = [x1, xs]; xs = []; y1 = [y1, ys]; ys = [];
    x2        = [x2, xf]; xf = []; y2 = [y2, yf]; yf = [];
end
vSteps    = [0:nsteps(end)-1];
sameX     = double(x(end) == x(1));
xs(1,:)   = x(end)*ones(nsteps(end), 1);   ys(1,:) = y(end)*ones(nsteps(end), 1);
xf(1,:)   = xof(end)*ones(nsteps(end), 1); yf(1,:) = yof(end)*ones(nsteps(end), 1);
signX     = sign(x(1)-x(end));             signY   = sign(y(1)-y(end));
xs        = vSteps*signX*deltax(end) + xs; ys      = vSteps*signY*deltay(end) + ys;
ys(2:end) = sameX*ys(1:end-1) + (1-sameX)*(slope(end)*xs(2:end) + yintcpt(end));
xf        = vSteps*signX*delxof(end) + xf; yf      = vSteps*signY*delyof(end) + yf;
yf(2:end) = sameX*yf(1:end-1) + (1-sameX)*(slope(end)*xf(2:end) + yintof(end));
x1        = [x1, xs]; y1 = [y1, ys];
x2        = [x2, xf]; y2 = [y2, yf];

% make matrix of segment coordinates (segmatx and segmaty)
segpoints = round(length(x1)/nsegment); %divide total newpoints eqully to all segments

% quartile segmentation (change starting point of roi making to new point)
nShift = 4; % 4 for quartiles, this could be one of input variable.
q_one = round(segpoints/nShift);
if rem(q_one,2) ~= 0
    q_one = q_one+1;
else
    q_one = q_one;
end
rot = q_one*(0:1:nShift-1);
Self.Polygons = [];
for jj = 1:length(rot)
    % circularly shif the coordinates
    x1    = circshift(x1,-rot(jj));
    y1    = circshift(y1,-rot(jj));
    x2    = circshift(x2,-rot(jj));
    y2    = circshift(y2,-rot(jj));

    x1(segpoints*nsegment+1:end) = []; x2(1:end-segpoints*nsegment) = [];
    y1(segpoints*nsegment+1:end) = []; y2(1:end-segpoints*nsegment) = [];
    if length(x1) < segpoints*nsegment
        lPad = segpoints*nsegment-length(x1);
        x1   = padarray(x1,[0, lPad], x1(end), 'post');
        y1   = padarray(y1,[0, lPad], y1(end), 'post');
        x2   = padarray(x2,[0, lPad], x2(end), 'post');
        y2   = padarray(y2,[0, lPad], y2(end), 'post');
    end
    matX1     = reshape(x1, segpoints, nsegment);       matY1   = reshape(y1, segpoints, nsegment);
    matX2     = reshape(x2, segpoints, nsegment);       matX2   = flipud(matX2); matY2 = reshape(y2, segpoints, nsegment); matY2 = flipud(matY2);
    endX1     = circshift(matX1(1,:),[0,-1]);           endY1   = circshift(matY1(1,:),[0,-1]);
    endX2     = circshift(matX2(end,:),[0,-1]);         endY2   = circshift(matY2(end,:),[0,-1]);
    endX3     = matX1(1,:);                             endY3   = matY1(1,:);
    segmatx   = [matX1',endX1',endX2',matX2', endX3']'; segmaty = [matY1',endY1',endY2',matY2', endY3']';
    segments(:,:,1) = segmatx; segments(:,:,2) = segmaty;
    Polygons_list   = mat2cell(segments, size(segments,1), ones(size(segments,2),1), 2);
    Self.Polygons   = [Self.Polygons, Polygons_list];
end
for ii = 1:length(Self.Polygons)
    Self.Polygons{ii} = squeeze(Self.Polygons{ii});
    BW_sub = poly2mask(Self.Polygons{ii}(:,1), Self.Polygons{ii}(:,2), size(Image_,1), size(Image_,2));
    Self.Labeled_Image(BW_sub == 1) = ii;
end