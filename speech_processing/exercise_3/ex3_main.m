% ELEC-E5500 Speech Processing -- Autumn 2018 Matlab Exercise 3:
% Voice activity detection

close all; clear;

addpath('speech_processing/exercise_1/');
addpath('speech_processing/exercise_2/');

% Section 0: Use the code from Exercise 1 to read and window the analyzed sample:
% 0.1. Read the audio file and sampling rate
[data, Fs] = audioread('SX83.WAV');
data = data/max(abs(data));

% 0.3. Split the data sequence into windows. Use ex1_windowing.m
frame_length = round(0.025*Fs); % In samples
hop_size = round(0.0125*Fs); % In samples (50% overlap)
window_types = {'rect','hann','cosine','hamming'};

frame_matrix = ex1_windowing_solution(data, frame_length, hop_size, window_types{2});

% Section 1: Acquire parameters for VUV detection: 

% 1.1. Implement zero-crossing rate (ZCR) computation
zcr_vec = zeros(1,size(frame_matrix,2));
for iFrame = 1:size(frame_matrix,2)
    zcr_vec(iFrame) = ex3_zcr(frame_matrix(:,iFrame));
end
% 1.2. Implement energy computation
energy_vec = zeros(1,size(frame_matrix,2));
for iFrame = 1:size(frame_matrix,2)
    energy_vec(iFrame) = ex3_energy(frame_matrix(:,iFrame));
end


% 1.3. Implement one-lag autocorrelation computation
ac_vec = zeros(1,size(frame_matrix,2));
for iFrame = 1:size(frame_matrix,2)
    ac_vec(iFrame) = ex3_one_lag_autocorrelation(frame_matrix(:,iFrame));
end

% 1.3 Use the functions from Exercise 2 to obtain peak values:
f0_max = 180;
f0_min = 80;

ac_peak_vec = zeros(1,size(frame_matrix,2));
for iFrame = 1:size(frame_matrix,2)
    [~, ac_peak_vec(iFrame)] = ex2_fundf_autocorr_solution(frame_matrix(:,iFrame),Fs,f0_min,f0_max,0);
end

ceps_peak_vec = zeros(1,size(frame_matrix,2));
for iFrame = 1:size(frame_matrix,2)
    [~, ceps_peak_vec(iFrame)] = ex2_fundf_cepstrum_solution(frame_matrix(:,iFrame),Fs,f0_min,f0_max,0);
end


% Section 2: Train a perceptron model with the computed input parameters for VAD.

% Load target output
vad_target = load('output_targets')';

% 2.1. Concatenate input vectors to a single input matrix (feature vectors
% as rows, frames as columns)
%vad_input =
num_frames = size(frame_matrix, 2);
vad_input = zeros(num_frames, num_frames);
vad_input = [zcr_vec; ac_vec; energy_vec; ac_peak_vec; ceps_peak_vec];


% 2.2. Add deltas and delta-deltas to input matrix (implement the function)
vad_input = ex3_add_deltas_deltadeltas(vad_input);

% 2.3. Normalize each input parameter to zero-mean and unit variance vectors
vad_input = ex3_normalize(vad_input);

% Add bias vector (a vector of ones) to input matrix
vad_input = [vad_input; ones(1, size(frame_matrix, 2))];

% Train a perceptron model (linear classifier with output non-linearity)
w_perceptron = ex3_perceptron_training(vad_input,vad_target);

% Train a linear classifier:


target_rescaled = [];
for i = vad_target
  if i == 0
       target_rescaled = [target_rescaled; -1];
   else
       target_rescaled = [target_rescaled; 1];
   end
end


w_linear = target_rescaled' * pinv(vad_input);

% 2.4. Use the obtained models to make the classifications:
thresh_perceptron = 0.0;

%vad_perceptron = % VAD classification of the utterance based on the trained perceptron model with vad_input as the input matrix 
vad_linear = vad_input' * w_linear';
vad_linear_rescaled = [];
for i = vad_linear'
   if i < 0
       vad_linear_rescaled = [vad_linear_rescaled, 0];
   else
       vad_linear_rescaled = [vad_linear_rescaled, 1];
   end
end

thresh_linear = 0.0;
vad_linear = vad_input' * w_linear'; % VAD classification of the utterance based on the linear classifier model with vad_input as the input matrix 
error_linear = sum((vad_linear_rescaled - vad_target) .^ 2) / length(vad_target'); % Classification error
disp(['Error of linear classifier: ' num2str(error_linear)]);



vad_perceptron = vad_input' * w_perceptron';
vad_perceptron_rescaled = [];
for i = vad_perceptron'
   if i < 0
       vad_perceptron_rescaled = [vad_perceptron_rescaled, 0];
   else
       vad_perceptron_rescaled = [vad_perceptron_rescaled, 1];
   end
end

error_perceptron = sum((vad_perceptron_rescaled - vad_target) .^ 2) / length(vad_perceptron); % Classification error
disp(['Error of perceptron: ' num2str(error_perceptron)]);




% Section 3: Visualize your results

figure();
% 3.1. Plot the input vectors 
subplot(3,1,1)
plot(transpose(vad_input(1:15, :)));

axis tight
title('Computed parameters (vad input)');

% 3.2. Plot the classifier activation values for each frame (without
% classification)
subplot(3,1,2)
plot(vad_target)
hold on;
plot(vad_perceptron)
hold on;
plot(vad_linear)
hold off;
axis tight
legend('Target','Perceptron','Linear');
title('Classifier activations');
set(gca,'XLim',[0 250]);
set(gca,'XTick',(0:20:250));

% 3.3. Plot the target vector, and obtained classification results for both
% classifiers
subplot(3,1,3)
plot(vad_target)
hold on;
plot(vad_perceptron_rescaled)
hold on;
plot(vad_linear_rescaled)
hold off;
ylim([-0.1 1.1]);
set(gca,'XLim',[0 250]);
set(gca,'XTick',(0:20:250));


title('Classifier outputs');
legend('Target','Perceptron','Linear');


% Section 4: Experiment with different input parameters.
% a) What is the single best parameter for VAD classification in the test
% utterance?
% b) What is the worst performing single parameter?
% c) What other features could be useful in VAD?


%{
 a)

    The biggest impact for the linear classifier has the zero-crossing
    rate parameter.    
    The biggest impact for the perceptron has the energy of the signal


b)
    The worst impact for the linear classifier has the energy of the signal
    The worst impact for the perceptron has the autocorrelation peak vector


c)
    MFCC can be useful
    Also prediction residual can be useful

%}







