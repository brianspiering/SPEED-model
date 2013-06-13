function out_array = na_movedown(in_array, pos)

% Function that inserts "N/A" in an array location and moves the remaining
% variable entries down one index in the array

out_array = in_array;

for i = length(in_array):-1:pos
    out_array{i+1} = in_array{i};
end

out_array{pos} = -100; % code for N/A
   