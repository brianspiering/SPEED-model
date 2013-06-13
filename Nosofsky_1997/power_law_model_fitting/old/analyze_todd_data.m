% Load Todd's data and fit power law
% 05/15/06 BJS
clear
close all
clc

% Load file
[rawrt,label] = xlsread('sub_1_rt.xls');
% [rawrt,label] = xlsread('sub_3_rt.xls');

% Clean
rt = rawrt(2,:);

% Average
counter = 1;
for x = 1:2:(length(rt)-1)
    avert(counter) = mean([rt(x),rt(x+1)]);
    counter = counter + 1;
end

% Create correctly formted response file 
col_1 = [1:length(avert)]';
col_2 = ones(length(avert),1);
col_3 = ones(length(avert),1);
col_4 = round(avert'*1000);
avert= col_4;
data = [col_1 col_2 col_3 col_4]

% Save
% Create data file
outfile = [cd '\Input\response.dat']; % for PC
fid = fopen([outfile],'w');
fprintf(fid,'%3i %2i %2i %5i\n',data' );
% Close response data file.
fclose(fid);

% Create param file
% [#_of_points horizational_asympote_start_range end_range]
% params = [length(avert) 0 min(col_4)];
params = [length(avert) -13000 -10000];
% Create data file
outfile = [cd '\Input\rtparams.dat']; % for PC
fid = fopen([outfile],'w');
fprintf(fid,'%3i %3i %4i \n',params');
% Close response data file.
fclose(fid);

disp('Files saved');

% Run model fit
!rtfit.exe 

% Load output parameters
loadcmd=['load ' cd '\Output\justparams.dat;'];
eval(loadcmd);	
hor_exp = justparams(1,1);
a_exp = justparams(1,2);
b_exp = justparams(1,3);
hor_pow= justparams(2,1);
a_pow = justparams(2,2);
b_pow = justparams(2,3);

% Setup plot
figure('Position',[38 480 591 379]);
hold on;
clf
ax=[0 length(avert) min(avert) max(avert)];
x= [1:length(avert)]';
tempy=avert;
plot(x,tempy,'r*');
hold on
axis(ax);
xlabel('Blocks')
ylabel('RT in ms')
title(label)
% Plot exp fit
y2 = a_exp*exp(b_exp*(1:length(avert))) + hor_exp ;
plot(x,y2,'b-');
hold off


% Setup plot
figure('Position',[1 40 591 379]);
hold on;
clf
ax=[0 length(avert) min(avert) max(avert)];
x= [1:length(avert)]';
tempy=avert;
plot(x,tempy,'r*');
hold on
axis(ax);
xlabel('Blocks')
ylabel('RT in ms')
title(label)
% Plot power fit
y3 = a_pow*x.^b_pow + hor_pow;
plot(x,y3,'b-');

hold off

