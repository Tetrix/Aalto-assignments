% ELEC-E5500 Speech Processing -- Autumn 2018 Matlab Exercise 1:
% Basics of speech processing and analysis with MATLAB

close all; clear;

% 1.1. Read the audio file SX83.WAV and sampling rate
[data, Fs] = audioread('SX83.WAV');

% 1.2. Make sure the sampling rate is 16kHz, resample if necessary

% Fs is 16000 Hz which is 16KHz so it does not need resampling

% 1.3. Split the data sequence into windows. Implement ex1_windowing.m
frame_length = round(0.025*Fs); % 25ms in samples
hop_size = round(0.0125*Fs); % 12.5ms in samples (50% overlap)
window_types = {'rect','hann','cosine','hamming'};
frame_matrix = ex1_windowing(data, frame_length, hop_size, 'hamming'); % Implement this!


% 1.4. Visualization. Create a new figure with three subplots.
figure(1)
% 1.4.1. Plot the whole signal into subplot 1. Denote x-axis as seconds.
% Set appropriate strings to title, xlabel and ylabel
subplot(3,1,1)

t=(0:length(data)-1) / Fs;
plot(t,data)

title('The whole signal')
xlabel('Seconds');
ylabel('Amplitude');


% 1.4.2. Plot a voiced frame from frame_matrix into subplot 2. Denote x-axis as milliseconds.
%subplot(3,1,2)
% Set appropriate strings to title, xlabel and ylabel

subplot(3,1,2)

t = (0:length(frame_matrix(:, 100))-1) / Fs;
plot(t*1E+3, frame_matrix(:, 100));

title('One voiced frame')
xlabel('Milliseconds')
ylabel('Amplitude')

% 1.4.3. Plot the magnitude spectrum of the same frame as in 1.4.2. into
% subplot 3. Denote x-axis as Hz, and y-axis as decibels.
% Set appropriate strings to title, xlabel and ylabel

subplot(3,1,3)

y = fft(frame_matrix(:, 1-0));
f = Fs * ((1:frame_length) - 1) / frame_length;
magnitude = abs(y);
decibels = mag2db(magnitude);
plot(f(1:length(f)/2), decibels(1:length(f)/2)); 

title('Magnitude spectrum');
xlabel('Hz');
ylabel('Decibels');


% 1.4.4. Compute and plot the spectrogram of the whole signal into a new
% figure.
figure(2)
%subplot(4,1,1);

t = (0:size(frame_matrix, 2) - 1) * hop_size;
s = zeros(400, 216);

for i = 1:size(frame_matrix, 2)
    s(:, i) = 20 * log10(abs(fft(frame_matrix(:, i))));
end

surf(t(1:length(t)/2), f(1:length(f)/2), s(1:size(s, 1)/2 , 1:size(s, 2)/2), 'EdgeColor', 'none');
axis xy; 
axis tight; 
colormap(jet); 
view(0,90);
xlabel('Time (secs)');
colorbar;
ylabel('Frequency(HZ)');
title('spectrogram');



