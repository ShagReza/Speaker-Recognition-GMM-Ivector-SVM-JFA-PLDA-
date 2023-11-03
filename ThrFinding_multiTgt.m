function [ EERMin, FRBest,FABest, FIBest,t1_best, t2_best]=ThrFinding_multiTgt(TotalImpScores,TotalTgtScores,TargetScoreFiles,ImpScoreFiles,NoSegImp,NoSegTgt,NoTargetModels,TotalTgtScoresMat,TotalImpScoresMat,NumOfTest,N_tgt,N_Imp,min_sigma1,step_sigma1,max_sigma1,min_t1,nStep_t1,max_t1,min_t2,nStep_t2,max_t2,sigma2)

step_t1    = (max_t1-min_t1)/nStep_t1 ;
step_t2    = (max_t2-min_t2)/nStep_t2 ;
%=============================================
D = 0;
for i=1:length(NumOfTest)
    D=[D, sum(NumOfTest(1:i))];
end
Flag=0;
EERMin =50;
EERDiffMin=0;
scores=[];
scores_tar=[];
scores_imp=[];
ThGr1=0.01;
ThGr2=0.05;
t2 = min_t2;
for sigma1 = min_sigma1 : step_sigma1 : max_sigma1
    sigma1
    metric1=[];
    metric2=[];
    FA=[];
    FR=[];
    for t1 = min_t1 : step_t1 : max_t1
        for t2 = min_t2 : step_t2 : max_t2

            indx_t1 = round((t1-min_t1)/step_t1)+1;
            indx_t2 = round((t2-min_t2)/step_t2)+1;
            Indx_sigma = round((sigma1-min_sigma1)/step_sigma1)+1;

            clear scoresMat;
            NFR = 0; NA = 0 ; FId = 0; Ntrueident = 0 ;
            j = 1; jj = 0;
            scores=[];
            scores_tar=[];
            scores_imp=[];

            for i=1:length(TargetScoreFiles)-2
                j = jj+1;
                jj = j+NoSegTgt(i)-1;
                tempV = find(D-i>=0);
                lan = tempV(1) - 1;
                scoresMat   = TotalTgtScoresMat(j:jj,:);
                scores_tar  = [scores_tar scoresMat' ];
                [a,b] = Recognize(scoresMat,sigma1,sigma2,t1,t2);
                if a>=t2
                    NA = NA+1;
                    if b==lan
                        Ntrueident = Ntrueident+1;
                    else
                        FId = FId +1;
                    end
                else
                    NFR = NFR+1;
                end
            end

            clear scoresMat;
            NFA = 0;
            j=1; jj=0;
            for i=1:length(ImpScoreFiles)-2
                j = jj+1 ;
                jj = j + NoSegImp(i)-1;
                scoresMat = TotalImpScoresMat(j:jj,:);
                scores_imp=[scores_imp scoresMat' ];
                [a,b] = Recognize(scoresMat,sigma1,sigma2,t1,t2);
                if  a>=t2
                    NFA = NFA + 1;
                end
            end

            FR (indx_t2) = NFR / N_tgt * 100;
            FA (indx_t2) = NFA / N_Imp * 100;
            FI (indx_t2) = (NA-Ntrueident) / NA * 100;
            metric1(indx_t2) = (FR (indx_t2) + FA (indx_t2))/2;
            metric2(indx_t2) = abs(FR (indx_t2) - FA (indx_t2))/( metric1(indx_t2)+eps);

            if ( metric2(indx_t2) < 0.5 && metric1(indx_t2) < EERMin)
                EERDiffMin = metric2(indx_t2);
                EERMin = metric1(indx_t2);
                t1_best = t1;
                t2_best = t2;
                Indx_sigma_best = Indx_sigma;
                FRBest = FR (indx_t2);
                FABest = FA (indx_t2);
                FIBest = FI (indx_t2);
                Flag=1;
                %                 scores=[scores_tar scores_imp];
                %    save (['res/' ['Scores_UBM_MIC_Imp_5_149CH=jfa']], 'scores_tar','scores_imp','-double');
            end

        end
        %         MinEER_t2=min(metric1)
        %         EERMin
    end

    if Flag  == 1
        EERMin
        EERDiffMin
        t1_best
        t2_best
        FRBest
        FABest
        Indx_sigma_best
        FIBest
    end
end


