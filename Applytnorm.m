function tnorm=Applytnorm(SCR)
tnorm(1:size(SCR,1),1:size(SCR,2))=0;
for i=1:size(SCR,2)
    for j=1:size(SCR,1)
        A=SCR(:,i); A(j)=[];
        tnorm(j,i)=(SCR(j,i)-mean(A))/(sqrt(var(A)));
    end
end