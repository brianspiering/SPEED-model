function randomize_stim
% Randomize Stimuli
% BJS 08/08/06


% load stimuli
cmd = ['load ' cd '\Fortran_Program\input\nosofsky_stim.dat;'];
eval(cmd)
data = nosofsky_stim;

% Randomize
data = randrows(data);

% Create data file
outfile =  [cd '\Fortran_Program\input\nosofsky_stim.dat'];% for PC
fid = fopen([outfile],'w');

% Write trial stimuli response1 response2 rt1 rt2 to a data file.
for trial=1:length(data)
    
        fprintf(fid,'%3i %3i %3i\n',data(trial,:)' );

end


fclose(fid);





