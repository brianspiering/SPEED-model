figure

plot(rel_trials,rt_std(rel_trials)/sqrt(15000))
legend('RT Standard Error',2)
title(['Standard Error in Mean Estimates using  ' num2str(num_sims) ' Simulations'],'FontSize',14)

