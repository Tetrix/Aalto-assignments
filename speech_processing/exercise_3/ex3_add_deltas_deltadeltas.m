function [ output ] = ex3_add_deltas_deltadeltas( vad_input )
%EX3_ADD_DELTAS_DELTADELTAS Add delta and delta-delta features to features
%of input matrix. Rows represent features, and columns frames.
%  Inputs:  vad_input: m x n matrix with m features and n frames
%
% Outputs:  output: 3*m x n matrix whose rows contain original features, and
% their delta and delta-delta features

% % https://en.wikipedia.org/wiki/Finite_difference_coefficient
filt_dx = filter([-0.5, 0, 0.5], 1, vad_input'); % Filter for delta computation
filt_ddx = filter([1, -2, 1], 1, vad_input'); % Filter for delta-delta computation

output = [vad_input; filt_dx'; filt_ddx'];

end

