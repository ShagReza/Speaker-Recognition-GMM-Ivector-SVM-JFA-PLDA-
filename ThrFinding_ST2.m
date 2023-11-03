
function [Results,meanE]=ThrFinding_ST2(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)

%------------------------------------------------
min_t1  = -5;
max_t1  = 0;
nStep_t1 =100;
step_t1 = (max_t1-min_t1)/nStep_t1;

min_t2 = -5;
max_t2 = 0;
nstep_t2 =100;
step_t2 = (max_t2-min_t2)/nstep_t2;

min_sigma = 0;
max_sigma = 1;
step_sigma =0.1;
nSigma=0;

MaxDiffer_FAFR=0.1;
%------------------------------------------------






%------------------------------------------------
I=sum(NumOfTest_test);
I2=size(NumOfSegments_imp,2);
k=1;
cls=[];
for i=1:size(NumOfTest_test,2)
    cls(1,k:k+NumOfTest_test(i)-1)=i;
    k=k+NumOfTest_test(i);
end
NumSpeaker=size(NumOfTest_test,2);

FA_s=[];FR_s=[]; EER_s=[]; metric_s=[];
FA=[]; FR=[]; metric=[]; EERmean=[];
nSigma=0;
for sigma = min_sigma : step_sigma : max_sigma
    nSigma=nSigma+1
    nt1=0;
    for t1 = min_t1 : step_t1 : max_t1
        nt1=nt1+1
        nt2=0;
        for t2 =  min_t2 :step_t2 : max_t2
            nt2=nt2+1;
            %-------------
            j = 1;   jj = 0;
            NFR(1:NumSpeaker)=0;
            for i = 1:I
                j = jj+1;   jj = j+NumOfSegments_test(i)-1;
                scr= ComparisionThershod_t1(t1,sigma,SCORE_test(:,j:jj)');
                if scr(cls(i))<t2
                    NFR(cls(i))=NFR(cls(i))+1;
                end
            end
            for i=1:NumSpeaker
                FR_s(i,nSigma,nt1,nt2) = NFR(i)/ NumOfTest_test(i)*100;
            end
            %--------------
            j = 1;   jj = 0;
            NFA(1:NumSpeaker)=0;
            for i = 1:I2
                j = jj+1;   jj = j+NumOfSegments_imp(i)-1;
                scr= ComparisionThershod_t1(t1,sigma,SCORE_imp(:,j:jj)');
                for k=1:size(NumOfTest_test,2)
                    if scr(k)>=t2
                        NFA(k)=NFA(k)+1;
                    end
                end
            end
            for i=1:NumSpeaker
                FA_s(i,nSigma,nt1,nt2) = (NFA(i)/I2)*100;
            end
            %--------------
            FA(nSigma,nt1,nt2)=0;
            FR(nSigma,nt1,nt2)=0;
            for i=1:NumSpeaker
                FA(nSigma,nt1,nt2) = FA(nSigma,nt1,nt2)+FA_s(i,nSigma,nt1,nt2);
                FR(nSigma,nt1,nt2) = FR(nSigma,nt1,nt2)+FR_s(i,nSigma,nt1,nt2);
            end
            FA(nSigma,nt1,nt2)=FA(nSigma,nt1,nt2)/NumSpeaker;
            FR(nSigma,nt1,nt2)=FR(nSigma,nt1,nt2)/NumSpeaker;
            %--------------
            for i=1:NumSpeaker
                EER_s(i,nSigma,nt1,nt2) = (FA_s(i,nSigma,nt1,nt2)+FR_s(i,nSigma,nt1,nt2))/2;
                metric_s(i,nSigma,nt1,nt2)  = abs(FA_s(i,nSigma,nt1,nt2)-FR_s(i,nSigma,nt1,nt2));
            end
            %--------------
            metric(nSigma,nt1,nt2)  = abs(FA(nSigma,nt1,nt2)-FR(nSigma,nt1,nt2));
            EERmean(nSigma,nt1,nt2)=(FA(nSigma,nt1,nt2)+FR(nSigma,nt1,nt2))/2;
        end
    end
end
%------------------------------------------------


% [x,y,z,Min_A]=MIN3Dimention(EERmean);
%t2 =  min_t2 :step_t2 : max_t2;
%nt2=0;
%for t2 =  min_t2 :step_t2 : max_t2;
%    nt2=nt2+1;
%    F(nt2)=FA_s(1,1,1,nt2);
%    R(nt2)=FR_s(1,1,1,nt2);
%end
%t2 =  min_t2 :step_t2 : max_t2;
%plot(t2,F,'-*');
%hold on;
%plot(t2,R,'-*');

% for sigma = min_sigma : step_sigma : max_sigma
%     nSigma=nSigma+1
%     nt1=0;
%     for t1 = min_t1 : step_t1 : max_t1
%         nt1=nt1+1
%         nt2=0;
%         for t2 =  min_t2 :step_t2 : max_t2
%             nt2=nt2+1;
%             
%         end
%     end
% end

% %------------------------------------------------
% Error_EER=[];
% Index=[];
% L=0;
% Differ_FAFR=MaxDiffer_FAFR;
% %%%%%%%%%%%%
% while isempty(Error_EER)
%     for i=1:nSigma
%         for j=1:nt1
%             for k=1:nt2
%                 if  metric(i,j,k)<Differ_FAFR
%                     L=L+1;
%                     Index(L,1:3)=[i,j,k];
%                     Error_EER(L)=(FA(i,j,k)+FR(i,j,k))/2;
%                 end
%             end
%         end
%     end
%     Differ_FAFR=Differ_FAFR*2;
% end
% %%%%%%%%%%%%    
% [a,b]=min(Error_EER);
% 
% nSIGMA=Index(b,1);
% nT1=Index(b,2);
% nT2=Index(b,3);
% minError=(FA(nSIGMA,nT1,nT2)+FR(nSIGMA,nT1,nT2))/2;
% Min_metric=metric(nSIGMA,nT1,nT2);
% Thershold1       = (nT1-1) * step_t1 + min_t1;
% Thershold2       = (nT2-1) * step_t2 + min_t2;
% Sigma= (nSIGMA-1) * step_sigma + min_sigma;
% %------------------------------------------------


meanE=0;
Results=[];
for n=1:NumSpeaker
    %------------------------------------------------
    Error_EER=[];
    Index=[];
    L=0;
    Differ_FAFR=MaxDiffer_FAFR;
    %%%%%%%%%%%%
    while isempty(Error_EER)
        for i=1:nSigma
            for j=1:nt1
                for k=1:nt2
                    if  metric_s(n,i,j,k)<Differ_FAFR
                        L=L+1;
                        Index(L,1:3)=[i,j,k];
                        Error_EER(L)=(FA_s(n,i,j,k)+FR_s(n,i,j,k))/2;
                    end
                end
            end
        end
        Differ_FAFR=Differ_FAFR*2;
    end
    %%%%%%%%%%%%    
    [a,b]=min(Error_EER);

    nSIGMA=Index(b,1);
    nT1=Index(b,2);
    nT2=Index(b,3);
    minError=(FA_s(n,nSIGMA,nT1,nT2)+FR_s(n,nSIGMA,nT1,nT2))/2;
    Min_metric=metric_s(n,nSIGMA,nT1,nT2);
    Thershold1       = (nT1-1) * step_t1 + min_t1;
    Thershold2       = (nT2-1) * step_t2 + min_t2;
    Sigma= (nSIGMA-1) * step_sigma + min_sigma;
    meanE=meanE+minError;
    %------------------------------------------------
    Results(n,1:5)=[minError,Min_metric,Thershold1,Thershold2,Sigma];
end
meanE=meanE/NumSpeaker;

