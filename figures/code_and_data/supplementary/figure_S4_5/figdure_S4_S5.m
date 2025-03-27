clc; clear all; close all;
%% figrue S4, S5
addpath(genpath("../../matlab_toolbox/"))
%----- options ----
fig_p = 1; % 1: figure S4; 2: figure S5;
fontname='Arial';
fontsize=15; 
fontsize2=20;
my_point_Inlet=[7,76,151]; 
markersize=5;
markersize1=5;
my_bij_color=[0.4 0.4 0.4];
my_tij_color=[0 0 0];
my_tij_color2='none';
panel_lable={'(a)';'(b)';'(c)';'(d)';'(e)';...
              '(f)';'(g)';'(h)';'(i)';'(j)';...
              '(k)';'(l)';'(m)';'(n)';'(o)';...
              '(p)';'(q)';'(r)';'(s)';'(t)';};
%%-----model grid----
load('../../figure_2/data/Couple_domain.mat');
[im_rho,jm_rho]=size(lon);
%%---- boundary ij ----
bij=load('../../figure_2/data/boundary_ij.txt');
[nbij,~]=size(bij);
lonb=zeros(nbij,1);
latb=zeros(nbij,1);
for n=1:nbij
    lonb(n)=lon(bij(n,1),bij(n,2));
    latb(n)=lat(bij(n,1),bij(n,2));
end;
%%---- transect ij ----
tij0=load('../../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
tij=tij0(1:650,:);
[ntij,~]=size(tij);
lont=zeros(ntij,1);
latt=zeros(ntij,1);
for n=1:ntij
    lont(n)=lon(tij(n,1),tij(n,2));
    latt(n)=lat(tij(n,1),tij(n,2));
end;
my_point=[520,569,625]; %5; 12; 20  km
% inlet
for ii=1:4
    clear tij ntij tij0
    tij0=load(['../../figure_2/data/transect_ij/tr_inlet_ocean',num2str(ii),'_with_dist.txt']);
    tij=tij0(1:200,:);
    [ntij,~]=size(tij);
    lont_inlet=zeros(ntij,1);
    latt_inlet=zeros(ntij,1);
    for n=1:ntij
        lont_inlet(n)=lon(tij(n,1),tij(n,2));
        latt_inlet(n)=lat(tij(n,1),tij(n,2));
    end;
    eval(['lont_Inlet',num2str(ii),'=lont_inlet;']);
    eval(['latt_Inlet',num2str(ii),'=latt_inlet;']);
end;

%-----time series----
target_str={'2018-09-11 05:00';...
            '2018-09-15 22:00';...
            '2018-09-16 19:00';...
            '2018-09-18 02:00';...
            '2018-09-20 09:00';...
            '2018-09-22 18:00';...
            '2018-09-24 22:00';...
            '2018-09-27 20:00';...
            '2018-09-29 03:00';...
            '2018-10-03 00:00'...
            }; 
ts = datetime(target_str);

if fig_p==1
   ii0=1;
   ii1=size(ts,1)/2;
else
   ii0=size(ts,1)/2+1;
   ii1=size(ts,1);
end;

%% figure
zmin=0.0;
zmax=35.0;

map=load('wh-bl-gr-ye-re.rgb');
map=map/280;

FPT_XMIN=-78.7;
FPT_XMAX=-77.6;
FPT_YMIN=33.6;
FPT_YMAX=34.4;

dlon=0.3;
dlat=0.2;

Nr=2;
Nc=5;
set(0,'DefaultFigureVisible','on');
h=figure;
set(gcf,'position',[10 10 1400 400],'inverthardcopy','off','color',[1 1 1]);
ha = tight_subplot(Nr,Nc,[.00 .00],[.01 .07],[.035 .065]);

%% 
for ii = ii0:ii1
    if fig_p==1
       hii=ii;
    else
       hii=ii-size(ts,1)/2;
    end
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')];
    for iexp=1:2
        load(['./data/combined_salinity_exp',num2str(iexp),'_',ts0,'.mat']);
        clear tmp_plt
        eval(['tmp_plt=combined_salinity_exp',num2str(iexp),'_',ts0,';']);
    
        axes(ha(Nc*iexp-(Nc-hii)))
        set(gca,'box','on','Layer','top','FontName',fontname,'FontSize',fontsize);
        hold on
        warning off;
        skipz=(zmax-zmin)/100;
        colormap(map);
        contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');  % #######
        caxis([zmin zmax]);
        % hydro-ocean bry
        hold on
        plot(lonb,latb,'Color',[0.3,0.3,0.3],'LineWidth',0.2);
        %% tr
        plot(lont,latt,'Color',my_tij_color,'LineWidth',0.8);
        plot(lont(my_point(1:3)),latt(my_point(1:3)),'s','Markersize',markersize1,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
        %Inlet
        plot(lont_Inlet1,latt_Inlet1,'Color',my_tij_color,'LineWidth',0.8);
        plot(lont_Inlet1(my_point_Inlet(1:3)),latt_Inlet1(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
        plot(lont_Inlet2,latt_Inlet2,'Color',my_tij_color,'LineWidth',0.8);
        plot(lont_Inlet2(my_point_Inlet(1:3)),latt_Inlet2(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
        plot(lont_Inlet3,latt_Inlet3,'Color',my_tij_color,'LineWidth',0.8);
        plot(lont_Inlet3(my_point_Inlet(1:3)),latt_Inlet3(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
        plot(lont_Inlet4,latt_Inlet4,'Color',my_tij_color,'LineWidth',0.8);
        plot(lont_Inlet4(my_point_Inlet(1:3)),latt_Inlet4(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
                
        xticklabels({});yticklabels({});
        xticks({});yticks({})
        
        axis equal
        axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
        tag1=cell2mat(panel_lable(Nc*iexp-(Nc-hii)));
        text(-78.65,34.35,tag1,'FontSize',fontsize2);
    end;
end;

%% post appearances1
hc = colorbar('Location','east');
set(hc, 'YAxisLocation','right')
ap=get(gca,'position');

% axes(ha(end));
% hc = colorbar('Location','east');
% ap=get(gca,'position');
caxis([zmin zmax]);
set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.945 ap(2)+0.005 0.015 0.918],'FontName',fontname,'FontSize',15);
ylabel(hc,{'Salinity'},'FontSize',fontsize,'Rotation',0)
hc.Label.Position(1)=0.5;
hc.Label.Position(2)=37.3;

axes(ha(1)); ylabel({'Stand-alone';'(ROMS only)'});
axes(ha(1+Nc)); ylabel({'One-Way Coupled';'("Linked" ROMS)'});

for ii = ii0:ii1
    if fig_p==1
       hii=ii;
    else
       hii=ii-size(ts,1)/2;
    end
    axes(ha(hii));
    title([cell2mat(target_str(ii))],'FontSize',fontsize);
end;


% save figure%
if fig_p==1
   outfile=['figureS4_ocean_salinity_exp12_2D_p1.png'];
else
   outfile=['figure10_ocean_salinity_exp12_2D_p2.png'];
end;
print(gcf,'-dpng',outfile);
% close(figure(1));

%% EOF

