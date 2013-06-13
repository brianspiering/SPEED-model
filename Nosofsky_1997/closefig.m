function [figind] = closefig(value,figind,message)
%[figind] = closefig(value,figind,message)
% Closes figures if there are any open
% Value
%   1  Closes all figures 
%   0 Closes last figure
% figind
%   handle to lastest open figure
% message
%   handle to message box
%
%  April 1 2004		Brian Spiering
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if value == 0 %Closes last figure
    if figind == 1
        set(message,'string','No figures to close')
    else
        close(figind);
        set(message,'string','Last figure closed')
        figind= figind-1;
    end
else
    if figind == 1 %Closes all figures
        set(message,'string','No figures to close')
    else
        for x = 2:figind
          close(x)
        end
        set(message,'string','All figures closed')
        figind = 1;
    end    
end
