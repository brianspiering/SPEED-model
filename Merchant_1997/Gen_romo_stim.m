% Generate Merchant, Zainos, Herandez, Salina, & Romo data
clear
close all

stim_all_type = [];

% 10 exemplars
% 5 Low speed
% 5 High speed

% One set of stimuli
% romo_stim = [stim_num cat mm/sec]
romo_stim =[1  1 12 
            2  1 14
            3  1 16
            4  1 18
            5  1 20
            6  2 22
            7  2 24
            8  2 26
            9  2 28
            10 2 30];

xyaxes = [0 3 10 32];        
plot2dstim([romo_stim(:,2) romo_stim(:,2:3)],xyaxes)


% Generate all stimuli
for stimtype = 1:length(romo_stim)
    
   stim = romo_stim(stimtype,:);
   num_trials = 400;
   col_1 = stim(2)*ones(num_trials,1);
   col_2 = stim(3)*ones(num_trials,1);
   stim_one_type = [col_1 col_2];
   stim_all_type = [stim_all_type; stim_one_type];
   
end
   

% Convert to 100 by 100 space

% Convert X dimension
% Orginal Range: 12 - 30 
% New     Range: 20 - 80
%  [a b] = solve('20=12*a+b','80 = 30*a + b')
stim_all_type(:,2)=stim_all_type(:,2)*10/3 - 20;

% add extra colum
newcol = 50*ones(length(stim_all_type),1);

newstim=[stim_all_type(:,1) newcol  stim_all_type(:,2)];
% Plot converted stimuli
xyaxes = [0 100 0 100]        
plot2dstim(newstim,xyaxes)
% plot2dstim([stim_all_type(:,1) stim_all_type(:,1:2)],xyaxes)


% ABABABABABABAB
[r c]= size(newstim);
oddind  = (1:2:r);
evenind = (2:2:r);
Astim=newstim(1:r/2,:);
Astim=randrows(Astim);
Bstim=newstim((r/2)+1:r,:);
Bstim=randrows(Bstim);
newstim(oddind,:)=Astim;
newstim(evenind,:)=Bstim;
newstim=round(newstim);

% Save new stimuli
fid = fopen([cd '\Fortran_Program\Input\merchant_stim.dat'],'W');
fprintf(fid,'%i %3i %3i \n',newstim');
fclose(fid);