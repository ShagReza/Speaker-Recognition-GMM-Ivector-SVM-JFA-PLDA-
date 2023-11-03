function    t_norm_scores=t_norm_seg_non_select(scores,NoModels,NoTargetModels,Dist)

Num_seg         = length(scores)/NoModels;
t_norm_scores   = ones(length(scores),1);

% if Flag==0
%     Targ_Num  = NoTargetModels+1:NoModels;
% else
%     Targ_Num = 1:NoModels;
% end
NumTnorm=40;

if (NoModels>1)
    for cnt_seg=1:Num_seg
        for cnt_tar=1:NoTargetModels
            Index_F=[];
            Index_M=[];            
            [Val_Select,Ind_Select]=sort(Dist(:,cnt_tar));                       
            for cnt=1:NumTnorm
                Index_F(cnt) = NoTargetModels+Ind_Select(cnt)+(cnt_seg-1)*NoModels;
            end           
          
            MeanScoresTar_t = mean(scores(Index_F));                        
            StdScoresTar_t  = std(scores(Index_F));
            Score_mean_norm = (scores-MeanScoresTar_t);
            t_norm_scores((cnt_tar+(cnt_seg-1)*NoModels))  = Score_mean_norm((cnt_tar+(cnt_seg-1)*NoModels))/(StdScoresTar_t+eps);
        end
    end
else
    t_norm_scores=scores;
end
