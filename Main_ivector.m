

%------------------- IVECTOR --------------------------
function Main_ivector
%---
pathstates=ProgramsInputs;
load(pathstates);
%---
kerneltype=Param.kerneltype;
c=Param.c;
g=Param.g;
ny=Param.ny;
Norm_ivector=Param.Norm_ivector;
NAPivector_Dim=Param.NAPivector_Dim;
LDA_ivector=Param.LDA_ivector;
NAP_ivector=Param.NAP_ivector;
WCCN_ivector=Param.WCCN_ivector;
TrainMethod=Param.TrainMethod;
NormScrs_target=Param.NormScrs_target;
NormScrs=Param.NormScrs;
art_data=Param.art_data;
OneVersusRest=1;
LDAmodel=[];
P_NAP=[];
B_WCCN=[];
FS=8000;
MethodName='IvectorSvm';
IvectorSvmpath=[Path.Prog,'\',MethodName];
mkdir(IvectorSvmpath);
SVM_Matlab=0;
MatlabSVM_train=[];
mkdir([Path.Prog,'\ResultIvector']);
method=Param.trainmethod;
RealTestData=Param.RealTestData;
method= str2num(method)
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
if (art_data==1)
    %AmbePath =input('Input path of train data converted to AMBE: ', 's');
    %if isequal(AmbePath,''),ERROR!!!!; end
    AmbePath =' ';
    ArtificialData(pathstates,AmbePath);
end
%--------------------------------------------------------------------------







%------------------------------ Train -------------------------------------
%method1:
if (method == 1)
    segmentation_train=1;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    [LDAmodel,P_NAP,B_WCCN]=TrainIvector(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim,c,g,SVM_Matlab,kerneltype,ny,TrainMethod);
end

%method2:
if (method==2)
    segmentation_train=1;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    [LDAmodel,P_NAP,B_WCCN]=IvectorExtract(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim,c,g,SVM_Matlab,kerneltype,ny,TrainMethod);
end

%method3:
if (method==3)
    segmentation_train=1;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    y=TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    TrainTargets(pathstates,IvectorSvmpath);
    
    if (NormScrs==1)
        FeatLabelExtracNormFiles(pathstates,IvectorSvmpath,segmentation_train)
        TrainTargetsNorm(pathstates,IvectorSvmpath);
    end
    if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
        JFA_eigen_lists='ivector_lda';
        [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    end
    NumImpSpeak=200;
    %[LDAmodel,P_NAP,B_WCCN]=IvectorExtract2(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim,c,g,kerneltype,TrainMethod,NumImpSpeak);
    IvectorExtract2(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,c,g,kerneltype,TrainMethod,NumImpSpeak);
    if (NormScrs==1)
        IvectorExtractNorm(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,c,g,kerneltype,TrainMethod,NumImpSpeak)
    end
end

%method3:
if (method==3)
    segmentation_train=1;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    %ModelTrainingUBM(pathstates,IvectorSvmpath);
    %y=TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    %     if (NormScrs==1)
    %         FeatLabelExtracNormFiles(pathstates,IvectorSvmpath,segmentation_train)
    %         TrainTargetsNorm(pathstates,IvectorSvmpath);
    %     end
    if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
        JFA_eigen_lists='ivector_lda';
        [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    end
    NumImpSpeak=200;
    yUBM=y;
    IvectorTrainSVM(yUBM,pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,c,g,kerneltype,TrainMethod,NumImpSpeak);
    %     if (NormScrs==1)
    %         IvectorExtractNorm(pathstates,IvectorSvmpath,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,c,g,kerneltype,TrainMethod,NumImpSpeak)
    %     end
end

%method4 (fast scoring):
if (method==4)
    segmentation_train=0;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    y=TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    [ivector_train,classIvectTrain]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
    
    load([pathstates,'\train']);
    ivector_train0=ivector_train;
    ivector_train=[]; ivector_train(1:Train.NumSpeaker,1:ny)=0;
    num_ivector(1:Train.NumSpeaker)=0;
    for i=1:length(classIvectTrain)
         ivector_train(classIvectTrain(i),:)=ivector_train0(i,:)+ ivector_train(classIvectTrain(i),:);
         num_ivector(classIvectTrain(i))= num_ivector(classIvectTrain(i))+1;
    end
    for i=1:Train.NumSpeaker
        ivector_train(i,:)=ivector_train(i,:)/num_ivector(i);
    end
    
    %     if (art_data==1)
    %         load([pathstates,'\train']);
    %         ivector_train0=ivector_train;
    %         ivector_train=[];
    %         for i=1:Train.NumSpeaker
    %             ivector_train(i,:)=mean(ivector_train0((i-1)*4+1:i*4,:));
    %         end
    %     end
    
    
    if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
        JFA_eigen_lists='ivector_lda';
        %method1:
        %[LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
        %method2:
        Path.PLDA=Path.LDA; save( Path.stats, 'Methods', 'Path','Param');
        [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation2(pathstates,IvectorSvmpath,JFA_eigen_lists,LDAdim,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    end
    ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
end

%method5 (generative) :
if (method==5)
    segmentation_train=0;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    y=TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    [ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
    if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
        JFA_eigen_lists='ivector_lda';
        [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    end
    ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    InvCovUbm=inv(cov(y));
end

%method6:PLDA
if (method==6)
    segmentation_train=1;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    TrainT(pathstates,IvectorSvmpath,ny,TrainMethod);
    [ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
    ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    
    Path.PLDA =input('datapath for PLDA?: ', 's');
    save( Path.stats, 'Methods', 'Path','Param');
    JFA_eigen_lists='ivector_Plda';
    [DataPLDA,classTest]=ivecExt(pathstates,IvectorSvmpath,JFA_eigen_lists);
    
    %TrainPLDA
    N_ITER = 10;
    Ny=180; Nx=0;
    PLDAModel=TrainPLDA(DataPLDA,classTest,N_ITER,Ny,Nx);
    save([Path.Prog,'\ResultIvector\PLDAModel'], 'PLDAModel');
    
    %     if (NormScrs==1)
    %         FeatLabelExtracNormFiles(pathstates,IvectorSvmpath,segmentation_train)
    %         TrainTargetsNorm(pathstates,IvectorSvmpath);
    %     end
    %     if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
    %         JFA_eigen_lists='ivector_lda';
    %
    [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    %     end
    
end

% method7: (fast scroring + channel Dependent ivector extract)
if (method==7)
    Path.ChannelData =input('datapath for channel Dependent ivector extract?: ', 's');
    save( Path.stats, 'Methods', 'Path','Param');
    
    segmentation_train=0;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
    ModelTrainingUBM(pathstates,IvectorSvmpath);
    
    y=TrainT_channelDependent(pathstates,IvectorSvmpath,ny,TrainMethod);
    [ivector_train]=IvectorExtract3(pathstates,IvectorSvmpath,TrainMethod);
    if (LDA_ivector==1 || NAP_ivector==1 || WCCN_ivector==1)
        JFA_eigen_lists='ivector_lda';
        %method1:
        
        %[LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
        %method2:
        Path.PLDA=Path.LDA; save( Path.stats, 'Methods', 'Path','Param');
        
        [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation2(pathstates,IvectorSvmpath,JFA_eigen_lists,LDAdim,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim);
    end
    ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
end
%--------------------------------------------------------------------------



%------------------------------ Test -------------------------------------
if (method == 1 || method == 2 || method == 3)
    JFA_eigen_lists='ivector_test';
    
    [DataTestSvm_test,SCORE_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector(pathstates,IvectorSvmpath,JFA_eigen_lists,OneVersusRest,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,NormScrs,NormScrs_target);
    JFA_eigen_lists='ivector_imptest';
    
    [DataIImpSvm,SCORE_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector(pathstates,IvectorSvmpath,JFA_eigen_lists,OneVersusRest,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN,NormScrs,NormScrs_target);
    %[Min_metric,minError,Thershold1,Thershold2 ,Sigma]=ThrFinding_ST(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    %[Results,meanE]=ThrFinding_ST2(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    
    [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
end
%-----
if (method == 4)
    
    if (RealTestData==0)
        [DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,'ivector_test');
        [DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,'ivector_imptest');
    else 
        [ivector_test,Numfiles_test,NumSpks_test,NumSegs_test]=TestIvector2_realdata(pathstates,IvectorSvmpath,'ivector_test')
        [ivector_imp,NumSegs_imp,NumSpks_imp]=ImposterIvector_realdata(pathstates,IvectorSvmpath,'ivector_imptest');
    end
    %---
    ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    %--
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
    %------
    if (NormScrs==1)
        %method1:adaptive LLR and LLR(0.5scr+0.5)
        [SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
    end
    if (NormScrs_target==1)
        %method2:tnorm
        %         for i=1:size(SCORE_test,2)
        %             SCORE_test2(:,i)=(SCORE_test(:,i)-mean(SCORE_test(:,i)))/var(SCORE_test(:,i));
        %         end
        %         for i=1:size(SCORE_imp,2)
        %             SCORE_imp2(:,i)=(SCORE_imp(:,i)-mean(SCORE_imp(:,i)))/var(SCORE_imp(:,i));
        %         end
        %method3:LLR(0.5scr+0.5)
        SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
        SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
    end
    %-----
    %[SCORE_test,SCORE_imp]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
    %[Min_metric,minError,Thershold1,Thershold2 ,Sigma]=ThrFinding_ST(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    %[Results,meanE]=ThrFinding_ST2(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    %[Min_metric,minError,Thershold1,Thershold2 ,Sigma]=ThrFinding_ST(NumOfSegments_test,NumOfTest_test,SCORE_test2,NumOfSegments_imp,SCORE_imp2);
    %[Results,meanE]=ThrFinding_ST2(NumOfSegments_test,NumOfTest_test,SCORE_test2,NumOfSegments_imp,SCORE_imp2);
  if (RealTestData==0)  
    [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
    [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
else
    [Results,meanE]=ThrFinding_mean_OneParam_realdata(SCORE_test,SCORE_imp,Numfiles_test,NumSpks_test,NumSegs_test,NumSegs_imp,NumSpks_imp);
end
end
%----
if (method==5)
    FA_eigen_lists='ivector_test';
    
    [DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
    JFA_eigen_lists='ivector_imptest';
    
    [DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
    %---
    ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    %--
    for i=1:size(ivector_train,1)
        for j=1:size(ivector_test,1)
            w=ivector_test(j,:)';
            m=ivector_train(i,:)';
            SCORE_test(i,j)= -0.5 * w'* InvCovUbm *w + w' * InvCovUbm * m - 0.5*m' * InvCovUbm*m;
        end
    end
    
    for i=1:size(ivector_train,1)
        for j=1:size(ivector_imp,1)
            w=ivector_imp(j,:)';
            m=ivector_train(i,:)';
            SCORE_imp(i,j)= -0.5 * w'* InvCovUbm *w + w' * InvCovUbm * m - 0.5*m' * InvCovUbm*m;
        end
    end
    %---
    if (NormScrs==1)
        %method1:adaptive tnorm
    end
    if (NormScrs_target==1)
        %method2:tnorm
        for i=1:size(SCORE_test,2)
            SCORE_test(:,i)=(SCORE_test(:,i)-mean(SCORE_test(:,i)))/var(SCORE_test(:,i));
        end
        for i=1:size(SCORE_imp,2)
            SCORE_imp(:,i)=(SCORE_imp(:,i)-mean(SCORE_imp(:,i)))/var(SCORE_imp(:,i));
        end
    end
    %-----
    %[Min_metric,minError,Thershold1,Thershold2 ,Sigma]=ThrFinding_ST(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    %[Min_metric,minError,Thershold1,Thershold2 ,Sigma]=ThrFinding_ST(NumOfSegments_test,NumOfTest_test,SCORE_test2,NumOfSegments_imp,SCORE_imp2);
    %[Results,meanE]=ThrFinding_ST2(NumOfSegments_test,NumOfTest_test,SCORE_test2,NumOfSegments_imp,SCORE_imp2);
    
    [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
    [Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp);
end
%-----
if (method == 6)
    JFA_eigen_lists='ivector_test';
    
    [DataTestSvm_test,ivector_test,classTest_test,CLASS_test,NumOfSegments_test,NumOfTest_test]=TestIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
    JFA_eigen_lists='ivector_imptest';
    
    [DataIImpSvm,ivector_imp,classTest_imp,CLASS_imp,NumOfSegments_imp,NumOfTest_imp]=ImposterIvector2(pathstates,IvectorSvmpath,JFA_eigen_lists);
    %---
    ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
    %----
    %     SCORE_test = PLDA_Identification(PLDAModel, ivector_test', ivector_train');    SCORE_test=SCORE_test';
    %     SCORE_imp = PLDA_Identification(PLDAModel, ivector_imp', ivector_train');    SCORE_imp=SCORE_imp';
    %     for i=1:size(SCORE_test,2)
    %         SCORE_test(:,i)=(SCORE_test(:,i)-mean(SCORE_test(:,i)))/var(SCORE_test(:,i));
    %     end
    %     for i=1:size(SCORE_imp,2)
    %         SCORE_imp(:,i)=(SCORE_imp(:,i)-mean(SCORE_imp(:,i)))/var(SCORE_imp(:,i));
    %     end
    %----
    for i=1:size(ivector_train,1)
        'test',i
        for j=1:size(ivector_test,1)
            SCORE_test(i,j)= PLDA_Verification(PLDAModel, ivector_test(j,:)', ivector_train(i,:)');
        end
    end
    for i=1:size(ivector_train,1)
        'imp',i
        for j=1:size(ivector_imp,1)
            SCORE_imp(i,j)= PLDA_Verification(PLDAModel, ivector_imp(j,:)', ivector_train(i,:)');
        end
    end
    %----
    
    [Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegment
    s_imp,SCORE_imp);
    minError
end
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% writing results:
load(pathstates);
mkdir([Path.Prog,'\ResultIvector']);
fid=fopen([Path.Prog,'\ResultIvector\ResultIvector.txt'],'w');
fprintf(fid,'%s : %f \n','minError',minError);
fprintf(fid,'%s : %f \n','Min_metric',Min_metric);
%fprintf(fid,'%s : %f \n','Thershold1',Thershold1);
%fprintf(fid,'%s : %f \n','Thershold2',Thershold2);
%fprintf(fid,'%s : %f \n','Sigma',Sigma);
fprintf(fid,'%s : %f \n','Threshold',Thershold2);
%fprintf(fid,'%s : %f \n','MED',MED);
%fprintf(fid,'%s : %f \n','MAD',MAD);

fprintf(fid,'\n\n\n-----------------------------');
fprintf(fid,'\n EER for each speakers:');
fprintf(fid,'\n MeanEERspeakers: %f',meanE);
%fprintf(fid,'\n [EER |FA-FR| t1 t2 sigma]');
fprintf(fid,'\n [EER |FA-FR| Threshold MED MAD]');
for i=1:size(Results,1)
    fprintf(fid,'\n speaker%d: [%f %f %f %f %f]',i, Results(i,1),Results(i,2),Results(i,3),Results(i,4),Results(i,5));
end

fclose(fid);

save( [Path.Prog,'\ResultIvector\LDAmodel'], 'LDAmodel');
save( [Path.Prog,'\ResultIvector\P_NAP'], 'P_NAP');
save( [Path.Prog,'\ResultIvector\B_WCCN'], 'B_WCCN');
save( [Path.Prog,'\ResultIvector\NumOfSegments_test'], 'NumOfSegments_test');
save( [Path.Prog,'\ResultIvector\NumOfTest_test'], 'NumOfTest_test');
save( [Path.Prog,'\ResultIvector\SCORE_test'], 'SCORE_test');
save( [Path.Prog,'\ResultIvector\NumOfSegments_imp'], 'NumOfSegments_imp');
save( [Path.Prog,'\ResultIvector\SCORE_imp'], 'SCORE_imp');

if (method == 4)
    save( [Path.Prog,'\ResultIvector\ivector_train'], 'ivector_train');
    save( [Path.Prog,'\ResultIvector\y'], 'y');
    save( [Path.Prog,'\ResultIvector\ivector_test'], 'ivector_test');
    save( [Path.Prog,'\ResultIvector\ivector_imp'], 'ivector_imp');
end

if (method == 5)
    save( [Path.Prog,'\ResultIvector\ivector_train'], 'ivector_train');
    save( [Path.Prog,'\ResultIvector\InvCovUbm'], 'InvCovUbm');
    save( [Path.Prog,'\ResultIvector\y'], 'y');
    save( [Path.Prog,'\ResultIvector\ivector_test'], 'ivector_test');
    save( [Path.Prog,'\ResultIvector\ivector_imp'], 'ivector_imp');
end
%--------------------------------------------------------------------------

