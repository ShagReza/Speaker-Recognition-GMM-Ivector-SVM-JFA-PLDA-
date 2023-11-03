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
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
if (art_data==1)
    %AmbePath =input('Input path of train data converted to AMBE: ', 's');
    %if isequal(AmbePath,''),ERROR!!!!; end
    AmbePath =' ';
    ArtificialData(pathstates,AmbePath);
end
%--------------------------------------------------------------------------
    segmentation_train=0;
    FeatureLabelExtraction_ivector(pathstates,IvectorSvmpath,segmentation_train);
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
    
    

    ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
