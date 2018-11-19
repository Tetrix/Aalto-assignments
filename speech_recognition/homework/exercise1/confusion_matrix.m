addpath /work/courses/T/S/89/5150/general/ex1
addpath /work/courses/T/S/89/5150/general/ex1/gmmbayestb
load ex1data


S = train_gmm(train_data, train_class, 15);

result_test = gmmb_decide(gmmb_normalize(gmmb_pdf(test_data, S)));
error_test = length(find(result_test~=test_class))/length(test_class)*100;

C = confusion_matrix(result_test, test_class);

plot_confusion(C, phonemes);


%{

a) Based on the confusion matrix, what can you conclude about phoneme 
recognition as a task and recognition performance of different phoneme classifiers?

- Based on the confusion matrix, we can say that the classifier did fairly
well recognizing the phonemes.
The model did best recognizing the phonemes 's' and 'u'.


b) Give examples of difficulties this classifier has.

- The classifier had difficulties recognizing 'p', 't', 'i', 'k'.

%}


tw1_predict = gmmb_decide(gmmb_normalize(gmmb_pdf(tw1, S)));
first_word = [];

for i = drange(1, length(tw1_predict))
   first_word = [first_word, phonemes(tw1_predict(i))];
end
first_word


tw2_predict = gmmb_decide(gmmb_normalize(gmmb_pdf(tw2, S)));
second_word = [];

for i = drange(1, length(tw2_predict))
   second_word = [second_word, phonemes(tw2_predict(i))];
end
second_word



tw3_predict = gmmb_decide(gmmb_normalize(gmmb_pdf(tw3, S)));
third_word = [];

for i = drange(1, length(tw3_predict))
   third_word = [third_word, phonemes(tw3_predict(i))];
end
third_word



%{

a) Which model performs classification better, the DNN or your best GMM? 

 - The results are similar but DNN model performs slightly better than GMM.

b) The DNN training script tells you the number of parameters. Look inside 
your best model (struct S in Matlab). Which has more parameters? 

- DNN model has more parameters.
The GNN model has 17 parameters and the DNN models has 145707.

%}


