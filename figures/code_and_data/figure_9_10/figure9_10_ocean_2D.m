clc; clear all; close all;
%% figure 9_10
addpath(genpath("../matlab_toolbox/"))
%----- options ----
fig_p=1; % 1: figure 9; 2: figure 10;

fontname='Arial';
fontsize=15; 
fontsize2=20;
my_point_Inlet=[7,76,151]; % 0.5, 7.5, 15 km
markersize=5;
markersize1=5;
my_tij_color=[0 0 0];
my_tij_color2='none';
% current
arrow_color=[1 1 1];
arrow_color2=[0.7 0.7 0.7];    
interval=55;
MaxHeadSize=4;
scalingFactor = 0.4;     
referenceMagnitude = 0.2; 
refU = referenceMagnitude * scalingFactor;
refV = 0; 
panel_lable={'(a)';'(b)';'(c)';'(d)';'(e)';...
              '(f)';'(g)';'(h)';'(i)';'(j)';...
              '(k)';'(l)';'(m)';'(n)';'(o)';...
              '(p)';'(q)';'(r)';'(s)';'(t)';};
%%-----model grid----
load('../figure_2/data/Couple_domain.mat');
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
tij0=load('../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
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
    tij0=load(['../figure_2/data/transect_ij/tr_inlet_ocean',num2str(ii),'_with_dist.txt']);
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

load('./data/grid_within_estuary.mat');
%----- time series ----
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
%% figure layout
FPT_XMIN=-78.7;
FPT_XMAX=-77.6;
FPT_YMIN=33.6;
FPT_YMAX=34.4;

dlon=0.3;
dlat=0.2;

Nr=4;
Nc=5;

set(0,'DefaultFigureVisible','on');
h=figure;
set(gcf,'position',[10 10 1400 800],'inverthardcopy','off','color',[1 1 1]);

ha = tight_subplot(Nr,Nc,[.00 .00],[.01 .07],[.035 .065]);
zmin=0.0;
zmax=35.0;
map=load('wh-bl-gr-ye-re.rgb');
map=map/280;

%% salinity
for ii = ii0:ii1
%     ii = 6
    if fig_p==1
       hii=ii;
    else
       hii=ii-size(ts,1)/2;
    end;
    ii
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')];
    load(['./data/salinity/combined_salinity_exp3_',ts0,'.mat']);
    clear tmp_plt
    eval(['tmp_plt=combined_salinity_exp3_',ts0,';']);
    eval(['clear combined_salinity_exp3_',ts0,';']);

    axes(ha(hii))
    set(gca,'box','on','Layer','top','FontName',fontname,'FontSize',fontsize);
    hold on
    warning off;
    skipz=(zmax-zmin)/100;
    colormap(map);
    contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');
 
    %% current
    hold on    
    clear u_bar v_bar
    load(['./data/current/combined_current_exp3_',ts0,'.mat']);
    clear u_con v_con lon_con lat_con
    u_con=u_bar; 
    v_con=v_bar;
    lon_con=lon(1:end-1,1:end-1);
    lat_con=lat(1:end-1,1:end-1);
    
    % Exclude grid data within estuary for visualization
    u_con(grid_within_estuary) = NaN;
    v_con(grid_within_estuary) = NaN;
    clear h
    h=quiver(lon_con(1:interval:end,1:interval:end),lat_con(1:interval:end,1:interval:end),...
            u_con(1:interval:end,1:interval:end)*scalingFactor,v_con(1:interval:end,1:interval:end)*scalingFactor,0);
    set(h,'color',arrow_color,'linewidth',0.6,'AlignVertexCenters','on',...
                   'MaxHeadSize',MaxHeadSize);
    
    hold on;
    h0=quiver(-78.5, 34.19, refU, refV, 0);
    set(h0,'color',arrow_color2,'linewidth',0.6,'AlignVertexCenters','on',...
                   'MaxHeadSize',2);
    text(-78.5,34.23,[num2str(referenceMagnitude),' m/s',],'Color',arrow_color2,'FontSize',12)
    hold on
    plot(lonb,latb,'Color',[0.3,0.3,0.3],'LineWidth',0.2);
    plot(lont,latt,'Color',my_tij_color,'LineWidth',0.8);
    plot(lont(my_point(1:3)),latt(my_point(1:3)),'s','Markersize',markersize1,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);
    %Inlet
    plot(lont_Inlet1,latt_Inlet1,'Color',my_tij_color,'LineWidth',0.8);
    plot(lont_Inlet1(my_point_Inlet(1:3)),latt_Inlet1(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);
    plot(lont_Inlet2,latt_Inlet2,'Color',my_tij_color,'LineWidth',0.8);
    plot(lont_Inlet2(my_point_Inlet(1:3)),latt_Inlet2(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);
    plot(lont_Inlet3,latt_Inlet3,'Color',my_tij_color,'LineWidth',0.8);
    plot(lont_Inlet3(my_point_Inlet(1:3)),latt_Inlet3(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);
    plot(lont_Inlet4,latt_Inlet4,'Color',my_tij_color,'LineWidth',0.8);
    plot(lont_Inlet4(my_point_Inlet(1:3)),latt_Inlet4(my_point_Inlet(1:3)),'o','Markersize',markersize,'MarkerFaceColor',my_tij_color2,'MarkerEdgeColor',my_tij_color);
    
    xticklabels({});yticklabels({});
    xticks({});yticks({})
    
    axis equal
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    tag1=cell2mat(panel_lable(hii));
    text(-78.65,34.35,tag1,'FontSize',fontsize2);
end;

%% salinity diff
map=load('MPL_RdBu.rgb');
map=flipud(map);
zmin=-10;
zmax=-zmin;
for ii = ii0:ii1
    if fig_p==1
       hii=ii;
    else
       hii=ii-size(ts,1)/2;
    end;
    ii
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')];
    for iexp=1:3
        clear tmp_plt
        if iexp==1  
            eval(['load(''./data/salinity_diff/combined_salinity_exp4_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp4_6_',ts0,';']);
            eval(['clear combined_salinity_exp4_6_',ts0,';']);
        elseif iexp==2
            eval(['load(''./data/salinity_diff/combined_salinity_exp5_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp5_6_',ts0,';']);
            eval(['clear combined_salinity_exp5_6_',ts0,';']);
        elseif iexp==3
            eval(['load(''./data/salinity_diff/combined_salinity_exp3_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp3_6_',ts0,';']);
            eval(['clear combined_salinity_exp3_6_',ts0,';']);
        end;
    
        for pp=1:im_rho
        for qq=1:jm_rho
            if tmp_plt(pp,qq) <= zmin
               tmp_plt(pp,qq) = zmin;
            end;
            if tmp_plt(pp,qq) >= zmax
               tmp_plt(pp,qq) = zmax;
            end;
        end;
        end;

        axes(ha(Nc*iexp-(Nc-hii)+Nc))
        set(gca,'box','on','Layer','top','FontName',fontname,'FontSize',fontsize);
        hold on
        warning off;
        skipz=(zmax-zmin)/100;
        colormap(map);
        contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');
       
        plot(lonb,latb,'Color',[0.3,0.3,0.3],'LineWidth',0.8);
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
        caxis([zmin zmax]);

        tag1=cell2mat(panel_lable(Nc*iexp-(Nc-hii)+Nc));
        text(-78.65,34.35,tag1,'FontSize',fontsize2)
    end;
end;

%% post appearances1
    zmin=-10;
    zmax=-zmin;
    axes(ha(end));
    hc = colorbar('Location','east');
    ap=get(gca,'position');
    caxis([zmin zmax]);
    set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.945 ap(2)+0.001 0.015 0.689],'FontName',fontname,'FontSize',15);
    hc.Ticks = linspace(-10, 10, 11) ; 
    hc.TickLabels = [{'<-10'};num2cell(-8:2:8)';{''}];
    text(1.21,2.98, ">10",'Units','normalized','HorizontalAlignment', 'center','FontName',fontname,'FontSize',fontsize)
    text(1.3,1.5, "Salinity Difference",'Units','normalized','HorizontalAlignment', 'center','FontName',fontname,'FontSize',fontsize,'Rotation',-90)
    
    axes(ha(1)); ylabel({'All forcings','(Exp3)'});
    axes(ha(1+Nc)); ylabel({'Wind','(Exp4-Exp6)'});
    axes(ha(1+Nc*2));ylabel({'Runoff','(Exp5-Exp6)'});
    axes(ha(1+Nc*3));ylabel({'Wind + Runoff','(Exp3-Exp6)'});
    
    % title
    fontsize=15;
    for ii = ii0:ii1
        if fig_p==1
           hii=ii;
        else
           hii=ii-size(ts,1)/2;
        end
        axes(ha(hii));
        title([cell2mat(target_str(ii))],'FontSize',fontsize);
    end

%% post appearances2
    map=load('wh-bl-gr-ye-re.rgb');
    map=map/280;
    for icb=1:Nc
        colormap(ha(icb),map)
    end
    zmin=0.0;
    zmax=35.0;
    axes(ha(Nc));  
    hc1 = colorbar('Location','east');
    ap=get(gca,'position');
    caxis([zmin zmax]);
    set(hc1,'ylim',[zmin zmax],'Units','normalized','Position',[0.945 ap(2)+0.002 0.015 0.228],'FontName',fontname,'FontSize',fontsize);
    hc1.Ticks = linspace(0, 35, 5) ; 
    hc1.TickLabels = [{''};num2cell(5:10:30)';{'>35'}];   
    text(1.17,0.040, "0",'Units','normalized','HorizontalAlignment', 'center','FontName',fontname,'FontSize',fontsize)
    text(1.3,0.5, "Salinity",'Units','normalized','HorizontalAlignment', 'center','FontName',fontname,'FontSize',fontsize,'Rotation',-90)

%% save figure
if fig_p==1
   outfile=['figure9_ocean_salinity_2D_p1.png'];
else
   outfile=['figure10_ocean_salinity_2D_p2.png'];
end;
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF

