function out_char = trimstr(in_char)

out_char = in_char;
last_char = out_char(length(out_char));

while (last_char == ' ') 
    out_char = out_char(1:(length(out_char)-1));
    last_char = out_char(length(out_char));
end