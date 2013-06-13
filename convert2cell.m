function out_array = convert2cell(in_array)

% Function for converting array to cell array 

for i = 1:length(in_array)
    
    out_array{i} = in_array(i);
    
end


