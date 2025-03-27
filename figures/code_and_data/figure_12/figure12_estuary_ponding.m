clc; clear all; close all;
%% figure 12
addpath(genpath("../matlab_toolbox/"))
%----- options ----
myfont='Arial';
fontsize=20;
fontsize_cb=18;
markersize=13;
bry_lw=2.5;
my_tij_color=[0.2 0.2 0.2];
%-----model grid----
load('../figure_2/data/Couple_domain.mat');
%% domain corner
FPT_XMIN=-78.07;
FPT_XMAX=-77.87;
FPT_YMIN=33.837;
FPT_YMAX=34.35;

dlon=0.1;
dlat=0.1;
%%---- boundary ij ----
bij=load('../figure_2/data/boundary_ij.txt');
[nbij,~]=size(bij);
lonb=zeros(nbij,1);
latb=zeros(nbij,1);
for n=1:nbij
    lonb(n)=lon(bij(n,1),bij(n,2));
    latb(n)=lat(bij(n,1),bij(n,2));
end;
%%---- transect ij ----
tij=load('../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
[ntij,~]=size(tij);
lont=zeros(ntij,1);
latt=zeros(ntij,1);
for n=1:ntij
    lont(n)=lon(tij(n,1),tij(n,2));
    latt(n)=lat(tij(n,1),tij(n,2));
end;
%%my_point
my_point=[30,50,100,148,245,467];

%% figure
Nr=1;
Nc=2;
h=figure;
set(gcf,'position',[10 50 620 600],'inverthardcopy','off','color',[1 1 1])

%% a)  prolonged ponding  
load('./data/combined_ponding.mat')
clear tmp_plt
tmp_plt=(combined_ponding_exp3-combined_ponding_exp6)*15/60;
    zmin=0;
    zmax=20;
    skipz=(zmax-zmin)/100;
    map=load('WhiteBlue.rgb');
    map=map/260;
    positionVector1 = [0.12, 0.13, 0.40, 0.80];

    ha(1)=subplot(Nr,Nc,1,'Position',positionVector1);
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
    set(gca,'color', [1.0 1.0 1.0]);
    
    hold on
    colormap(ha(1),map); 
    contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');

    hold on
    plot(lonb,latb,'Color',[0.1,0.1,0.1],'LineWidth',bry_lw);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',1);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])

    shading flat;
    caxis([zmin zmax]);
    hold on
    set(gca,'XTick',-78:dlon:-77.9);
    set(gca,'XTickLabel',{'-78.0' '-77.9'});
    set(gca,'YTick',33.9:dlat:34.3);
    set(gca,'YTickLabel',{'33.9' '34.0' '34.1' '34.2' '34.3'});

    set(gca,'FontSize',fontsize);
    set(gca,'tickdir','out')
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    xlabel('Longitude')
    ylabel('Latitude')

    hold on
    ap=get(gca,'position');
    shading flat;
    caxis([zmin zmax]);

    hc=colorbar;
    text(1.05,1.04,'(hours)','Units','normalized','FontName',myfont,'FontSize',fontsize_cb)  
    % title('(a) Prolonged Ponding','Units','normalized','FontName',myfont,'FontSize',fontsize,'FontWeight','Normal')
    ax = gca;
    ax.TitleHorizontalAlignment = 'left';

%% b) max salinity 
load('./data/combined_max_salinity_exp3.mat')
clear tmp_plt
tmp_plt=combined_max_salinity_exp3; 

    zmin=0;
    zmax=35.0;
    skipz=(zmax-zmin)/100;
    map=load('wh-bl-gr-ye-re.rgb');
    map=map/280;
    positionVector2 = [0.56, 0.13, 0.4, 0.80];
    
    ha(2)=subplot(Nr,Nc,2,'Position',positionVector2);
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
    set(gca,'color', [1.0 1.0 1.0]);
    
    hold on
    colormap(ha(2),map)
    contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');

    hold on
    plot(lonb,latb,'Color',[0.1,0.1,0.1],'LineWidth',bry_lw);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',1);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])

    shading flat;
    caxis([zmin zmax]);
    hold on
    
    set(gca,'XTick',-78:dlon:-77.9);
    set(gca,'XTickLabel',{'-78.0' '-77.9'});
    set(gca,'YTick',33.9:dlat:34.3);
    set(gca,'YTickLabel',{'33.9' '34.0' '34.1' '34.2' '34.3'});
    yticklabels({})
    xlabel('Longitude')
    set(gca,'FontSize',fontsize);
    set(gca,'tickdir','out')
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])

    hold on
    ap=get(gca,'position');
    shading flat;
    caxis([zmin zmax]);

    hc=colorbar;
    text(1.05,1.04,'Salinity','Units','normalized','FontName',myfont,'FontSize',fontsize_cb)
    % title('(b) Maximum Salinity','Units','normalized','FontName',myfont,'FontSize',fontsize,'FontWeight','Normal')
    ax = gca;
    ax.TitleHorizontalAlignment = 'left';

%% save figure
outfile=['figure12_estuary_ponding.png'];
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF

