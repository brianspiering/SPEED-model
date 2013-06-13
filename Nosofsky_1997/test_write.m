
load_cmd = ['load ' cd '\Expert_Fortran\input\master_stim_set.dat'];
eval(load_cmd)

rand('seed',sum(100*clock))

% Write random stimulus file
    file_name = [cd '\Expert_Fortran\input\modelfbstim.dat'];
    fid = fopen(file_name,'w');
    fprintf(fid, '%i %i %i\n', randrows(master_stim_set)');
    fclose(fid);    