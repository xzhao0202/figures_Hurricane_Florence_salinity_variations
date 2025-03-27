clc; clear all; close all;
%% figure 7 
addpath(genpath("../matlab_toolbox/"))
%----- options----
myfont='Arial';
fontsize=15; % for panel label
fontsize2=20;
markersize=8;
my_bij_color=[0.4 0.4 0.4];
my_tij_color=[0 0 0];
panel_lable={'(a)';'(b)';'(c)';'(d)';'(e)';...
              '(f)';'(g)';'(h)';'(i)';'(j)';...
              '(k)';'(l)';'(m)';'(n)';'(o)';...
              '(p)';'(q)';'(r)';'(s)';'(t)';...
              '(u)';'(v)';'(w)';'(x)';'(y)';};
%-----model grid----
load('../figure_2/data/Couple_domain.mat');
h_rho=combine_h;
[im_rho,jm_rho]=size(lon);
%% domain corner
FPT_XMIN=-78.07;
FPT_XMAX=-77.87;
FPT_YMIN=33.837;
FPT_YMAX=34.35;

dlon=0.3;
dlat=0.2;

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

%% my_point
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
%% figure layout
Nr=3;
Nc=7;

set(0,'DefaultFigureVisible','on');
h=figure;
set(gcf,'position',[10 10 910 755],'inverthardcopy','off','color',[1 1 1])
ha = tight_subplot(Nr,Nc,[.00 .00],[.01 .07],[.15 .15]);

%% salinity diff
map=load('MPL_RdBu.rgb');
map=flipud(map);
zmin=-10;
zmax=-zmin;
for ii = 1:Nc
    yy = year(ts(ii));
    mm = month(ts(ii));
    dd = day(ts(ii));
    hh = hour(ts(ii));
    min = minute(ts(ii));
    ts0 = [num2str(yy),num2str(mm,'%02d'),num2str(dd,'%02d'),...
               num2str(hh,'%02d'),num2str(min,'%02d')];
    clear tmp_plt
    for iexp=1:3
        if iexp==1  
            eval(['load(''./data/combined_salinity_exp4_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp4_6_',ts0,';']);
        elseif iexp==2
            eval(['load(''./data/combined_salinity_exp5_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp5_6_',ts0,';']);
        elseif iexp==3
            eval(['load(''./data/combined_salinity_exp3_6_',ts0,'.mat'');']);
            eval(['tmp_plt=combined_salinity_exp3_6_',ts0,';']);
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

        axes(ha(Nc*iexp-(Nc-ii)))
        set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',fontsize);
        hold on;warning off;
        skipz=(zmax-zmin)/100;
        colormap(map);
        contourf(lon,lat,tmp_plt,[zmin:skipz:zmax],'linestyle','none');
        
        % hydro-ocean bry
        hold on
        plot(lonb,latb,'Color',my_bij_color,'LineWidth',0.2);
        plot(lont,latt,'Color',my_tij_color,'LineWidth',0.2);
        plot(lont(my_point(1:3)),latt(my_point(1:3)),'o','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');
        plot(lont(my_point(4:6)),latt(my_point(4:6)),'^','Markersize',markersize,'MarkerFaceColor','k','MarkerEdgeColor','none');
        
        xticklabels({});yticklabels({});
        xticks({});yticks({})
        axis equal
        axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
        caxis([zmin zmax]);
        tag1=cell2mat(panel_lable(Nc*iexp-(Nc-ii)));
        text(-78.06,34.33,tag1,'FontSize',fontsize2)
    end;
end;

%% post appearances1
    axes(ha(end));
    hc = colorbar('Location','east');
    ap=get(gca,'position');
    caxis([zmin zmax]);
    set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.855 ap(2)+0.001 0.02 0.92],'FontName',myfont,'FontSize',15);
    hc.Ticks = linspace(-10, 10, 11) ; 
    hc.TickLabels = [{'<-10'};num2cell(-8:2:8)';{''}];    
    text(1.46,2.98, ">10",'Units','normalized','HorizontalAlignment', 'center','FontName',myfont,'FontSize',fontsize)
    text(1.6,1.5, "Salinity Difference",'Units','normalized','HorizontalAlignment', 'center','FontName',myfont,'FontSize',fontsize,'Rotation',-90)
    
    axes(ha(1)); ylabel({'Wind','(Exp4-Exp6)'});
    axes(ha(1+Nc*1));ylabel({'Runoff','(Exp5-Exp6)'});
    axes(ha(1+Nc*2));ylabel({'Wind + Runoff','(Exp3-Exp6)'});
    % title
    fontsize=15;
    for ii = 1:7
        axes(ha(ii));
        tag=cell2mat(target_str(ii));
        title({tag(1:10),tag(12:end)},'FontSize',fontsize,'FontWeight','normal');
    end;


%% save figure
outfile='figure7_estuary_salinity_diff_2D.png';
print(gcf,'-dpng',outfile);
%close(figure(1));

%% EOF

