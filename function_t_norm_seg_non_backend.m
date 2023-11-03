function    t_norm_scores=t_norm_seg_non_backend(scores,NoModels,NoTargetModels,Flag,G)

Num_seg         = length(scores)/NoModels;
t_norm_scores   = ones(length(scores),1);

if Flag==0
    Targ_Num  = NoTargetModels+1:NoModels;
else
    Targ_Num = 1:NoModels;
end

if (Targ_Num>1)
    for cnt_seg=1:Num_seg
        for cnt_targ=1:NoTargetModels
            if Flag==0
                Index = Targ_Num;
            else
                Index = find(Targ_Num~=cnt_targ);
            end
            Index =Index+(cnt_seg-1)*NoModels;
            MeanScoresTar_t = mean(scores(Index));
            Score_mean_norm = (scores-MeanScoresTar_t);
            % VarScoresTar_t = var(Score_mean_norm(Index));
            StdScoresTar_t  = std(scores(Index));
            t_norm_scores((cnt_targ+(cnt_seg-1)*NoModels)) = Score_mean_norm((cnt_targ+(cnt_seg-1)*NoModels))/(StdScoresTar_t+eps);
        end
        for cnt_targ=NoTargetModels+1:NoModels
            Index = find(Targ_Num~=cnt_targ);       
            Index = Index+(cnt_seg-1)*NoModels;
            MeanScoresTar_t = mean(scores(Index));
            Score_mean_norm = (scores-MeanScoresTar_t);
            StdScoresTar_t  = std(scores(Index));
            t_norm_scores((cnt_targ+(cnt_seg-1)*NoModels)) = Score_mean_norm((cnt_targ+(cnt_seg-1)*NoModels))/(StdScoresTar_t+eps);
        end
    end
else
    t_norm_scores=scores;
end

if cnt_seg==1
    for cnt=1:NoTargetModels
        LDA_vector(1,1)=t_norm_scores(cnt);
        LDA_vector(2:NoModels-NoTargetModels+1)=t_norm_scores(NoTargetModels+1:end);
        t_norm_scores(cnt)=-LDA_vector*G;
    end
end

