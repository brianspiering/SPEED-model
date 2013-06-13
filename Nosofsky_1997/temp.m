format compact	
clear all
close all

% Load data
loadcmd=['load ' cd '\Expert_Fortran\Output\prop.dat;'];
eval(loadcmd);	
data = prop;
[r c]= size(data);
totalact = data(:,3);
twofac = data(:,4);
threefac = data(:,5);
decay = data(:,6);
noise = data(:,7);
inhib = data(:,8);
figind = 1

% Check sums
trial = 501;
sum = twofac + threefac + decay + noise + inhib
sumtrial = twofac(trial) + threefac(trial) + decay(trial) + noise(trial) + inhib(trial)
sum(trial)
totalact(trial)

% Setup plot
figure('Position',[99 507 591 379]);
figind=figind+1;
hold on;
clf
x= [1:r]';
y=sum;
ax=[0 r 0 max(y)];
plot(x,y,'k*');
hold on
% 	title(['Contributions to Motor Output'])
xlabel('Trial')
ylabel('sum')
axis(ax);
hold off


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
y=twofac./threefac;
ax=[0 r 0 max(y)];
plot(x,y,'k*');
hold on
% 	title('Contributions to Motor Output')
xlabel('Trial')
ylabel('2 factor/3 factor')
axis(ax);
hold off