% Plots the contribution of various components to the response activation

equil_mean = decay_mean + noise_mean + inhibition_mean;
non_three_factor_mean = equil_mean+two_factor_mean;
test_ratio_mean = three_factor_mean./(three_factor_mean+two_factor_mean+equil_mean-decay_mean);

figure

num_plots = 9;

subplot(num_plots,1,1)
plot(rel_trials,total_activation_mean(rel_trials),'k')
legend('Total Response Activation',2)
title(['Mean Estimates by Trial using ' num2str(num_sims) ' Simulations'],'FontSize',14)

subplot(num_plots,1,2)
plot(rel_trials,two_factor_mean(rel_trials),'b')
legend('Two Factor Contribution',4)

subplot(num_plots,1,3)
plot(rel_trials,three_factor_mean(rel_trials),'g')
legend('Three Factor Contribution',1)

subplot(num_plots,1,4)
plot(rel_trials,decay_mean(rel_trials),'m')
legend('Decay Contribution',4)

subplot(num_plots,1,5)
plot(rel_trials,noise_mean(rel_trials),'r')
legend('Noise Contribution',1)

subplot(num_plots,1,6)
plot(rel_trials,inhibition_mean(rel_trials),'c')
legend('Inhibition Contribution',4)

subplot(num_plots,1,7)
plot(rel_trials,equil_mean(rel_trials),'k')
legend('Sum of Non-learning Contributions',4)

subplot(num_plots,1,8)
plot(rel_trials,non_three_factor_mean(rel_trials),'k')
legend('Sum of Non-Three Factor',4)

subplot(num_plots,1,9)
plot(rel_trials,test_ratio_mean(rel_trials),'k')
legend('Proportion due to Three Factor',4)


xlabel('Trial Number')

