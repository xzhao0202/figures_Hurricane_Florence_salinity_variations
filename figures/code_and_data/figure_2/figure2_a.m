clear;clc;close all
%% figure 2 panels a-b
addpath(genpath("../matlab_toolbox/"))
%----- options -----
bgcolor=[1.0 1.0 1.0];
myfont='Arial';
%% figure 2 panel (a)
figure;
set(gcf,'position',[10 50 700 800],'inverthardcopy','off','color',[1 1 1])
    FPT_XMIN=-85;
    FPT_XMAX=-70;
    FPT_YMIN=24;
    FPT_YMAX=43;
  
    set(gca,'box','on','Layer','top','FontName',myfont,'FontSize',15,'LineWidth',2);
    set(gca,'color',bgcolor);
    hold on
    
    set(gca,'FontSize',15);
    set(gca,'tickdir','none')
    axis tight 
    axis([FPT_XMIN FPT_XMAX FPT_YMIN FPT_YMAX])
    xlabel('Longitude') 
    ylabel('Latitude') 

    hold on
    bij=load('data/coastal_line.dat');
    plot(bij(:,1),bij(:,2),'Color',[0.2,0.2,0.2],'LineWidth',0.5);    
%% parent domain    
    clearvars lon lat im jm xd yd
    load('data/Carolinas.mat');
    [im,jm]=size(lon);
    xd=zeros(5,1);
    yd=zeros(5,1);
    xd(1)=lon(1,jm);
    yd(1)=lat(1,jm);
    xd(2)=lon(1,1);
    yd(2)=lat(1,1);
    xd(3)=lon(im,1);
    yd(3)=lat(im,1);
    xd(4)=lon(im,jm);
    yd(4)=lat(im,jm);
    xd(5)=lon(1,jm);
    yd(5)=lat(1,jm);
    plot(xd,yd,'k--','LineWidth',2);    
    clearvars lon lat im jm xd yd
 %% study domain
    load('data/Couple_domain.mat');
    [im,jm]=size(lon);
    xd=zeros(5,1);
    yd=zeros(5,1);
    xd(1)=lon(1,jm);
    yd(1)=lat(1,jm);
    xd(2)=lon(1,1);
    yd(2)=lat(1,1);
    xd(3)=lon(im,1);
    yd(3)=lat(im,1);
    xd(4)=lon(im,jm);
    yd(4)=lat(im,jm);
    xd(5)=lon(1,jm);
    yd(5)=lat(1,jm);
    plot(xd,yd,'r--','LineWidth',2);

%% hurricane track    
% load hurricane track
track=load('data/track.txt');
track1=load('data/track1.txt');
track2=load('data/track2.txt');
track3=load('data/track3.txt');
track4=load('data/track4.txt');  
    plot(-track1(:,2),track1(:,1),'k-','LineWidth',1);
    plot(-track2(:,2),track2(:,1),'k-','LineWidth',1);
    plot(-track3(:,2),track3(:,1),'k-','LineWidth',1);
    plot(-track4(:,2),track4(:,1),'k-','LineWidth',1);
    plot(-track(1:end-1,2),track(1:end-1,1),'ko','Markersize',6);
    
    xshift=0.23;
    yshift=0.3;
    text(-73.2-xshift-0.5,31.5-yshift+0.015,'09/13','FontName',myfont,'FontSize',12)
    text(-76.5-xshift-0.35,34.0-yshift,'09/14','FontName',myfont,'FontSize',12)
    text(-78.8-xshift-0.1,33.9-yshift,'09/15','FontName',myfont,'FontSize',12)
    text(-80.2-xshift-0.1,33.6-yshift,'09/16','FontName',myfont,'FontSize',12)
    text(-82.2-xshift-0.7,35.0,'09/17','FontName',myfont,'FontSize',12)
    
%% save figure
outfile=['figure2_a','.png'];
print(gcf,'-dpng',outfile)  
% close(figure(1));

%% EOF