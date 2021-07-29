%ROI membrane segmentation code originally written in imagej macro
%inputs are membrane width (offset), segment area (segpixels)
%@dnbadu: June 25, 2019 3:21pm

function Self = Curve_Guided_DAMAR(roi,offset,segmentationtype,segmentationvalue)

if nargin <2, offset=12; elseif isempty(offset),offset=16; end
if nargin <3
    segmentationtype='area';
    segmentationvalue=500;
elseif isempty(segmentationtype),segmentationtype='area'; 
    segmentationvalue=500;
end
if nargin <4 && strcmp(segmentationtype,'area')
    segmentationvalue=500;
elseif nargin <4 && strcmp(segmentationtype,'number segments')
    segmentationvalue=1;
end

% x and y are polygon coordinates
% x=[10,100,40,80,10];
% y=[10,10,60,60,100];

x(1,:)=roi(:,1);
y(1,:)=roi(:,2);
%disp(x);
%disp(length(x));
dist=[];
normx=[];
normy=[];
prodc=[];
slope=[];
yintcpt=[];
xlnth=[];
ylnth=[];
for i=1:length(x)
    if i==length(x)
        dist(i)=sqrt((x(1)-x(i))^2+(y(1)-y(i))^2);
        normx(i)=(y(1)-y(i))/dist(i);
        normy(i)=-(x(1)-x(i))/dist(i);
        prodc(i)=(x(1)-x(i))*(y(1)+y(i));
        slope(i)=(y(1)-y(i))/(x(1)-x(i));
        yintcpt(i)=y(i)-slope(i)*x(i);
        xlnth(i)=x(1)-x(i);
        ylnth(i)=y(1)-y(i);
    else
        dist(i)=sqrt((x(i+1)-x(i))^2+(y(i+1)-y(i))^2);
        normx(i)=(y(i+1)-y(i))/dist(i);
        normy(i)=-(x(i+1)-x(i))/dist(i);
        prodc(i)=(x(i+1)-x(i))*(y(i+1)+y(i));
        slope(i)=(y(i+1)-y(i))/(x(i+1)-x(i))
        yintcpt(i)=y(i)-slope(i)*x(i);
        xlnth(i)=x(i+1)-x(i);
        ylnth(i)=y(i+1)-y(i);
    end
end
%disp(dist);
%disp(ylnth);
%sum of prodc will help to determine clockwise anticlokwise polygon
sumprodc= sum(prodc);
%membrane width=offset
% offset = 5; %input
if sumprodc>0
    offset=offset;
else
    offset=-offset;
end
%in1 are 1st end of offset side
xin1=[];
yin1=[];
for i=1:length(x)
    xin1(i)=x(i)+offset*normx(i);
    yin1(i)=y(i)+offset*normy(i);
end
%in2 are 2nd end of offset side
% xin2=[];
% yin2=[];
for i=1:length(x)
    if i==length(x)
        xin2(i)=x(1)+offset*normx(i);
        yin2(i)=y(1)+offset*normy(i);
    else
        xin2(i)=x(i+1)+offset*normx(i);
        yin2(i)=y(i+1)+offset*normy(i);
    end
end
%a,b,c are coefficients of ax+by+c=0 offset sides
a=[];
b=[];
c=[];
for i=1:length(x)
    a(i)=yin2(i)-yin1(i);
    b(i)=xin1(i)-xin2(i);
    c(i)=(xin2(i)*yin1(i))-(yin2(i)*xin1(i));
end
% to find point of intersection of offset sides: det=a1b2-a2b1
for i=1:length(x)
    if i==length(x)
        det(i)=abs(a(i)*b(1)-a(1)*b(i));
    else
        det(i)=abs(a(i)*b(i+1)-a(i+1)*b(i));
    end
