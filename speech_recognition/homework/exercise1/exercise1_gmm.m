addpath /work/courses/T/S/89/5150/general/ex1
addpath /work/courses/T/S/89/5150/general/ex1/gmmbayestb
load ex1data

error = [];
error_test = [];
num_components = [];

for i = drange(9:18)
    S = train_gmm(train_data, train_class, i);
    result = gmmb_decide(gmmb_normalize(gmmb_pdf(train_data, S)));
    %phonemes(result(2991:3010))
    error = [error, length(find(result~=train_class))/length(train_class)*100];

    result_test = gmmb_decide(gmmb_normalize(gmmb_pdf(test_data, S)));
    error_test = [error_test, length(find(result_test~=test_class))/length(test_class)*100];
    
    num_components = [num_components, i];
end

figure1 = figure;
plot(num_components, error)
hold on;
plot(num_components, error_test)
hold off;
legend({'train error', 'test error'});
xlabel('number of components');
ylabel('error');

saveas(figure1,'/u/15/porjazd1/unix/Documents/Aalto/SpeechRecognition/exercise1/error1.png');


%{

a) Why are the recognition results with the train and the test set different?
- The results are different because the classifier is trained on the
training data and that is why is has lower error rate.
On the other hand, the test set data has not been seen previously by the
classifier, so that is why it performs worse on it.

b) What is a good number of components for recognizing an unknown set of samples? 
- From the plot we can see that the optimal number of components for
recognizing an unknown set of samples is 15

%}

