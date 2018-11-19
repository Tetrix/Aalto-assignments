addpath /work/courses/T/S/89/5150/general/ex1
addpath /work/courses/T/S/89/5150/general/ex1/gmmbayestb
load ex1data

plot(sampleword);


s = spectrogram(sampleword, hamming(400), 240);
imagesc(sqrt(abs(s)))
axis xy
sample_word_segmentation


s2 = spectrogram(filter([1 -0.97], 1, sampleword), hamming(400), 240);
figure
imagesc(sqrt(abs(s2)))
axis xy
sample_word_segmentation


plot(M', 'b')


figure
imagesc(log(M*sqrt(abs(s2))+1))
axis xy
sample_word_segmentation


imagesc(D)
colorbar


figure
imagesc(D*log(M*sqrt(abs(s2))+1))
axis xy
sample_word_segmentation

%{
 
a) What are the properties of MFCC features that make them well suited for 
automatic speech recognition?
-The MFCC decorrelates the features and reduces the dimensionality, which
makes them suited for automatic speech recognition.

b) Why spectrogram or mel-spectrum wouldn't work so well?
- The power spectrogram contains a lot of data and redundancy. It also
contains a lot of noise.
The mel spectrogram is better. It contains approximately 10 times less data
. It also contains less noise and less redundancy compared to the power
spectrogram.
MFCC uses discrete cosine transformation in order to decorrelate the
features and reduce the dimensionality.

%}




