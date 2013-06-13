function saveparams(newParams)

global message


% Create data file
outfile =  [cd '\Fortran_Program\input\merchant_params.dat'];% for PC
fid = fopen([outfile],'w');

% Write trial stimuli response1 response2 rt1 rt2 to a data file.
for trial=1:length(newParams)
    if trial <= 3 
        fprintf(fid,'%3i\n',newParams(trial,:)' );
    else
	    fprintf(fid,'%15.13f\n',newParams(trial,:)' );
    end
end

% Close response data file.
fclose(fid);

% Update message
set(message,'string','New parameters saved')

% Update displayed params
cmd = ['load ' cd '\Fortran_Program\input\merchant_params.dat;'];
eval(cmd)
for curparam = 1:length(merchant_params)
	paraminput(curparam) = uicontrol('Style', 'text', 'String', num2str(merchant_params(curparam)), ...
        'Position', [10 700-(curparam*21) 75 17]);
end