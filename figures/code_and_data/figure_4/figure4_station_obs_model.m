clc; clear all; close all;
%% figrue 4
addpath(genpath("../matlab_toolbox/"))
%----- options -----
near_ZB_on=1;
pbias_val_on=1;
my_color_zb={'b'};
my_color1={'m';'[0.3010 0.7450 0.9330]]';'[0., 0., 0.]'};
my_color2={'[0.8500 0.3250 0.0980]';'[0, 0.5, 0]';'b';}; %% grean blue orange
fontsize=18;
fontsize2=15;
fontname='Arial';
x_interval=2;
my_dash_color=[0.5 0.5 0.5];
my_dash_width=0.1;

%-----time series----
beg_time_str='2018-09-11 00:00:00';
end_time_str='2018-10-08 00:00:00';
ref_time_str='1858-11-17 00:00:00';

t0 = datetime(beg_time_str); 
t1 = datetime(end_time_str);
ts = [t0:hours(1):t1]';

%% figure
h=figure;
set(gcf,'position',[10 10 910 750],'inverthardcopy','off','color',[1 1 1])
t=tiledlayout(3,1,'TileSpacing','Tight','Padding','Compact');
ts_plot = [t0-1/2:hours(1):t1]';
%% a) ZB
%% coupled WRF-Hydro (exp3)
load('./data/ZB_obs_model_salinity.mat');
obs_plot=ZB_obs_model_salinity(:,1); 

nexttile(1)
plot(datenum(ts_plot),obs_plot,'Color',char(my_color1{3}),'linestyle','-','linewidth',1.6)

hold on;
clear tmp_model
tmp_model=ZB_obs_model_salinity(:,2);
plot(datenum(ts_plot),tmp_model,'Color',char(my_color_zb),'linestyle','-','linewidth',2)

clear paired_data
good=find(~isnan(obs_plot(:,1)));
paired_data(:,1)=obs_plot(good,1);
paired_data(:,2)=tmp_model(good,1);
eval(['lr_exp3_hydro_ZB=fitlm(paired_data(:,1),paired_data(:,2));']);
pbias_val_ZB=corr(paired_data(:,1),paired_data(:,2));
rmse_ZB=rmse(paired_data(:,1),paired_data(:,2));
pbias_val_ZB = 100 * sum(paired_data(:,2)-paired_data(:,1)) / sum(paired_data(:,1));
pbias_val_ZB=pbias_val_ZB;

%% ROMS near ZB (exp1,2,3)
if near_ZB_on==1
   for ii = 1:3
    clear tmp_model
    tmp_model=ZB_obs_model_salinity(:,2+ii);
       
    hold on;
    plot(datenum(ts_plot),tmp_model,'Color',char(my_color2{ii}),'linestyle',':','linewidth',2)
    
    clear paired_data
    good=find(~isnan(obs_plot(:,1)));
    paired_data(:,1)=obs_plot(good,1);
    paired_data(:,2)=tmp_model(good,1);
    eval(['lr_exp',num2str(ii),'_ROMS_near_ZB=fitlm(paired_data(:,1),paired_data(:,2));']);
    rmse_val(ii)=rmse(paired_data(:,1),paired_data(:,2));
    pbias_val(ii) = 100 * sum(paired_data(:,2)-paired_data(:,1)) / sum(paired_data(:,1));
   end;
end;

title ('(a) Zeke''s Basin (ZB)','FontWeight','Normal')
ylabel('Salinity');
ax.FontSize = fontsize;
set(gca,'FontSize',fontsize,...
    'ylim',[0 37],'ytick',[0:5:35]);
xlim([datenum(ts(1)),datenum(ts(end))]);
set(gca,'TickLength',[0.005, 0.005]);
dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(ts(1)):x_interval*(datenum(ts(1*24+1))-datenum(ts(1))):datenum(ts(end));
    xticks(ticks);
    xticklabels({});

