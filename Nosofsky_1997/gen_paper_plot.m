function [figind] = gen_paper_plot(figind)
% Generate Nosofsky figure for SPeed paper
% BJS 08/11/06

disp('Please wait')

% Load data
% Load data
loadcmd=['load ' cd '\Fortran_Program\rt_corr_mean.dat;'];
eval(loadcmd);	

[r c] = size(rt_corr_mean);
rt = rt_corr_mean;

% Setup plot
figure
hold on;
clf
ax=[0 r min(rt)-100 max(rt)+100];
x= [1:r]';
y=rt;
plot(x,y,'r-');
hold on
title('Reaction time Unaveraged')
axis(ax);
hold off

% Find correct pertange per block 
smblksize = floor(r/30);
num_smblocks = 30;
model_ave_rt=[];
for nextsmblk = 0:num_smblocks-1
	nextsmblk_data = rt(nextsmblk*smblksize+1:nextsmblk*smblksize+smblksize,:);
	blockmean = mean(nextsmblk_data); 
	model_ave_rt=[model_ave_rt blockmean];
end

% Plot data
figure
plot(1:num_smblocks,model_ave_rt,'kd');
hold on
% axis([.9 num_smblocks 0 1.1])
xlabel('Block Number')
ylabel('Time')
title('Reaction time Averaged')


% Resave data 
newdata = [(1:30)' ones(30,1) ones(30,1) round(model_ave_rt')];
% Create data file
outfile =  [cd '\power_law_model_fitting\input\response.dat'];% for PC
fid = fopen([outfile],'w');
% Write to a data file.
for trial=1:length(model_ave_rt)
        fprintf(fid,'%3i %3i %3i %5i\n',newdata(trial,:)' );
end
% Close response data file.
fclose(fid);
disp('Averaged data saved')

% Run model

% Execute Fortran
cd power_law_model_fitting
!rtfit.exe
cd ..
disp('Ran model fit')

% Plot model fit
% Load data
loadcmd=['load ' cd '\power_law_model_fitting\output\predictedvalues.dat;'];
eval(loadcmd);	
x = predictedvalues(:,1);
powervals = predictedvalues(:,2);
expvals = predictedvalues(:,3);

% Plot
plot(x,powervals,'b.-');
plot(x,expvals,'rp-');
legend('Averaged Values (Model)','Predicted Expotential','Predicted Power');

% Display
% % Load parameters
loadcmd=['load ' cd '\power_law_model_fitting\input\rtparams.dat;'];
eval(loadcmd);
disp('# of points  horizational asympote start range & end range')
disp(rtparams)
% Load output file
fid= fopen([ cd '\power_law_model_fitting\output\explained.dat']);
x1= fgetl(fid);
x2= fgetl(fid);
x3= fgetl(fid);
x4= fgetl(fid);
disp(x1)
disp(x2)
disp(x3)
disp(x4)




