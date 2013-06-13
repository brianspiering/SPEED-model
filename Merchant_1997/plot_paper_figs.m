function [figind]=plot_paper_figs(figind,plotflag,threshold,binsize)

global message
format compact g
disp('Creating plots');
disp('Please wait');

if plotflag(1) == 1 	% Generate Low Speed Putamen Spike Trains
	
	% Load response
	loadcmd=['load ' cd '\Fortran_Program\output\response.dat;'];
	eval(loadcmd);
	[r c]= size(response);
	
	% Load input
	loadcmd=['load ' cd '\Fortran_Program\input\merchant_stim.dat;'];
	eval(loadcmd);
	input = merchant_stim;
	input=input(1:r,:);% Cut it to length of responses
	
	stimspeeds = [20 27 33 40 47 53 60 67 73 80];
% 	stimspeeds = 20;
	all_output=[];
	
	% Number of trials per stim speed
	num_trials = 10;
	
	for current_speed = 1:length(stimspeeds)
	
		trial_ind=(find(input(:,3)==stimspeeds(current_speed)));
		trialcheat = 0;
        
        for trials = (length(trial_ind)-num_trials)+1:length(trial_ind) % Look at last set trials for each stim type
	            
			%load data
            current_trial=trial_ind(trials);
			loadcmd=['load ' cd '\Fortran_Program\output\Activations_T' num2str(current_trial) '.dat;'];
			eval(loadcmd);
			cmd=['data = Activations_T' num2str(current_trial) ';'];
			eval(cmd);
			
			act=data(:,1); % Putamen cell A
			
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
    title('Low Speed Putamen Spike Trains')
	ax=[2000 6500 10 40];
    axis(ax);
	hold off
		
	% Save output
	fid = fopen([cd '\low_speed_cell_per_stim_type.dat'],'W');
	fprintf(fid,'%5i %4.2f \n',all_output');% col 1 is time of spke % col 2 is stimtype (12.2 12.4 12.6
	fclose(fid);
	
	all_output
	disp('Done');
elseif plotflag(2) == 1 	% Generate High Speed Putamen Spike Trains
    % Load response
	loadcmd=['load ' cd '\Fortran_Program\output\response.dat;'];
	eval(loadcmd);
	[r c]= size(response);
	
	% Load input
	loadcmd=['load ' cd '\Fortran_Program\input\merchant_stim.dat;'];
	eval(loadcmd);
	input = merchant_stim;
	input=input(1:r,:);% Cut it to length of responses
	
	stimspeeds = [20 27 33 40 47 53 60 67 73 80];
% 	stimspeeds = 20;
	all_output=[];
	
	% Number of trials per stim speed
	num_trials = 10;
	
	for current_speed = 1:length(stimspeeds)
	
		trial_ind=(find(input(:,3)==stimspeeds(current_speed)));
		trialcheat = 0;
        
        for trials = (length(trial_ind)-num_trials)+1:length(trial_ind) % Look at last set trials for each stim type
	            
			%load data
            current_trial=trial_ind(trials);
			loadcmd=['load ' cd '\Fortran_Program\output\Activations_T' num2str(current_trial) '.dat;'];
			eval(loadcmd);
			cmd=['data = Activations_T' num2str(current_trial) ';'];
			eval(cmd);
			
			act=data(:,2); % Putamen cell B
			
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
    title('High Speed Putamen Spike Trains')
	ax=[2000 6500 10 40];
    axis(ax);
	hold off
		
	% Save output
	fid = fopen([cd '\high_speed_cell_per_stim_type.dat'],'W');
	fprintf(fid,'%5i %4.2f \n',all_output');% col 1 is time of spke % col 2 is stimtype (12.2 12.4 12.6
	fclose(fid);
	
	disp('Done');
elseif plotflag(3) == 1 	% Generate Low Speed Premotor Histograms
    % Load response
	loadcmd=['load ' cd '\Fortran_Program\output\response.dat;'];
	eval(loadcmd);
	[r c]= size(response);
	
	% Load input
	loadcmd=['load ' cd '\Fortran_Program\input\merchant_stim.dat;'];
	eval(loadcmd);
	input = merchant_stim;
	input=input(1:r,:);% Cut it to length of responses
	
	stimspeeds = [20 27 33 40 47 53 60 67 73 80];
% 	stimspeeds = 20;
	all_output=[];
	
	% Number of trials per stim speed
	num_trials = 10;
	
	for current_speed = 1:length(stimspeeds)
	
		trial_ind=(find(input(:,3)==stimspeeds(current_speed)));
		trialcheat = 0;
        
        for trials = (length(trial_ind)-num_trials)+1:length(trial_ind) % Look at last set trials for each stim type
	            
			%load data
            current_trial=trial_ind(trials);
			loadcmd=['load ' cd '\Fortran_Program\output\Activations_T' num2str(current_trial) '.dat;'];
			eval(loadcmd);
			cmd=['data = Activations_T' num2str(current_trial) ';'];
			eval(cmd);
			
			act=data(:,7); % Premotor cell A
			
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
             
            % Put Spike trains into bins
			counter =1;
			for time = 1:binsize:length(spiketrain)
                spikebins(counter) = sum(spiketrain(time:time+(binsize-1)));
                counter =counter+1;
			end       
      
            all_output=[all_output;spikebins];
            
    
        end
        
	end
	
	sum_spiketrains=sum(all_output);
	
	% Plot Spike Bins
	% Setup plot
	figure('Position',[616 423 660 443]);
	hold on;
	clf
	
	% Plot
	bar(sum_spiketrains,0.08,'k')
	title(['Low Speed Premotor Histogram']);  

	
	% Make it look pretty
	ax=[0 length(sum_spiketrains) 0 max(sum_spiketrains)+1];
     axis(ax);
	xlabel('Time');
	ylabel('Spikes');
	disp('Done');  
end
