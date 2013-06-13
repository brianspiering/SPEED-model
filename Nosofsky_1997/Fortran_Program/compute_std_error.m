for i = rel_trials 
    
    i
    
    define_cmd = ['rt_std(' num2str(i) ') = std(rt_trial_' num2str(i) '(:,3));'];
    eval(rt_std_cmd)
    
    define_cmd = ['two_factor_std(' num2str(i) ') = std(activity_trial_' num2str(i) '(:,2));'];
    eval(define_cmd);    
 
    define_cmd = ['three_factor_std(' num2str(i) ') = std(activity_trial_' num2str(i) '(:,3));'];
    eval(define_cmd);    
    
    
end

rt_std_error = rt_std(rel_trials)/sqrt(15000);
two_factor_std_error = two_factor_std(rel_trials)/sqrt(15000);
three_factor_std_error = three_factor_std(rel_trials)/sqrt(15000);
