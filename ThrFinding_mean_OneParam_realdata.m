
function [Results,meanE]=ThrFinding_mean_OneParam_realdata(SCORE_test,SCORE_imp,Numfiles_test,NumSpks_test,NumSegs_test,NumSegs_imp,NumSpks_imp)

T=0.5;
%-----------------------------------------
min_t  = -0.5;
max_t  = 1;
nStep_t =100;
step_t = (max_t-min_t)/nStep_t;
%-----------------------------------------
for i=1:size(SCORE_imp,1)
    MED(i)=median(SCORE_imp(i,:));
    MAD(i)=median(abs(SCORE_imp(i,:)-MED(i)));
end
c=3;
MaxDiffer_FAFR=0.1;
%-----------------------------------------
I=sum(Numfiles_test);
% I2=size(NumOfSegments_imp,2);
% k=1;
% cls=[];
% for i=1:size(NumOfTest_test,2)
%     cls(1,k:k+NumOfTest_test(i)-1)=i;
%     k=k+NumOfTest_test(i);
% end
%NumSpeaker=size(NumOfTest_test,2);
%-----------------------------------------
NumSpeaker=size(SCORE_test,1);
nt=0;
FA_s=[];FR_s=[]; EER_s=[]; metric_s=[];

for t =  min_t :step_t : max_t
    nt=nt+1
    %-------------
    j = 1;   jj = 0;
    NFR=[]; NFR(1:NumSpeaker)=0; Ntarget(1:NumSpeaker)=0;
    for numtarget=1:length(Numfiles_test)
        Ntarget(numtarget)=0;
        for numtest=1:Numfiles_test(numtarget)
            scr=[]; scrotal=[];
            for numspks=1:NumSpks_test(numtarget,numtest)
                if (NumSegs_test(numtarget,numtest,numspks)~=0)
                    j = jj+1;   jj = j+NumSegs_test(numtarget,numtest,numspks)-1;
                    scr(numspks)= ComparisionThreshold(t,c,MAD(numtarget),MED(numtarget),SCORE_test(numtarget,j:jj)');
                end
            end
            if isempty(scr)==0
                scrtotal=max(scr);
                if scrtotal<T
                    NFR(numtarget)=NFR(numtarget)+1;
                end
                Ntarget(numtarget)=Ntarget(numtarget)+1;
            end
            
        end
    end
    
    for numtarget=1:NumSpeaker
        FR_s(numtarget,nt) = NFR(numtarget)/  Ntarget(numtarget)*100;
    end
    %--------------
    j = 1;   jj = 0;
    NFA(1:NumSpeaker)=0; Nimp=0;
    for numimp=1:length(NumSpks_imp)
         scr=[];
        for numspks=1:NumSpks_imp(numimp)
            nn=0;
            if (NumSegs_imp(numimp,numspks)~=0)
                nn=nn+1;
                j = jj+1;   jj = j+NumSegs_imp(numimp,numspks)-1;
                for numtarget=1:NumSpeaker
                    scr(numtarget,nn)= ComparisionThreshold(t,c,MAD(numtarget),MED(numtarget),SCORE_imp(numtarget,j:jj)');
                end
            end  
        end
        if(isempty(scr)==0)
            for numtarget=1:NumSpeaker
                if max(scr(numtarget,:))>=T
                    NFA(numtarget)=NFA(numtarget)+1;
                end
            end
            Nimp=Nimp+1;
        end
    end
   for i=1:NumSpeaker
        FA_s(i,nt) = (NFA(i)/Nimp)*100;
   end
    %--------------
    for i=1:NumSpeaker
        EER_s(i,nt) = (FA_s(i,nt)+FR_s(i,nt))/2;
        metric_s(i,nt)  = abs(FA_s(i,nt)-FR_s(i,nt));
    end
end
%-----------------------------------------



%-----------------------------------------
meanE=0;
Results=[];
for n=1:NumSpeaker
    Error_EER=[];
    Index=[];
    L=0;
    Differ_FAFR=MaxDiffer_FAFR;
    while isempty(Error_EER)
        for k=1:nt
            if  metric_s(n,k)<Differ_FAFR
                L=L+1;
                Index(L,1)=k;
                Error_EER(L)=(FA_s(n,k)+FR_s(n,k))/2;
            end
        end
        Differ_FAFR=Differ_FAFR*2;
    end
    
    [a,b]=min(Error_EER);
    nT=Index(b,1);
    minError=(FA_s(n,nT)+FR_s(n,nT))/2;
    Min_metric=metric_s(n,nT);
    Thershold       = (nT-1) * step_t + min_t;
    meanE=meanE+minError;
    Results(n,1:5)=[minError,Min_metric,Thershold,MED(n),MAD(n)];
end
meanE=meanE/NumSpeaker;
%-----------------------------------------

