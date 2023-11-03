% Train With TestIvector.cpp

%-------------------------------
% segmentation_train=0;
% FeatureLabelExtraction_ivector2(pathstates,IvectorSvmpath,segmentation_train);
% ModelTrainingUBM(pathstates,IvectorSvmpath);
% zakhire modelhaye matlab 
%------------------------------
% make_suf_stat_enroll_ivector:
Results='D:\progIvec_920813\ResultsModelsWithCprog';
ConfigFilePath='IVector.cfg';
FeatureFolder='D:\progIvec_920813\IvectorSvm\Features';
LabelFolder='D:\progIvec_920813\IvectorSvm\Labels';
ModelsFolder='D:\progIvec_920813\ModelsIvector';
OutFolder='G:\';
DoSegment='0';
for i=1:length(dirUBM)
    TestName=dirUBM(i).name;  TestName(end-3:end)=[];
    dos(['IVector.exe ivector ',ConfigFilePath,'   ',FeatureFolder,'  ',LabelFolder,'  ',ModelsFolder,' ', TestName,'  ',OutFolder,'  ',DoSegment]);
    Ni=textread('G:\N.txt'); 
    Fi=textread('G:\F.txt');
    delete('G:\F.txt'); 
    delete('G:\N.txt'); 
    delete([OutFolder,'\',TestName,'.ivec']); 
    save(['data/stats/',num2str(i) '.mat'],'Ni','Fi');
end
% T:
y=TrainT2(pathstates,IvectorSvmpath,ny,TrainMethod);
%------------------------------
% write ivector extractor (Vmatrix_1):
% chek shavad: v=v' c:79872 f:200 
fid = fopen([Results,'\v_matrix_1'],'w');
C=size(v,1);
F=size(v,2);
fwrite(fid,C,'uint32');
fwrite(fid,F,'uint32');
for i=1:F
i
    for Ic=1:C, fwrite(fid,v(Ic,i),'double'); end;
end
fclose(fid);
%--------------------------------------------------------------------------
                          % LDA WCCN
% LDA&WCCN data
JFA_eigen_lists='ivector_lda';
Path.PLDA='G:\KavoshgarGooyande\Data\8sideTrain'; 
Path.SADmodels='G:\KavoshgarGooyande\SADmodels';
save( Path.stats, 'Methods', 'Path','Param');
load(pathstates);
task='PLdaData';
PathSpks  = dir(Path.PLDA); % waves path of language nl
kk=0;
DataPLDA=[]; 
classTest=[]; 
for j = 1:(length(PathSpks)-2)
    pathWavs=dir([Path.PLDA,'\',PathSpks(j+2).name,'\*.wav']);
    for i=1:length(pathWavs)
        TestPath = [Path.PLDA,'\',PathSpks(j+2).name, '\',pathWavs(i,1).name];       
        OutputLabelFile='G:\A.lbl';
        OutputFeatureFile='G:\A.ftr';
        dos(['SAD.exe  ',TestPath,' ', OutputLabelFile,' ', Path.SADmodels,'   Temp 1 Energy.txt 0  10  10 0.05 0.73 100']);
        dos(['MFCCWhitSAD.exe ',TestPath,' ',OutputFeatureFile ,' ',Path.SADmodels]);
        kk=kk+1;
        classTest(kk)=j;
        dos(['IVector.exe ivector ',ConfigFilePath,'   G:\  G:\  ',ModelsFolder,' A  G:\  ',DoSegment]);
        %read ivec
        ivec=textread(['G:\A.ivec']);
        DataPLDA=[DataPLDA;ivec(1:200)];
        delete('G:\A.ftr');
        delete('G:\A.lbl');
        delete('G:\A.ivec');
        delete('G:\N.txt');
        delete('G:\F.txt');
    end
end
%LDA&WCCN Extract:
y=DataPLDA;
class=classTest;
Norm_ivector=1; LDA_ivector=1; NAP_ivector=0; WCCN_ivector=1;
%NORM:
if (Norm_ivector==1)
    for i=1:size(y,1)
        y(i,:)=y(i,:)./norm(y(i,:));
    end
end
%LDA:
if (LDA_ivector==1)
    LDA_Struct = struct('X', y', 'y', class);
    reg=0.001;
    LDAmodel = lda_reg_me ( LDA_Struct ,  LDAdim , reg );
    y=linproj(y', LDAmodel)';
end
%NAP:
if (NAP_ivector==1)
    NAP_Struct = struct('X', y', 'y', class);
    WCC = WithenClassCov(NAP_Struct);
    [Vec,D] = eig (WCC);
    [D,inx] = sort(diag(D),1,'descend');
    V = Vec(:,inx(1:NAPivector_Dim));
    P_NAP=eye(size(y,2))-V*V';
    y=(P_NAP*y')';
end
%WCCN:
if (WCCN_ivector==1)
    NAP_Struct = struct('X', y', 'y', class);
    WCC = WithenClassCov(NAP_Struct);
    reg=0.001;
    B_WCCN=chol(inv(WCC+ reg * eye(size(WCC,1))));
    y=(B_WCCN*y')';
end
% WriteLDA & WCCN models
%chek shavad:
CompWCCN=B_WCCN; save ([Path.Prog,'\models\CompWCCN'],'CompWCCN','-ASCII');
CompLDAbias=LDAmodel.b; save ([Path.Prog,'\models\CompLDAbias'],'CompLDAbias','-ASCII');
CompLDAweight=LDAmodel.w; save ([Path.Prog,'\models\CompLDAweight'],'CompLDAweight','-ASCII');
%--------------------------------------------------------------------------
% write yUBM
yUBM=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%write:
f = fopen([Results,'\yUBM.bin'], 'wb');
fwrite(f, size(y), 'integer*4')
fwrite(f, y', 'double')
fclose(f);
%--------------------------------------------------------------------------



