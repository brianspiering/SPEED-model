% Creates histograms of rt data 

figure

binwidth = 1;
num_down = 1;
num_across = 1;
height = 70;
trial = [10 50 100 200 300 400 800 1400 2000];

for i = 1:length(trial)
	
	subplot(num_down,num_across,i)
	
    bins = 0:binwidth:3500;
    
	hist_cmd = ['hist(rt_trial_' num2str(trial(i)) '(:,3),bins);'];
    eval(hist_cmd)
    axis([0 3500 0 height]);    
    
    set(gca,'XTick',[0 2000])
    text_str = ['Trial ' num2str(trial(i))];
    legend(text_str);
    ylabel('frequency')
    
    if (i == 2)
        title(['Histograms for Reaction Time by Trial - ' num2str(num_sims) ' Simulations'],'FontSize',14)
    end
    
end