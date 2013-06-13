% Computes the mean rt, mean accuracy, and mean ratio of 3 to 2 factor learning across simulations

for i = rel_trials
   
    i
    
    rt_mean_cmd = ['rt_mean(' num2str(i) ') = mean(rt_trial_' num2str(i) '(:,3));'];
    eval(rt_mean_cmd)
    
    rt_mean_cmd = ['rt_corr_mean(' num2str(i) ') = mean(rt_corr_trial_' num2str(i) '(:,3));'];
    eval(rt_mean_cmd)
    
    acc_cmd = ['accuracy_mean(' num2str(i) ') = length(find(rt_trial_' num2str(i) '(:,1) == rt_trial_' num2str(i) '(:,2)))/length(rt_trial_' num2str(i) '(:,1));'];
    eval(acc_cmd)
    
    define_cmd = ['total_activation_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,1));'];
    eval(define_cmd);    
    
    define_cmd = ['two_factor_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,2));'];
    eval(define_cmd);    
 
    define_cmd = ['three_factor_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,3));'];
    eval(define_cmd);    

    define_cmd = ['decay_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,4));'];
    eval(define_cmd);    
        
    define_cmd = ['noise_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,5));'];
    eval(define_cmd);    
    
    define_cmd = ['inhibition_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,6));'];
    eval(define_cmd);    
    
    define_cmd = ['ratio_mean(' num2str(i) ') = mean(activity_trial_' num2str(i) '(:,7));'];
    eval(define_cmd);   
        
end

rt_mean = rt_mean(rel_trials);
rt_corr_mean = rt_corr_mean(rel_trials);
accuracy_mean = accuracy_mean(rel_trials);
total_activation_mean = total_activation_mean(rel_trials);
two_factor_mean = two_factor_mean(rel_trials);
three_factor_mean = three_factor_mean(rel_trials);
decay_mean = decay_mean(rel_trials);
noise_mean =  noise_mean(rel_trials);
inhibition_mean = inhibition_mean(rel_trials);
ratio_mean = ratio_mean(rel_trials);

file_name = [cd '\rt_corr_mean.dat'];

fid = fopen(file_name,'w');
fprintf(fid,'%i\n',round(rt_corr_mean));
fclose(fid);

    