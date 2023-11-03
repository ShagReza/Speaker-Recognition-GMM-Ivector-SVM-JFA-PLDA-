function    t_norm_scores=t_norm_seg(scores,NoModels)
Num_seg = length(scores)/NoModels;

MeanScoresTar_t=ones(length(scores),1);
VarScoresTar_t=ones(length(scores),1);
t_norm_scores=ones(length(scores),1);
Targ_Num = 1:size(NoModels,1);
if (start_tnorm>1)
    for cnt_seg=1:Num_seg
        for cnt_targ=1:NoModels
            Index    = find(Targ_Num~=cnt_targ);
            Index=Index+(cnt_seg-1)*NoModels;
            MeanScoresTar_t(cnt_targ) = mean(scores(Index));
            VarScoresTar_t(cnt_targ)  = var(scores(Index));
            t_norm_scores(cnt_targ) = (scores-MeanScoresTar_t)./sqrt(VarScoresTar_t);
        end
    end
else
    t_norm_scores=scores;
end
