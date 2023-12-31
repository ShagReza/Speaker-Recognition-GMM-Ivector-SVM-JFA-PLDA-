

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test:
function [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation(LDAdim,pathstates,IvectorSvmpath,JFA_eigen_lists,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim)
iter=10;
load(pathstates);
NumOfSegments=[]; %number of segments
FS=8000;
LDAmodel=[];P_NAP=[];B_WCCN=[];
%________________
task='LdaData';
FaSvmpath=IvectorSvmpath;
new=[IvectorSvmpath,'\',task];
mkdir(new);
mkdir([new,'\Waves'          ]);
mkdir([new,'\EnhancedWaves'  ]);
mkdir([new,'\Models']);
mkdir([new,'\Features']);
mkdir([new,'\Labels']);
%________________
PathModels=[IvectorSvmpath,'\Models'];
copyfile([PathModels,'\UBM.gmm'],[FaSvmpath,'\',task,'\Models\UBM.gmm'])
copyfile([PathModels,'\UBMinit.gmm'],[FaSvmpath,'\',task,'\Models\UBMinit.gmm'])
[MSV,CSV,W] = readALZgmm([PathModels,'\UBM.gmm']);
Dim=length(MSV)/length(W);
%________________
DataLDA=[]; NumOfTest=[];
classTest=[]; class=[]; CLASS=[];
WW=0;

PathWaves  = dir([Path.LDA, '\*.wav']); % waves path of language nl
if (LDAdim>length(PathWaves))
    LDAdim=length(PathWaves);
end
for j = 1:LDAdim
    rmdir([new,'\Waves\'          ],'s'); mkdir([new,'\Waves\'          ]);
    rmdir([new,'\EnhancedWaves\'  ],'s'); mkdir([new,'\EnhancedWaves\'  ]);
    rmdir([new,'\Features\'       ],'s'); mkdir([new,'\Features\'       ]);
    rmdir([new,'\Labels\'       ],'s'); mkdir([new,'\Labels\'       ]);
    
    TestPath = [Path.LDA, '\',PathWaves(j,1).name];
    [I, NS]=Segmentation_Gsl(j,Param.SegLen,FS,Param.LapLen,TestPath,new,'lda');
    FeatureLabelExtraction_ivectorTest(pathstates,new);
    %_________________________________________________________________%
    %         if lda==1 || lda==2
    %             EnhSegmentsPath   = dir([new,'\Features\*.ftr']);
    %             for b2 = 1:length(EnhSegmentsPath)
    %                 TestPath      = [new,'\Features\',EnhSegmentsPath(b2).name];
    %                 ApplingHLDA(TestPath,A,lda);
    %             end
    %         end
    %________________________________________________________________%
    EnhSegmentsPath   = dir([new,'\Waves\*.wav']);
    class=[]; NumEmpty=0; kk=0;
    for b2 = 1:length(EnhSegmentsPath)
        WavPath      = [new,'\Waves\',EnhSegmentsPath(b2).name];
        W_nam=EnhSegmentsPath(b2).name; W_nam(end-3:end) = [];
        [AA,B,C,D,Scrs] = textread([new,'\Labels\',W_nam,'.lbl'],'%s %s %s %s %f');
        if isempty(AA)==1
            NumEmpty=NumEmpty+1;
        else
            kk=kk+1;
            class(kk)=j;
        end
    end
    %___
    JFA_s_lists       =[Path.Prog,'\lists\'];    mkdir(JFA_s_lists);
    fid_List = fopen([JFA_s_lists  JFA_eigen_lists  ,'.lst'],'w');
    Label1 ='MIX04_';
    Label2 ='_f=';
    Label3 ='data/Features/';
    
    dirFiles=dir([new,'\Labels\'       ]);
    for jj=3:length(dirFiles)
        dirFiles(jj).name(end-3:end)=[];
        VV = readHTK([new,'\Features\', dirFiles(jj).name,'.ftr'],0);
        save (['data\Features\', dirFiles(jj).name,'.ascii'],'VV','-ASCII');
        fprintf(fid_List,'%s\n' ,[Label1 'lda'  Label2 Label3 dirFiles(jj).name]);
    end
    fclose (fid_List);
    make_suf_stat_enroll(Path.Prog,[Path.Prog,'\data\Features\'],JFA_eigen_lists);
    
    tst=load(['data/stats/' JFA_eigen_lists]);
    m             = load('models/ubm_means');
    E             = load('models/ubm_variances');
    v_matrix_file = ['optimum_output/' ['v_opt_' num2str(iter) ]];
    load(v_matrix_file);
    ny = size(v, 1);
    tst.spk_ids = (1:size(tst.N,1))';
    n_speakers=max(tst.spk_ids);
    n_sessions=size(tst.spk_ids,1);
    
    tst.y=zeros(n_speakers,ny);
    tst.z=zeros(n_speakers,size(tst.F,2));
    [tst.y]=estimate_y_and_v(tst.F, tst.N, 0, m, E, 0, v, 0, tst.z, tst.y, zeros(n_sessions,1), tst.spk_ids);
    %________________________________________________________________%
    NumOfSegments=[NumOfSegments,NS-NumEmpty];
    DataLDA=[DataLDA;tst.y];
    classTest=[classTest,class];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  [DataPLDA,classTest]=ivecExt(pathstates,IvectorSvmpath,JFA_eigen_lists);
%  y=DataPLDA;
%  class=classTest;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
class=classTest;
y=DataLDA;
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
%---
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
%---
%WCCN:
if (WCCN_ivector==1)
    NAP_Struct = struct('X', y', 'y', class);
    WCC = WithenClassCov(NAP_Struct);
    reg=0.001;
    B_WCCN=chol(inv(WCC+ reg * eye(size(WCC,1))));
    y=(B_WCCN*y')';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










