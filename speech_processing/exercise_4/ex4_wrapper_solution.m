% Wrapper for main function to play around with pitch

clear;
close all;

% vowel: constant pitch 
% Play around with these values
vowel_new_constant_pitch = 150;     % Should be greater than 50
sentence_new_constant_pitch = 150; % Should be greater than 50
sentence_new_variable_pitch = 1.5; % Should be greater than 0.5

% main solution
[data_vowel, vowel_pitch_modified, data_sentence, sentence_pitch_modified_constant,...
    sentence_pitch_modified_variable, Fs] = ex4_main_solution(vowel_new_constant_pitch, sentence_new_constant_pitch,...
    sentence_new_variable_pitch);

