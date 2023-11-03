function function_GMMUBM_Test(Path_Stats)

load(Path_Stats);
%=====================================================================
% Path and Parameters
SegmentLen = Param.SegmentLen;
OverlapLen = Param.OverlapLen;
MaxLength  = Param.MaxLength;
TargetSNR  = Param.TargetSNR;
ImpSNR     = Param.ImpSNR;

%=====================================================================

% # of models (target and nantarget models)

NonTargetModels = dir(Path.NonTargetSpeakers_Train);
TargetModels    = dir(Path.TargetSpeakers_Train);
ModelOfTestingFile = [];
for i=3:length(TargetModels)
    ModelOfTestingFile = [ModelOfTestingFile,' ',TargetModels(i).name];
end
for i=3:length(NonTargetModels)
    ModelOfTestingFile = [ModelOfTestingFile,' ',NonTargetModels(i).name];
end

NoTargetModels    = length(TargetModels)-2;                 % # of targert speaker models
NoNonTargetModels = length(NonTargetModels)-2;              % # of nontargert speaker models
NoModels          = NoTargetModels + NoNonTargetModels;     % # of speaker models either targert or nontarget
%=====================================================================
fprintf ('\n%s\n',' Calculating target scores and normalizing.... ') ;

%Calculating target scores and normalizing the scores...
tic;
TargetClients = dir(Path.TargetSpeakers_Test);% # of client
NumOfTest=zeros(length(TargetClients)-2,1)';  
length(TargetClients)
for i=3:length(TargetClients)   
   
    % # of test file 
    TargetWavePath = [Path.TargetSpeakers_Test ,TargetClients(i).name,'\'];
    TargetWaves = dir(TargetWavePath);
    L = length(TargetClients(i).name); 
    index=0;      
    for k=3:length(TargetModels)        
        if length(TargetModels(k).name) == L
            if  sum(TargetModels(k).name == TargetClients(i).name)~=L
                
            else
                index = k-2;
            end
        end        
        if isequal(TargetModels(k).name, TargetClients(i).name) 
            index = k-2;
        end    
    end       
    if index==0
        fprintf('Error: The client, "%s" , is not a Target speaker\n',TargetClients(i).name)        
    else        
        cnt_tru=0;        
        % Score Claculation Phase
        for j=3:length(TargetWaves)
            TargetWaveName = TargetWaves(j).name;                 
            TargetWaveName(end-3:end) = [];
            cnt_tru=cnt_tru+1;            
            Scoring(Path_Stats,TargetWavePath,TargetWaveName,ModelOfTestingFile,SegmentLen,OverlapLen,NoModels,NoTargetModels,MaxLength,TargetSNR);                                        
        end
        NumOfTest(i-2) = cnt_tru;
    end
end
ve = find(NumOfTest==0);
NumOfTest(ve) = [];
TargetScoringTime=toc;
%==========================================================================================================================
fprintf ('\n%s\n',' Calculating Impostor scores and normalizing.... ') ;

%Calculating imposter scores and normalizing the scores...
%Saving scores of test(impostor) file on the target models after
%normalization
tic;
cnt_tru=0;
Impostors = dir(Path.Impostors_Test);
for i=3:length(Impostors)
    ImpWaveName = Impostors(i).name;
    ImpWaveName(end-3:end) = [];
    
    ImpWavePath = [Path.Impostors_Test];    
    Scoring(Path_Stats,ImpWavePath,ImpWaveName,ModelOfTestingFile,SegmentLen,OverlapLen,NoModels,NoTargetModels,MaxLength,ImpSNR);
    cnt_tru=cnt_tru+1;    

    [Gender, ModelName, sign, TestFileName, scores] = textread([Path.TestScoreNorm,'\Norm_',ImpWaveName,'.res'],'%s %s %s %s %f');
    fid = fopen([Path.TestScoreNormImp,'\Norm_',ImpWaveName,'.res'],'w');
    for l1=1:length(Gender)/NoModels
        for l2=1:NoTargetModels
            fprintf(fid,'%s %s %s %s %f\n',Gender{(l1-1)*NoModels+l2}, ModelName{(l1-1)*NoModels+l2}, sign{(l1-1)*NoModels+l2}, TestFileName{(l1-1)*NoModels+l2}, scores((l1-1)*NoModels+l2));
        end
    end
    fclose(fid);
end

NumOfTest(end+1)  = cnt_tru;
ImpostScoringTime = toc;

%=============================================================================================================================
fprintf ('\n%s\n',' copy target score files.... ') ;
%Saving scores of test(target) file on the target models after
%normalization
tic;
TargetClients = dir(Path.TargetSpeakers_Test);
for i=3:length(TargetClients)
    TargetWavePath = [Path.TargetSpeakers_Test ,TargetClients(i).name];
    TargetWaves = dir(TargetWavePath);
    L = length(TargetClients(i).name);
    index=0;    
    for k=3:length(TargetModels)
        if isequal(TargetModels(k).name, TargetClients(i).name)   %% *
             index = k-2;
         end 
    end   
    if index==0
    else        
        for j=3:length(TargetWaves)
            TargetWaveName = TargetWaves(j).name;
            TargetWaveName(end-3:end) = [];
                     
            [Gender, ModelName, sign, TestFileName, scores] = textread([Path.TestScoreNorm, 'Norm_',TargetWaveName,'.res'],'%s %s %s %s %f');
            fid1 = fopen([Path.TestScoreNormMultiTgt, 'Norm_',TargetWaveName,'.res'],'w');
            for l1=1:length(Gender)/NoModels
                for l2=1:NoTargetModels
                    fprintf(fid1,'%s %s %s %s %f\n',Gender{(l1-1)*NoModels+l2}, ModelName{(l1-1)*NoModels+l2}, sign{(l1-1)*NoModels+l2}, TestFileName{(l1-1)*NoModels+l2}, scores((l1-1)*NoModels+l2));
                end
            end            
            fclose(fid1);
            [Gender, ModelName, sign, TestFileName, scores] = textread([Path.TestScoreNorm,'Norm_',TargetWaveName,'.res'],'%s %s %s %s %f');
            fid2 = fopen([Path.TestScoreNormSingleTgt,'Norm_',TargetWaveName,'.res'],'w');
            for ll=1:length(Gender)/NoModels
                fprintf(fid2,'%s %s %s %s %f\n',Gender{(ll-1)*NoModels+(index)}, ModelName{(ll-1)*NoModels+(index)}, sign{(ll-1)*NoModels+(index)}, TestFileName{(ll-1)*NoModels+(index)}, scores((ll-1)*NoModels+(index)));
            end
            fclose(fid2);
            %             end
        end
    end
end

%==========================================================================================================================
fprintf ('\n%s\n',' (1) files.... ') ;

% Obtaining Target Scores and Calculating the number of segments in a wave
% file and saving in a vector whose name is "NoSegTgt"...

TotalTgtScores1 = [];
TargetScoreFiles = dir(Path.TestScoreNormSingleTgt);
for i=3:length(TargetScoreFiles)
    [G,M,S,T,TgtScores1] = textread([Path.TestScoreNormSingleTgt,TargetScoreFiles(i).name],'%s %s %s %s %f');
    NoSegTgt(i-2) = length(G);
    TotalTgtScores1 = [TotalTgtScores1;TgtScores1];
end

TotalTgtScores2 = [];
TargetScoreFiles = dir(Path.TestScoreNormMultiTgt);

for i=3:length(TargetScoreFiles)
    [G,M,S,T,TgtScores2] = textread([Path.TestScoreNormMultiTgt,TargetScoreFiles(i).name],'%s %s %s %s %f');
    NoSegTgt(i-2) = length(G)/NoTargetModels;
    TotalTgtScores2 = [TotalTgtScores2;TgtScores2];
end

%Reading and saving scores in a matrix whose name is "TotalTgtScoresMat"...
TotalTgtScoresMat = [];
for i=1:length(TotalTgtScores2)/NoTargetModels
    TotalTgtScoresMat(i,1:NoTargetModels) = TotalTgtScores2(NoTargetModels*(i-1)+(1:NoTargetModels));
end

N_tgt = length(TargetScoreFiles)-2;

%=============================================================================================================================
% Obtaining Imposter Scores and Calculating the number of segments in a wave
% file and saving in a vector whose name is "NoSegImp"...

TotalImpScores = [];
NoSegImp=[];
ImpScoreFiles = dir(Path.TestScoreNormImp);
for i=3:length(ImpScoreFiles)
    [G,M,S,T,ImpScores] = textread([Path.TestScoreNormImp,ImpScoreFiles(i).name],'%s %s %s %s %f');
    NoSegImp(i-2) = length(G)/NoTargetModels;
    TotalImpScores = [TotalImpScores;ImpScores];
end

%Scores are read and saved in a matrix whose name is "TotalImpScoresMat"...
TotalImpScoresMat = [];
for i=1:length(TotalImpScores)/NoTargetModels
    TotalImpScoresMat(i,1:NoTargetModels) = TotalImpScores(NoTargetModels*(i-1)+(1:NoTargetModels));
end
N_Imp = length(ImpScoreFiles)-2

%=============================================================================================================================
%Setting parameters...
%  fprintf('The results of multi-target speaker verification system:\n');
%  [ EERMin, FRBest,FABest, FIBest,t1_best, t2_best]=ThrFinding_multiTgt(TotalImpScores,TotalTgtScores2,TargetScoreFiles,...
%      ImpScoreFiles,NoSegImp,NoSegTgt,NoTargetModels,TotalTgtScoresMat,...
%      TotalImpScoresMat,NumOfTest,N_tgt,N_Imp,Param.min_sigma1,Param.step_sigma1,...
%      Param.max_sigma1,Param.min_t1,Param.nStep_t1,Param.max_t1,Param.min_t2,Param.nStep_t2,Param.max_t2,Param.sigma2)

fprintf('The results of single-target speaker:\n');
[ PooledEERMin, PooledFRBest,PooledFABest,t1_best, t2_best]=ThrFinding_singleTgt(TotalImpScores,TotalTgtScores1,TargetScoreFiles,...
    ImpScoreFiles,NoSegImp,NoSegTgt,NoTargetModels,TotalImpScoresMat,...
    N_tgt,N_Imp,Param.min_sigma1,Param.step_sigma1,Param.max_sigma1,Param.min_t1,Param.nStep_t1,...
    Param.max_t1,Param.min_t2,Param.nStep_t2,Param.max_t2,Param.sigma2)

