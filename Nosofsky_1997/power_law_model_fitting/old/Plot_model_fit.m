% Plot model fit
% BJS 02/027/06
clc
close all

%    Parameters for exp fit:       8.7726      -0.0003
%    Parameters for pow fit:       8.9301      -0.0454

% Load response
loadcmd=['load ' cd '\Input\response.dat;'];Tod
eval(loadcmd);	
rt= (response(:,4));
[r c] = size(rt); 

% Load input parameters
loadcmd=['load ' cd '\Input\rtparams.dat;'];
eval(loadcmd);	
num_trials = rtparams(1);
hoz_ast = rtparams(2);

% Load output parameters
loadcmd=['load ' cd '\Output\justparams.dat;'];
eval(loadcmd);	
a = justparams(1);
b = justparams(2);

% % Input paramters
% % Y = ae^bx
% disp(' ');
% disp('1. Y = ae^bx');
% disp('2. Y = ax^b');  
% exp_or_power = input('   1 or 2 :  ');

hor_exp = justparams(1,1)
a_exp = justparams(1,2)
b_exp = justparams(1,3)

hor_pow= justparams(2,1);
a_pow = justparams(2,2);
b_pow = justparams(2,3);


% Setup plot
figure('Position',[38 480 591 379]);
hold on;
clf
ax=[0 r min(rt)-100 max(rt)+100];
x= [1:r]';
tempy=rt;
plot(x,tempy,'r*');
hold on
% title('Reaction time Expotential Fit')

axis(ax);

y2 = a_exp*exp(b_exp*(1:r)) + hor_exp ;
plot(x,y2,'b-');

hold off

% Setup plot
figure('Position',[1 40 591 379]);
hold on;
clf
ax=[0 r min(rt)-100 max(rt)+100];
x= [1:r]';
tempy=rt;
plot(x,tempy,'r*');
hold on

% title('Reaction time Power Fit')

axis(ax);

y3 = a_pow*x.^b_pow + hor_pow;
plot(x,y3,'b-');

hold off


% save output for excel plotting
output = [y3];

fid = fopen(['c:\Brian\Speed_model_fitting\yvalues.dat'],'W');
fprintf(fid,'%3f \n',output');
fclose(fid);


        