clc; clear all; close all;
%% figure 3 basin precipitation & wind
addpath(genpath("../matlab_toolbox/"))
%----- options -----
myfont_size=18;
myfont='Arial';
x_interval=2;
ts_interval=1;
my_dash_color=[0.5 0.5 0.5];

%-----time series----
beg_time_str='2018-09-08 00:00:00';
end_time_str='2018-10-08 00:00:00';
ref_time_str='1858-11-17 00:00:00';

t0 = datetime(beg_time_str); 
t1 = datetime(end_time_str);
ts = [t0:hours(1):t1]';
dateRange = [ts(1),(ts(end))];

%% figure
h=figure;
set(gcf,'position',[10 10 1200 700],'inverthardcopy','off','color',[1 1 1])
t=tiledlayout(2,1,'TileSpacing','tight','Padding','loose');

%%----- rainfall -----
load('./data/rainrate_sum_basin_full_hr_ladsin.mat'); %% [mm/s]
clear my_var
my_var=rainrate_sum_basin_full_hr_ladsin(:,1:3); %% west, east, middle
    prcp_plot=my_var;
    %filter 3-hour smoothed
    for ii=1:3
        filtered_prcp_plot(:,ii) = sgolayfilt(prcp_plot(:,ii),1,3);
    end
    
    %% panel a
    nexttile(1);hold on;box on;
    colororder({'k','[0.3010 0.7450 0.9330]'})
    yyaxis left
        % bar
        bar_data=[prcp_plot(:,2),prcp_plot(:,3),prcp_plot(:,1)];
        b=bar(datenum(ts),bar_data,'EdgeColor','none','FaceAlpha',0.9);
        b(1).FaceColor = 'b';
        b(2).FaceColor = 'k';
        b(3).FaceColor = [0, 0.5, 0];
        
        plot(datenum(ts),filtered_prcp_plot(:,1),'Color',[0, 0.5, 0],'LineStyle','-','LineWidth', 3);
        plot(datenum(ts),filtered_prcp_plot(:,2),'b-','LineWidth', 2);
        plot(datenum(ts),filtered_prcp_plot(:,3),'k-','LineWidth', 2);

        ax.FontSize = myfont_size;
        set(gca,'FontSize',myfont_size,...
            'ylim',[0 45],'ytick',[0:10:45],...  
            'yticklabel',[0:10:45]);
        xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
        dateFormat = 'mm/dd';
        datetick('x',dateFormat,'keepticks', 'keeplimits');
        ticks = datenum(dateRange(1)):x_interval*(datenum(ts(ts_interval*24+1))-datenum(ts(1))):datenum(dateRange(2));
        xticks(ticks);
        xticklabels({});
        set(gca,'TickLength',[0.005, 0.005]);
        ylabel({'Rainfall Rate','(mm/s)'});
%%----- discharge -----
clear my_var
load('./data/discharge.mat');
    my_var=discharge;
    yyaxis right
    ff(1)=plot(datenum(ts(1:end-1)),my_var,'Color','[0.3010 0.7450 0.9330]','LineStyle','-','LineWidth',6);
    dmin=0; dmax=4000;
    
    ax.FontSize = myfont_size;
    set(gca,'FontSize',myfont_size,...
        'ylim',[dmin dmax],'ytick',[dmin:1000:dmax],...  
        'yticklabel',[dmin:1000:dmax])
    xlim([datenum(dateRange(1)),datenum(dateRange(end))]);
    dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):x_interval*(datenum(ts(ts_interval*24+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels({});
    set(gca,'TickLength',[0.005, 0.005])
    ylabel('Discharge (m^3/s)');
    
    %legend
    lg=legend([b(1:3),ff(1)],'West basin', 'Middle basin (CFRE)', 'East basin','Discharge','Location','northeast');
    lg.Position(1)=lg.Position(1)-0.003;
    lg.Position(2)=lg.Position(2)-0.013;
    fontsize=25;
    text(datenum('2018-09-08 06:00'),3750,'(a)','FontSize',fontsize)

%%----- Wind -----
load('./data/SUN2_wind.mat');
clear my_var
my_var=SUN2_wind;
    windSpeed = my_var(:,1);
    windDirection = my_var(:,2);
    windDirectionRad = deg2rad(270-windDirection);
    
    x = datenum(ts);              
    y = zeros(size(x));
    u = windSpeed .* cos((windDirectionRad));
    v = windSpeed .* sin((windDirectionRad));
    scalingFactor = 0.2;
    scaledU = u * scalingFactor;
    scaledV = v * scalingFactor;
    
    nexttile(2);hold on;box on;
    h = quiver(x, y, scaledU, scaledV, 0,'Color','k');
    h.MaxHeadSize = 0.02;
    h.LineWidth = 1.0;
    
    referenceMagnitude = 10; 
    refU = referenceMagnitude * scalingFactor;
    refV = 0; 
    hold on;
    h0=quiver(datenum(ts(355)), 2.75, refU, refV, 'k', 'LineWidth', 1.5);
    h0.MaxHeadSize = 0.4;
    h0.LineWidth = 1.0;
    text(datenum(ts(355)),3.,[num2str(referenceMagnitude),' m/s',],'FontSize',15)
    
    plot(x,y,'Color',my_dash_color,'LineWidth', 0.2);
    
    set(gca,'FontSize',myfont_size);
    set(gca, 'ytick', []);
    ylim([-2.9 4])
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):2*(datenum(ts(ts_interval*24+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels(datestr(ticks, dateFormat)); % Format the tick labels as Month Day, Year
    set(gca,'TickLength',[0.005, 0.005]);
    
    ylabel({'Wind Vector',''});
    text(datenum('2018-09-08 06:00'),3.58,'(b)','FontSize',fontsize)
    xlabel('Date in Year 2018');

%% save figure 
outfile='figure3.png';
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF