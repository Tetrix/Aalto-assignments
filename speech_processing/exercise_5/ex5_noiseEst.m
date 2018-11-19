function ret = ex5_noiseEst(data_matrix, est_type)

% If estimation type is ideal noise, return back the true noise value.
% Else, if estimation type is avg_noise_model, get the average noise model
% by computing the mean of the noise type. The dimesions of 'ret' should be
% same as the dimensions of the input data_matrix
switch est_type
    case 'avg_noise_model'
        avg_noise = zeros(size(data_matrix));
        noise_mat = data_matrix;
        % fft of the noise
        noise_freq = fft(noise_mat);
        avg_noise = mean(abs(noise_freq) .^ 2, 2);
        ret = repmat(avg_noise, 1, size(data_matrix, 2));
        
    case 'ideal_noise'
        % Get the ideal noise 
        noise_mat = data_matrix;
        % fft of the noise matrix
        noise_freq = fft(noise_mat);
        
        ret = abs(noise_freq) .^ 2;
end


end