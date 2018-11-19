function [ output ] = ex3_normalize( M )
%EX3_NORMALIZE Normalize (zero-mean and unit variance) the values of input matrix M for each row.
%   Detailed explanation goes here

output = zeros(size(M));

for i = 1:size(M,1)
   tmp = M(i,:);
   tmp = tmp-mean(tmp); % Zero-mean
   tmp = tmp/norm(tmp); % Unit variance
   output(i,:) = tmp; 
end

end

