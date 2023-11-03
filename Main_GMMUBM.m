
%------------------- GMM-UBM --------------------------
%function Main_ivector

pathstates=ProgramsInputs;
load(pathstates);
%----
FS=8000;
MethodName='GMMUBM';
GMMUBMpath=[Path.Prog,'\',MethodName];
mkdir(GMMUBMpath);
mkdir([Path.Prog,'\ResultIvector']);
%--------------------------------------------------------------------------



%------------------------------ Artificial data for train  ----------------
art_data =input('Do you want to use artificial data :0/1 (1:yes,0:no,default:0)', 's');  art_data=str2num(art_data);
if isempty(art_data), art_data=0; end;

if (art_data==1)
    AmbePath =input('Input path of train data converted to AMBE: ', 's');
    %if isequal(AmbePath,''),ERROR!!!!; end
    ArtificialData(pathstates,AmbePath);
end
%--------------------------------------------------------------------------



%------------------------------------Normalize Scores----------------------
NormScrs_target =input('Normalize Scores(with target speakers)? :0/1 (1:yes,0:no,default:0)', 's');  NormScrs_target=str2num(NormScrs_target);
if isempty(NormScrs_target), NormScrs_target=0; end;

NormScrs =input('Normalize Scores(with nontarget speakers)? :0/1 (1:yes,0:no,default:0)', 's');  NormScrs=str2num(NormScrs);
if isempty(NormScrs), NormScrs=0; end;

% if (NormScrs==1)
%     Path.NormSpeak =input('Path of speakers for LLR or tnorm: ', 's');
%     save( Path.stats, 'Methods', 'Path','Param');
% end
%--------------------------------------------------------------------------



%-------------------------------Train-------------------------------------
segmentation_train=0;
FeatureLabelExtraction_ivector(pathstates,GMMUBMpath,segmentation_train);
load(pathstates);
UBM_DataPath=Path.UBM;
GMM_DataPath=Path.TargetSpeakers_Train;
ProgramsPath=Path.Prog;
NumGMM=Param.NumGMM;
ModelTraining_GMMUBM(UBM_DataPath,GMMUBMpath,GMM_DataPath,ProgramsPath,NumGMM);
TrainTargets_gmmubm(pathstates,GMMUBMpath);
AdaptLLR=1;
NameAdaptLLRData=[];
NumImpSpeak=3;
if AdaptLLR==1
    NameAdaptLLRData=AdaptiveLLRData(pathstates,GMMUBMpath,NumImpSpeak);
end
%--------------------------------------------------------------------------



%----------------------------------Test------------------------------------
FS=8000;
SegLen_test=Param.SegLen;
LAP_test=Param.LapLen;
Enh=0;
fw=0;
A=[];
lda=0;
NewDim=39;
VAD=1;
GMMpath=[ProgramsPath,'\',MethodName,'\Models'];


DataPath=Path.TargetSpeakers_Test; task='test';
[NumOfSegs_test,NumOfTest_test,NL_test,ScrPath_test]=GeneratingScores(FS,GMMUBMpath,GMMpath,DataPath,ProgramsPath,SegLen_test,LAP_test,Enh,VAD,fw,A,lda,NewDim,task,pathstates,AdaptLLR,NameAdaptLLRData);
[Class_test,NumOfSegments_test,SCORE_test] = ReadingScores(NumOfSegs_test,NumOfTest_test,ScrPath_test,DataPath,GMMpath,NumImpSpeak,AdaptLLR);
SCORE_test=changScrFormat(SCORE_test,NL_test,NumOfTest_test,NumOfSegments_test,Class_test);


if AdaptLLR==0
    DataPath=Path.Impostors_Test;
    [NumOfSegments_imp,ScrPath_imp]=GeneratingScores_imp(FS,GMMUBMpath,GMMpath,DataPath,ProgramsPath,SegLen_test,LAP_test,Enh,VAD,fw,A,lda,NewDim,task,pathstates,AdaptLLR,NameAdaptLLRData);
    [Class_imp,NumOfSegments_imp,SCORE_imp] = ReadingScores_imp(NumOfSegments_imp,ScrPath_imp,DataPath_imp,GMMpath,NumImpSpeak,AdaptLLR);
else
    [Class_imp,NumOfSegments_imp,SCORE_imp]=ScrImp(FS,GMMUBMpath,GMMpath,ProgramsPath,SegLen_test,LAP_test,Enh,VAD,fw,A,lda,NewDim,pathstates,AdaptLLR,NameAdaptLLRData,NumImpSpeak);
end


[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test',NumOfSegments_imp,SCORE_imp');
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test',NumOfSegments_imp,SCORE_imp');
meanE,minError
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
load(pathstates);
mkdir([Path.Prog,'\ResultGMMUBM']);
fid=fopen([Path.Prog,'\ResultGMMUBM\ResultGMMUBM.txt'],'w');
fprintf(fid,'%s : %f \n','minError',minError);
fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
fprintf(fid,'%s : %f \n','Threshold',Thershold2);
fprintf(fid,'\n\n\n-----------------------------');
fprintf(fid,'\n EER for each speakers:');
fprintf(fid,'\n MeanEERspeakers: %f',meanE);
fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
for i=1:size(Results,1)
    fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
end
fclose(fid);
%--------------------------------------------------------------------------

