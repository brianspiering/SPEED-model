function [figind]=Plot_Control(figind,modflag,mapflag,trial)

global message

if modflag(1) == 1 %Plot Learning Curve
	% Load data
	loadcmd=['load ' cd '\Fortran_Program\Output\response.dat;'];
	eval(loadcmd);	
	data = response;
	[r c]= size(data);
	
	% Find correct pertange per block 
    smblksize = 50;
	num_smblocks = r/smblksize;
	subject_pbcorr=[];
	for nextsmblk = 0:num_smblocks-1
		nextsmblk_data = data(nextsmblk*smblksize+1:nextsmblk*smblksize+smblksize,:);
		numcorr = length(find(nextsmblk_data(:,2)==nextsmblk_data(:,3))); % Compare reponse(col 3) to stim(col 4)
		pbcorr = numcorr/smblksize;
	% 	pberror = 1 - pbcorr;
		subject_pbcorr=[subject_pbcorr pbcorr];
	end
	
	% Plot data
    figure('Position',[59 516 591 378])
	plot(1:num_smblocks,subject_pbcorr,'bd-');
	hold on
	axis([.9 num_smblocks 0 1.1])
	xlabel('Block Number')
	ylabel('P (Correct)')
	title('Nicky''s Performance')
	hold off
    figind=figind+1;
end

if modflag(2) == 1   % Plot Scatter
    figure('Position',[5 348 1269 532])
    figind=figind+1;
        % Load response file
	loadcmd=['load ' cd '\Fortran_Program\Output\response.dat;'];
	eval(loadcmd);	
    
        % Load input file
	loadcmd=['load ' cd '\Fortran_Program\input\nosofsky_stim.dat;'];
	eval(loadcmd);	
	stim = nosofsky_stim;
     
    plotind = 1;
    
    for block = 1:(length(response)/50)
	    
        % Open new figure window
        if block == 6
            figure('Position',[-7 260 1269 532]);%
            figind=figind+1;
             plotind = 1;
        elseif block == 11
              figure('Position',[0 -7 1269 532]);%
            figind=figind+1;
             plotind = 1;
        elseif block == 16
              figure('Position',[0 -7 1269 532]);%
            figind=figind+1;
             plotind = 1;
         
             
        end
    
		startpoint = block*50-49;
		stoppoint = block*50;
        disprows = startpoint:stoppoint;
	        
		% Set up for plots
		x = stim(disprows,2);
		y = stim(disprows,3);
		xyaxes=[0 100 0 100];
	
		% Plot correct response

		    subplot(2,5,plotind)
  
        
		corrcat = response(disprows,3);
		corresp =[corrcat x y];
		plot2dstim(corresp,xyaxes,0);
		title(['Correct Responses from ' num2str(startpoint)  ' to ' num2str(stoppoint)])
		xlabel('Orientation');
		ylabel('Spatial Frequency');
        	
        % Plot subject's response
       		     subplot(2,5,plotind+5)
       
       
        resp = response(disprows,2);
		subres =[resp x y];
		plot2dstim(subres,xyaxes,0);
		title(['Nicky''s Responses from ' num2str(startpoint)  ' to ' num2str(stoppoint)])
		xlabel('Orientation');
		ylabel('Spatial Frequency');
        
        plotind = plotind +1;
            
	end

    
end

