clc; clear all; close all;
%% figure 5
warning('off', 'MATLAB:hg:AutoSoftwareOpenGL');

%----- options -----
ts_interval = 4;  % #outputs per hour
plot_waterlevel=1;
plot_salinity=1;
dateFormat = 'mm/dd';
dash_on=1;
fontname='Arial';
fontsize=18;
fontsize2=25;
linewidth=3;
perc_ylim=0.92;
perc_xim=0.1;
my_color={'[0.8500 0.3250 0.0980]';'[0 0.5 0]';'b'};
my_color2={'[0.9290 0.6940 0.1250]';'[0.55 0.55 0.55]';'[0.4940 0.1840 0.5560]';};
my_color_wl={'m';'[0 0.4470 0.7410]';'[0.2 0.2 0.2]';'k';'[0.3010 0.7450 0.9330]';};
if dash_on==1
    my_dash_color=[0.7 0.7 0.7];
end

%-----time series----
target_str={'2018-09-11 05:00';...
            '2018-09-14 05:00';...
            '2018-09-15 01:00';...
            '2018-09-16 09:00';...
            '2018-09-16 19:00';...
            '2018-09-19 11:00';...
            '2018-10-06 00:00'...
            }; 
itime=[2;3;6]; % selected time points in panel a

beg_time_str='2018-09-11 00:00:00';
end_time_str='2018-10-08 00:00:00';
ref_time_str='1858-11-17 00:00:00';

t0 = datetime(beg_time_str); 
t1 = datetime(end_time_str);
ts = [t0:hours(1/ts_interval):t1]';
dateRange = [(ts(1)),(ts(end))];

%% transect ij 
tij=load('../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
[ntij,~]=size(tij);
dist_from_head=tij(:,3)-tij(1,3);  
my_point=[30,47,100,148,245,467];

%% figure
figure_wd=915; figure_ht=1000;

%% panel a) water level
if plot_waterlevel==1
h=figure(1);
set(gcf,'position',[10 10 figure_wd figure_ht],'inverthardcopy','off','color',[1 1 1])
    
    t=tiledlayout(4,1,'TileSpacing','Tight','Padding','Compact');
    load('./data/water_level_transect_location.mat');
    nexttile(1);hold on;box on;
    max_dist=3;min_dist=-0.5;
    
    xx=[dist_from_head(31) dist_from_head(81)  dist_from_head(81) dist_from_head(31)];
    yy=[-0.5 -0.5 3 3];
    p = patch(xx,yy,[0.4660, 0.6740, 0.1880],'FaceAlpha',0.1,'EdgeColor','none'); 
    text(4.3,2.5, 'Wetlands','FontName',fontname,'Fontsize',fontsize,'Color','[0.4660 0.6740 0.1880]')
    
    hold on
    for jj=1:3
        clear wl_tmp
        wl_tmp=water_level_transect_location(:,jj);
        plt(jj)=plot(dist_from_head,wl_tmp,'Color',char(my_color_wl{jj}),'LineWidth',linewidth);
        set(gca,'FontSize',fontsize);
        xlim([0,dist_from_head(485)]);
    end;
    %  ylim([min_dist,max_dist]);
    set(gca,'YLim',[min_dist,max_dist],'YTick',(0:1:3))
    yy_dist=max_dist*zeros(size(dist_from_head));
    plot(dist_from_head,yy_dist,'Color',my_dash_color,'LineStyle','-','LineWidth',1.2);
    yy_dist=[min_dist:0.1:max_dist]';
    for ii=1:size(my_point,2)
        xx_dist=dist_from_head(my_point(ii))*ones(size(yy_dist));
        plot(xx_dist,yy_dist,'Color',my_dash_color,'LineStyle','--','LineWidth',1.0);
    end;
    wlgd=legend([plt(1:3)],char(target_str(itime)),'Location','northeast'); 
    wlgd_pos = wlgd.Position;
    wlgd_pos(1)=wlgd_pos(1)-0.04;
    wlgd_pos(2)=wlgd_pos(2)-0.015;
    set(wlgd, 'Position', wlgd_pos)
    ylabel( {'Water Level (m)'},'FontSize',fontsize);
    xlabel( 'Distance from estuary head (km)','FontSize',fontsize);
    text(0.5, 0.935*(max_dist-min_dist)+min_dist,'(a)','FontSize',fontsize2)

%% save figure
    outfile=['figure5_a_water_level.png'];
    print(gcf,'-dpng',outfile);
% close(figure(1));
end;

%% b-c) salinity
if plot_salinity==1
h2=figure(2);
set(gcf,'position',[10 10 figure_wd figure_ht],'inverthardcopy','off','color',[1 1 1]);
t=tiledlayout(5,1,'TileSpacing','Tight','Padding','Compact');

