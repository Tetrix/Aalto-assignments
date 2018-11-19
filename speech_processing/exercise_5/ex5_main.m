% ELEC-E5500 Speech Processing -- Autumn 2018 Matlab Exercise 05
% Enhancement

%close all;
clear;
clc;


% Section 0: Use the code from Exercise 1 to read and window the analyzed sample:
% 0.1. Read the noisy audio file 'noisy.wav' and sampling rate
[data_clean, Fs] = audioread('SX83.WAV');

% 0.2. Make sure the sampling rate is 16kHz
if Fs ~= 16000 %%%
    data_clean = resample(data_clean,16000,Fs); %%%
    Fs = 16000; %%%
end %%%

% Generate a noisy signal
% Generate white Gaussian noise of strength -35dB
data_noise = wgn(length(data_clean), 1.0, -35);
% Generate the noisy signal, where the noise is additive white Guassian
data_noisy = data_clean + data_noise;

audiowrite('test.wav', data_noisy, Fs);

% 0.3. Split the noisy data sequence into windows. You can use ex1_windowing_solution.m
frame_length = round(0.025*Fs); % 25ms in samples
hop_size = round(0.0125*Fs); % 12.5ms in samples (50% overlap)
window_types = {'rect','hann','cosine','hamming'};
win_i = 4;
frame_matrix = ex1_windowing_solution(data_noisy, frame_length, hop_size, window_types{win_i}); % Implement this!


% Section 1: Estimate noise model
estimation_types = {'ideal_noise', 'avg_noise_model'};
est_type = 2;
% Window the generated white Gaussian noise signal/s for modelling: 
frame_matrix_noise = ex1_windowing_solution(data_noise, frame_length, hop_size, window_types{win_i}); % Implement this!
% Obtain the noise model which will be used later for noise reduction
noise_est = ex5_noiseEst(frame_matrix_noise, estimation_types{est_type});


% Section 2: Enhancement
% Perform spectral substraction
enhanced_sig_specSub = ex5_spectralSub(frame_matrix, hop_size, window_types{win_i}, noise_est, length(data_noisy));

% Perform Wiener filtering
enhanced_sig_wiener = ex5_wiener(frame_matrix, hop_size, window_types{win_i}, noise_est, length(data_noisy));

% Perform linear filtering
enhanced_sig_linear = ex5_linear(frame_matrix, hop_size, window_types{win_i}, noise_est, length(data_noisy));

% VAD based noise-reduction
load('output_targets');
% Perform filtering-VAD based noise removal
enhanced_vad = ex5_vadEnhance(frame_matrix, hop_size, window_types{win_i}, noise_est, length(data_noisy), output_targets);

% Section 3: Evaluation

% Compute the global SNR in dB for all the enhanced signals using spectral
% subtraction, Wiener filtering, linear filtering
SNR_global_noisy = ex5_snrGlb(data_clean, data_noisy);
SNR_global_ss = ex5_snrGlb(data_clean, enhanced_sig_specSub);
SNR_global_wie = ex5_snrGlb(data_clean, enhanced_sig_wiener);
SNR_global_linear = ex5_snrGlb(data_clean, enhanced_sig_linear);
SNR_global_vad = ex5_snrGlb(data_clean, enhanced_vad);

% Segmental-SNR
% First, Window the clean and enhanced signals 
frame_matrix_clean = ex1_windowing_solution(data_clean, frame_length, hop_size, window_types{win_i});
frame_matrix_enhSS = ex1_windowing_solution(enhanced_sig_specSub, frame_length, hop_size, window_types{win_i});
frame_matrix_enhWie = ex1_windowing_solution(enhanced_sig_wiener, frame_length, hop_size, window_types{win_i});
frame_matrix_enhLin = ex1_windowing_solution(enhanced_sig_linear, frame_length, hop_size, window_types{win_i});
frame_matrix_enhvad = ex1_windowing_solution(enhanced_vad, frame_length, hop_size, window_types{win_i});

% Then compute the segmental SNR
SNR_seg_noisy = ex5_snrSeg(frame_matrix_clean, frame_matrix);
SNR_seg_ss = ex5_snrSeg(frame_matrix_clean, frame_matrix_enhSS);
SNR_seg_wie = ex5_snrSeg(frame_matrix_clean, frame_matrix_enhWie);
SNR_seg_linear = ex5_snrSeg(frame_matrix_clean, frame_matrix_enhLin);
SNR_seg_vad = ex5_snrSeg(frame_matrix_clean, frame_matrix_enhvad);

% Section 4: Plotting and visualization
figure;
% Plot the noisy signal and the segmental-SNRs from the 4 methods. Let the
% x-axis denote frames and y-axis denote the SNR in dB
plot(SNR_seg_noisy);
hold on;
plot(SNR_seg_ss);
hold on;
plot(SNR_seg_wie);
hold on;
plot(SNR_seg_linear);
hold on;
plot(SNR_seg_vad);
legend('noisy', 'spectral subtraction', 'wiener', 'linear', 'vad');
title('Segmental SNG: average noise model');
hold off;


% Plot the spectrograms of the clean, noisy and the enhanced signals
% In this figure, plot the clean and noisy spectrograms
Nfft = 1024;
f_axis = (0:(Nfft/2))/(Nfft/2)*Fs/2;

figure;
% CLean
subplot(2, 1, 1);
t = (0:size(frame_matrix_clean, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_clean, 1), size(frame_matrix_clean, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_clean, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_clean(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Clean Signal');


%noisy
subplot(2, 1, 2);
t = (0:size(frame_matrix, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix, 1), size(frame_matrix, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Noisy Signal');



% In this figure, plot all the 4-enhanced signals
figure;
% Plot the enhanced signal-spectral subtraction
subplot(2, 2, 1);
t = (0:size(frame_matrix_enhSS, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_enhSS, 1), size(frame_matrix_enhSS, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_enhSS, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_enhSS(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Spectral Subtraction');


% Plot the enhanced signal-Wiener filter
subplot(2, 2, 2);
t = (0:size(frame_matrix_enhWie, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_enhWie, 1), size(frame_matrix_enhWie, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_enhWie, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_enhWie(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Wiener Filter');


% Plot the enhanced signal-Linear filtering
subplot(2, 2, 3);
t = (0:size(frame_matrix_enhLin, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_enhLin, 1), size(frame_matrix_enhLin, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_enhLin, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_enhLin(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Linear');


% Plot the enhanced signal - VAD
subplot(2, 2, 4);
t = (0:size(frame_matrix_enhvad, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_enhvad, 1), size(frame_matrix_enhvad, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_enhvad, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_enhvad(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('VAD Enhanced');
