function [ zcr ] = exc3_zcr( frame )
%EXC3_ZCR ZERO-CROSSING RATE COMPUTATION
%   Count the number of times that a signal crosses the zero-line
%   Inputs: frame : the input signal frame
%
%   Outputs: zcr : The zero-crossing rate of a zero-mean frame. (I.e.
%   remember to remove the mean from frame!)
    frame = frame-mean(frame);
    frame_len = length(frame);
    zcr = 0;
    
    for i = (2:frame_len)
        sign_value = sign(frame(i) * frame(i - 1));
        if sign_value < 0
           zcr = zcr + sign_value; 
        end
    end
    zcr = zcr * -1;
end

