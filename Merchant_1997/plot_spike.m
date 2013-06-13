function [sum_spiketrains] = plot_spike(num_trials,aorb,speed,threshold,binsize)

curdir= 'C:\Brian\Nicky\';

% Load response
loadcmd=['load ' curdir '\Expert_Fortran\output\response.dat;'];
eval(loadcmd);
[r c]= size(response);
lasttrial = response(r,1) * response(r,2);

% Load input
loadcmd=['load ' curdir '\Expert_Fortran\input\modelfbstim.dat;'];
eval(loadcmd);
cmd=['inputdata = modelfbstim;'];
eval(cmd);
inputdata=inputdata(1:lasttrial,:);

trial_ind=find(inputdata(:,3)==speed);
all_output=[];

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
	[r c]= size(data);
	x= [1:r]';
	if aorb(1) == 1
     act = data(:,7);
	elseif aorb(2) == 1
     act = data(:,8);
	end
	
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
	% Put Spike trains into bins
	counter =1;
	for time = 1:binsize:length(spiketrain)
        spikebins(counter) = sum(spiketrain(time:time+(binsize-1)));
        counter =counter+1;
	end       
      
    all_output=[all_output;spikebins];
    
end 


sum_spiketrains=sum(all_output);

% Plot Spike Bins
% Setup plot
figure('Position',[616 423 660 443]);
hold on;
clf

% Plot
bar(sum_spiketrains,0.08,'k')

% Title
if aorb(1) == 1
 title(['Low Speed for Stim ' num2str(speed) ' Spike Train']);  
elseif aorb(2) == 1
  title(['High Speed for Stim ' num2str(speed) ' Spike Train']); 
end

% Make it look pretty
ax=[0 length(sum_spiketrains) 0 max(sum_spiketrains)+1];
 axis(ax);
xlabel('Time');
ylabel('Spikes');

% Save output


% Title
if aorb(1) == 1
    filename=[cd '\sum_spiketrains_Low_Speed_' num2str(speed) '.dat'];
elseif aorb(2) == 1
    filename=[cd '\sum_spiketrains_High_Speed_' num2str(speed) '.dat'];
end
fid = fopen([filename],'W');
fprintf(fid,'%5i \n',sum_spiketrains');
fclose(fid);
