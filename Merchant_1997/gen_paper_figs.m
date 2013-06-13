% function [figind]=gen_paper_figs(figind);

% Generate Figures for Paper
% BJS 08/10/06

% Setup up
clear;
figind=1;
clc;
close all;
warning off;
format short g
figure('Position',  [565 243 712 481]);
figind = figind +1;
plotflag=[0 0 0 0 ];
threshold =50;
binsize= 25;
% Title
title = uicontrol('Style', 'text', 'String', 'Generate Merchant Figures for Paper',...
        'Position', [200 825 500 30]);
set(title,'fontsize',18)

% Low Speed Putamen Spike trians
lowspdputbox = uicontrol('Style', 'checkbox', 'String', 'Low Speed Putamen Spike Trains',...
    'Position', [100 400 200 50],'Callback', 'plotflag(1) = get(lowspdputbox,''value'');');
% High Speed Putamen Spike trians
highspdutbox = uicontrol('Style', 'checkbox', 'String', 'High Speed Putamen Spike Trains',...
    'Position', [100 300 200 50],'Callback', 'plotflag(2) = get(highspdutbox,''value'');');
% Low Speed Precortex Histograms
lowspdprebox =  uicontrol('Style', 'checkbox', 'String', 'Low Speed Precortex Histograms',...
    'Position', [100 200 200 50],'Callback', 'plotflag(3) = get(lowspdprebox,''value'');');
% High Speed Precortex Histograms
highspdprebox =  uicontrol('Style', 'checkbox', 'String', 'High Speed Precortex Histograms',...
    'Position', [100 100 200 50],'Callback', 'plotflag(4) = get(highspdprebox,''value'');');


newfig = uicontrol('Style', 'pushbutton', 'String', 'Plot',...
        'Position', [580 325 75 50], 'Callback',...
        '[figind]=plot_paper_figs(figind,plotflag,threshold,binsize);'); 


% Threshold
thresholdtitle = uicontrol('Style', 'text', 'String', 'Threshold',...
    'Position', [580 300 75 15]);
thresholdinput = uicontrol('Style', 'edit',...
    'Position', [580 250 75 50], 'Callback', 'threshold=str2num(get(thresholdinput,''String''));');
set(thresholdinput,'string',threshold);
% Binsize
binsizetitle = uicontrol('Style', 'text', 'String', 'Binsize',...
    'Position', [580 150 75 15]);
binsizeinput = uicontrol('Style', 'edit',...
    'Position', [580 100 75 50], 'Callback', 'binsize=str2num(get(binsizeinput,''String''));');
set(binsizeinput,'string',binsize);










