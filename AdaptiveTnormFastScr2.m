function [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr2(ivector_train,y,ivector_test,ivector_imp)
Ntnorm=20;
%-----------------------
%adaptive tnorm
for i=1:size(ivector_train,1)
    for j=1:size(y,1)
        SCORE_norm(i,j)=abs((ivector_train(i,:)*y(j,:)')/(norm(ivector_train(i,:))*norm(y(j,:))));
    end
end

index_norm=zeros(size(ivector_train,1),Ntnorm);
for i=1:size(ivector_train,1)
    [a,b]=sort(SCORE_norm(i,:));
    %[a,b]=sort(SCORE_norm(i,:));
    index_norm(i,1:Ntnorm)=b(1:Ntnorm);
end
%-----------------------
SCORE_test=[];
for i=1:size(ivector_train,1)
    i
    scrtotal=[]; scr=[]; scr_norm=[];
    for j=1:size(ivector_test,1)
        scr(1,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
    %---
    for k=1:size(index_norm,2)
        for j=1:size(ivector_test,1)
            scr_norm(k,j)=(y(index_norm(i,k),:)*ivector_test(j,:)')/(norm(y(index_norm(i,k),:))*norm(ivector_test(j,:)));
        end
    end
    %---
    scrtotal=[scr;scr_norm];
    scrtotal=ApplyLLR2(0.5*scrtotal+0.5);
    SCORE_test(i,:)=scrtotal(1,:);        
end
%-----------------------
SCORE_imp=[];
for i=1:size(ivector_train,1)
    i
    scrtotal=[]; scr=[]; scr_norm=[];
    for j=1:size(ivector_imp,1)
        scr(1,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
    %---
    for k=1:size(index_norm,2)
        for j=1:size(ivector_imp,1)
            scr_norm(k,j)=(y(index_norm(i,k),:)*ivector_imp(j,:)')/(norm(y(index_norm(i,k),:))*norm(ivector_imp(j,:)));
        end
    end
    %---
    scrtotal=[scr;scr_norm];
    scrtotal=ApplyLLR2(0.5*scrtotal+0.5);
    SCORE_imp(i,:)=scrtotal(1,:);        
end
%---------------------

