figure

subplot(3,1,1)
plot(rel_trials,rt_std_error,'k')
legend('Reaction Time',1)
title(['Standard Error in Mean Estimates using  ' num2str(num_sims) ' Simulations'],'FontSize',14)
ylabel('milliseconds')

subplot(3,1,2)
plot(rel_trials,two_factor_std_error,'m')
legend('Two Factor Contribution',1)
ylabel('Activation Units')

subplot(3,1,3)
plot(rel_trials,three_factor_std_error,'g')
legend('Three Factor Contribution',1)
xlabel('Trial Number')
ylabel('Activation Units')