if modflag(3) == 1% Plot counter of WA-WB synapse map

   % Plot A Only
   if mapflag(1) == 1 & mapflag(3) == 1
		%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthCaudAT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthCaudAT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[7 570 591 311])
        contour3(data)
        surface(data)
        axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Cauduate A Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   if mapflag(2) == 1 & mapflag(3) == 1
       	%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthPreMotAT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthPreMotAT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[649 571 619 310])
                contour3(data)
        surface(data)
       axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Pre-Motor A Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   
      % Plot B Only
   if mapflag(1) == 1 & mapflag(4) == 1
		%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthCaudBT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthCaudBT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[3 195 619 310])
        contour3(data)
        surface(data)
         axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Cauduate B  Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   if mapflag(2) == 1 & mapflag(4) == 1
       	%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthPreMotBT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthPreMotBT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[662 271 591 336])
                contour3(data)
        surface(data)
        axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Pre-Motor B Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   
   
    
    
      % Plot A-B (Difference) 
    if mapflag(1) == 1 & mapflag(5) == 1
		%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthCaudT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthCaudT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[43 59 591 379])
                contour3(data)
        surface(data)
        axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Cauduate A-B Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   if mapflag(2) == 1 & mapflag(5) == 1
       	%load data
		loadcmd=['load ' cd '\Fortran_Program\output\StrengthPreMotT' num2str(trial) '.dat;'];
		eval(loadcmd);
		cmd=['data = StrengthPreMotT' num2str(trial) ';'];
		eval(cmd)
        
        figure('Position',[656 59 591 379])
                contour3(data)
        surface(data)
         axis([0 100 0 100 -.005 .005])
        colorbar
        rotate3d
%         [cout,H,cf]=contourf(data);
%         colorbarf(cout,H);
        title(['Strength Pre-Motor A-B Trial ' num2str(trial)]);
        figind=figind+1;
%        set(message,'string','John gave me the right stuff')
   end
   

   
   
   
end

if modflag(4) == 1% Plot activation of all cells
    
    % Load response file
	loadcmd=['load ' cd '\Fortran_Program\Input\nosofsky_stim.dat;'];
	eval(loadcmd);	
	data = nosofsky_stim;
    
    % Plot Stimtype  
    if data(trial,1) == 1
		% Plot A pic
		cd pictures
		filename=['picA.jpeg'];
		A = imread(filename,'jpeg');
		figure('Position',  [131 448 250 176])
		image(A)
		axis off
		cd ..
    elseif data(trial,1) == 2
      	% Plot B pic
		cd pictures
		filename=['picB.jpeg'];
		A = imread(filename,'jpeg');
		figure('Position',  [131 448 250 176])
		image(A)
		axis off
		cd ..  
        
    end
    figind=figind+1;
%     
%     if data(50*(block-1)+trial,2:3) ~= [25 75] & data(50*(block-1)+trial,2:3) ~= [25 75] % One exemplar per category
%         % Plot Stim Number
%         if data(50*(block-1)+trial,2:3) == [10    90]
%             stimnum = 1;
% 		elseif  data(50*(block-1)+trial,2:3) == [ 50    90]
%             stimnum = 2;   
% 		elseif  data(50*(block-1)+trial,2:3) == [30    70]
%             stimnum = 3;    
% 		elseif  data(50*(block-1)+trial,2:3) == [70    70]
%             stimnum = 4; 
% 		elseif  data(50*(block-1)+trial,2:3) == [10    50]
%             stimnum = 5; 
% 		elseif  data(50*(block-1)+trial,2:3) == [50    50]
%             stimnum = 6; 
% 		elseif  data(50*(block-1)+trial,2:3) == [90    50]
%             stimnum = 7;
% 		elseif  data(50*(block-1)+trial,2:3) == [30    30]
%             stimnum = 8; 
% 		elseif  data(50*(block-1)+trial,2:3) == [ 70    30]
%             stimnum = 9;
% 		elseif  data(50*(block-1)+trial,2:3) == [10    10]
%             stimnum = 10;
% 		elseif  data(50*(block-1)+trial,2:3) == [50    10]
%             stimnum = 11;     
% 		elseif  data(50*(block-1)+trial,2:3) == [70    10]
%             stimnum = 12;     
% 		end
           
%         cmd=('filename=[''num'' num2str(stimnum) ''.jpg'']');
%         eval(cmd) 
%         		
% 		cd pictures
% 		A = imread(filename,'jpeg');
% 		figure('Position',  [245 724 222 200])
% 		image(A)
% 		axis off
% 		cd ..
%         figind=figind+1;    
%     end 
    
   
	%load data
	curdir = cd;
	loadcmd=['load ' curdir '\Fortran_Program\output\Activations_T' num2str(trial) '.dat;'];
	eval(loadcmd);
	cmd=['data = Activations_T' num2str(trial) ';'];
	eval(cmd)
	
	
	% Setup plot
	[r c]= size(data);
	figure('Position',[664 286 591 378]);
    figind=figind+1;
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
	
              

    
end

