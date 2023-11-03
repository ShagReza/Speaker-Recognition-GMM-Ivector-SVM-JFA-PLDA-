
%=======================================================================
% function  [princComp meanVec] = trainPCA(data)
%
% Principla Component Analysis (PCA)
%
%   Input:
%       Data    - NFeature  x NSample   Training data
%
%   Output:
%       princComp   - Principal Expectation of latent varialbe h and latent
%                       noise 
%       meanVec     - Mean vector of the data
%
function [princComp meanVec] = trainPCA(data)
[nDim nData] = size(data);
meanVec = mean(data,2);
data = data-repmat(meanVec,1,nData);

XXT = data'*data;
[dummy LSq V] = svd(XXT);
LInv = 1./sqrt(diag(LSq));
princComp  = data * V * diag(LInv);
% End of function trainPCA