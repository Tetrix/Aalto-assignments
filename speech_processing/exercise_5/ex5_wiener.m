function ret = ex5_wiener(frame_matrix, hop_size, window_type, noise_est, original_signal_length)
% Return enhanced signal after Wiener filtering

% Setting initial variables
frame_length = size(frame_matrix, 1);
fftlen = (frame_length/2)+1;
hwin = ex5_getWindow(frame_length, window_type);
xest = zeros(original_signal_length, 1);

% Performing enhancement for each frame
for winix = 1:size(frame_matrix, 2)
    start = (winix-1)*hop_size+1; % Starting index of frame
    stop = min(start+frame_length-1,original_signal_length); % End index of frame (cannot exceed length of data)
 
    Y_freq = fft(frame_matrix(:,winix));
 
    pspec = (abs(Y_freq) .^ 2 - noise_est(:, winix)) ./ abs(Y_freq) .^ 2;
    pspec(pspec < 0) = 0;
    pspec = Y_freq .* pspec;
    xwinest = ifft(pspec);
    xest(start:stop, 1) = xest(start:stop, 1) + xwinest;
    
end

ret = xest;

end