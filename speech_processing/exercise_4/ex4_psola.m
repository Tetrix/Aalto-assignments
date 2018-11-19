function new_wave = ex4_psola(data, fs, hop_size, f0_vec_original, f0_vec_target)
% This is the function to modify the pitch of the input data without
% modifying the duration
% Inputs:
% data: signal vector whose pitch is to be modified
% fs: sampling frequency
% hop_size: overlap between frames
% f0_vec_original: original fundamental frequency vector of data
% f0_vec_target: target fundamental frequency vector. Dimensions same as
% that of f0_vec_original

new_wave = zeros(length(data), 1);

% Initialize a starting data point
idx = ceil(fs/50);

% Maximum data-point for starting
strt_pt_max = (length(data) - idx);

num_frames = length(f0_vec_original);

while idx < strt_pt_max
    
    % Find which frame the sample point belongs to
    
    frame_index = ceil(idx / hop_size);

    % put a check: in case the estimated frame for idx exceeds original number of frames 
    % assign idx to highest frame
    
    if frame_index > num_frames
       idx = strt_pt_max;
       break;
    end
        
    % Find center index 
    if f0_vec_original(frame_index) ~= 0
        % Convert to pitch period
        t0 = ceil(fs * (1 / f0_vec_original(frame_index)));

        % Find maximum value of data within a search range of t0
        [~, ind] = max(data((idx + t0) : (idx + 2 * t0)));

        % Re-assign the maximum value as center idx. Make sure the indexing
        % is absolute and not relative
        
        center_index = ind + idx;
    else   % no change in center index
        center_index = idx;
    end

    % Select two pitch period segment of data based on center index (for
    % unvoiced, select a const value)
    if f0_vec_target(frame_index) ~= 0
        t0 = ceil(fs * (1 / f0_vec_target(frame_index)));
    else
        t0 = 100;
    end
    
    segment_start = center_index - t0;
    segment_stop = center_index + t0;
    
    
    % Extracting data two pitch period long
    psola_frame = data(segment_start : segment_stop);

        
    % Apply windowing
    psola_frame = ex1_windowing_solution(psola_frame, 2 * t0, hop_size, 'hamming');

    % Add modified-psola_frame to new_wave
    new_center = idx + ceil(t0 / (f0_vec_target(frame_index) / f0_vec_original(frame_index)));
    psola_start = new_center - ceil(length(psola_frame) / 2);
    psola_stop = new_center + ceil(length(psola_frame) / 2);

    new_wave(psola_start : psola_stop-1) = new_wave(psola_start : psola_stop-1) + psola_frame;
    
    % Update sample number

    idx =  new_center + 1;
end