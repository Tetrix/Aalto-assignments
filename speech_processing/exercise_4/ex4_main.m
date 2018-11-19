% ELEC-E5500 Speech Processing -- Autumn 2018 Matlab Exercise 4:
% PSOLA

clear;
close all;

addpath('../aalto/speech_processing/exercise_2/');

% Read and window the vowel segment aa.wav:
% 0.1. Read the audio file aa.wav and sampling rate
[data_vowel, Fs] = audioread('aa.wav');
% 0.2. Make sure the sampling rate is 16kHz
if Fs ~= 16e3
    [P,Q] = rat(16e3/Fs, 0.0001);
    data_vowel = resample(data_vowel, P, Q); % resampling
    Fs = 16e3;   % re-assign sampling rate
end

% 0.3. Split the data sequence in to windows. Use ex1_windowing.m
frame_length = round(0.05*Fs); % 25ms in samples
hop_size = round(0.0125*Fs); % 12.5ms in samples (25% overlap)
window_types = {'rect','hann','cosine','hamming'};
win_type = window_types{4};
frame_matrix_vowel = ex1_windowing_solution(data_vowel, frame_length, hop_size, win_type); % Implement this!

% Section 1: Modify the pitch of the vowel 'aa'
% Use solution from exercise 2 to estimate the fundamental frequency. You
% can use either the autocorrelation or the cepstral method 

% Define minimum and maximum values for the F0 search range, and the
% threshold value for Voiced/Unvoiced decision
f0_max = 180;
f0_min = 50;
vuv_threshold_ac = 0.6;

% Loop through frame_matrix_vowel that calls the function ex2_fundf_autocorr to obtain
% the F0 estimates for each frame
f0_vec_original_vowel = zeros(1,size(frame_matrix_vowel,2)); % Allocate f0 vector for autocorrelation method
ac_peak_vec_vowel = zeros(1,size(frame_matrix_vowel,2));
for iFrame = 1:size(frame_matrix_vowel,2)
    [f0_vec_original_vowel(iFrame), ac_peak_vec_vowel(iFrame)] = ex2_fundf_autocorr_solution(frame_matrix_vowel(:,iFrame), Fs, f0_min, f0_max, vuv_threshold_ac);
end


% 1.1 Modify the pitch of the underlying data (vowel) by applying PSOLA
% Initialize a constant target pitch frequency (greater than 50 Hz)
f0_vec_target_vowel = 80 + zeros(1, 84);
% Apply PSOLA
vowel_pitch_modified = ex4_psola(data_vowel, Fs, hop_size, f0_vec_original_vowel, f0_vec_target_vowel);


% Plotting and visualization
% 1.2 Plot the original signal and the pitch modified signal and label the
% axes and the title with appropriate strings
figure;
% Original vowel signal
subplot(2, 2, 1);
t = (0 : length(data_vowel) - 1) / Fs;
plot(t, data_vowel);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Vowel Signal');


% Pitch modified vowel signal
subplot(2, 2, 2); 
t = (0 : length(vowel_pitch_modified) - 1) / Fs;
plot(t, vowel_pitch_modified);
xlabel('Time (s)');
ylabel('Amplitude');
title('Modified Vowel Signal (80Hz)');

