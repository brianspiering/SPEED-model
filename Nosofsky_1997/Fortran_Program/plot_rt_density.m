% Computes and plots the rt density for a given trial.  Note that we must
% first run load_rt_data.m before this program will run properly.

h = 10;

trial_def
max_height = 9;

figure

for i = 1:length(trial)

    def_cmd = ['n = length(rt_corr_trial_' num2str(trial(i)) '(:,1));'];
    eval(def_cmd);
    
	file_name = [cd '\input\density_info.dat'];
	fid = fopen(file_name,'w');
	fprintf(fid,'%i %i %i\n', h, trial(i),n);
	fclose(fid);
	
 	! compute_density
	
	load_cmd = ['load ' cd '\output\density_output.dat'];
	eval(load_cmd);
	
	poss_rt_vals = 0:3500;
	
	subplot(3,3,i)
  
    plot(poss_rt_vals,density_output*1000,'k','LineWidth',2);
    axis([0 3500 0 max_height]);   
%     text_str = ['Trial ' num2str(trial(i))];
%     legend(text_str);
%    ylabel('density x 1000')
 
    set(gca, 'XTick', 0:1000:3000)
%    set(gca,'XTickLabel',[])
%    set(gca,'YTickLabel',[])
    
%     if (i == 2)
%         title_cmd = ['title(''Estimated Density Functions for Reaction Time by Trial (h = ' num2str(h) 'ms)'',''FontSize'',14)'];
%         eval(title_cmd)
%     end

    
end
