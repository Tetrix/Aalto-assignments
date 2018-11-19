% wrapper to run main reference file
estimation_types = {'ideal_noise', 'avg_noise_model'};
tmp = 2;

if strcmp(estimation_types{tmp}, 'ideal_noise')
    est_type = 1;
elseif strcmp(estimation_types{tmp}, 'avg_noise_model')
    est_type = 2;
end

ex5_main_solution(est_type)