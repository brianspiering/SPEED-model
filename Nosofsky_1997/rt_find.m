% This script will run nickylong_pro_rt many times and rename her response
% files according to the random seeds

load_cmd = ['load ' cd '\Fortran_Program\input\master_stim_set.dat'];
eval(load_cmd)

rand('seed',sum(100*clock))

for run_num = 1:num_sims;
    
    % Write random stimulus file
    file_name = [cd '\Fortran_Program\input\nosofsky_stim.dat'];
    fid = fopen(file_name,'w');
    fprintf(fid, '%i %i %i\n', randrows(master_stim_set)');
    fclose(fid);    
    
    % Run RT verson of Nicky
    
    cd Fortran_Program
    !nosofsky_prog_pro_rt.exe
    cd ..
    
    % Now we have to rename the output files. 
        
    movefile([cd '\Fortran_Program\Output\prop.dat'],[cd '\Fortran_Program\Output\prop_' num2str(run_num) '.dat']);
    movefile([cd '\Fortran_Program\Output\response.dat'],[cd '\Fortran_Program\Output\response_' num2str(run_num) '.dat']);
    
end  