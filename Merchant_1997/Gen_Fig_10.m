% Gen Figure 10
% Pre-motor cortex
% BJS 10/22/05



%% Setup up
clear;
clc;
close all;
warning off;
disp('Running');
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
% stimspeeds = 20;
all_output=[];

% Number of trials per stim speed
num_trials = 10;

for current_speed = 1:length(stimspeeds)

	trial_ind=find(input(:,3)==stimspeeds(current_speed));
	trialcheat = 0;
    
    for trials = (length(trial_ind)-num_trials)+1:length(trial_ind)
		% Load
        current_trial=trial_ind(trials);
		block = ceil(current_trial/50);
		trial = current_trial-(block*50)+50;
        
		%load data
		loadcmd=['load ' curdir '\Expert_Fortran\output\NickyB' num2str(block) 'T' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = NickyB' num2str(block) 'T' num2str(trial) ';'];
		eval(cmd);
		
		act=data(:,8); % cell 
		threshold = 300;
		
		% Convert activation to spike trains
		oldact = 0;
		for time =1:length(act)
            currentact=[oldact+act(time)];
            if currentact >= threshold
                spiketrain(time) = 1;
                oldact=0;
            else
                spiketrain(time) = 0;
                oldact=currentact;
            end
         
		end
     
        spikelocations=find(spiketrain==1);
        
        % Convert Stimuli to Romo Space
        %[a b]= solve('12=a*20+b','30=a*80+b')
        romospeed=stimspeeds(current_speed)*3/10 + 6; % covert 20 to 12 etc
        current_romospeed=romospeed+trialcheat;% Stagger romo speed to make pretty graphs
        trialcheat=trialcheat+.2;
             
        % Put into Matrix
        one_speed_output=[spikelocations' ones(length(spikelocations),1)*current_romospeed ];
        all_output=[all_output;one_speed_output];
    end
    
end



% Create Graph
figure
hold on
scatter(all_output(:,1), all_output(:,2), 'k*')
% ax=[-500 5000 10 40];
% axis(ax);
hold off


% col 1 is time of spke 
% col 2 is stimtype (12.2 12.4 12.6
% Save output
fid = fopen([cd '\premotor_B_per_stim_type.dat'],'W');
fprintf(fid,'%5i %5i \n',all_output');
fclose(fid);

all_output
disp('Done');