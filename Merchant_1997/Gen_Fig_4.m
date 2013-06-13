%Interface  User friendly interface for creating spike trains
% Take activation and convert to spike trains
% Notes:
% Denpendicies :
%     plot_spike
%  
%  July 7 2005		Brian Spiering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% October 29 05 BJS

% Setup up
clear;
clc;
close all;
warning off;
format long;
boxwidth  = 600;
boxheight = 600;
leftpos = 50;
boxlength = 150;
smallboxsize=[75 50];
smalltitlesize=[smallboxsize(1) 15];

figure('Position',  [50 250 boxwidth boxheight]);

num_trials = 10;
threshold   = 8;
aorb        = [1 0];
binsize     = 25; % Good values 25 50 100 200 250 500
speed = 20;

% Title
bigtitlesize = [275 30];
title = uicontrol('Style', 'text', 'String', 'Generate Spike Trains',...
        'Position', [boxwidth/2-bigtitlesize(1)/2 boxheight-bigtitlesize(2) bigtitlesize(1) bigtitlesize(2)]);
set(title,'fontsize',18)

% A Cell
Abox = uicontrol('Style', 'checkbox', 'String', 'A Only',...
    'Position', [leftpos boxheight/1.2 smallboxsize(1) smallboxsize(2)],'Callback', 'exclusiveradio(Abox,Bbox);aorb(1) = get(Abox,''value'');aorb(2) = get(Bbox,''value'');');
% B Cell
Bbox = uicontrol('Style', 'checkbox', 'String', 'B Only',...
    'Position', [leftpos+boxlength boxheight/1.2 smallboxsize(1) smallboxsize(2)],'Callback', 'exclusiveradio(Bbox,Abox);aorb(1) = get(Abox,''value'');aorb(2) = get(Bbox,''value'');');

% Speed
speedtitle = uicontrol('Style', 'text', 'String', 'Stim Speed (20 27 33 40 47 53 60 67 73 80)',...
    'Position', [250 75 225 smalltitlesize(2)]);
speedinput = uicontrol('Style', 'edit',...
    'Position', [350 20 smallboxsize(1) smallboxsize(2)], 'Callback', 'speed=str2num(get(speedinput,''String''));');
set(speedinput,'string',speed);

% # of trials
trialstitle = uicontrol('Style', 'text', 'String', '# of Trials',...
    'Position', [leftpos boxheight/1.4 smalltitlesize(1) smalltitlesize(2)]);
trialsinput = uicontrol('Style', 'edit',...
    'Position', [leftpos boxheight/1.6 smallboxsize(1) smallboxsize(2)], 'Callback', 'num_trials=str2num(get(trialsinput,''String''));');
set(trialsinput,'string',num_trials);

% % Trial
% trialtitle = uicontrol('Style', 'text', 'String', 'Trial',...
%     'Position', [leftpos+boxlength boxheight/1.4 smalltitlesize(1) smalltitlesize(2)]);
% trialinput = uicontrol('Style', 'edit',...
%     'Position', [leftpos+boxlength boxheight/1.6 smallboxsize(1) smallboxsize(2)], 'Callback', 'trial=str2num(get(trialinput,''String''));');
% set(trialinput,'string',trial);


% Threshold
thresholdtitle = uicontrol('Style', 'text', 'String', 'Threshold',...
    'Position', [leftpos boxheight/1.8 smalltitlesize(1) smalltitlesize(2)]);
thresholdinput = uicontrol('Style', 'edit',...
    'Position', [leftpos boxheight/2.2 smallboxsize(1) smallboxsize(2)], 'Callback', 'threshold=str2num(get(thresholdinput,''String''));');
set(thresholdinput,'string',threshold);

% Bin Size
binsizetitle = uicontrol('Style', 'text', 'String', 'Bin Size',...
    'Position', [leftpos+boxlength boxheight/1.8 smalltitlesize(1) smalltitlesize(2)]);
binsizeinput = uicontrol('Style', 'edit',...
    'Position', [leftpos+boxlength boxheight/2.2 smallboxsize(1) smallboxsize(2)], 'Callback', 'binsize=str2num(get(binsizeinput,''String''));');
set(binsizeinput,'string',binsize);


% Creat New Figure
newfig = uicontrol('Style', 'pushbutton', 'String', 'Plot',...
        'Position', [leftpos+boxwidth/1.4 boxheight/1.2 smallboxsize(1) smallboxsize(2)], 'Callback',...
        'sum_spiketrains = plot_spike(num_trials,aorb,speed,threshold,binsize);');  