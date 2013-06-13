function output = reasonable(input,mult)

ind = find((input <= max(input) - range(input)*mult)&(input >= min(input) + range(input)*mult));
output=input(ind);