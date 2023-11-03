function Dist = function_cohort_selection(Path_Stats)
load(Path_Stats);

TargetFiles = dir(Path.TargetSpeakers_Train);
NonTargetFiles = dir(Path.NonTargetSpeakers_Train);

for cnt_tar=3:length(TargetFiles)
    filename=[Path.s_Models TargetFiles(cnt_tar).name ,'.gmm'];
    [MSV,CSV,W]=readALZgmm_me(filename);
    NComp       = size(MSV,1);
    NFeat     = size(MSV,2);
    W_r = repmat(W,1,NFeat);
    for cnt_nontar=3:length(NonTargetFiles)
       filename=[Path.s_Models NonTargetFiles(cnt_nontar).name ,'.gmm'];
       cnt_nontar;
       [MSVn,CSVn,Wn]=readALZgmm_me(filename);
       DelMu= MSVn-MSV;
       Dist(cnt_nontar-2,cnt_tar-2)=sum(W_r(:).*DelMu(:).*CSVn(:).*DelMu(:));
%      [Val(cnt_tar-2,:),Index(cnt_tar-2,:)]=sort(Dist(:,cnt_tar-2));
    end
end

