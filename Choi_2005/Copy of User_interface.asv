%Interface  User friendly interface for finding Vicky's parameters
% 
% Nicky 
% The offspring of Ned and Vicky (Visual Into Caudate)
% Notes:
% Many dependencies
%  
%  April 18 2005		Brian Spiering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Setup up

clear;

clc;
close all;
warning off;
format short g
figind = 1;
figure('Position',  [0 0 1200 747]);
modflag=[0 0 0 0 0 0];
mapflag=[0 0 0 0 0 0 0];
block =10;
trial =1;
curparamvalue=-1;

global message

% Title
title = uicontrol('Style', 'text', 'String', 'Model Choi Data',...
        'Position', [300 825 275 30]);
set(title,'fontsize',18)

% Display Intial Parameters
storedparmbox = uicontrol('Style', 'text', 'String', 'Stored Parameters',...
                'Position', [1 800 90 17]);
cmd = ['load ' cd '\Fortran_Program\input\choi_params.dat;'];
eval(cmd)
newParams=choi_params;

for curparam = 1:length(newParams)
	paraminput(curparam) = uicontrol('Style', 'text', 'String', num2str(newParams(curparam)), ...
        'Position', [10 700-(curparam*21) 75 17]);
end

% New Parameters    
newparmbox = uicontrol('Style', 'text', 'String', 'New Parameters',...
                'Position', [95 700 90 17]); 

% Output Labels
cmd = ['importdata ' cd '\Fortran_Program\input\choi_params_names.dat;'];
eval(cmd)

labels = ans;

for curlabel = 1:length(labels)
	currlabelbox = uicontrol('Style', 'text', 'String', labels(curlabel),...
            'Position', [200 700-(curlabel*21) 290 17]);
end

% % Type of Plot
% Plot learning Curve
Curve = uicontrol('Style', 'checkbox', 'String', 'Learning Curve',...
    'Position', [500 630 100 50],'Callback', 'modflag(1) = get(Curve,''value'');');
% Plot reaction time
Reactiontimebox = uicontrol('Style', 'checkbox', 'String', 'Reaction Time',...
    'Position', [610 630 100 50],'Callback', 'modflag(5) = get(Reactiontimebox,''value'');');

% Plot activation
Activationbox = uicontrol('Style', 'checkbox', 'String', 'Activations',...
    'Position', [610 600 100 50],'Callback', 'modflag(4) = get(Activationbox,''value'');');
% Plot activation
Paramsbox = uicontrol('Style', 'checkbox', 'String', 'Parameters',...
    'Position', [500 600 100 50],'Callback', 'modflag(2) = get(Paramsbox,''value'');');
% Plot DA levels
DAlevelsbox = uicontrol('Style', 'checkbox', 'String', 'DA Levels',...
    'Position', [500 540 100 50],'Callback', 'modflag(6) = get(DAlevelsbox,''value'');');
% Plot porportions of motor response
motoroutbox = uicontrol('Style', 'checkbox', 'String', 'Motor Output',...
    'Position', [610 540 100 50],'Callback', 'mapflag(7) = get(motoroutbox,''value'');');

% Trial
trialtitle = uicontrol('Style', 'text', 'String', 'Trial',...
    'Position', [750 620 75 15]);
trialinput = uicontrol('Style', 'edit',...
    'Position', [750 570 75 50], 'Callback', 'trial=str2num(get(trialinput,''String''));');
set(trialinput,'string',trial);

% Create Buttons
savebtn = uicontrol('Style', 'pushbutton', 'String', 'Save',...
    'Position', [500 325 75 50], 'Callback', 'saveparams(newParams)');
newfig = uicontrol('Style', 'pushbutton', 'String', 'Plot',...
        'Position', [580 325 75 50], 'Callback',...
        '[figind]=plot_Control(figind,modflag,mapflag,trial);');   
closelast = uicontrol('Style', 'pushbutton', 'String', 'Close Last',...
        'Position', [500 250 75 50], 'Callback', '[figind]=closefig(0,figind,message);');
closeall = uicontrol('Style', 'pushbutton', 'String', 'Close All',...
        'Position', [580 250 75 50], 'Callback', '[figind]=closefig(1,figind,message);');

% Execute Button
executebtn_normal = uicontrol('Style', 'pushbutton', 'String', 'Run',...
    'Position', [700 295 100 50], 'BackgroundColor',[1 0 0], 'Callback', 'execute(figind,1)');


fid = fopen('label_names.dat','w');
for i = 1:length(newparams)
    name = ['input_' num2str(i)]
    fprintf(fid,'%10s\n', name);
end
fclose(fid);

importdata label_names.dat;
input = ans;

for i = 1:length(newparams)
    
    input(i,:) = uicontrol('Style', 'edit',...
    'Position', [100 700-(i*21) 75 17], 'Callback', ['newParams(' num2str(i) ')=str2num(get(input(i),''String''));']);

end

% Message
message = uicontrol('Style', 'text', 'String', 'Nothing to say .... Yet',...
    'Position', [600 75 200 25]);    