if modflag(5) == 1 %Plot Reaction Time
	% Load data
	loadcmd=['load ' cd '\Fortran_Program\Output\response.dat;'];
	eval(loadcmd);	
	data = response;
	[r c]= size(data);
    rt=data(:,4);
	
	% Setup plot
	figure('Position',[658 515 591 379]);
	hold on;
	clf
	ax=[0 r min(rt)-100 max(rt)+100];
	x= [1:r]';
	tempy=rt;
	plot(x,tempy,'r-');
	hold on
	title('Reaction time')
	axis(ax);
	hold off
   
    figind=figind+1;
end

if mapflag(6) == 1 %Plot Dopamine
	% Load data
	loadcmd=['load ' cd '\Fortran_Program\output\dope_levels.dat;'];
	eval(loadcmd);	
	data = dope_levels;
	[r c]= size(data);
    DA = data(:,2);
	
	% Setup plot
	figure('Position',[35 34 591 379]);
	hold on;
	clf
	ax=[0 r 0 1];
	x= [1:r]';
	tempy=DA;
	plot(x,tempy,'r*');
	hold on
	title('Dopamine')
	axis(ax);
	hold off
   
    figind=figind+1;
end

% if mapflag(7) == 1 %Motor Contrubitions
% 	% Load data
% 	loadcmd=['load ' cd '\Fortran_Program\Output\prop.dat;'];
% 	eval(loadcmd);	
% 	data = prop;
% 	[r c]= size(data);
% 	totalact = data(:,3);
% 	twofac = data(:,4);
% 	threefac = data(:,5);
% 	decay = data(:,6);
% 	noise = data(:,7);
% 	inhib = data(:,8);
% 	
% 	
% 	% Setup plot
% 	figure('Position',[461 505 591 379]);
% 	figind=figind+1;
% 	hold on;
% 	clf
% 	x= [1:r]';
% 	y=twofac;
% 	ax=[0 r 0 max(y)];
% 	plot(x,y,'k*');
% 	hold on
% 	% 	title(['Contributions to Motor Output'])
% 	xlabel('Trial')
% 	ylabel('2 factor')
% 	axis(ax);
% 	hold off
% 	
% 	% Setup plot
% 	figure('Position',[568 270 591 379]);
% 	figind=figind+1;
% 	hold on;
% 	clf
% 	x= [1:r]';
% 	y=threefac;
% 	ax=[0 r 0 max(y)];
% 	plot(x,y,'k*');
% 	hold on
% 	% 	title('Contributions to Motor Output')
% 	xlabel('Trial')
% 	ylabel('3 factor')
% 	axis(ax);
% 	hold off
% 	
% 	% Setup plot
% 	figure('Position',[674 8 591 379]);
% 	figind=figind+1;
% 	hold on;
% 	clf
% 	x= [1:r]';
% 	y=noise;
% 	ax=[0 r 0 max(y)];
% 	plot(x,y,'k*');
% 	hold on
% 	% 	title('Contributions to Motor Output')
% 	xlabel('Trial')
% 	ylabel('noise')
% 	axis(ax);
% 	hold off
%     
%    % Setup plot
% 	figure('Position', [334 15 591 379]);
% 	figind=figind+1;
% 	hold on;
% 	clf
% 	x= [1:r]';
% 	y=twofac/threefac;
% % 	ax=[0 r 0 max(y)];
% 	plot(x,y,'k*');
% 	hold on
% 	% 	title('Contributions to Motor Output')
% 	xlabel('Trial')
% 	ylabel('2 factor/3 factor')
% % 	axis(ax);
% 	hold off
% 
% 
% end
