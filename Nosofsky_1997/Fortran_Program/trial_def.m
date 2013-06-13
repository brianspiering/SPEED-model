
step = linspace(max(ratio_mean),min(ratio_mean),9);

for i = 1:9
    ind = find(ratio_mean >= step(i));
    trial(i) = ind(length(ind));
end

file_name = [cd '\figures\trial.dat'];

fid = fopen(file_name,'w');
fprintf(fid,'%i\n',trial);
fprintf(fid,'%f\n',step);
fclose(fid);

