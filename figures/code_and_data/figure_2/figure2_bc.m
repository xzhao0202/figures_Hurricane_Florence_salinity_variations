clear;clc;close all
%% figure 2 panels c-d
addpath(genpath("../matlab_toolbox/"))
%----- options -----
bgcolor=[1.0 1.0 1.0];
myfont='Arial';
%% subplot1: domain - panel c
set(gcf,'position',[10 50 1200 700],'inverthardcopy','off','color',[1 1 1])
positionVector1 = [0.07, 0.1, 0.3, 0.80];
subplot(1,3,2,'Position',positionVector1)    
    load('data/Couple_domain.mat')
    [im,jm]=size(combine_h);

    FPT_XMIN=lon(1+20,1);
    FPT_XMAX=lon(im-20,1);
    FPT_YMIN=lat(1,1+20);
    FPT_YMAX=lat(1,jm-20);
   
    map = cmocean('topo');
    map(129:256,:)=flipud(map(129:256,:));
    colormap(map);

    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',15);
    set(gca,'color',bgcolor);
    
    zmin=-50.0;
    zmax=50.0;
    skipz=(zmax-zmin)/100;
    contourf(lon,lat,-combine_h,zmin:skipz:zmax,'linestyle','none');

    shading flat;
    caxis([zmin zmax]);
    hold on
    
    set(gca,'XTick',-78.8:0.3:-77.6);
    set(gca,'XTickLabel',{'-78.8' '-78.5' '-78.2' '-77.9' '-77.6'});
    set(gca,'YTick',33.6:0.2:35.4);
    set(gca,'YTickLabel',{'33.6' '33.8' '34.0' '34.2' '34.4' '34.6' '34.8' '35.0' '35.2' '35.4'});
    set(gca,'FontSize',15);
    set(gca,'tickdir','out')
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    xlabel('Longitude') 
    ylabel('Latitude') 

    hold on
