% Convert vector to response file
% BJS 2/27/06

% x is the vector of data points.

[r c] = size(x);

trial = [1:r]';
data(:,1)=trial;
filler = ones(r,1);
data(:,2)=filler;
data(:,3)=filler;
data(:,4)=x;

% Create data file
outfile = [cd '\Input\response.dat']; % for PC
fid = fopen([outfile],'w');

% Write trial stimuli response1 response2 rt1 rt2 to a data file.
for trial=1:r
  	    fprintf(fid,'%3i %2i %2i %8.3f\n',data(trial,:)' );
end

% Close response data file.
fclose(fid);

disp('done');