% ELEC-E5500 Speech Processing -- Autumn 2017 Matlab Exercise 2:
% Fundamental frequency estimation

close all; clear;

addpath('../exercise_1/');

% Section 1: Use the code from Exercise 1 to read and window the analyzed sample:
% 1.1. Read the audio file and sampling rate
[data, Fs] = audioread('SX83.WAV'); 

% 1.3. Split the data sequence into windows. Use ex1_windowing.m
frame_length = round(0.05*Fs); % In samples
hop_size = round(0.0125*Fs); % In samples
window_types = {'rect','hann','cosine','hamming'};

%frame_matrix = ex1_windowing(data, frame_length, hop_size, window_types{4});
% You can use the given solutions of previous exercises if you want
frame_matrix = ex1_windowing_solution(data, frame_length, hop_size, window_types{4}); 

% Section 2: Fundamental frequency estimation with the autocorrelation method
% 2.1. Define minimum and maximum values for the F0 search range, and the
% threshold value for Voiced/Unvoiced decision. 
f0_max = 180; % In Hz
f0_min = 50; % In hz
vuv_threshold_ac = 0.6;

% 2.2 Write a loop through frame_matrix that calls the function ex2_fundf_autocorr to obtain
% the F0 estimates for each frame
f0vec_ac = zeros(1,size(frame_matrix,2)); % Allocate f0 vector for autocorrelation method
ac_peak_vec = zeros(1,size(frame_matrix,2)); % Allocate ac peak vector
for iFrame = 1:size(frame_matrix,2)
    [f0vec_ac(iFrame), ac_peak_vec(iFrame)] = ex2_fundf_autocorr( frame_matrix(:, iFrame), Fs, f0_min, f0_max, vuv_threshold_ac );
end



% Section 3: Fundamental frequency estimation with the cepstrum method
vuv_threshold_ceps = 0.2;
f0vec_ceps = zeros(1,size(frame_matrix,2)); % Allocate f0 vector for cestrum method
ceps_peak_vec = zeros(1,size(frame_matrix,2)); % Allocate cepstral peak vector
for iFrame = 1:size(frame_matrix,2)
    [f0vec_ceps(iFrame), ceps_peak_vec(iFrame)] = ex2_fundf_cepstrum( frame_matrix(:, iFrame), Fs, f0_min, f0_max, vuv_threshold_ceps );
end

% Section 4: Test & Visualize your results
figure();

% 4.1. Plot the spectrogram of the original signal as in Ex 1.4.4.
subplot(3,1,1);

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
title('spectrogram');




% 4.2. Plot the estimated F0 vectors. Report F0max and F0min within the
% title.
subplot(3,1,2);
plot(t, f0vec_ceps);
hold on
plot(t, f0vec_ac)
hold off
title(sprintf('The F0max is: %d and the f0min is: %d', f0_max, f0_min))
xlabel('Time(s)')
ylabel('Frequency(Hz)')
legend('cepstrum','autocorrelation')

% 4.3. Plot the peak amplitudes of the cepstral peak and the
% autocorrelation peak
subplot(3,1,3);
plot(t, ceps_peak_vec);
hold on
plot(t, ac_peak_vec)
hold off
xlabel('Time(s)')
ylabel('Amplitude')
legend('cepstrum','autocorrelation')


% 4.4. Experiment with the parameters.
% a) How does tuning these parameters affect the autocorrelation method?
% Report your findings regarding at least:
%       i) Frame length
%       ii) Windowing function
%       iii) F0 search range
%       iv) Voicing threshold value
% b) Same as a), but for the cepstral method

%{
 a)
    i) Lowering the frame length lowers the autocorrelation so we also need to
    lower the threshhold value. It's also harder to find the correct F0.

    Increasing the frame length increases the autocorrelation so we need to
    increase the threshhold in order to find the correct F0.

    ii) Compared to hamming, if we use the cosine windowing function, the
    autocorrelation does not change.

    Compared to hamming, if we use the hann windowing function, the
    autocorrelation does not change.

    Compared to hamming, if we use the rect windowing function, the
    autocorrelation changes significantly. Some peaks are the same and some
    are higher than cepstrum. If we increase the threshhold for the
    autocorrelation a little bit, the autocorrelation and cepstrum peaks
    match.

    The hamming finds the F0 frequencies for the autocorrelation well.

    iii) If we increase the f0max, we autocorrelation changes a little bit

    iV) With high threshhold values we have more 0 values

        With low values it's hard to find the correct F0

 b) 
   i) Lowering the frame length lowers the amplitude of the cepstrum but
   it's not as noticable as in the autocorrelation. It's also harder to
   find the correct F0.

    Increasing the frame length dons not affect the cepstrum significantly

   ii) Compared to hamming, if we use the cosine windowing function, the
    cepstrum changes a little bit (there are couple of different peaks) but it doesn't change significantly.

    Compared to hamming, if we use the hann windowing function, the
    cepstrum does not change.

    Compared to hamming, if we use the rect windowing function, the
    amplitude for the cepstrum has changed significantly. It is also
    harder to find the F0 frequencies. Also we might need to lower the
    cepstrum.

    The hamming finds the F0 frequencies for the cepstrum well.


   iii) If we increase the F0max, the cepstrum changes more signifincatly

   iV) With high threshhold values we have more 0 values

        With low values it's hard to find the correct F0
%}