end
% xoff and yoff are point of instersections /offset coordinates
xoff=[];
yoff=[];
for i=1:length(x)
    if i==length(x)
        if det(i)==0;
            xoff(i)=xin2(1);
            yoff(i)=yin2(1);
        else
            xoff(i)=(b(i)*c(1)-b(1)*c(i))/(a(i)*b(1)-a(1)*b(i))
            yoff(i)=(c(i)*a(1)-c(1)*a(i))/(a(i)*b(1)-a(1)*b(i))
        end
    else
        if det(i)==0;
            xoff(i)=xin2(i);
            yoff(i)=yin2(i);
        else
            xoff(i)=(b(i)*c(i+1)-b(i+1)*c(i))/(a(i)*b(i+1)-a(i+1)*b(i))
            yoff(i)=(c(i)*a(i+1)-c(i+1)*a(i))/(a(i)*b(i+1)-a(i+1)*b(i))
        end
    end
end
%make order of vertex match with original polygon
xof=[];
yof=[];
xof(1)=xoff(length(x)); %last is first, first is second and so on
yof(1)=yoff(length(x));
for i=2:length(x)
    xof(i)=xoff(i-1);
    yof(i)=yoff(i-1);
end
%yintercept, xlength, ylength of sides of offset polygon
yintof=[];
xlnof=[];
ylnof=[];
for i=1:length(x)
    if i==length(x)
        yintof(i)=yof(i)-slope(i)*xof(i);
        xlnof(i)=xof(1)-xof(i);
        ylnof(i)=yof(1)-yof(i);
    else
        yintof(i)=yof(i)-slope(i)*xof(i);
        xlnof(i)=xof(i+1)-xof(i);
        ylnof(i)=yof(i+1)-yof(i);
    end
end
A=polyarea(x,y);
Aof=polyarea(xof,yof);
pixels=A-Aof;
% segpixels=200; %input=(pixels) gives whole membrane
if strcmp(segmentationtype,'area')
    segpixels=segmentationvalue
    nsegment= round(pixels/segpixels); %segmentation based on area (can input specific number)
elseif strcmp(segmentationtype,'number segments')
    nsegment=segmentationvalue;
end
sf=[]; %scale factor to nsteps (to make stepsize same for all sides)
nsteps=[]; %steps to intrapolate points in polygon side
maxdist=max(dist);
for i=1:length(x)
    sf(i)=round(dist(i)*10/maxdist); %10 can be any integer
    nsteps(i)=sf(i)*nsegment; %need to multiply by nsegments to make segpoints always an integer
end
% cumulative addintion of nsteps
nstepcf=cumsum(nsteps);
%x1 and y1 are intrapolation in sides of original polygon (new points)
x1=[];
y1=[];
for m=1:length(x)
    xs=[];
    ys=[];
    deltax=abs(xlnth(m)/nsteps(m));
    deltay=abs(ylnth(m)/nsteps(m));
    xs(1)=x(m);
    ys(1)=y(m);
    for i=1:nsteps(m)-1
        if m<length(x)
            if x(m)<x(m+1)
                xs(i+1)=xs(i)+deltax;
                ys(i+1)=slope(m)*xs(i+1)+yintcpt(m);
            elseif x(m)>x(m+1)
                xs(i+1)=xs(i)-deltax;
                ys(i+1)=slope(m)*xs(i+1)+yintcpt(m);
            elseif x(m)==x(m+1)
                xs(i+1)=xs(i);
                if y(m+1)>y(m)
                    ys(i+1)=ys(i)+deltay;
                else
                    ys(i+1)=ys(i)-deltay;
                end
            end

        elseif m==length(x)
            if x(m)<x(1)
                xs(i+1)=xs(i)+deltax;
                ys(i+1)=slope(m)*xs(i+1)+yintcpt(m);
            elseif x(m)>x(1)
                xs(i+1)=xs(i)-deltax;
                ys(i+1)=slope(m)*xs(i+1)+yintcpt(m);
            elseif x(m)==x(1)
                xs(i+1)=xs(i);
                if y(1)>y(m)
                    ys(i+1)=ys(i)+deltay;
                else
                    ys(i+1)=ys(i)-deltay;
                end
            end
        end
    end
    for j=1:nsteps(m)
        if m==1
            x1(j+(m-1)*nsteps(m))=xs(j);
            y1(j+(m-1)*nsteps(m))=ys(j);
        elseif m > 1
            x1(j+nstepcf(m-1))=xs(j);
            y1(j+nstepcf(m-1))=ys(j);
        end
    end
