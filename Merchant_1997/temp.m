% Load response
	loadcmd=['load ' cd '\Fortran_Program\output\response.dat;'];
	eval(loadcmd);
	[r c]= size(response);
	
	% Load input
	loadcmd=['load ' cd '\Fortran_Program\input\merchant_stim.dat;'];
	eval(loadcmd);
	input = merchant_stim;
	input=input(1:r,:);% Cut it to length of responses
	
% 	stimspeeds = [20 27 33 40 47 53 60 67 73 80];
	stimspeeds = 20;
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