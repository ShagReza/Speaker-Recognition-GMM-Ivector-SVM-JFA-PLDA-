% Test 1 file ba 2 barname:
progPath='G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali';
path='G:\Bistoon-Ph1AndIvector\Test';
name='Train_spk_01_1_2';
modelpath='G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\modelsSpk_10Amali';
wavpath='G:\Bistoon-Ph1AndIvector\Test\Train_spk_01_1_2.wav';
ftrPath='G:\Bistoon-Ph1AndIvector\Test\Train_spk_01_1_2.ftr';
lblPath='G:\Bistoon-Ph1AndIvector\Test\Train_spk_01_1_2.lbl';
dos(['MFCC.exe ',wavpath,' ',ftrPath ]);
dos(['VAD.exe ',wavpath,' ',lblPath,' 0 -1 -1  0  SNR.txt 0 ']);
%--------------------------------------------------------------
% C:
dos(['TestIvector2.exe CfgIvecSpk_2048_2.txt ',path,' ',path,' ',modelpath,' ',name,' ',path,' Test.lst UBM 1024 Thr10Spk.txt']);
%--------------------------------------------------------------
% Matlab:
VV = readHTK(ftrPath,0);
ftrAsci='G:\Bistoon-Ph1AndIvector\Test\Test_spk_02_8.ascii'; save (ftrAsci,'VV','-ASCII');
fid_List = fopen([progPath,'\lists\List.lst'],'w');
fprintf(fid_List,'%s\n' ,['MIX04_' name  '_f=' path '\' name]);
fclose (fid_List);
make_suf_stat_enroll(progPath,path,'List');
tst=load(['data/stats/List']);
m             = load('models/ubm_means');
E             = load('models/ubm_variances');
v_matrix_file = ['optimum_output/' ['v_opt_10']];
load(v_matrix_file);
ny = size(v, 1);
tst.spk_ids = (1:size(tst.N,1))';
n_speakers=max(tst.spk_ids);
n_sessions=size(tst.spk_ids,1);
tst.y=zeros(n_speakers,ny);
tst.z=zeros(n_speakers,size(tst.F,2));
[tst.y]=estimate_y_and_v(tst.F, tst.N, 0, m, E, 0, v, 0, tst.z, tst.y, zeros(n_sessions,1), tst.spk_ids);
ivector_test=tst.y;
%-----
load('G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\ResultIvector\ivector_train10AmaliSpks.mat')
load('G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\ResultIvector\LDAmodel_fullNist.mat')
load('G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\ResultIvector\P_NAP_fullNist.mat')
load('G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\ResultIvector\y.mat')
load('G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali\ResultIvector\B_WCCN_fullNist.mat')
Norm_ivector=1; LDA_ivector=1; NAP_ivector=0; WCCN_ivector=1;
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%----
Ntnorm=20;
%adaptive tnorm
for i=1:size(ivector_train,1)
    for j=1:size(y,1)
        SCORE_norm(i,j)=(ivector_train(i,:)*y(j,:)')/(norm(ivector_train(i,:))*norm(y(j,:)));
    end
end
index_norm=zeros(size(ivector_train,1),Ntnorm);
for i=1:size(ivector_train,1)
    [a,b]=sort(SCORE_norm(i,:),'descend');
    %[a,b]=sort(SCORE_norm(i,:));
    index_norm(i,1:Ntnorm)=b(1:Ntnorm);
end
SCORE_test=[];
for i=1:size(ivector_train,1)
    scrtotal=[]; scr=[]; scr_norm=[];
    for j=1:size(ivector_test,1)
        scr(1,j)=(ivector_train(i,:)*ivector_test(j,:)')/(norm(ivector_train(i,:))*norm(ivector_test(j,:)));
    end
    for k=1:size(index_norm,2)
        for j=1:size(ivector_test,1)
            scr_norm(k,j)=(y(index_norm(i,k),:)*ivector_test(j,:)')/(norm(y(index_norm(i,k),:))*norm(ivector_test(j,:)));
        end
    end
    scrtotal=[scr;scr_norm];
    scrtotal=ApplyLLR2(0.5*scrtotal+0.5);
    SCORE_test(i,:)=scrtotal(1,:);        
end
%-----------------------
c=3;
t=[0.13,0.25,0.1,0.52,0.115,-0.2,-0.1,0.4,0.22,0.475];
MED=[-3.060904,-3.042594,-3.058199,-3.070157,-3.078827,-3.035219,-3.023877,-3.045320,-3.074813,-3.074813];
MAD=[0.038097,0.032715,0.030246,0.036646,0.035156,0.035552,0.031854,0.031333,0.034049,0.030838];
numspks=10; scr=[];
for i=1:numspks
    scr(i)= ComparisionThreshold(t(i),c,MAD(i),MED(i),SCORE_test(i));
end
%---------------------




