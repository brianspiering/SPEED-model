			

clear
trial =1
	%load data
	curdir = cd;
	loadcmd=['load ' curdir '\Fortran_Program\output\Activations_T' num2str(trial) '.dat;'];
	eval(loadcmd);
	cmd=['data = Activations_T' num2str(trial) ';'];
	eval(cmd)
	
	
	% Setup plot
	[r c]= size(data);
	figure('Position',[664 286 591 378]);

	hold on;
	clf
	ax=[0 r 0 1];
	szmat = [2 4]; %rows and columns of graph
	dataind = 1;
		
	x= [1:r]';
    
	titlestr={'Caudate A cell'; 'Caudate B cell';'Globus Pallidus A Cell';'Globus Pallidus B Cell';
          'Thalamus A Cell'; 'Thalamus B Cell';'Pre-Motor A Cell'; 'Pre-Motor B Cell';};
      
	for plotnum = 1:8
       subplot(szmat(1), szmat(2), plotnum)     
       plot(x,data(:,plotnum),'g-'); hold on;
       title(titlestr(plotnum));  
       axis(ax);
	end