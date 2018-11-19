function [ energy ] = ex3_energy( frame )
%EX3_ENERGY SIGNAL ENERGY COMPUTATION
%   Compute the energy of a given frame (with mean removed)
%
%   Inputs: frame : the input signal frame
%
%   Outputs: energy : Frame energy

    frame = frame-mean(frame);
    energy = sqrt(frame' * frame);
    
end