%% HUC bry
huc_bry_color='b';%[0.75 0.75 0.75];
huc_bry_w=1.2;
linestyle='-';
    % mid basin
    clear huc_bry
    load('./data/basin_bry/mid_basin_bry');
    huc_bry=mid_basin_bry;
    huc_bry(12320:12380,:)=nan;
    plot(huc_bry(:,2),huc_bry(:,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', linestyle); 
    % east basin
    clear huc_bry
    load('./data/basin_bry/east_basin_bry');
    huc_bry=east_basin_bry;
    plot(huc_bry(1:500,2),huc_bry(1:500,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', '-'); 
    plot(huc_bry(end-100:end,2),huc_bry(end-100:end,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', linestyle); 
%% bij
    bij=load('data/boundary_ij.txt');
    [nbij,~]=size(bij);
    lonb=zeros(nbij,1);
    latb=zeros(nbij,1);
    for n=1:nbij
        lonb(n)=lon(bij(n,1),bij(n,2));
        latb(n)=lat(bij(n,1),bij(n,2));
    end
    plot(lonb,latb,'Color',[0.05,0.05,0.05],'LineWidth',1.); 

%% stations
    % ocean
    lons2(1)=-78.4877;    lats2(1)=33.8408;
    lons2(2)=-77.7183;    lats2(2)=34.1445;
    plot(lons2,lats2,'bs','Markersize',10,'MarkerFaceColor','m');     
    % estuary
    lons3=-77.9350;    lats3=33.9547; %% noczbwq   	Zeke's Basin
    plot(lons3,lats3,'b^','Markersize',9,'MarkerFaceColor','m'); 
    % point source for Exp2
    plot(-77.995,34.273,'bp','Markersize',10,'MarkerFaceColor',[0.0 0.4 0.0]);  
    plot(-77.952,34.28,'bp','Markersize',10,'MarkerFaceColor',[0.0 0.4 0.0]);  

%% zoom-in view frame for panel d
    xd=zeros(5,1);
    yd=zeros(5,1);
    
    FPT_XMIN=-78.7;
    FPT_XMAX=-77.6;
    FPT_YMIN=33.6;
    FPT_YMAX=34.4;

    xd(1)=FPT_XMIN;
    yd(1)=FPT_YMIN;
    xd(2)=FPT_XMIN;
    yd(2)=FPT_YMAX;
    xd(3)=FPT_XMAX;
    yd(3)=FPT_YMAX;
    xd(4)=FPT_XMAX;
    yd(4)=FPT_YMIN;
    xd(5)=FPT_XMIN;
    yd(5)=FPT_YMIN;
    plot(xd,yd,'r--','LineWidth',1);    
%% hurricane track
% load hurricane track
track=load('data/track.txt');
track1=load('data/track1.txt');
track2=load('data/track2.txt');
track3=load('data/track3.txt');
track4=load('data/track4.txt');
    % plot(-track1(:,2),track1(:,1),'b-','LineWidth',1);
    % plot(-track2(:,2),track2(:,1),'m-','LineWidth',1);
    % plot(-track3(:,2),track3(:,1),'g-','LineWidth',1);
    % plot(-track4(:,2),track4(:,1),'y-','LineWidth',1);
    % plot(-track(:,2),track(:,1),'ko','Markersize',6);
    plot(-track1(:,2),track1(:,1),'k-','LineWidth',1);
    plot(-track2(:,2),track2(:,1),'k-','LineWidth',1);
    plot(-track3(:,2),track3(:,1),'k-','LineWidth',1);
    plot(-track4(:,2),track4(:,1),'k-','LineWidth',1);
    plot(-track(:,2),track(:,1),'ko','Markersize',6);
    
    xshift=0.01;
    yshift=0.04;
    text(-77.9+xshift,34.1-yshift+0.01,'09/14 12:00','FontName',myfont,'FontSize',10)
    text(-78.4+xshift,34-yshift,'09/14 18:00','FontName',myfont,'FontSize',10)
    text(-78.8+xshift,33.9-yshift,'09/15 00:00','FontName',myfont,'FontSize',10)

%% subplot2: zoom-in view for estuary  - panel d
positionVector2 = [0.43, 0.1, 0.5, 0.80];
subplot(1,3,2,'Position',positionVector2)     
    colormap(map);
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',12);
    set(gca,'color',bgcolor);
    set(gcf,'inverthardcopy','off');
    set(gcf,'color',[1 1 1]);

    contourf(lon,lat,-combine_h,zmin:skipz:zmax,'linestyle','none');
    shading flat;
    caxis([zmin zmax]);
    hold on

    dlon=0.3;
    dlat=0.2;
    set(gca,'XTick',FPT_XMIN:dlon:FPT_XMAX);
    set(gca,'XTickLabel',{' ' num2str(FPT_XMIN+dlon,'%.1f') num2str(FPT_XMIN+dlon*2,'%.1f') num2str(FPT_XMIN+dlon*3,'%.1f')});
    set(gca,'YTick',FPT_YMIN:dlat:FPT_YMAX);
    set(gca,'YTickLabel',{num2str(FPT_YMIN,'%.1f') num2str(FPT_YMIN+dlat,'%.1f') num2str(FPT_YMIN+dlat*2,'%.1f') num2str(FPT_YMIN+dlat*3,'%.1f') num2str(FPT_YMAX,'%.1f')});

    set(gca,'FontSize',15);
    set(gca,'tickdir','out')
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    xlabel('Longitude') 
    %ylabel('Latitude') 
    hold on
    
%% HUC bry
huc_bry_color='b';%[0.75 0.75 0.75];
huc_bry_w=1.2;
linestyle='-';
    % mid basin
    clear huc_bry
    load('./data/basin_bry/mid_basin_bry');
    huc_bry=mid_basin_bry;
    huc_bry(12320:12380,:)=nan;
    plot(huc_bry(:,2),huc_bry(:,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', linestyle); 
    % east basin
    clear huc_bry
    load('./data/basin_bry/east_basin_bry');
    huc_bry=east_basin_bry;
    plot(huc_bry(1:500,2),huc_bry(1:500,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', '-'); 
    plot(huc_bry(end-100:end,2),huc_bry(end-100:end,1),'Color',huc_bry_color,'LineWidth',huc_bry_w,'LineStyle', linestyle); 
%% bij
    bij=load('data/boundary_ij.txt');
    [nbij,~]=size(bij);
    lonb=zeros(nbij,1);
    latb=zeros(nbij,1);
    for n=1:nbij
        lonb(n)=lon(bij(n,1),bij(n,2));
        latb(n)=lat(bij(n,1),bij(n,2));
    end
    plot(lonb,latb,'Color',[0.05,0.05,0.05],'LineWidth',1.); 
%% stations
    % ocean
    lons2(1)=-78.4877;    lats2(1)=33.8408;
    lons2(2)=-77.7183;    lats2(2)=34.1445;
    plot(lons2,lats2,'bs','Markersize',10,'MarkerFaceColor','m');     
    % estuary
    lons3=-77.9350;    lats3=33.9547; %% noczbwq   	Zeke's Basin
    plot(lons3,lats3,'b^','Markersize',9,'MarkerFaceColor','m'); 
    % point source for Exp2
    plot(-77.995,34.273,'bp','Markersize',10,'MarkerFaceColor',[0.0 0.4 0.0]);  
    plot(-77.952,34.28,'bp','Markersize',10,'MarkerFaceColor',[0.0 0.4 0.0]);  
        
%% Land-estuary-ocean transect (trij) 
tij0=load('data/transect_ij/tr_long_left_with_dist.txt');
    tij=tij0(1:660,:);
    [ntij,~]=size(tij);
    lons4=zeros(ntij,1);
    lats4=zeros(ntij,1);
    for n=1:ntij
        lons4(n)=lon(tij(n,1),tij(n,2));
        lats4(n)=lat(tij(n,1),tij(n,2));
    end
    %selected point
    my_point=[30,47,100,148,245,467,520,569,625];  % 2024/06/25; 12, 23, 49 km from land-ocean boundary
    plot(lons4,lats4,'k-','LineWidth',1)
    markersize=10;
    plot(lons4(my_point(1:3)),lats4(my_point(1:3)),'o','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','k');%[0.8500 0.3250 0.0980])
    plot(lons4(my_point(4:6)),lats4(my_point(4:6)),'^','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','k');%[0.8500 0.3250 0.0980])
    plot(lons4(my_point(7:9)),lats4(my_point(7:9)),'s','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','k');%[0.8500 0.3250 0.0980])
%% inlet transects (trij) 
for transet_opt=1:4
    clear tij ntij tij0
    tij0=load(['data/transect_ij/tr_inlet_ocean',num2str(transet_opt),'_with_dist.txt']);
    tij=tij0(1:200,:);
    [ntij,~]=size(tij);
    lont_inlet=zeros(ntij,1);
    latt_inlet=zeros(ntij,1);
    for n=1:ntij
        lont_inlet(n)=lon(tij(n,1),tij(n,2));
        latt_inlet(n)=lat(tij(n,1),tij(n,2));
    end;
    eval(['lont_Inlet',num2str(transet_opt),'=lont_inlet;']);
    eval(['latt_Inlet',num2str(transet_opt),'=latt_inlet;']);
end;
my_tij_color='k';
my_tij_color2='none';
my_point_Inlet=[7,76,151]; % 0.5, 7.5, 15 km
%Inlet
hold on
plot(lont_Inlet1,latt_Inlet1,'Color',my_tij_color,'LineWidth',0.8);
plot(lont_Inlet1(my_point_Inlet(1:3)),latt_Inlet1(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
plot(lont_Inlet2,latt_Inlet2,'Color',my_tij_color,'LineWidth',0.8);
plot(lont_Inlet2(my_point_Inlet(1:3)),latt_Inlet2(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
plot(lont_Inlet3,latt_Inlet3,'Color',my_tij_color,'LineWidth',0.8);
plot(lont_Inlet3(my_point_Inlet(1:3)),latt_Inlet3(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])
plot(lont_Inlet4,latt_Inlet4,'Color',my_tij_color,'LineWidth',0.8);
plot(lont_Inlet4(my_point_Inlet(1:3)),latt_Inlet4(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);%[0.8500 0.3250 0.0980])

%% hurricane track
    plot(-track1(:,2),track1(:,1),'k-','LineWidth',1);
    plot(-track2(:,2),track2(:,1),'k-','LineWidth',1);
    plot(-track3(:,2),track3(:,1),'k-','LineWidth',1);
    plot(-track4(:,2),track4(:,1),'k-','LineWidth',1);
    plot(-track(:,2),track(:,1),'ko','Markersize',6);
    
    xshift=0.018;
    yshift=0.013;
    text(-77.9-xshift,34.1-yshift,'09/14 12:00','FontName',myfont,'FontSize',10)
    text(-78.4+0.005,34-0.01,'09/14 18:00','FontName',myfont,'FontSize',10)
%% zoom-in view frame for panel e
    hold on;
    FPT_XMIN=-78.07;
    FPT_XMAX=-77.87;
    FPT_YMIN=33.837;
    FPT_YMAX=34.35;
    xd(1)=FPT_XMIN;
    yd(1)=FPT_YMIN;
    xd(2)=FPT_XMIN;
    yd(2)=FPT_YMAX;
    xd(3)=FPT_XMAX;
    yd(3)=FPT_YMAX;
    xd(4)=FPT_XMAX;
    yd(4)=FPT_YMIN;
    xd(5)=FPT_XMIN;
    yd(5)=FPT_YMIN;
    plot(xd,yd,'r--','LineWidth',1); 
 
    hc=colorbar;
    set(hc,'ylim',[zmin zmax],'Units','normalized','position',[0.945, 0.1, 0.020, 0.801],'FontName',myfont,'FontSize',15);
    text(0.95,1.04,'Topography (m)','Units','normalized','FontName',myfont,'FontSize',15)

%% save figure
outfile=['figrue2_cd.png'];
print(gcf,'-dpng',outfile)  
% close(figure(1));

%% EOF