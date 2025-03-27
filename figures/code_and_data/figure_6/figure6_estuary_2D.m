clc; clear all; close all;
%% figrue 6
addpath(genpath("../matlab_toolbox/"))
%----- options -----
my_bij_color=[0.4 0.4 0.4];
my_tij_color=[0.1 0.1 0.1];
fontname='Arial';
fontsize=15;
cb_fontsize=14;
%-----time series----
target_str={'2018-09-11 05:00';...
            '2018-09-14 05:00';... 
            '2018-09-15 01:00';...
            '2018-09-16 09:00';...
            '2018-09-16 19:00';...
            '2018-09-19 11:00';...
            '2018-10-06 00:00'...
            };   
ts = datetime(target_str);
%----- model grid ----
load('../figure_2/data/Couple_domain.mat');
h_rho=combine_h;
[im_rho,jm_rho]=size(lon);
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
my_point=[30,47,100,148,245,467];  
%% figure setup
zmin=0; zmax=35;
map=load('wh-bl-gr-ye-re.rgb');
map=map/280;
dlon=0.3;
dlat=0.2;

Nr=3;
Nc=size(target_str,1);

h=figure;
set(gcf,'position',[1 1 1200 667],'inverthardcopy','off','color',[1 1 1])
t = tiledlayout(Nr,Nc,'TileSpacing', 'tight','Padding','compact' );

%% zoom-in view
FPT_XMIN=-78.02;
FPT_XMAX=-77.93;
FPT_YMIN=latt(170);
FPT_YMAX=34.3;

nexttile(1,[1 1]);
hold on; box on;
xticklabels({});

%% 1
ii=1
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['./data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);
    nn=0;
    nexttile(nn+ii,[1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    hold on; warning off;
    skipz=(zmax-zmin)/50;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none'); 
    % hydro-ocean bry
    hold on;box on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');

    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')
 
%% 2
ii=2
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);

    nexttile(nn+ii,[1  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none'); 
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')

%% 3
ii=3
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')] 
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);

    nexttile(nn+ii,[1  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');

    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')

%% 4
ii=4
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);
    
    nexttile(nn+ii,[1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');

    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')

%% 5
ii=5
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);

    nexttile(nn+ii,[Nr-2  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')

%% 6
ii=6
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);
    
    nexttile(nn+ii,[1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');

    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
   
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')

%% 7
ii=7
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);

    nexttile(nn+ii,[1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');

    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    
    tag=cell2mat(target_str(ii));
    title({[tag(1:10)];tag(12:16)},'FontName',fontname,'FontSize',fontsize,'FontWeight','normal')


%% zoom-out view
FPT_XMIN=-78.07;
FPT_XMAX=-77.87;
FPT_YMIN=33.837;
FPT_YMAX=34.35;
%% 1
ii=1
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);

    nn=1*Nc;
    nexttile(nn+ii,[Nr-1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none'); 
    % hydro-ocean bry
    hold on;box on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    %
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));
%% 2
ii=2
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])

    nexttile(nn+ii,[Nr-1  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));

%% 3
ii=3
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])
    
    nexttile(nn+ii,[Nr-1  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));

%% 4
ii=4
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])
    
    nexttile(nn+ii,[Nr-1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    %
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));

%% 5
ii=5
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])
    
    nexttile(nn+ii,[Nr-1  1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');  
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    tag=cell2mat(target_str(ii));

%% 6
ii=6
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])
    
    nexttile(nn+ii,[Nr-1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none');
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');    
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    
    tag=cell2mat(target_str(ii));
 
%% 7
ii=7
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')]
    load(['data/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';'])

    nexttile(nn+ii,[Nr-1 1]);
    hold on; box on;
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    hold on; warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,zmin:skipz:zmax,'linestyle','none'); 
    % hydro-ocean bry
    hold on;
    plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');
    plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',10,'MarkerFaceColor','k','MarkerEdgeColor','none');    
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    caxis([zmin zmax]);
    
    tag=cell2mat(target_str(ii));


%% post appearances
    hc = colorbar('Location','east');
    set(hc, 'YAxisLocation','right')
    ap=get(gca,'position');
    caxis([zmin zmax]);
    set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.96 ap(2) 0.02 ap(4)+0.295],'FontName',fontname,'FontSize',cb_fontsize);
    ylabel(hc,{'Salinity'},'FontSize',cb_fontsize,'Rotation',0)
    hc.Label.Position(1)=0.5;
    hc.Label.Position(2)=36.3;

%% save figure
outfile=['figure6_estuary_2D.png'];
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF