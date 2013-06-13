function [figind]=Plot_Control(figind,modflag,mapflag,trial)

global message

if modflag(1) == 1 %Plot Learning Curve
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\response.dat;'];
	eval(loadcmd);	
	data = response(:,2);
	[r c]= size(data);


    % Find correct pertange per block (all trials)
    smblksize = 50;
	num_smblocks = r/smblksize;
	subject_pbcorr=[];
	for nextsmblk = 0:num_smblocks-1
		nextsmblk_data = data(nextsmblk*smblksize+1:nextsmblk*smblksize+smblksize,:);
		numcorr = length(find(nextsmblk_data<16000)); 
		pbcorr = numcorr/smblksize;
	% 	pberror = 1 - pbcorr;
		subject_pbcorr=[subject_pbcorr pbcorr];
	end
    % Plot data
    figure('Position',[9 494 578 383])
	plot(1:num_smblocks,subject_pbcorr,'b*');
	hold on
	axis([.9 num_smblocks 0 1.1])
% 	xlabel('Blocks of 10 trials')
	ylabel('P (Correct)')
	title('Simrat''s Performance Go Trials')
	hold off
    figind=figind+1;
    
%     % Find correct pertange for No go trials
%     nogo_data_ind = find(data(:,4)==0);
%     nogo_data = data(nogo_data_ind,:); 
%     [r c]= size(nogo_data);
%     % Find correct pertange per block (all trials)
%     smblksize = 5;
% 	num_smblocks = r/smblksize;
% 	subject_pbcorr=[];
% 	for nextsmblk = 0:num_smblocks-1
% 		nextsmblk_data = nogo_data(nextsmblk*smblksize+1:nextsmblk*smblksize+smblksize,:);
% 		numcorr = length(find(nextsmblk_data(:,2)==nextsmblk_data(:,3))); % Compare reponse(col 3) to stim(col 4)
% 		pbcorr = numcorr/smblksize;
% 	% 	pberror = 1 - pbcorr;
% 		subject_pbcorr=[subject_pbcorr pbcorr];
% 	end
%     % Plot data
%     figure('Position', [690 465 560 420])
% 	plot(1:num_smblocks,subject_pbcorr,'bd-');
% 	hold on
% 	axis([.9 num_smblocks 0 1.1])
% 	xlabel('Block Number')
% 	ylabel('P (Correct)')
% 	title('Red''s Performance No-Go Trials')
% 	hold off
%     figind=figind+1;
end

if modflag(2) == 1% Plot parameters
    %%% Load Sum Activation
	
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\sumactive.dat;'];
	eval(loadcmd);	
	data = sumactive;
	[r c]= size(data);
	% visual  % Cuadate  % Pre-motor % Response % Stim
	
	%% Caudate
	y = data(:,2);
	
% 	% Remove no stim trials
% 	y = y(1:2:r,:);
% 	[r c]= size(y);
	x= [1:r]';
	
	% Plot
	figure('Position', [35 518 560 420]);
    figind=figind+1;
	plot(x,y)
	title('Caudate activation over experiment')
	
	%% Pre-motor
	y = data(:,3);
	
% 	% Remove no stim trials
% 	y = y(1:2:r,:);
% 	[r c]= size(y);
	x= [1:r]';
	
	% Plot
	figure('Position',[604 515 560 420]);
    figind=figind+1;
	plot(x,y)
	title('Pre-motor activation over experiment')
	
	%%% Plot Params
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\params.dat;'];
	eval(loadcmd);	
	data = params;
	[r c]= size(data);
	% Visual to Cuadate  % Visual to Pre-motor
	
	%% Visual to Caudate parameter
	y = data(:,1);
	x= [1:r]';
	
	% Plot
	figure('Position', [33 15 560 420]);
	figind=figind+1;
    plot(x,y)
	title('Visual to Caudate parameter over experiment')
	
	%% Visual to Pre-motor parameter
	y = data(:,2);
	x= [1:r]';
	
	% Plot
	figure('Position', [601 12 560 420]);
	figind=figind+1;
    plot(x,y)
	title('Visual to Pre Motor parameter over experiment')
end

if modflag(4) == 1% Plot activation of all cells
    
	%load data
	curdir = cd;
	loadcmd=['load ' curdir '\Fortran_program\output\ActivationsT' num2str(trial) '.dat;'];
	eval(loadcmd);
	cmd=['data = ActivationsT' num2str(trial) ';'];
	eval(cmd)
	
	[r c]= size(data);
	
	% Setup plot
	figure('Position', [695 245 577 338]);
    figind=figind+1;
	hold on;
	clf
	ax=[0 r 0 1];
	szmat = [2 4]; %rows and columns of graph
	dataind = 1;
		
	x= [1:r]';
    
	titlestr={'Caudate';'Globus Pallidus ';'Thalamus';'Pre-Motor';};
      
	for plotnum = 1:4
       subplot(szmat(1), szmat(2), plotnum)     
       plot(x,data(:,plotnum),'g-'); hold on;
       title(titlestr(plotnum));  
       axis(ax);
	end
	
              

    
end

if modflag(5) == 1 %Plot Reaction Time
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\response.dat;'];
	eval(loadcmd);	
	data = response;
	[r c]= size(data);
    rt=data(:,2);
	
    
	% Setup plot
	figure('Position',[8 25 596 384]);
	hold on;
	clf
	ax=[0 r 5000 max(rt)];
	x= [1:r]';
	tempy=rt;
	plot(x,tempy,'r*');
	hold on
	title('Reaction time')
	axis(ax);
	hold off
   
    figind=figind+1;
end

if modflag(6) == 1 %Plot DA levels
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\dope_levels.dat;'];
	eval(loadcmd);	
	data = dope_levels(:,2);
	[r c]= size(data);
     
	% Setup plot
	figure('Position',[8 25 596 384]);
	hold on;
	clf
	ax=[0 r 0 1];
	x= [1:r]';
	tempy=data;
	plot(x,tempy,'r*');
	hold on
	title('DA levels')
	axis(ax);
	hold off
   
    figind=figind+1;
end

if mapflag(7) == 1 %Motor Contrubitions
	% Load data
	loadcmd=['load ' cd '\Fortran_program\Output\prop.dat;'];
	eval(loadcmd);	
	data = prop;
	[r c]= size(data);
	totalact = data(:,2);
	twofac = data(:,3);
	threefac = data(:,4);
	decay = data(:,5);
	noise = data(:,6);

	
	
	% Setup plot
	figure('Position',[461 505 591 379]);
	figind=figind+1;
	hold on;
	clf
	x= [1:r]';
	y=twofac;
	ax=[0 r 0 max(y)];
	plot(x,y,'k*');
	hold on
	% 	title(['Contributions to Motor Output'])
	xlabel('Trial')
	ylabel('2 factor')
	axis(ax);
	hold off
	
	% Setup plot
	figure('Position',[568 270 591 379]);
	figind=figind+1;
	hold on;
	clf
	x= [1:r]';
	y=threefac;
	ax=[0 r 0 max(y)];
	plot(x,y,'k*');
	hold on
	% 	title('Contributions to Motor Output')
	xlabel('Trial')
	ylabel('3 factor')
	axis(ax);
	hold off
	
	% Setup plot
	figure('Position',[674 8 591 379]);
	figind=figind+1;
	hold on;
	clf
	x= [1:r]';
	y=noise;
	ax=[0 r 0 max(y)];
	plot(x,y,'k*');
	hold on
	% 	title('Contributions to Motor Output')
	xlabel('Trial')
	ylabel('noise')
	axis(ax);
	hold off
    
   % Setup plot
	figure('Position', [334 15 591 379]);
	figind=figind+1;
	hold on;
	clf
	x= [1:r]';
	y=threefac/twofac;
% 	ax=[0 r 0 max(y)];
	plot(x,y,'k*');
	hold on
	% 	title('Contributions to Motor Output')
	xlabel('Trial')
	ylabel('3 factor/2 factor')
% 	axis(ax);
	hold off


end