%% stat text
if near_ZB_on==1
   l2=19.8; l3=16.6;

    if pbias_val_on==1
        text(datenum('2018-09-25 13:45'),l3,[repmat(' ',[1, 1]),'PBIAS ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
    end;
    text(datenum('2018-09-25 18:00'),23,[repmat(' ',[1, 6]),'R^2 ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-09-25 18:00'),l2,'RMSE =','Color','k','FontSize',fontsize2,'FontName',fontname) 

    r2  =lr_exp3_hydro_ZB.Rsquared.Ordinary;
    if pbias_val_on==1
        text(datenum('2018-09-27 18:00'),26,'Coupled','Color',char(my_color_zb),'FontSize',fontsize2,'FontName',fontname)
        text(datenum('2018-09-27 18:00'),l3,[repmat(' ',[1, 2]),num2str(pbias_val_ZB,'%3.2f')],'Color',char(my_color_zb),'FontSize',fontsize2,'FontName',fontname)
    else
        text(datenum('2018-09-27 18:00'),23,'Coupled','Color',char(my_color_zb),'FontSize',fontsize2,'FontName',fontname)
    end;
    text(datenum('2018-09-27 18:00'),23,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color_zb),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-09-27 18:00'),l2,[repmat(' ',[1, 2]),num2str(rmse_ZB,'%3.2f')],'Color',char(my_color_zb),'FontSize',fontsize2,'FontName',fontname)

    r2  =lr_exp3_ROMS_near_ZB.Rsquared.Ordinary;
    if pbias_val_on==1;
        text(datenum('2018-09-30 6:00'),26,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
        text(datenum('2018-09-30 6:00'),l3,[repmat(' ',[1, 2]),num2str(pbias_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
    else
        text(datenum('2018-09-30 6:00'),23,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)   
    end;
    text(datenum('2018-09-30 6:00'),23,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-09-30 6:00'),l2,[repmat(' ',[1, 2]),num2str(rmse_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)

    r2  =lr_exp2_ROMS_near_ZB.Rsquared.Ordinary;
    if pbias_val_on==1
        text(datenum('2018-10-02 12:00'),26,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
        text(datenum('2018-10-02 12:00'),l3,[repmat(' ',[1, 2]),num2str(pbias_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
    else
        text(datenum('2018-10-02 12:00'),23,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
    end;
    text(datenum('2018-10-02 12:00'),23,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-10-02 12:00'),l2,[repmat(' ',[1, 2]),num2str(rmse_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)

    r2  =lr_exp1_ROMS_near_ZB.Rsquared.Ordinary;
    if pbias_val_on==1
        text(datenum('2018-10-04 12:00'),26,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
        text(datenum('2018-10-04 12:00'),l3,[repmat(' ',[1, 2]),num2str(pbias_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
    else
        text(datenum('2018-10-04 12:00'),23,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
    end;
    text(datenum('2018-10-04 12:00'),23,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-10-04 12:00'),l2,[repmat(' ',[1, 2]),num2str(rmse_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)

    if pbias_val_on==1 
       hh=12.3;
    else 
       hh=10.1;
    end;
end;

%% b)  SUN2
load('./data/SUN2_obs_model_salinity.mat');
clear obs_plot
obs_plot=SUN2_obs_model_salinity(:,1);

nexttile(2)
plot(datenum(ts_plot),obs_plot,'Color',char(my_color1{3}),'linestyle','-','linewidth',1.6)

for ii = 1:3
    clear tmp_model
    tmp_model=SUN2_obs_model_salinity(:,1+ii);
    
    hold on;
    plot(datenum(ts_plot),tmp_model,'Color',char(my_color2{ii}),'linestyle','-','linewidth',2)
    
    clear paired_data
    good=find(~isnan(obs_plot(:,1)));
    paired_data(:,1)=obs_plot(good,1);
    paired_data(:,2)=tmp_model(good,1);
    eval(['lr_exp',num2str(ii),'_SUN2=fitlm(paired_data(:,1),paired_data(:,2));']);
    rmse_val(ii)=rmse(paired_data(:,1),paired_data(:,2));
    pbias_val(ii) = 100 * sum(paired_data(:,2)-paired_data(:,1)) / sum(paired_data(:,1));
end;

title ('(b) West Station (SUN2)','FontWeight','Normal')
ylabel('Salinity');
ax.FontSize = fontsize;
set(gca,'FontSize',fontsize,...
    'ylim',[15 37],'ytick',[15:5:35],...  
    'yticklabel',[15:5:35])
xlim([datenum(ts(1)),datenum(ts(end))]);
set(gca,'TickLength',[0.005, 0.005]);
dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(ts(1)):x_interval*(datenum(ts(1*24+1))-datenum(ts(1))):datenum(ts(end));
    xticks(ticks);
    xticklabels({})

%% stat text
if pbias_val_on==1
    text(datenum('2018-09-27 20:00'),17,[repmat(' ',[1, 1]),'PBIAS ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-09-28'),21,[repmat(' ',[1, 6]),'R^2 ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-09-28'),19,'RMSE =','Color','k','FontSize',fontsize2,'FontName',fontname) 

r2  =lr_exp3_SUN2.Rsquared.Ordinary;
if pbias_val_on==1
    text(datenum('2018-09-30'),23,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-09-30'),17,[repmat(' ',[1, 2]),num2str(pbias_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-09-30'),17,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-09-30'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-09-30'),19,[repmat(' ',[1, 2]),num2str(rmse_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)

r2  =lr_exp2_SUN2.Rsquared.Ordinary;
if pbias_val_on==1
    text(datenum('2018-10-02 12:00'),23,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-10-02 12:00'),17,[repmat(' ',[1, 2]),num2str(pbias_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-10-02 12:00'),17,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-10-02 12:00'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-10-02 12:00'),19,[repmat(' ',[1, 2]),num2str(rmse_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)

r2  =lr_exp1_SUN2.Rsquared.Ordinary;
if pbias_val_on==1
    text(datenum('2018-10-04 12:00'),23,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-10-04 12:00'),17,[repmat(' ',[1, 2]),num2str(pbias_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-10-04 12:00'),17,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-10-04 12:00'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-10-04 12:00'),19,[repmat(' ',[1, 2]),num2str(rmse_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)

%% c) ILM2
load('./data/ILM2_obs_model_salinity.mat');
clear obs_plot
obs_plot=ILM2_obs_model_salinity(:,1);

nexttile(3)
plot(datenum(ts_plot),obs_plot,'Color',char(my_color1{3}),'linestyle','-','linewidth',1.6)

for ii = 1:3
    clear tmp_model
    tmp_model=ILM2_obs_model_salinity(:,1+ii);
    
    hold on;
    plot(datenum(ts_plot),tmp_model,'Color',char(my_color2{ii}),'linestyle','-','linewidth',2)

    clear paired_data
    good=find(~isnan(obs_plot(:,1)));
    paired_data(:,1)=obs_plot(good,1);
    paired_data(:,2)=tmp_model(good,1);
    eval(['lr_exp',num2str(ii),'_ILM2=fitlm(paired_data(:,1),paired_data(:,2));']);
    rmse_val(ii)=rmse(paired_data(:,1),paired_data(:,2));
    pbias_val(ii) = 100 * sum(paired_data(:,2)-paired_data(:,1)) / sum(paired_data(:,1));
end;

title ('(c) East Station (ILM2)','FontWeight','Normal')
ylabel('Salinity');
ax.FontSize = fontsize;
set(gca,'FontSize',fontsize,...
    'ylim',[15 37],'ytick',[15:5:35])
xlim([datenum(ts(1)),datenum(ts(end))]);
set(gca,'TickLength',[0.005, 0.005]);
dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(ts(1)):x_interval*(datenum(ts(1*24+1))-datenum(ts(1))):datenum(ts(end));
    xticks(ticks);
    datetick('x',dateFormat,'keepticks', 'keeplimits');

%% stat text
if pbias_val_on==1
    text(datenum('2018-09-27 19:30'),17,[repmat(' ',[1, 1]),'PBIAS ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-09-28'),21,[repmat(' ',[1, 6]),'R^2 ='],'Color','k','FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-09-28'),19,'RMSE =','Color','k','FontSize',fontsize2,'FontName',fontname) 

r2  =lr_exp3_ILM2.Rsquared.Ordinary;
if pbias_val_on==1
text(datenum('2018-09-30 6:00'),23,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-09-30 6:00'),17,[repmat(' ',[1, 2]),num2str(pbias_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-09-30 6:00'),17,'Coupled','Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-09-30 6:00'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-09-30 6:00'),19,[repmat(' ',[1, 2]),num2str(rmse_val(3),'%3.2f')],'Color',char(my_color2{3}),'FontSize',fontsize2,'FontName',fontname)

r2  =lr_exp2_ILM2.Rsquared.Ordinary;
if pbias_val_on==1
text(datenum('2018-10-02 12:00'),23,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-10-02 12:00'),17,[repmat(' ',[1, 2]),num2str(pbias_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-10-02 12:00'),17,'Linked','Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-10-02 12:00'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-10-02 12:00'),19,[repmat(' ',[1, 2]),num2str(rmse_val(2),'%3.2f')],'Color',char(my_color2{2}),'FontSize',fontsize2,'FontName',fontname)

r2  =lr_exp1_ILM2.Rsquared.Ordinary;
if pbias_val_on==1;
    text(datenum('2018-10-04 12:00'),23,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
    text(datenum('2018-10-04 12:00'),17,[repmat(' ',[1, 2]),num2str(pbias_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
else
    text(datenum('2018-10-04 12:00'),17,'Stand-alone','Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
end;
text(datenum('2018-10-04 12:00'),21,[repmat(' ',[1, 2]),num2str(r2,'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)
text(datenum('2018-10-04 12:00'),19,[repmat(' ',[1, 2]),num2str(rmse_val(1),'%3.2f')],'Color',char(my_color2{1}),'FontSize',fontsize2,'FontName',fontname)

xlabel(t,'Date in Year 2018','FontSize',fontsize)

%% save figure
outfile='figure4_station_obs_model.png';
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF