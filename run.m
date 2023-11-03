%-------------------------
y=TrainT_channelDependent(pathstates,IvectorSvmpath,ny,TrainMethod);
LDA_ivector=1; WCCN_ivector=1; NAP_ivector=0; Norm_ivector=1; LDAdim=180;
JFA_eigen_lists='ivector_lda';
% Path.PLDA=Path.LDA; save( Path.stats, 'Methods', 'Path','Param');
% [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation2(pathstates,IvectorSvmpath,JFA_eigen_lists,LDAdim,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
save( [Path.Prog,'\ResultIvector\y'], 'y');
save( [Path.Prog,'\ResultIvector\LDAmodel'], 'LDAmodel');
save( [Path.Prog,'\ResultIvector\P_NAP'], 'P_NAP');
save( [Path.Prog,'\ResultIvector\B_WCCN'], 'B_WCCN');
%------------------------
%Mic
Path.TargetSpeakers_Train='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_mic';
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_1ch_mic';
Path.Impostors_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\imp_mic';
save( Path.stats, 'Methods', 'Path','Param');
FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
[ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
save( [Path.Prog,'\ResultIvector\mic_ivector_train'], 'ivector_train');
%Mic 1ch
Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
load([Path.Prog,'\ResultIvector\mic_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
JFA_eigen_lists='ivector_imptest';
[DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\mic1ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\mic_ivector_imp'], 'ivector_imp');
save( [Path.Prog,'\ResultIvector\mic1ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\mic1ch_NumOfTest_test'], 'NumOfTest_test');
save( [Path.Prog,'\ResultIvector\NumOfSegments_imp'], 'NumOfSegments_imp');
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\mic1chLLR_ResultIvector.txt'],'w');
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

% %A-LLR
% load([Path.Prog,'\ResultIvector\y']);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\mic1chAdaptLLR_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);

% %AllrWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\mic1chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%-----
%mic 4ch:
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_4ch_mic';
save( Path.stats, 'Methods', 'Path','Param');
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\mic4ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\mic4ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\mic4ch_NumOfTest_test'], 'NumOfTest_test');
load([Path.Prog,'\ResultIvector\mic_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
load( [Path.Prog,'\ResultIvector\mic_ivector_imp']);

Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);

%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\mic4chLLR_ResultIvector.txt'],'w');
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

%A-LLR
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\mic4chAdaptLLR_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);

% %ALLRWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\mic4chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%--------------------------------------------End mic



%------------------------
%fix
Path.TargetSpeakers_Train='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_fix';
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_1ch_fix';
Path.Impostors_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\imp_fix';
save( Path.stats, 'Methods', 'Path','Param');
FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
[ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
save( [Path.Prog,'\ResultIvector\fix_ivector_train'], 'ivector_train');
%fix 1ch
Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
load([Path.Prog,'\ResultIvector\fix_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
JFA_eigen_lists='ivector_imptest';
[DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\fix1ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\fix_ivector_imp'], 'ivector_imp');
save( [Path.Prog,'\ResultIvector\fix1ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\fix1ch_NumOfTest_test'], 'NumOfTest_test');
save( [Path.Prog,'\ResultIvector\NumOfSegments_imp'], 'NumOfSegments_imp');
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\fix1chLLR_ResultIvector.txt'],'w');
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

%A-LLR
[SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\fix1chAdaptLLR_ResultIvector.txt'],'w');
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

% %AllrWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\fix1chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%-----
%fix 4ch:
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_4ch_fix';
save( Path.stats, 'Methods', 'Path','Param');
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\fix4ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\fix4ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\fix4ch_NumOfTest_test'], 'NumOfTest_test');
load([Path.Prog,'\ResultIvector\fix_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
load( [Path.Prog,'\ResultIvector\fix_ivector_imp']);

Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);

%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\fix4chLLR_ResultIvector.txt'],'w');
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

%A-LLR
[SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\fix4chAdaptLLR_ResultIvector.txt'],'w');
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

% %ALLRWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\fix4chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%--------------------------------------------End fix



%------------------------
%amb
Path.TargetSpeakers_Train='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_amb';
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_1ch_amb';
Path.Impostors_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\imp_amb';
save( Path.stats, 'Methods', 'Path','Param');
FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
[ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
save( [Path.Prog,'\ResultIvector\amb_ivector_train'], 'ivector_train');
%amb 1ch
Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
load([Path.Prog,'\ResultIvector\amb_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
JFA_eigen_lists='ivector_imptest';
[DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\amb1ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\amb_ivector_imp'], 'ivector_imp');
save( [Path.Prog,'\ResultIvector\amb1ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\amb1ch_NumOfTest_test'], 'NumOfTest_test');
save( [Path.Prog,'\ResultIvector\NumOfSegments_imp'], 'NumOfSegments_imp');
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\amb1chLLR_ResultIvector.txt'],'w');
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

%A-LLR
[SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\amb1chAdaptLLR_ResultIvector.txt'],'w');
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

% %AllrWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\amb1chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%-----
%amb 4ch:
Path.TargetSpeakers_Test='G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_4ch_amb';
save( Path.stats, 'Methods', 'Path','Param');
JFA_eigen_lists='ivector_test';
[DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
save( [Path.Prog,'\ResultIvector\amb4ch_ivector_test'], 'ivector_test');
save( [Path.Prog,'\ResultIvector\amb4ch_NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\amb4ch_NumOfTest_test'], 'NumOfTest_test');
load([Path.Prog,'\ResultIvector\amb_ivector_train']);
load([Path.Prog,'\ResultIvector\y']);
load( [Path.Prog,'\ResultIvector\amb_ivector_imp']);

Norm_ivector=1;LDA_ivector=0;NAP_ivector=0;WCCN_ivector=0;
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);

%LLR:
for i=1:size(ivector_train,1)
    for j=1:size(ivector_test,1)
        SCORE_test(i,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
end

for i=1:size(ivector_train,1)
    for j=1:size(ivector_imp,1)
        SCORE_imp(i,j)=(ivector_train(i,:)*ivector_imp(j,:)')/(norm(ivector_train(i,:))*norm(ivector_imp(j,:)));
    end
end
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\amb4chLLR_ResultIvector.txt'],'w');
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

%A-LLR
[SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);

load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\amb4chAdaptLLR_ResultIvector.txt'],'w');
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

% %ALLRWccnLDA
% Norm_ivector=1;LDA_ivector=1;NAP_ivector=0;WCCN_ivector=1;
% ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
% [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
% [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
% 
% load(pathstates);
% mkdir([Path.Prog,'\ResultIvector']);
% fid=fopen([Path.Prog,'\ResultIvector\amb4chAdaptLLRWccnLDA_ResultIvector.txt'],'w');
% fprintf(fid,'%s : %f \n','minError',minError);
% fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
% fprintf(fid,'%s : %f \n','Threshold',Thershold2);
% fprintf(fid,'\n\n\n-----------------------------');
% fprintf(fid,'\n EER for each speakers:');
% fprintf(fid,'\n MeanEERspeakers: %f',meanE);
% fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
% for i=1:size(Results,1)
%     fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
% end
% fclose(fid);
%--------------------------------------------End amb

