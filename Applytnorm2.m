function tnorm=Applytnorm2(SCR)
tnorm(1:size(SCR,1),1:size(SCR,2))=0;
c=3;
for i=1:size(SCR,2)
    for j=1:size(SCR,1)
        A=SCR(:,i); A(j)=[];
        MED=median(A);
        MAD=median(abs(A-MED));
        tnorm(j,i)=(SCR(j,i)-MED)/(c*MAD);
    end
end