clc; clear all; close all;
%% figure 8
addpath(genpath("../matlab_toolbox/"))
%----- options -----
ts_interval = 4;  % #outputs per hour
dateFormat = 'mm/dd';
fontsize=18;
linewidth=3;
my_color={'[0.8500 0.3250 0.0980]';'[0 0.5 0]';'b'};
my_color2={'[0.9290 0.6940 0.1250]';'[0.55 0.55 0.55]';'[0.4940 0.1840 0.5560]';};
my_dash_color=[0.5 0.5 0.5];
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

beg_time_str='2018-09-11 00:00:00';
end_time_str='2018-10-08 00:00:00';
ref_time_str='1858-11-17 00:00:00';

t0 = datetime(beg_time_str); 
t1 = datetime(end_time_str);
ts = [t0:hours(1/ts_interval):t1]';
ts = ts(1:end); 
dateRange = [(ts(1)),(ts(end))];

%% figure
figure_wd=915; figure_ht=1000;
h=figure;
set(gcf,'position',[10 10 figure_wd figure_ht],'inverthardcopy','off','color',[1 1 1])
t=tiledlayout(4,1,'TileSpacing','Tight','Padding','Compact');
%%----- a) LE 3 points -----
nn=1
zmax=40; zmin=15;
load('./data/salinity_EO.mat')    
nexttile(nn);hold on;box on;
    for ii=1:3
        clear tmp3; 
        tmp3=salinity_EO(:,ii);
        plt(ii) = plot(datenum(ts), tmp3,'Color',my_color2{ii},'LineWidth',linewidth);
    end;
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);  
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks); 
    xticklabels(datestr(ticks, dateFormat)); 
    xticklabels({});

    set(gca,'TickLength',[0.003, 0.003]);
    ylabel( 'Salinity','FontSize',fontsize);
    hold on
    yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
    plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    ylim([zmin,zmax]);
    yticks([zmin:5:zmax])
    lg1=legend([plt(1:3)],'EO1','EO2','EO3','Location','southeast');  
    legend box off
    lg1.Position(1)=lg1.Position(1)-0.075;
    text(datenum(ts(24)), 0.93*(zmax-zmin)+zmin,'(a)','FontSize',25)
%%----- b-d) salinity diff -----
linstyle={'-.';'-';':'};
panel_label={'(b)';'(c)';'(d)'};
for nn=2:4
    clear tmp
    eval(['load(''./data/salinity_EO',num2str(nn-1),'_exp_diff.mat'');']);
    eval(['tmp=salinity_EO',num2str(nn-1),'_exp_diff;']);
    clear tmp3  tmp4  tmp5 tmp6; 
    tmp3=tmp(:,1);  %% EO1/2/3 exp3
    tmp4=tmp(:,2);  %% EO1/2/3 exp4
    tmp5=tmp(:,3);  %% EO1/2/3 exp5
    tmp6=tmp(:,4);  %% EO1/2/3 exp6

    nexttile(nn);hold on;box on;
    xx1=datenum(ts);yy1=zeros(size(xx1));
    plot(xx1, yy1,'-','Color',[.5 .5 .5],'LineWidth',0.5);
    clear plt
    plt(1)=plot(datenum(ts), tmp4(:)-tmp6(:),'Color',my_color{1},'LineStyle',linstyle{1},'LineWidth',linewidth);
    plt(2)=plot(datenum(ts), tmp5(:)-tmp6(:),'Color',my_color{2},'LineStyle',linstyle{2},'LineWidth',linewidth);
    plt(3)=plot(datenum(ts), tmp3(:)-tmp6(:),'Color',my_color{3},'LineStyle',linstyle{3},'LineWidth',linewidth);
  
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(24*ts_interval+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels(datestr(ticks, dateFormat)); 
    ylabel_h = ylabel( 'Salinity Difference','FontSize',fontsize); 

    if nn==2
       zmax=5;
       zmin=-18; 
       ylim([zmin,zmax]);
       yticks([-20:5:5])
    elseif nn==3
       zmax=5;
       zmin=-12;
       ylim([zmin,zmax]);
       yticks([zmin:4:zmax])
       ylabel_tmp= ylabel_h.Position(1);
    elseif nn==4
       zmax=4;
       zmin=-6
       ylim([zmin,zmax]);
       yticks([zmin:2:zmax])
       ylabel_h.Position(1)=ylabel_tmp;
    end;
    hold on
    yy0=[zmin:0.1:zmax];xx0=datenum(target_str)*ones(size(yy0));
    plot(xx0, yy0,'--','Color',my_dash_color,'LineWidth',0.8);
    set(gca,'TickLength',[0.003, 0.003]);
    %ylabel( 'Salinity Difference','FontSize',fontsize); 
    if (nn<4)
        xticklabels({});
    end;
    lgd=legend([plt(1:3)],'Wind','Runoff','Wind + Runoff','Location','southeast');
    lgd.Position(1)=lgd.Position(1)+0.005;
    legend box off
    text(datenum(ts(24)), 0.93*(zmax-zmin)+zmin,panel_label{nn-1},'FontSize',25)
end;
xlabel(t, 'Date in Year 2018','FontSize',fontsize);

%% save figure
outfile=['figure8_salinity.png'];
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF

