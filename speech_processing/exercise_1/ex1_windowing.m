function [ frame_matrix ] = ex1_windowing( data, frame_length, hop_size, windowing_function )
%EX1_WINDOWING Based on the input parameters, generate a n x m matrix of windowed
%frames, with n corresponding to frame_length and m corresponding to number
%of frames. The first frame starts at the beginning of the data.

    data = data(:);
    number_of_frames = 1 + floor((length(data) - frame_length) / hop_size);
    frame_matrix = zeros(frame_length, number_of_frames);

    switch windowing_function
        case 'rect'
            window = rectwin(frame_length);
        case 'hann'
            window = hann(frame_length);
        case 'cosine'
            window = sqrt(hann(frame_length));
        case 'hamming'
            window = hamming(frame_length);
    end


    % Copy each frame segment from data to the corresponding column of frame_matrix.
    % If the end sample of the frame segment is larger than data
    % length,fumber_of_frame

    % zero-pad the remainder to achieve constant frame length.
    % Remember to apply the chosen windowing function to the frame!

    data_overlap = buffer(data, frame_length, hop_size);

    for i = 1 : number_of_frames
        frame = zeros(frame_length, 1); % Initialize frame as zeroes 
        if i ~= number_of_frames    
            frame(:, 1) = data_overlap(:, i) .* window;    
            frame_matrix(:, i) = frame; % Copy frame to frame_matrix 
        else
            last_frame_length = length(data_overlap(:, i));
            remainder = frame_length - last_frame_length;     
            if remainder ~= 0
                data_overlap(remainder: frame_length, i) = 0;
            end
        end
    end
end



