clc; clear all; close all;
%% figrue S1
addpath(genpath("../../matlab_toolbox/"))
%----- options -----
fig_p=1;
myfont='Arial';
fontsize=15; % for panel label
fontsize2=20;
markersize=8;
my_tij_color=[0.2 0.2 0.2];
pannel_label={'(a)';'(b)';'(c)';'(d)';'(e)';...
              '(f)';'(g)';'(h)';'(i)';'(j)';...
              '(k)';'(l)';'(m)';'(n)';'(o)';...
              '(p)';'(q)';'(r)';'(s)';'(t)';...
              '(u)';'(v)';'(w)';'(x)';'(y)';};
%----- model grid ----
load('../../figure_2/data/Couple_domain.mat');
h_rho=combine_h;%ncread(fname_grd,'h');
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
tij=load('../../figure_2/data/transect_ij/tr_long_left_with_dist.txt');
[ntij,~]=size(tij);
lont=zeros(ntij,1);
latt=zeros(ntij,1);
for n=1:ntij
    lont(n)=lon(tij(n,1),tij(n,2));
    latt(n)=lat(tij(n,1),tij(n,2));
end;
my_point=[30,50,100,148,245,467]; 
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

%% figure
Nr=2;
Nc=size(target_str,1)

set(0,'DefaultFigureVisible','on');
h=figure;
set(gcf,'position',[10 10 915 670],'inverthardcopy','off','color',[1 1 1])
ha = tight_subplot(Nr,Nc,[.00 .00],[.15 .15],[.15 .15]);

%% estuary
FPT_XMIN=-78.07;
FPT_XMAX=-77.87;
FPT_YMIN=33.837;
FPT_YMAX=34.35;

map=load('wh-bl-gr-ye-re.rgb');
map=map/280;
zmin=0.0;
zmax=35.0;
for ii = 1:Nc
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));

    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')];
    for jj=1:Nr
        clear tmp
        eval(['load(''./data/combined_salinity_exp',num2str(jj),'_',ts0,''');']); 
        eval(['tmp=combined_salinity_exp',num2str(jj),'_',ts0,';']);

        axes(ha(Nc*jj-(Nc-ii)))
        set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
        hold on
        warning off;
        skipz=(zmax-zmin)/100;
        colormap(map);
        contourf(lon,lat,tmp,[zmin:skipz:zmax],'linestyle','none');
        
        hold on
        plot(lonb,latb,'Color',[0.3,0.3,0.3],'LineWidth',0.2);
        plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
        plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])
        plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');%[0.8500 0.3250 0.0980])
        
        xticklabels({});yticklabels({});
        xticks({});yticks({})
        
        axis equal
        axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
        caxis([zmin zmax]);
        text(-78.06,34.33,cell2mat(pannel_label(Nc*jj-(Nc-ii))),'FontSize',fontsize2)
    end;
end;

%% post appearances1
axes(ha(end));
hc = colorbar('Location','east');
ap=get(gca,'position');
caxis([zmin zmax]);
set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.855 ap(2)+0.001 0.02 0.7],'FontName',myfont,'FontSize',15);
ylabel(hc,{'Salinity'},'FontSize',fontsize,'Rotation',0)
hc.Label.Position(1)=0.5;
hc.Label.Position(2)=36.8;

axes(ha(1)); ylabel({'Stand-alone';'(ROMS only)'});
axes(ha(1+Nc)); ylabel({'One-Way Coupled';'("Linked" ROMS)'});

for ii = 1:7
    axes(ha(ii));
    tag=cell2mat(target_str(ii));
    title({tag(1:10),tag(12:end)},'FontSize',fontsize,'FontWeight','normal');
end;

%% save figure
outfile='figureS1_estuary_salinity_exp12.png';
print(gcf,'-dpng',outfile);
% close(figure(1));

%% EOF