%% b) LE 3 points
nn=1
load('./data/salinity_LE.mat')
  zmax=40; zmin=0;
  clear plt
  for ii=1:3
     clear tmp3
     tmp3=salinity_LE(:,ii);   %% exp3 LE
    
     nexttile(nn);hold on;box on;
     plt(ii) = plot(datenum(ts), tmp3(:,:),'Color',my_color2{ii},'LineWidth',linewidth);
    
     set(gca,'FontSize',fontsize);
     xlim([datenum(dateRange(1)),datenum(dateRange(2))]);  
     datetick('x',dateFormat,'keepticks', 'keeplimits');
     ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
     xticks(ticks); 
     xticklabels(datestr(ticks, dateFormat)); 
     xticklabels({});
     set(gca,'TickLength',[0.003, 0.003]);
     ylabel( 'Salinity','FontSize',fontsize);
   end; 

    hold on  
    if dash_on==1
        yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
        plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    end;

    ylim([zmin,zmax]);
    yticks([zmin:10:zmax])
    lgd1=legend([plt(1:3)],'LE1','LE2','LE3','Location','northeast');  

    lgd1.Position(1) = lgd1.Position(1)-0.14;
    lgd1.Position(2) = lgd1.Position(2)-0.003;
    legend box off
    text(datenum(ts(24)), perc_ylim*(zmax-zmin)+zmin,'(b)','FontSize',fontsize2)

 %% c) ES 3 points
 nn=3
 load('./data/salinity_ES.mat')
   clear plt
   for ii=1:3
     clear tmp3
     tmp3=salinity_ES(:,ii);

     nexttile(2);hold on;box on;
     plt(ii) = plot(datenum(ts), tmp3(:,:),'Color',my_color2{ii},'LineWidth',linewidth);

     set(gca,'FontSize',fontsize);
     xlim([datenum(dateRange(1)),datenum(dateRange(2))]);  
     datetick('x',dateFormat,'keepticks', 'keeplimits');
     ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
     xticks(ticks);
     xticklabels(datestr(ticks, dateFormat)); 
     zmax=40;zmin=0;
     xticklabels({});

     set(gca,'TickLength',[0.003, 0.003]);
     ylabel( 'Salinity','FontSize',fontsize);
   end; 

   hold on  
   if dash_on==1
      yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
      plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
   end;

   ylim([zmin,zmax]); yticks([zmin:10:zmax])
   lgd1=legend('ES1','ES2','ES3','Location','southeast');
   lgd1.Position(1) = lgd1.Position(1)-0.14;
   lgd1.Position(2) = lgd1.Position(2)+0.003;
   legend box off
   text(datenum(ts(24)), perc_ylim*(zmax-zmin)+zmin,'(c)','FontSize',fontsize2)

%% d-f) salinity diff
linstyle={'-.';'-';':'};
lg2_offset=0.055;
%% d) LE3 salinity diff
nn=3
load('./data/salinity_LE3_exp_diff.mat')
    clear tmp3  tmp4  tmp5 tmp6
    tmp3=salinity_LE3_exp_diff(:,1); %% LE3 exp3
    tmp4=salinity_LE3_exp_diff(:,2); %% LE3 exp4
    tmp5=salinity_LE3_exp_diff(:,3); %% LE3 exp5
    tmp6=salinity_LE3_exp_diff(:,4); %% LE3 exp6

    nexttile(3);hold on;box on;
    xx1=datenum(ts);yy1=zeros(size(xx1));
    plot(xx1, yy1,'-','Color',[.5 .5 .5],'LineWidth',0.5);
    clear plt
    plt(1)=plot(datenum(ts), tmp4(:,:)-tmp6(:,:),'Color',my_color{1},'LineStyle',linstyle{1},'LineWidth',linewidth);
    plt(2)=plot(datenum(ts), tmp5(:,:)-tmp6(:,:),'Color',my_color{2},'LineStyle',linstyle{2},'LineWidth',linewidth);
    plt(3)=plot(datenum(ts), tmp3(:,:)-tmp6(:,:),'Color',my_color{3},'LineStyle',linstyle{3},'LineWidth',linewidth);
      
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels(datestr(ticks, dateFormat)); 
    zmax=5;
    zmin=-30; 
    ylim([zmin,zmax]);
    yticks([-30:10:10])

    hold on
    if dash_on==1
        yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
        plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    end;

    xticklabels({});
    set(gca,'TickLength',[0.003, 0.003]);

    lgd2=legend([plt(1:3)],'Wind','Runoff','Wind + Runoff','Location','northeast');
    lgd2.Position(2) = lgd2.Position(2)-0.03;
    lgd2.Position(1) = lgd2.Position(1)-lg2_offset;
    legend box off
    ylabel( {'Salinity Difference'},'FontSize',fontsize);
    text(datenum(ts(24)), perc_ylim*(zmax-zmin)+zmin,'(d)','FontSize',fontsize2)

