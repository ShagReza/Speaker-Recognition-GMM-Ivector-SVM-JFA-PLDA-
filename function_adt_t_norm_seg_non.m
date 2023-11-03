function    t_norm_scores=adt_t_norm_seg_non(scores,NoModels,NoTargetModels,FIndex,MIndex,GenderIndex)

Num_seg         = length(scores)/NoModels;
t_norm_scores   = ones(length(scores),1);
% if Flag==0
%     Targ_Num  = NoTargetModels+1:NoModels;
% else
%     Targ_Num = 1:NoModels;
% end

if (NoModels>1)
    for cnt_seg=1:Num_seg
        for cnt_targ=1:NoModels
            Index_F=[];
            Index_M=[];            
           
            for cnt=1:length(FIndex)
                Index_F(cnt) = NoTargetModels+ FIndex(cnt)+(cnt_seg-1)*NoModels;
            end            
            for cnt=1:length(MIndex)
                Index_M(cnt) = NoTargetModels+MIndex(cnt)+(cnt_seg-1)*NoModels;
            end
            
            MeanScoresTar_F = mean(scores(Index_F));
            MeanScoresTar_M = mean(scores(Index_M));
            
%             if (GenderIndex(cnt_targ)==0)
                MeanScoresTar_t=MeanScoresTar_M;
                StdScoresTar_t =std(scores(Index_M));
%             else                
%                 MeanScoresTar_t=MeanScoresTar_F;
%                 StdScoresTar_t =std(scores(Index_F));
%             end
            
            Score_mean_norm = (scores-MeanScoresTar_t);
            t_norm_scores((cnt_targ+(cnt_seg-1)*NoModels))  = Score_mean_norm((cnt_targ+(cnt_seg-1)*NoModels))/(StdScoresTar_t+eps);
        end
    end
else
    t_norm_scores=scores;
end

