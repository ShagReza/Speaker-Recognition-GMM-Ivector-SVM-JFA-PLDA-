function [ PooledEERMin, PooledFRBest,PooledFABest,t1_best, t2_best]=ThrFinding_singleTgt(TotalImpScores,TotalTgtScores,TargetScoreFiles,ImpScoreFiles,NoSegImp,NoSegTgt,NoTargetModels,TotalImpScoresMat,N_tgt,N_Imp,min_sigma1,step_sigma1,max_sigma1,min_t1,nStep_t1,max_t1,min_t2,nStep_t2,max_t2,sigma2)
%Testing...
step_t1    = (max_t1-min_t1)/nStep_t1 ;
step_t2    = (max_t2-min_t2)/nStep_t2 ;
%==============================================================
step_t1_o=step_t1;
step_t2_o=step_t2;
t1= min_t1;
t2= min_t2;
Flag =0;
PooledEERMinTemp=100;
PooledEERMin =100;
PooledEERDiffMin=0;

for sigma1 = min_sigma1 : step_sigma1 : max_sigma1    
   
    for t1 = min_t1 : step_t1 : max_t1
         PooledEERTemp=[];
        for t2 = min_t2 : step_t2 : max_t2
            
            indx_t1 = round((t1-min_t1)/step_t1)+1;
            indx_t2 = round((t2-min_t2)/step_t2)+1;
            Indx_sigma = round((sigma1-min_sigma1)/step_sigma1)+1;
            
            clear scoresVec;
            NFR = 0;
            j = 1; jj = 0;
            for i=1:length(TargetScoreFiles)-2
                j = jj+1 ;
                jj = j+NoSegTgt(i)-1;
                scoresVec = TotalTgtScores(j:jj);
                Res1 = Recognize2(scoresVec,sigma1,sigma2,t1,t2);
                NFR = NFR + sum(Res1);
            end
            
            clear scoresMat;
            NFA = 0;
            j=1; jj=0;
            for i=1:length(ImpScoreFiles)-2
                j = jj+1 ;
                jj = j + NoSegImp(i)-1;
                scoresMat = TotalImpScoresMat(j:jj,:);
                Res2 = Recognize2(scoresMat,sigma1,sigma2,t1,t2);
                NFA = NFA + sum(~Res2);
            end
            
            PooledFR (indx_t1,indx_t2) = 100*NFR / (N_tgt);
            PooledFA (indx_t1,indx_t2) = 100*NFA / (N_Imp * NoTargetModels);
            PooledEER(indx_t1,indx_t2) = (PooledFR(indx_t1,indx_t2)+PooledFA(indx_t1,indx_t2))/2;
            PooledEERDiff(indx_t1,indx_t2) = abs(PooledFR(indx_t1,indx_t2)-PooledFA(indx_t1,indx_t2))/(PooledEER(indx_t1,indx_t2)+eps);
            PooledEERTemp(indx_t2) = PooledEER(indx_t1,indx_t2);
%           pause            
            if (PooledEERDiff(indx_t1,indx_t2) <0.1 && PooledEER(indx_t1,indx_t2) < PooledEERMin)
                PooledEERDiffMin = PooledEERDiff(indx_t1,indx_t2);
                PooledEERMin = PooledEER(indx_t1,indx_t2);
                t1_best = t1;
                t2_best = t2;
                Indx_sigma_best = Indx_sigma;
                PooledFRBest = PooledFR(indx_t1,indx_t2)
                PooledFABest = PooledFA(indx_t1,indx_t2)
                Flag=1 
            end            
        end        
%         PooledEERMinTemp =min( PooledEERTemp)
%         if indx_t1>1
%             [ min(PooledEER(indx_t1,1:indx_t2))   min(PooledEER(indx_t1-1,1:indx_t2))]
%            %  PooledEER(indx_t1,:)
%             if min(PooledEER (indx_t1,1:indx_t2))>=  min(PooledEER (indx_t1-1,1:indx_t2))
%                 step_t1= step_t1*1.5;
%                 step_t2= step_t2*1.5;
%             else
%                 step_t1= step_t1_o;
%                 step_t2= step_t2_o;
%             end
%              indx_t2_temp=indx_t2;
%         end
        
    end
%     if Flag == 1
        PooledEERMin
        PooledEERDiffMin
        t1_best
        t2_best
        PooledFRBest
        PooledFABest
%     end
    
    %     [Val1, Inx1] = min(PooledEERDiff,[],1);
    %     [Val2, Inx2] = min(Val1);
    %     EER(Indx_sigma) = Val2;
    %     Inx_t1_star(Indx_sigma) = Inx1(Inx2);
    %     Inx_t2_star(Indx_sigma) = Inx2;    
end

% [Best_EER_Cod,InxBestSigma1] = min(PooledEERDiff)
% Best_EER = Best_EER_Cod(PooledEERDiff)
%
% Best_t1_star = (Inx_t1_star(InxBestSigma1)-1)*step_t1 + min_t1
% Best_t2_star = (Inx_t2_star(InxBestSigma1)-1)*step_t2 + min_t2
% BestSigma    = (InxBestSigma1-1) * step_sigma1 + min_sigma1

