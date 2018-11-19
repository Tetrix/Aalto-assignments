function ret = ex5_snrSeg(clean, enhanced)
% Function to compute the segmental SNR

% Check if the two input signals are of the same length
if size(clean)~=size(enhanced)
    error('mismatch in matrix size');
end

% Compute the segmental-SNR in dB
ret = 10*log10(sum(abs(clean) .^ 2, 1) ./ sum((abs(clean) - abs(enhanced)) .^ 2, 1));

end