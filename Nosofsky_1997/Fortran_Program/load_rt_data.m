% Loads in response time data for the various trials of the simulation, the
% pot activations for the simulations, and computes the ratios of three to
% two factor learning activations.


for i = rel_trials 

    i
    
    load_cmd = ['load ' cd '\output\rt_trial_' num2str(i) '.dat'];
    eval(load_cmd);

    load_cmd = ['load ' cd '\output\rt_corr_trial_' num2str(i) '.dat'];
    eval(load_cmd);
    
    load_cmd = ['load ' cd '\output\activity_trial_' num2str(i) '.dat'];
    eval(load_cmd);


end
