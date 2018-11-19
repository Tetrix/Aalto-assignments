function [ w ] = ex3_perceptron_training( vad_input, outputs )
%EX3_PERCEPTRON_TRAINING Summary of this function goes here
%   Detailed explanation goes here
MAX_ITER = 100000;
w = zeros(1,size(vad_input,1)); % Initialize weight matrix as zeroes
y = zeros(size(outputs)); % Initial forward pass is zeroes

% Training:
iter = 0;

while iter < MAX_ITER
   % Compute weight gradient:
   dw = (outputs-y)*vad_input'/size(vad_input,2);
  
   % Update weights 
   w = w+dw;
   
   % Apply non-linearity
   y = ((w*vad_input) > 0);
   
   iter = iter+1;
end

disp(['Perceptron training complete after ' num2str(iter) ' iterations.']);

end