% Spectrogram of vowel signal
subplot(2, 2, 3);
t = (0:size(frame_matrix_vowel, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_vowel, 1), size(frame_matrix_vowel, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_vowel, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_vowel(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Original Spectrogram Vowel');


% 3.2 Spectrogram of pitch modified vowel
frame_matrix_vowel_modified = ex1_windowing_solution(vowel_pitch_modified, frame_length, hop_size, win_type); % Implement this!
subplot(2, 2, 4);
t = (0:size(frame_matrix_vowel_modified, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_vowel_modified, 1), size(frame_matrix_vowel_modified, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_vowel_modified, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_vowel_modified(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Modified Spectrogram Vowel (80Hz)');



% Section 2: Modify the pitch of the sentence in SX83.WAV
% 0.1. Read the audio file SX83.WAV and sampling rate
[data_sentence, Fs] = audioread('SX83.WAV');

% 0.2. Make sure the sampling rate is 16kHz
if Fs ~= 16e3
    [P,Q] = rat(16e3/Fs, 0.0001);
    data_sentence = resample(data_sentence, P, Q); % resampling
    Fs = 16e3;   % re-assign sampling rate
end

% 0.3. Split the data sequence in to windows. Use ex1_windowing.m
frame_matrix_sentence = ex1_windowing_solution(data_sentence, frame_length, hop_size, win_type);; 

% Use solution from exercise 2 to estimate the fundamental frequency. You
% can use either the autocorrelation or the cepstral method

% Define minimum and maximum values for the F0 search range, and the
% threshold value for Voiced/Unvoiced decision
f0_max = 180;
f0_min = 50;
vuv_threshold_ac = 0.6;

% Loop through frame_matrix_vowel that calls the function ex2_fundf_autocorr to obtain
% the F0 estimates for each frame
f0_vec_original_sentence = zeros(1,size(frame_matrix_sentence,2)); % Allocate f0 vector for autocorrelation method
ac_peak_vec_sentence = zeros(1,size(frame_matrix_sentence,2));
for iFrame = 1:size(frame_matrix_sentence,2)
    [f0_vec_original_sentence(iFrame), ac_peak_vec_sentence(iFrame)] = ex2_fundf_autocorr_solution(frame_matrix_sentence(:,iFrame), Fs, f0_min, f0_max, vuv_threshold_ac);
end


% 2.1 Modify the pitch of the underlying data (sentence) by applying PSOLA
% Initialize a constant target pitch
f0_vec_target_sentence_constant = 80 + zeros(1, 214);
% Apply PSOLA to modify the pitch to the target constant pitch
sentence_pitch_modified_const = ex4_psola(data_sentence, Fs, hop_size, f0_vec_original_sentence, f0_vec_target_sentence_constant);


% 2.2 Modify the pitch of the underlying data (sentence) by applying PSOLA
% Initialize a variable target pitch vector
f0_vec_target_sentence_variable = f0_vec_original_sentence * 1.5 + zeros(1, 214);
% Apply PSOLA to modify the pitch to the target constant pitch
sentence_pitch_modified_var = ex4_psola_solution(data_sentence, Fs, hop_size, f0_vec_original_sentence, f0_vec_target_sentence_variable);


% Plotting and visualization
% 2.3.1 Plot the original signal and the pitch modified signal and label the
% axes and the title with appropriate strings
figure;
% plot original sentence
subplot(2, 3, 1);
t = (0 : length(data_sentence) - 1) / Fs;
plot(t, data_sentence);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Sentence Signal');

% Plot the Constant Pitch modified signal-sentence_pitch_modified_const
subplot(2, 3, 2); 
t = (0 : length(sentence_pitch_modified_const) - 1) / Fs;
plot(t, sentence_pitch_modified_const);
xlabel('Time (s)');
ylabel('Amplitude');
title('Modified Sentence Signal (80Hz) Constant');

% Plot the Variable Pitch modified signal-sentence_pitch_modified_var
subplot(2, 3, 3); 
t = (0 : length(sentence_pitch_modified_var) - 1) / Fs;
plot(t, sentence_pitch_modified_var);
xlabel('Time (s)');
ylabel('Amplitude');
title('Modified Sentence Signal (1.5 times original) Variable');

% 2.3.2 Compute and plot the spectrogram

% spectrogram of the original sentence
subplot(2, 3, 4);
t = (0:size(frame_matrix_sentence, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_sentence, 1), size(frame_matrix_sentence, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_sentence, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_sentence(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Original Spectrogram Sentence');

% spectrogram of the constant pitch modified sentence-sentence_pitch_modified_const
frame_matrix_sentence_modified = ex1_windowing_solution(sentence_pitch_modified_const, frame_length, hop_size, win_type); % Implement this!
subplot(2, 3, 5);
t = (0:size(frame_matrix_sentence_modified, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_sentence_modified, 1), size(frame_matrix_sentence_modified, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_sentence_modified, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_sentence_modified(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('spectrogram');
title('Modified Spectrogram Sentence (80Hz) Constant');

% spectrogram of the variable pitch modified sentence-sentence_pitch_modified_var
frame_matrix_sentence_modified = ex1_windowing_solution(sentence_pitch_modified_var, frame_length, hop_size, win_type); % Implement this!
subplot(2, 3, 6);
t = (0:size(frame_matrix_sentence_modified, 2) - 1) * hop_size*1/Fs;
s = zeros(size(frame_matrix_sentence_modified, 1), size(frame_matrix_sentence_modified, 2));
f = Fs * ((1:frame_length) - 1) / frame_length;
size(t)
for i = 1:size(frame_matrix_sentence_modified, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix_sentence_modified(:, i))));
end

surf(t, f(1:length(f)/2), s(1:length(f)/2 , :), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('Modified Spectrogram Sentence (1.5 times original) Variable');


% Experiment with different target frequencies
% a) Difference between a constant and varying pitch modified signal?
% b) Can you spot this difference from the signal spectrograms? If yes,
% how?
% c) What changes do you observe in the signal plots (time domain and
% spectrogram), when you increase and decrease the pitch?
% d) Can you think of any applications of this PSOLA implementation for
% pitch modification?

%{

a) The constant pitch modified signal seems a bit distorted and the quality is lost.
Also there are some gaps. That happend for both increasing and decreasing
of the pitch
The varying pitch modified signal works fine. I have tried increasing and
decreasing the pitch. Both work good
The quality is a lot better with the varying pitch modification.


b) In the constant modified pitch we can notice that the amplitudes of the
   consonants are increased a lot. That is why on the spectrogram we can
   see blue area in the place where the vowels are. The vowels are correct
   but since the amplitudes of the consonants are so high, the vowels are
   not noticable on the spectrogram. So, this method does not work well
   when there are consonants.


c) When we increase the pitch in time domain we can notice that the signal
   is dencer and has more periods. When we lower the pitch we can see that
   the signal is sparser with less periods.

   In the spectrograms we can see that if we increase the pitch, the
   fundamental frequencies are further apart.
   If we decrease the pitch, we can see that the fundamental frequencies
   are closer.


d) We can use this to do auto tuning of a voice. It can also be used for
   creating digital audio effects.
   Can be used also for speech synthesis

%}


