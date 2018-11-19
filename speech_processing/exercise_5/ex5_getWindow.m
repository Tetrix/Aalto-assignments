% Returns the desired window with the specified length

function window = ex5_getWindow(frame_length, windowing_type)

switch windowing_type
    case 'rect'
        window = ones(frame_length,1);
    case 'hann'
        window = hann(frame_length);
    case 'cosine'
        window = sqrt(hann(frame_length));
    case 'hamming'
        window = hamming(frame_length);
end

end