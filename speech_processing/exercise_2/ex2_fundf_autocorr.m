function [ f0, ac_peak_val ] = ex2_fundf_autocorr( frame, fs, f0_min, f0_max, vuv_threshold)

    frame = frame-mean(frame); % Remove mean to omit effect of DC component

    max_lag = floor(fs * (1/f0_min));
    min_lag = floor(fs * (1/f0_max));
    
    frame_len = length(frame);
    r = zeros(1, max_lag);
    for k = 1:max_lag
        sum = 0;
        for i = k:frame_len
            sum = sum + frame(i) * frame(i - k + 1);
        end
        r(k) = sum;
    end

    r = r/max(abs(r)); % Normalize to unity at zero-lag
    
    [ac_peak_val, idx] = max(r(min_lag:max_lag));

    if ac_peak_val > vuv_threshold
        f0 = fs / (min_lag + idx - 1);
        
        f0_1_lag = (min_lag + idx -1) * 2;
        f0_2_lag = (min_lag + idx -1) * 3;
        f0_3_lag = (min_lag + idx -1) * 4;
       
        if f0_3_lag < max_lag && r(1, f0_3_lag) > vuv_threshold
            f0 = f0_3_lag;
        end
        if f0_2_lag < max_lag && r(1, f0_2_lag) > vuv_threshold
           f0 = f0_2_lag; 
        end
        if f0_1_lag < max_lag && r(1, f0_1_lag) > vuv_threshold
            f0 = f0_1_lag;
        end       
    else
        f0 = 0;
    end


end

