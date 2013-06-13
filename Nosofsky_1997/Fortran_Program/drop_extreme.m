function output = drop_extreme(input,mult)

% Function to drop extreme values from an array.  All values that are
% mult*range(input) away from either extreme value are dropped.  To create
% no effect set mult = 0.

ind = find((input <= max(input) - range(input)*mult)&(input >= min(input) + range(input)*mult));
output=input(ind);