clear;clc;close all
addpath(genpath("../matlab_toolbox/"))
%% figure 2 panels a-b

load('./data/Couple_domain.mat')
[im,jm]=size(combine_h);

%% load bij
bij=load('./data/boundary_ij.txt');
[nbij,~]=size(bij);
lonb=zeros(nbij,1);
latb=zeros(nbij,1);
for n=1:nbij
    lonb(n)=lon(bij(n,1),bij(n,2));
    latb(n)=lat(bij(n,1),bij(n,2));
end;

%% transect ij 
tij=load('./data/transect_ij/tr_long_left_with_dist.txt');
[ntij,~]=size(tij);
lont=zeros(ntij,1);
latt=zeros(ntij,1);
for n=1:ntij
    lont(n)=lon(tij(n,1),tij(n,2));
    latt(n)=lat(tij(n,1),tij(n,2));
end;

%% zoom-in view
FPT_XMIN=-78.02;
FPT_XMAX=-77.93;
FPT_YMIN=latt(170);
FPT_YMAX=34.3;

%% figrue
figure;
set(gcf,'position',[10 10 430 790],'inverthardcopy','off','color',[1 1 1])
% box on; 
xticklabels({});yticklabels({});
xticks({});yticks({})
ax = geoaxes;
latlim=[FPT_YMIN FPT_YMAX]; % map boundary
lonlim=[FPT_XMIN FPT_XMAX];
grid off
%% points on map
my_point=[30,47,100,148,245,467,520,569,625];  
my_bij_color=[0.3 0.3 0.3];
my_tij_color='k';[0.2 0.2 0.2];
hold on;

geoplot(latb,lonb,'Color',my_bij_color,'LineWidth',1.5);
geoplot(latt,lont,'Color',my_tij_color,'LineWidth',2.5);

hold on
geoscatter(latt(my_point(1:3)),lont(my_point(1:3)),350,'k','filled');
geoscatter(latt(my_point(4:6)),lont(my_point(4:6)),350,'k','^','filled');
geoscatter(latt(my_point(7:9)),lont(my_point(7:9)),350,'k','d','filled');

%% basemap
geobasemap('topographic');
geolimits(latlim, lonlim);

%% transparency
hax = findobj(gcf,'type','geoaxes');
opacity = 0.5;
drawnow
tstrips = vertcat(hax.BasemapDisplay.QuadObjects.Children);
for k = 1:numel(tstrips)
    mapcd = tstrips(k).TriangleStrip.Texture.CData;
    mapcd = opacity*(1-im2double(mapcd));
    mapcd = im2uint8(1-mapcd);
    tstrips(k).TriangleStrip.Texture.CData = mapcd;
end

ax.TickLabelFormat='dm';
ax.LatitudeAxis.TickLabels = {};
ax.LongitudeAxis.TickLabels = {};
ax.LatitudeLabel.String = '';
ax.LongitudeLabel.String = '';

%% save figrue
outfile='figure2_f.png';
print(gcf,'-dpng',outfile)  

%% EOF