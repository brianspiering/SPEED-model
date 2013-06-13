clear			
%load data
            current_trial=1
			loadcmd=['load ' cd '\Fortran_Program\output\Activations_T' num2str(current_trial) '.dat;'];
			eval(loadcmd);
			cmd=['data = Activations_T' num2str(current_trial) ';'];
			eval(cmd);
			
			act=data(:,8)