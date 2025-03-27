clc; clear all; close all;
%% figure 11 
addpath(genpath("../matlab_toolbox/"))
%----- options -----
ts_interval = 4;  % #outputs per hour
myfont='Arial';
my_dash_color=[ 0.5 0.5 0.5];
fontsize=18;
x_interval=2;

%----- time series ----
beg_time_str='2018-09-11 00:00:00';
end_time_str='2018-10-08 00:00:00';
ref_time_str='1858-11-17 00:00:00';

t0 = datetime(beg_time_str); 
t1 = datetime(end_time_str);
ts = [t0:hours(1/ts_interval):t1]';
ts = ts(1:end-1);
dateRange = [(ts(1)),(ts(end))];

%% figure
zmax=35;
zmin=0;
skipz=(zmax-zmin)/100;
map=cmocean('haline');
Nr=5;Nc=1;
panel_label={'(a) EO';'(b) Inlet1';'(c) Inlet2';'(d) Inlet3';'(e) Inlet4';};
h=figure; 
set(gcf,'position',[1 1 1000 900],'inverthardcopy','off','color',[1 1 1])
ha = tight_subplot(Nr,Nc,[.015 .00],[.07 .03],[.1 .1]);  

exp=3; %% exp3
%% a) Estuary-Ocean
clear tij dist2head tmp
    tij0=load('../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
    tij=tij0(485:660,:);
    dist2head=tij(:,3)-tij(1,3);
    load(['./data/plume_exp',num2str(exp),'_EO.mat']);
    eval(['tmp=plume_exp',num2str(exp),'_EO;']);
    
    axes(ha(1))
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
    hold on; 
    clear X Y
    [X,Y]=meshgrid(datenum(ts),dist2head(1:end));
    colormap(map);
    contourf(X',Y', tmp, [zmin:skipz:zmax],'linestyle','none');%colorbar
    set(gca,'YDir','reverse')
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    hold on;
    iso_label=[0 0.5 2 18 35];
    contour(X', Y', tmp, iso_label,'linestyle','-','Color',my_dash_color,'ShowText','on');
    
    hold on;
    [C,h] = contour(X', Y', tmp,[0 30 40],'linestyle','-','Color','k','LineWidth', 1.2,'ShowText','on');
    clabel(C,h,'FontSize',15,'Color','k')
    caxis([zmin zmax]);
    
    set(gca,'layer','top');
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    ylim([dist2head(1),dist2head(end)]);
    yticks([0:5:25]);
    set(gca,'YTickLabel',num2str([0:5:25]')); 
    dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):x_interval*(datenum(ts(ts_interval*24+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    xticklabels({});xticks({});
    text(datenum(ts(24)), 0.90*(0-25)+25,panel_label{1},'FontSize',25)
%% b-e) inlet
for ii=1:4
    clear tij dist2head tmp
    tij=load(['../figure_2/data/transect_ij/tr_inlet_ocean',num2str(ii),'_with_dist.txt']);
    dist2head=tij(:,3);
    eval(['load(''./data/plume_exp',num2str(exp),'_inlet',num2str(ii),'.mat'');']);
    eval(['tmp=plume_exp',num2str(exp),'_inlet',num2str(ii),';']);

    axes(ha(ii+1))
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
    [X,Y]=meshgrid(datenum(ts),dist2head(1:200));
    colormap(map);
    contourf(X',Y', tmp, [zmin:skipz:zmax],'linestyle','none');%colorbar
    set(gca,'YDir','reverse');
    set(gca, 'YGrid', 'on', 'XGrid', 'off')
    hold on;
    iso_label=[0 0.5 2 18 35];
    contour(X', Y', tmp, iso_label,'linestyle','-','Color',my_dash_color,'ShowText','on');
    
    hold on;
    [C,h] = contour(X', Y', tmp,[0 30 40],'linestyle','-','Color','k','LineWidth', 1.2,'ShowText','on');
    clabel(C,h,'FontSize',15,'Color','k')
    
    set(gca,'layer','top');
    set(gca,'FontSize',fontsize);
    xlim([datenum(dateRange(1)),datenum(dateRange(2))]);
    ylim([dist2head(1),dist2head(200)]);
    yticks([0:5:20]);set(gca,'YTickLabel',num2str([0:5:20]')); 
    dateFormat = 'mm/dd';
    datetick('x',dateFormat,'keepticks', 'keeplimits');
    ticks = datenum(dateRange(1)):x_interval*(datenum(ts(ts_interval*24+1))-datenum(ts(1))):datenum(dateRange(2));
    xticks(ticks);
    if ii<4
       xticklabels({});xticks({});
    elseif ii==4
       xticklabels(datestr(ticks, 'mm/dd')); 
    end;
    caxis([zmin zmax]);
    text(datenum(ts(24)), 0.90*(0-20)+20,panel_label{ii+1},'FontSize',25);
end;

ylabel(ha(3),'Distance from Coastline (km)','FontSize',fontsize)
xlabel(ha(5),'Date in Year 2018','FontSize',fontsize)

hc = colorbar('Location','east');
caxis([zmin zmax]);
ap=get(gca,'position');
set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.92 ap(2) 0.02 0.90],'FontName',myfont,'FontSize',fontsize);
set(hc, 'YAxisLocation','right')
ylabel(hc,{'Salinity'},'FontSize',fontsize,'Rotation',0)
hc.Label.Position(1)=0.5;
hc.Label.Position(2)=36.18;

%% save figure
outfile='figure11_plume.png';
print(gcf,'-dpng',outfile);
close(1);
%% EOF