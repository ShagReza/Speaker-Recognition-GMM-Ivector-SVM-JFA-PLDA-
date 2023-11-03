save 
NumOfTest=[5 4 3 50];
sum(NumOfTest);
NumbOfTestFiles=[];
cnt3=0;
for cnt=1:length(NumOfTest)-1
    for cnt2=1:NumOfTest(cnt)
        cnt3=cnt3+1;
      NumbOfTestFiles(cnt3)=cnt;
    end
end



% % clear all;
Thresh = 0.10;
for cnt_o=1:20
    
    %load (['exp/' ['Scores_Mat=' num2str(cnt_o)]]);
    clear FAR FRR EER FI FId
    TrLab = textread('exp/scores_enroll_labels.txt','%s');
    TeLab = textread('exp/scores_test_labels.txt','%s');
    TestLength = length(TeLab);
    TestTargetLength = TestLength;
    
    MaxScores = max(scores);
    MinFI = TestTargetLength; cnt2=0;
    MinEER = 100;
    Flag=1;
    
    for Thr =min(MaxScores):0.01:max(MaxScores)
        TA=0;
        cnt2=cnt2+1;
        TI =0;TId=0;
        for cnt1=1:TestTargetLength
            [ii(cnt1),jj(cnt1)]=max(scores(cnt1,:));
            if (NumbOfTestFiles(cnt1)==jj(cnt1))
                TId = TId+1;
            end
            if ii(cnt1)>Thr
                if (NumbOfTestFiles(cnt1)==jj(cnt1))
                    TI = TI+1;
                end
                TA=TA+1;
            end
            %     end
        end
        FI=(TA-TI)/TA;
        FA=0;
        
        for cnt3=TestTargetLength+1:TestLength
            [ii(cnt3),jj(cnt3)]=max(scores(:,cnt3));
            if ii(cnt3)>Thr
                %         if isequal(TrLab{jj(cnt)}(1:10),TeLab{cnt}(1:10))
                FA=FA+1;
                %             cnt
                %         end
            end
        end
        
        FAR(cnt2) =  100*FA/(cnt3-cnt1);
        FRR(cnt2) =  100*(cnt1-TA)/cnt1;
        FIR(cnt2) =  100*FI;
        FIdR(cnt2)=  100*(cnt1-TId)/cnt1;
        
        EER(cnt2)=(FAR(cnt2)+FRR(cnt2))/2;
        EERdef(cnt2)=abs(FAR(cnt2)-FRR(cnt2))/EER(cnt2);
        
        if  (EERdef(cnt2)<Thresh && EER(cnt2)<MinEER)
            MinEER = EER(cnt2);
            MinFAR = FAR(cnt2);
            MinFRR = FRR(cnt2);
            MinFI = FIR(cnt2);
            MinFId = FIdR(cnt2);
            Flag=0;
        end
    end
    
    if Flag == 0
        MinEER_Optim(cnt_o) = MinEER;
        MinFAR_Optim(cnt_o) = MinFAR;
        MinFRR_Optim(cnt_o) = MinFRR;
        MinFI_Optim(cnt_o)  = MinFI;
        MinFId_Optim(cnt_o) = MinFId;
    else
        MinEER_Optim(cnt_o) = 100;
        MinFAR_Optim(cnt_o) = 100;
        MinFRR_Optim(cnt_o) = 100;
        MinFI_Optim(cnt_o)  = 100;
        MinFId_Optim(cnt_o) = 100;        
    end    
end

save (['exp/' ['MultiEER_Mat_Dena=' num2str(cnt_o)]],  'MinEER_Optim', 'MinFRR_Optim', 'MinFAR_Optim', 'MinFId_Optim' , 'MinFId_Optim' )

%  22.5302   21.3992   23.6613    3.6649   10.2881