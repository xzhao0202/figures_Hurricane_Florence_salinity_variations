clc; clear all; close all;
%% figure S2
addpath(genpath("../../matlab_toolbox/"))
%----- options -----
fontsize =15;
myfont='Arial';
pannel_label={'(a)';'(b)';'(c)';'(d)';'(e)';...
              '(f)';'(g)';'(h)';'(i)';'(j)';...
              '(k)';'(l)';'(m)';'(n)';'(o)';...
              '(p)';'(q)';'(r)';'(s)';'(t)';};
%-----time series----
target_str={'2018-09-11 05:00';...
            '2018-09-14 05:00';...
            '2018-09-15 01:00';...
            '2018-09-16 09:00';...
            '2018-09-16 19:00';...
            '2018-09-19 11:00';...
            '2018-09-29 03:00';...
            '2018-10-06 00:00'...
            };  

%% figrue 
zmax=35; zmin=0;
skipz=(zmax-zmin)/100;
my_dash_color=[ 0 0 0];
iso_label=[0 0.5 2 18 30 35];

map=load('wh-bl-gr-ye-re.rgb');
map=map/280;

Nc=1;
h=figure;
set(gcf,'position',[10 10 600 1100],'inverthardcopy','off','color',[1 1 1])
ha = tight_subplot(size(target_str,1),Nc,[.015 .01],[.15 .15],[.15 .15]);

%% LE
for nn=1: size(target_str,1)
    t0=datestr(target_str(nn),'yyyymmddHHMM');
    eval(['load(''./data/combined_salinity_estuary_vertical_profile_exp3_',t0,'.mat'');']);
    clear tmp;
    eval(['tmp=combined_salinity_estuary_vertical_profile_exp3_',t0,';']);
    
    axes(ha(nn))
    colormap(map);
    contourf(distance2head,depth,tmp,[0:skipz:zmax],'linestyle','none');
    hold on;grid on;
    contour(distance2head,depth,tmp,iso_label,'linestyle','-','Color',my_dash_color,'ShowText','on');
    caxis([zmin zmax]);
    set(gca,'FontSize',fontsize);
    ylim([-20,0]); yticks([-20:5:0]);
    if nn<size(target_str,1) 
       xticklabels({});xticklabels({});
    end;
    text(0.5,-18,cell2mat(target_str(nn)),'FontSize',12);
    text(0.5,-2,cell2mat(pannel_label(nn)),'FontSize',fontsize)
end;

%% post apperance
hc = colorbar('Location','east');
caxis([zmin zmax]);
ap=get(gca,'position');
set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.86 ap(2) 0.03 0.7],'FontName',myfont,'FontSize',fontsize);
set(hc, 'YAxisLocation','right')
ylabel(hc,{'Salinity'},'FontSize',fontsize,'Rotation',0)
hc.Label.Position(1)=0.5;
hc.Label.Position(2)=36.2;
xlabel('Distance from Land-Ocean Boundray (km)','FontName',myfont,'FontSize',fontsize)
text(-0.1,4.7, "Depth (m)",'Units','normalized','HorizontalAlignment', 'center','FontName',myfont,'FontSize',fontsize,'Rotation',90)

%% export figure
outfile=['figureS2_estuary_vertical_profile.png'];
print(gcf,'-dpng',outfile);
% close(1)
%% EOF

