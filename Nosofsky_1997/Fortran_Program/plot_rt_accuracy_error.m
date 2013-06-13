% Plots the mean rt's and accuracy across trials

figure

subplot(4,1,1)
plot(rel_trials,accuracy_mean,'k')
legend('Accuracy',4)
title(['Mean Estimates and Standard Errors by Trial using ' num2str(num_sims) ' Simulations'],'FontSize',14)
ylabel('Proportion Correct')

subplot(4,1,2)
errorbar(rel_trials,rt_mean-5000,rt_std_error,'c')
axis([0 1000 0 2000]);
legend('Reaction Time',1)
ylabel('milliseconds')
hold on
plot(rel_trials,rt_mean-5000,'k')

subplot(4,1,3)
errorbar(rel_trials,two_factor_mean,two_factor_std_error,'m')
axis([0 1000 0 400]);
legend('Two Factor Contribution',4)
ylabel('Activation Units')
hold on 
plot(rel_trials,two_factor_mean,'k')
hold off

subplot(4,1,4)
errorbar(rel_trials,three_factor_mean,three_factor_std_error,'g')
axis([0 1000 0 400]);
legend('Three Factor Contribution',1)
ylabel('Activation Units')
xlabel('Trial Number')
hold on 
plot(rel_trials,three_factor_mean,'k')
hold off