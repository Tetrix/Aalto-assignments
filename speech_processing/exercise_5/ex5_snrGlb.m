function ret = ex5_snrGlb(clean, enhanced)
% Function to compute the global snr of the enhanced signal in dB

% Check if the two input signals are of same length. If not, throw an error
if length(clean)~=length(enhanced)
    error('length of signals do not match');
end

% Compute the global SNR in dB
ret = sum(abs(clean) .^ 2, 1) / sum((abs(clean - enhanced)) .^ 2, 1);

end