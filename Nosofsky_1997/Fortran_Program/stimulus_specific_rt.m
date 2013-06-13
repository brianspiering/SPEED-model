clear all
close all
home

rand('seed',sum(100*clock))

cd input
load master_stim_set.dat
file_name = [cd '\nosofsky_stim.dat'];
fid = fopen(file_name,'w');
fprintf(fid, '%i %i %i\n', randrows(master_stim_set)');
fclose(fid);    
load nosofsky_stim.dat
ns = nosofsky_stim;
cd ..

!nosofsky_prog_pro_rt.exe

cd output
load response.dat
cd ..

pos = [10 10; 10 50; 10 90;30 30; 30 70; 50 10; 50 50; 50 90; 70 10; 70 30; 70 70; 90 50];

for i = 1:12
    stim_ind{i} = find((ns(:,2)== pos(i,1))&(ns(:,3) == pos(i,2)));
end

num_trials = 120;

for i = 1:12
    for j = 1:num_trials
        rt(i,j) = response(stim_ind{i}(j+30),4);
    end
end

for i = 1:12
    rt_mean(i) = mean(rt(i,:));
    rt_std(i) = std(rt(i,:))/sqrt(num_trials);
end

figure
axis([0 100 0 100]);

for i = 1:12
    text(pos(i,1)-6,pos(i,2)+2, num2str(rt_mean(i)));
    text(pos(i,1)-5,pos(i,2)-3, num2str(rt_std(i)));
end

