function [a,b] = Recognize(scoresMat,sigma1,sigma2,t1,t2)


p_1 = scoresMat;

if sigma1 == 0
    matres = (p_1 >= repmat(t1,size(p_1,1),size(p_1,2)));
    p2 = p_1.*matres;
    if size(p2,1)>1
        nseglang = sum(matres,1);
        p1 = sum(p2,1)./nseglang;
    else
        p1 = p2;
    end
else
    B  = ones(size(p_1,1),size(p_1,2)) + exp(-1*(p_1-repmat(t1,size(p_1,1),size(p_1,2)))/sigma1);
    A  = ones(size(p_1,1),size(p_1,2))./B;
    %C  = abs(p_1-repmat(t1,size(p_1,1),size(p_1,2))).*A;
    C  = A.*p_1;
    p1 = sum(C,1)./sum(A,1);
end

% B2  = ones(size(p1,1),size(p1,2)) + exp(-1*(p1-repmat(t2,size(p1,1),size(p1,2)))/sigma2);
% A2  = ones(size(p1,1),size(p1,2))./B2;
% %C2  = abs(p1-repmat(t1,size(p1,1),size(p1,2))).*A2;
% C2  = A2.*p1;
% s_prim = sum(C2,1)./sum(A2,1);

[a,b] = max(p1);

% 
% for u=1:length(p1)
%     if isnan(p1(u))
% 
%         Res(u)=1;
%     else
%         if p1(u)<t2
%             Res(u)=1;
%         else
%             Res(u)=0;
%         end
%     end
% end
% Res = (s_prim < 0.5); %A vector which has 'NoTargetModels' elements
