% Plots the mean rt's and accuracy across trials

numplots = 3;

figure

subplot(numplots,1,1)
plot(rel_trials,accuracy_mean,'k','LineWidth',2)
%legend('Accuracy',4)
%title(['Mean Estimates by Trial using ' num2str(num_sims) ' Simulations'],'FontSize',14)
%ylabel('Proportion Correct')

% set(gca, 'XTick', 0:200:1800)
% set(gca,'XTickLabel',[])
% set(gca,'YTickLabel',[])

subplot(numplots,1,2)
plot(rel_trials,rt_mean,'k','LineWidth',2)
%legend('Reaction Time',1)
%ylabel('milliseconds')

% set(gca, 'XTick', 0:200:1800)
% set(gca,'XTickLabel',[])
% set(gca,'YTickLabel',[])

% subplot(numplots,1,3)
% plot(rel_trials,two_factor_mean,'m')
% legend('Two Factor Contribution',4)
% ylabel('Activation Units')
% 
% subplot(numplots,1,4)
% plot(rel_trials,three_factor_mean,'g')
% legend('Three Factor Contribution',1)
% ylabel('Activation Units')

subplot(numplots,1,3)
plot(rel_trials,ratio_mean,'k','LineWidth',2)
%legend('Proportion of Learning Activation due to Three Factor',1)
%ylabel('Proportion')
%xlabel('Trial Number')
% 
% set(gca, 'XTick', 0:200:1800)
% set(gca,'XTickLabel',[])
% set(gca,'YTickLabel',[])
