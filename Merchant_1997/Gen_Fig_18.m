% Psychometric functions
% BJS 10/31/05



%% Setup up
clear;
clc;
close all;
warning off;
format;
curdir= 'C:\Brian\Nicky\';

% Load response
loadcmd=['load ' curdir '\Expert_Fortran\output\response.dat;'];
eval(loadcmd);
[r c]= size(response);
lasttrial = response(r,1) * response(r,2);

% Load input
loadcmd=['load ' curdir '\Expert_Fortran\input\modelfbstim.dat;'];
eval(loadcmd);
cmd=['input = modelfbstim;'];
eval(cmd)
input=input(1:lasttrial,:);

stimspeeds = [20 27 33 40 47 53 60 67 73 80];
%  stimspeeds = 20;
all_output=[];

% Number of trials per stim speed
num_trials = 10;

for current_speed = 1:length(stimspeeds)

	trial_ind=find(input(:,3)==stimspeeds(current_speed));
	all_output_onetype=[];
    trials = (length(trial_ind)-num_trials)+1:length(trial_ind);
	correct_ind=find(response(trial_ind(trials),3)==1) ;
    p_correct=length(correct_ind)/num_trials;
    all_output=[all_output; [stimspeeds(current_speed) p_correct]];
    
end


romo_speeds=[12 14 16 18 20 22 24 26 28 30]';

% Save output
fid = fopen([cd '\p(A)_per_stim_type.dat'],'W');
fprintf(fid,'%5i %5i \n',all_output');
fclose(fid);


disp([romo_speeds all_output(:,2)])
disp('done')

% 	    
%  all_output(:,2) % P(A)
%   1-all_output(:,2)% P(B)