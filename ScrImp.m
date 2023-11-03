function [Class_imp,NumOfSegments_imp,SCORE_imp2]=ScrImp(FS,GMMUBMpath,GMMpath,ProgramsPath,SegLen_test,LAP_test,Enh,VAD,fw,A,lda,NewDim,pathstates,AdaptLLR,NameAdaptLLRData,NumImpSpeak)
load(pathstates);

task='test' ;
ScrPath=[GMMUBMpath,'\',task];
%---------------------------------
LanFolders=dir(Path.TargetSpeakers_Test);
NL=length(LanFolders)-2;
lanfolders=cell(1,NL);
for i=1:NL
    lanfolders(i)={LanFolders(i+2).name};
end
LanFolders=lanfolders;
%---------------------------------
for nn=1:NL
     NumOfSegments=[]; %number of segments
    %------------------------------------------%
    LAN  = char(LanFolders(nn));
    if AdaptLLR==1
        Langauge=[];
        Langauge=[LAN];
        for i=1:size(NameAdaptLLRData,2)
            Langauge=[Langauge,'  ' ,NameAdaptLLRData{nn,i}];
        end
    end
    %------------------------------------------%
    PathWaves=dir([Path.Impostors_Test,'\*.wav']);
    for nl = 1:length(PathWaves) % nl: language counter (targets and non target)
        LAN='imp';
        % making folders
        [fidtxt,fidtxt2]=MakingFolders (ScrPath);
        % Segmmentation
        % NS : number of segments
        [I, NS]=Segmentation_imp (nl,SegLen_test,FS,LAP_test,Path.Impostors_Test,ScrPath,PathWaves,fidtxt,fidtxt2,Langauge,LAN,AdaptLLR,NameAdaptLLRData);
        NumOfSegments=[NumOfSegments,NS];
        % Enhancement
        Enhancement (ScrPath,Enh);
        % FeatureExtraction (SDC + RASTA)
        FeatureExtraction (ScrPath,fw,pathstates);
        % Label extraction
        LableExtraction (ScrPath,VAD);
        %---
        if lda==1 || lda==2
            EnhSegmentsPath   = dir([ScrPath,'\Features\*.ftr']);
            for b2 = 1:length(EnhSegmentsPath)
                TestPath      = [ScrPath,'\Features\',EnhSegmentsPath(b2).name];
                ApplingHLDA(TestPath,A,lda);
            end
        end
        %---
        % Computing Scores
        ComputingScores(ProgramsPath,ScrPath,GMMpath,LAN,nl,NewDim)
        % Score normalization
        ScoreNormalization (ScrPath,LAN,nl);
    end
    %------------------------------------------%
    [Class_imp,NumOfSegments_imp,SCORE_imp] = ReadingScores_imp(NumOfSegments,ScrPath,Path.Impostors_Test,GMMpath,NumImpSpeak,AdaptLLR);
    SCORE_imp=SCORE_imp';
    for i=1:size(SCORE_imp,2)
        SCORE_imp(:,i)=(SCORE_imp(:,i)-mean(SCORE_imp(:,i)))/var(SCORE_imp(:,i));
    end
    SCORE_imp2(nn,:)=SCORE_imp(1,:);
end
SCORE_imp2=SCORE_imp2';