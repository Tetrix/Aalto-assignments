function [ f0, cepstral_peak_val ] = ex2_fundf_cepstrum( frame, fs, f0_min, f0_max, vuv_threshold )

    max_lag = floor(fs * (1/f0_min));
    min_lag = floor(fs * (1/f0_max));
    eps = 0.00001;

    power_spectrum = (abs(fft(frame))) .^ 2 + eps;
    log_ps = log(power_spectrum);
    c = ifft(log_ps);
    
    [cepstral_peak_val, idx] = max(c(min_lag:max_lag));
    
    
    if cepstral_peak_val > vuv_threshold    
        f0 = fs / (min_lag + idx - 1);
        
        f0_1_lag = (min_lag + idx -1) * 2;
        f0_2_lag = (min_lag + idx -1) * 3;
        f0_3_lag = (min_lag + idx -1) * 4;
       
        if f0_3_lag < max_lag && c(f0_3_lag) > vuv_threshold
            f0 = f0_3_lag;
        end
        if f0_2_lag < max_lag && c(f0_2_lag) > vuv_threshold
           f0 = f0_2_lag; 
        end
        if f0_1_lag < max_lag && c(f0_1_lag) > vuv_threshold
            f0 = f0_1_lag;
        end
    else
        f0 = 0;
    end

end
