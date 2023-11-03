
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This program gets input data and generates scores with compute test
% inputs:
%         FS: sampling frequency
%         new:[ProgramsPath,'\GMMUBM']
%         GMMpath: path of gaussian models of training languages
%         DataPath: path of data
%         nontargetNam: name of non target folder
%         ProgramsPath: path of programs
%         SegmentLen: length of segments
%         OverlapLen: overlap of segments
%         Enh:(if 1: features will be extracted from enhanced files)
%         VAD: choosing label extraction program
%         fw: (if 1: feature warping will be applied on features)
%         task: a name for creating a new folder: [new,'\',task]
% outputs:
%         NumOfSegments: Number Of Segments
%         NumOfTest: Number of data in each folder
%         NL: Number of input sub folder
%         ScrPath : [new,'\',task]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




function [NumOfSegments,ScrPath]=GeneratingScores_imp(FS,new,GMMpath,DataPath,ProgramsPath,SegmentLen,OverlapLen,Enh,VAD,fw,A,lda,NewDim,task,pathstates,AdaptLLR,NameAdaptLLRData)
%__________________________________________________________________________
ScrPath=[new,'\',task];
mkdir(ScrPath);
mkdir([ScrPath,'\Waves'          ]);
mkdir([ScrPath,'\EnhancedWaves'  ]);
mkdir([ScrPath,'\Features'       ]);
mkdir([ScrPath,'\Labels'         ]);
mkdir([ScrPath,'\TestResults'    ]);
mkdir([ScrPath,'\NormTestResults']);
%__________________________________________________________________________
% LanFolders=dir(DataPath);
% NL=length(LanFolders)-2;
% lanfolders=cell(1,NL);
% for i=1:NL
%     lanfolders(i)={LanFolders(i+2).name};
% end
% LanFolders=lanfolders;
% 
% 
 Langauge=LanguageNames(GMMpath); % Language: list of target GMM files
% NumOfTest(1:NL)=0; %number of Test files
 NumOfSegments=[]; %number of segments
PathWaves=dir([DataPath,'\*.wav']);
for nl = 1:length(PathWaves) % nl: language counter (targets and non target)
    LAN='imp';
    % making folders
    [fidtxt,fidtxt2]=MakingFolders (ScrPath);
    % Segmmentation
    % NS : number of segments
    [I, NS]=Segmentation_imp (nl,SegmentLen,FS,OverlapLen,DataPath,ScrPath,PathWaves,fidtxt,fidtxt2,Langauge,LAN,AdaptLLR,NameAdaptLLRData);
    NumOfSegments=[NumOfSegments,NS];
    % Enhancement
    Enhancement (ScrPath,Enh);
    % FeatureExtraction (SDC + RASTA)
    FeatureExtraction (ScrPath,fw,pathstates);
    % Label extraction
    LableExtraction (ScrPath,VAD);
    %_________________________________________________________________%
    if lda==1 || lda==2
        EnhSegmentsPath   = dir([ScrPath,'\Features\*.ftr']);
        for b2 = 1:length(EnhSegmentsPath)
            TestPath      = [ScrPath,'\Features\',EnhSegmentsPath(b2).name];
            ApplingHLDA(TestPath,A,lda);
        end
    end
    %________________________________________________________________%
    % Computing Scores
    ComputingScores(ProgramsPath,ScrPath,GMMpath,LAN,nl,NewDim)
    % Score normalization
    ScoreNormalization (ScrPath,LAN,nl);
end
NumOfSegmentsTask=['NumOfSegments_',task];
NumOfTestTask=['NumOfTest_',task];
NLTask=['NL_',task];
save([ProgramsPath,'\',NumOfSegmentsTask],'NumOfSegments');
%__________________________________________________________________________
