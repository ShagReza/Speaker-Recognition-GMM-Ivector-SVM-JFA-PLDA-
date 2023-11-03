function LLR=ApplyLLR2(SCR)
LLR(1:size(SCR,1),1:size(SCR,2))=0;
for i=1:size(SCR,2)
    for j=1:size(SCR,1)
        A=SCR(:,i); %A(j)=[];
        LLR(j,i)=log(SCR(j,i)/sum(A));
    end
end