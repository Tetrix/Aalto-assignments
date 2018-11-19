function [ val ] = ex3_one_lag_autocorrelation( frame )
%EX3_ONE_LAG_AUTOCORRELATION ONE-LAG AUTOCORRELATION COEFFICIENT COMPUTATION
%   Returns the 1-lag autocorrelation coefficient of input sequence.
%   Removes mean and normalizes the coefficients based on the zero-lag
%   coefficient.
%
%   Inputs: frame : the input signal frame
%
%   Outputs: val : The one-lag autocorrelation coefficient

    val = 0;
    frame_len = length(frame);
    mean_f = mean(frame);
    for i = (2:frame_len)
       val = val + ((frame(i) - mean_f) * (frame(i - 1) - mean_f)); 
    end
    val = val / (frame_len * var(frame));
end

