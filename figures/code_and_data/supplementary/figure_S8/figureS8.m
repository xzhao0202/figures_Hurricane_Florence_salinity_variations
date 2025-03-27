clc; clear all; close all;
%% figure S8 
addpath(genpath("../../matlab_toolbox/"))
%----- options -----
fontsize =15;
myfont='Arial';
x_max=25;
EO_start=485;

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

%% figrue 
zmax=35; zmin=0;
skipz=(zmax-zmin)/100;
my_dash_color=[ 0 0 0];
iso_label=[0 0.5 2 18 30 35];
map=cmocean('haline');

Nc=5;
h=figure;
set(gcf,'position',[10 10 1800 1200],'inverthardcopy','off','color',[1 1 1])
ha = tight_subplot(size(target_str,1),Nc,[.011 .01],[.07 .07],[.15 .15]);

%% 1st column: Estuary-Ocean
for nn=1: size(target_str,1)
    t0=datestr(target_str(nn),'yyyymmddHHMM');
    eval(['load(''./data/combined_salinity_EO_vertical_profile_exp3_',t0,'.mat'');']);
    clear tmp;
    eval(['tmp=combined_salinity_EO_vertical_profile_exp3_',t0,';']);
    
    axes(ha(1+(nn-1)*Nc))
    colormap(map);
    contourf(distance2head,depth,tmp,[0:skipz:zmax],'linestyle','none');%colorbar
    hold on;grid on;
    contour(distance2head,depth,tmp,iso_label,'linestyle','-','Color',my_dash_color,'ShowText','on');
    caxis([zmin zmax]);
    set(gca,'FontSize',fontsize);
    ylim([-20,0]); yticks([-20:5:0]);
    if Nc==6
       yticklabels({});yticklabels({});
    end;
    xlim([0,x_max]); xticks([0:5:x_max]);
    if nn<size(target_str,1)
       xticklabels({});xticklabels({});
    end;
    if nn==1
       title('Estuary-Ocean Transect (EO)','FontSize',fontsize,'FontWeight','normal');
    end;
    
    text(1,-18,cell2mat(target_str(nn)),'FontSize',12);
end;

%% 2nd-4th column: Inlet1-4 transets

for transet_opt=1:4
for nn=1: size(target_str,1)
    t0=datestr(target_str(nn),'yyyymmddHHMM');
    eval(['load(''./data/combined_salinity_Inlet',num2str(transet_opt),'_vertical_profile_exp3_',t0,'.mat'');']);
    clear tmp;
    eval(['tmp=combined_salinity_Inlet',num2str(transet_opt),'_vertical_profile_exp3_',t0,';']);

    axes(ha(transet_opt+(nn-1)*Nc+Nc-4))
    colormap(map);
    contourf(distance2head,depth, tmp,[0:skipz:zmax],'linestyle','none');%colorbar
    hold on;grid on;
    contour(distance2head,depth, tmp,iso_label,'linestyle','-','Color',my_dash_color,'ShowText','on');
    caxis([zmin zmax]);
    set(gca,'FontSize',fontsize);

   ylim([-20,0]);   yticks([-20:5:0]);
   xlim([0,x_max]); xticks([0:5:x_max]);
   yticklabels({});yticklabels({});
    if nn<size(target_str,1)
       xticklabels({});xticklabels({});
    end;
    if nn==1
          title(['Inlet',num2str(transet_opt),' Transect'],'FontSize',fontsize,'FontWeight','normal'); 
    end;
    text(1,-18,cell2mat(target_str(nn)),'FontSize',12);
end;
end;

hc = colorbar('Location','east');
caxis([zmin zmax]);
ap=get(gca,'position');
set(hc,'ylim',[zmin zmax],'Units','normalized','Position',[0.86 ap(2) 0.015 0.86],'FontName',myfont,'FontSize',fontsize);
set(hc, 'YAxisLocation','right')
ylabel(hc,{'Salinity'},'FontSize',fontsize,'Rotation',0)
hc.Label.Position(1)=0.5;
hc.Label.Position(2)=35.9;
text(-1.65,-0.4, "Distance from Coastline (km)",'Units','normalized','HorizontalAlignment', 'center','FontName',myfont,'FontSize',fontsize)
text(-4.5,5.7, "Depth (m)",'Units','normalized','HorizontalAlignment', 'center','FontName',myfont,'FontSize',fontsize,'Rotation',90)

%% export figure
outfile=['figureS8_ocean_inlet_transect_vertical_profile.png'];
print(gcf,'-dpng',outfile);
% close(1)
%% EOF