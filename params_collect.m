% Script to collect parameters from the various folders.

clear names

num_files = 4; 
num_params = 39;

names{1} = 'choi';
names{2} = 'carelli';
names{3} = 'merchant';
names{4} = 'nosofsky';

par = '_params';
labels = '_names';
com_dir = '\Fortran_Program\input\';

year = [2005 1997 1997 1997];
flag = [ 0 0 1 1];

for i = 1:4
     
     import_cmd = [char(names(i)) par ' = convert2cell(importdata(''' cd '\' char(names(i)) '_' num2str(year(i)) com_dir char(names(i)) par '.dat''));'];
     eval(import_cmd)
      
     if (flag(i) == 0)
         for j = [2 14 15 20 28 39]
             redef_cmd = [char(names(i)) par ' = na_movedown(' char(names(i)) par ',j);'];
             eval(redef_cmd)
         end
     else
         for j = [18 25 35:38]
             redef_cmd = [char(names(i)) par ' = na_movedown(' char(names(i)) par ',j);'];
             eval(redef_cmd)
         end
     end
     
     reshape_cmd = [char(names(i)) par ' = reshape(' char(names(i)) par ',length(' char(names(i)) par '),1);'];
     eval(reshape_cmd)
     
 end
 
big_matrix = cell(num_params,num_files);

for i = 1:num_files
     
    for j = 1:num_params

        def_cmd = ['big_matrix{j,i} = ' char(names(i)) par '{j};'];
        eval(def_cmd)
        
    end

     
end

[n m] = size(big_matrix);

for i = 1:n
    for j = 1:m
        all_params(i,j) = big_matrix{i,j};
    end
end
    
fid = fopen('all_params.dat','w');
fprintf(fid,'%20.10f %20.10f %20.10f %20.10f\n', all_params');
fclose(fid);