%% e) ES2 salinity diff
nn=4
load('./data/salinity_ES2_exp_diff.mat')
    clear tmp3  tmp4  tmp5 tmp6
    tmp3=salinity_ES2_exp_diff(:,1); %% ES2 exp3
    tmp4=salinity_ES2_exp_diff(:,2); %% ES2 exp4
    tmp5=salinity_ES2_exp_diff(:,3); %% ES2 exp5
    tmp6=salinity_ES2_exp_diff(:,4); %% ES2 exp6

    nexttile(nn);hold on;box on;
    xx1=datenum(ts);yy1=zeros(size(xx1));
    plot(xx1, yy1,'-','Color',[.5 .5 .5],'LineWidth',0.5);
    clear plt
    plt(1)=plot(datenum(ts), tmp4(:,:)-tmp6(:,:),'Color',my_color{1},'LineStyle',linstyle{1},'LineWidth',linewidth);
    plt(2)=plot(datenum(ts), tmp5(:,:)-tmp6(:,:),'Color',my_color{2},'LineStyle',linstyle{2},'LineWidth',linewidth);
    plt(3)=plot(datenum(ts), tmp3(:,:)-tmp6(:,:),'Color',my_color{3},'LineStyle',linstyle{3},'LineWidth',linewidth);
  
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels(datestr(ticks, dateFormat)); 
    ylim([zmin,zmax]);
    yticks([zmin:10:zmax])

    hold on
    if dash_on==1
        yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
        plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    end;
    xticklabels({});
    set(gca,'TickLength',[0.003, 0.003]);

    lgd2=legend([plt(1:3)],'Wind','Runoff','Wind + Runoff','Location','northeast');  
    lgd2.Position(2) = lgd2.Position(2)-0.03;
    lgd2.Position(1) = lgd2.Position(1)-lg2_offset;
    legend box off
    ylabel( {'Salinity Difference'},'FontSize',fontsize);
    text(datenum(ts(24)), perc_ylim*(zmax-zmin)+zmin,'(e)','FontSize',fontsize2)

%% f) ES3 salinity diff
nn=5
load('./data/salinity_ES3_exp_diff.mat')
    clear tmp3  tmp4  tmp5 tmp6
    tmp3=salinity_ES3_exp_diff(:,1); %% ES3 exp3
    tmp4=salinity_ES3_exp_diff(:,2); %% ES3 exp4
    tmp5=salinity_ES3_exp_diff(:,3); %% ES3 exp5
    tmp6=salinity_ES3_exp_diff(:,4); %% ES3 exp6

    nexttile(nn);hold on;box on;
    xx1=datenum(ts);yy1=zeros(size(xx1));
    plot(xx1, yy1,'-','Color',[.5 .5 .5],'LineWidth',0.5);
    clear plt
    plt(1)=plot(datenum(ts), tmp4(:,:)-tmp6(:,:),'Color',my_color{1},'LineStyle',linstyle{1},'LineWidth',linewidth);
    plt(2)=plot(datenum(ts), tmp5(:,:)-tmp6(:,:),'Color',my_color{2},'LineStyle',linstyle{2},'LineWidth',linewidth);
    plt(3)=plot(datenum(ts), tmp3(:,:)-tmp6(:,:),'Color',my_color{3},'LineStyle',linstyle{3},'LineWidth',linewidth);

    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels(datestr(ticks, dateFormat)); 
    ylim([zmin,zmax]);
    yticks([zmin:10:zmax])

    hold on
    if dash_on==1
        yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
        plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    end;

    set(gca,'TickLength',[0.003, 0.003]);
    lgd2=legend([plt(1:3)],'Wind','Runoff','Wind + Runoff','Location','southeast');
    lgd2.Position(2) = lgd2.Position(2)+0.003;
    lgd2.Position(1) = lgd2.Position(1)-lg2_offset;
    legend box off

    ylabel( {'Salinity Difference'},'FontSize',fontsize);
    xlabel( 'Date in Year 2018','FontSize',fontsize);
    text(datenum(ts(24)), perc_ylim*(zmax-zmin)+zmin,'(f)','FontSize',fontsize2)

%% save figure
    outfile=['figure5_b2f_salinity.png'];
    print(gcf,'-dpng',outfile);
% close(figure(1));
end;

%% EOF