end
%x2 and y2 are intrapolation in sides of offset polygon
x2=[];
y2=[];
for n=1:length(x)
    xf=[];
    yf=[];
    delxof=abs(xlnof(n)/nsteps(n));
    delyof=abs(ylnof(n)/nsteps(n));
    xf(1)=xof(n);
    yf(1)=yof(n);
    for i=1:nsteps(n)-1
        if n<length(x)
            if x(n)<x(n+1)
                xf(i+1)=xf(i)+delxof;
                yf(i+1)=slope(n)*xf(i+1)+yintof(n);
            elseif x(n)>x(n+1)
                xf(i+1)=xf(i)-delxof;
                yf(i+1)=slope(n)*xf(i+1)+yintof(n);
            elseif x(n)==x(n+1)
                xf(i+1)=xf(i);
                if y(n+1)>y(n)
                    yf(i+1)=yf(i)+delyof;
                else
                    yf(i+1)=yf(i)-delyof;
                end
            end

        elseif n==length(x)
            if x(n)<x(1)
                xf(i+1)=xf(i)+delxof;
                yf(i+1)=slope(n)*xf(i+1)+yintof(n);
            elseif x(n)>x(1)
                xf(i+1)=xf(i)-delxof;
                yf(i+1)=slope(n)*xf(i+1)+yintof(n);
            elseif x(n)==x(1)
                xf(i+1)=xf(i);
                if y(1)>y(n)
                    yf(i+1)=yf(i)+delyof;
                else
                    yf(i+1)=yf(i)-delyof;
                end
            end
        end
    end
    for j=1:nsteps(n)
        if n==1
            x2(j+(n-1)*nsteps(n))=xf(j);
            y2(j+(n-1)*nsteps(n))=yf(j);
        elseif n > 1
            x2(j+nstepcf(n-1))=xf(j);
            y2(j+nstepcf(n-1))=yf(j);
        end
    end
end
% make matrix of segment coordinates (segmatx and segmaty)
segpoints=round(length(x1)/nsegment); %divide total newpoints eqully to all segments
segmatx= (2*segpoints+2):nsegment;
segmaty= (2*segpoints+2):nsegment;
segx1=[]; %from original polygon x1
segy1=[];
segx2=[]; %from offset polygon x2
segy2=[];
segxr2=[]; %reverse the coordinates to make polygon
segyr2=[];
endx=[];% include end points in every segments
endy=[];
for s=1:nsegment
    for j=1:segpoints
        segx1(j)=x1(j+(s-1)*segpoints);
        segy1(j)=y1(j+(s-1)*segpoints);
        segx2(j)=x2(j+(s-1)*segpoints);
        segy2(j)=y2(j+(s-1)*segpoints);
    end
    for r=1:segpoints
        segxr2(r)=segx2(segpoints-r+1);
        segyr2(r)=segy2(segpoints-r+1);
    end
    if s<nsegment
        endx(1)=x1(s*segpoints+1)
        endy(1)=y1(s*segpoints+1)
        endx(2)=x2(s*segpoints+1)
        endy(2)=y2(s*segpoints+1)
    elseif s==nsegment
        endx(1)=x1(1)
        endy(1)=y1(1)
        endx(2)=x2(1)
        endy(2)=y2(1)
    end
    segx=[segx1,endx,segxr2];
    segy=[segy1,endy,segyr2];
    for p=1:2*segpoints+2
        segmatx(p,s)=segx(p);
        segmaty(p,s)=segy(p);
    end
end
segments(:,:,1)=segmatx;
segments(:,:,2)=segmaty;
%plot all segmnents
for i=1:nsegment
    plot(segmatx(:,i),segmaty(:,i),'-o','LineWidth',2,'MarkerSize',2);
    if i==1
        hold on
    end    
end
hold off
%BW=roipoly(110,110);


