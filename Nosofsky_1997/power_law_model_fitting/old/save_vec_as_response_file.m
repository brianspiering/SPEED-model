% Save vec as response file
% brian spiering
% 3/16/06
clear

% vector of rt is called x;
x=[1600
1455.718182
1105.696546
879.6498457
586.4227273
554.2363636
541.3272727
531.6772727
527.4909091
524.4363636
522.0545455
521.4954545
521.0045455
520.0363636
520
519.8318182
519.25
519.3181818
];

[r c] = size(x);

data(:,1) = (1:r)';
data(:,2) = ones(r,1);
data(:,3) = ones(r,1);
data(:,4) = x;



% Create data file
outfile = [cd '\Input\response.dat']; % for PC
fid = fopen([outfile],'w');
fprintf(fid,'%3i %2i %2i %8.3f\n',data' );
% Close response data file.
fclose(fid);

disp('Saved file');