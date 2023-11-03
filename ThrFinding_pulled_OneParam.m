
function [Min_metric,minError,Thershold,MED_total,MAD_total]=ThrFinding_pulled_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)

T=0.5;
%-----------------------------------------
min_t  = -0.5;
max_t  = 1;
nStep_t =100;
step_t = (max_t-min_t)/nStep_t;
%-----------------------------------------
MED_total=median(SCORE_imp(:));
MAD_total=median(abs(SCORE_imp(:)-MED_total));
c=3;
MaxDiffer_FAFR=0.1;
%-----------------------------------------
I=sum(NumOfTest_test);
I2=size(NumOfSegments_imp,2);
k=1;
cls=[];
for i=1:size(NumOfTest_test,2)
    cls(1,k:k+NumOfTest_test(i)-1)=i;
    k=k+NumOfTest_test(i);
end
FA=[]; FR=[];
nt=0;
NumSpeaker=size(NumOfTest_test,2);
%------------------------------------------------
for t =  min_t :step_t : max_t
    nt=nt+1
    j = 1;   jj = 0;
    NFR=0;
    for i = 1:I
        j = jj+1;   jj = j+NumOfSegments_test(i)-1;
        scr= ComparisionThreshold(t,c,MAD_total,MED_total,SCORE_test(:,j:jj)');
        if scr(cls(i))<T
            NFR=NFR+1;
        end
    end
    FR(nt) = NFR/ I*100;
    %--------------
    j = 1;   jj = 0;
    NFA=0;
    for i = 1:I2
        j = jj+1;   jj = j+NumOfSegments_imp(i)-1;
        scr= ComparisionThreshold(t,c,MAD_total,MED_total,SCORE_imp(:,j:jj)');
        for k=1:size(NumOfTest_test,2)
            if scr(k)>=T
                NFA=NFA+1;
            end
        end
    end
    FA(nt) = NFA/(size(NumOfTest_test,2)*I2)*100;
    %--------------
    metric(nt)  = abs(FA(nt)-FR(nt));
end
%------------------------------------------------






%------------------------------------------------
Error_EER=[];
Index=[];
L=0;
Differ_FAFR=MaxDiffer_FAFR;

while isempty(Error_EER)
    for k=1:nt
        if  metric(k)<Differ_FAFR
            L=L+1;
            Index(L,1)=k;
            Error_EER(L)=(FA(k)+FR(k))/2;
        end
    end
    Differ_FAFR=Differ_FAFR*2;
end

[a,b]=min(Error_EER);
nT=Index(b,1);
minError=(FA(nT)+FR(nT))/2;
Min_metric=metric(nT);
Thershold      = (nT-1) * step_t + min_t;
%------------------------------------------------



