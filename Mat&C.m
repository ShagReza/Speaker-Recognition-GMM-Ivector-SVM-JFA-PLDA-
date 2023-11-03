% Test 1 file ba 2 barname:
Path.SADmodels='G:\KavoshgarGooyande\SADmodels';
progPath='D:\yeksansaziMatlabC';
path='D:\yeksansaziMatlabC\C';
name='A';
pathwav=path;
modelpath='D:\progIvec_920813\modelsSpk_10Amali_newexp_100cohort';
wavpath=[path,'\',name,'.wav'];
ftrPath=[path,'\',name,'.ftr'];
lblPath=[path,'\',name,'.lbl'];
dos(['SAD.exe  ',wavpath,' ', lblPath,' ', Path.SADmodels,'   Temp 1 Energy.txt 0  10  10 0.05 0.73 100']);
dos(['MFCCWhitSAD.exe ',wavpath,' ',ftrPath ,' ',Path.SADmodels]);
%--------------------------------------------------------------
% C:
dos(['TestIvector2.exe CfgIvecSpk_2048_2.txt ',path,' ',path,' ',modelpath,' ',name,' ',path,' Test.lst UBM 1024 Thr10Spk.txt']);
%--------------------------------------------------------------
% Matlab:
VV = readHTK(ftrPath,0);
ftrAsci=[path,'\',name,'.ascii']; save (ftrAsci,'VV','-ASCII','-double'); %Afzoodane '-double'
fid_List = fopen([progPath,'\lists\List.lst'],'w');
fprintf(fid_List,'%s\n' ,['MIX04_' name  '_f=' path '\' name]);
fclose (fid_List);
make_suf_stat_enroll(progPath,path,'List');
%make_suf_stat_enroll2(ftrPath,progPath,path,'List');
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
load('D:\progIvec_920813\Models_ivec200\LDAmodel.mat')
load('D:\progIvec_920813\Models_ivec200\P_NAP.mat')
load('D:\progIvec_920813\Models_ivec200\B_WCCN.mat')
Norm_ivector=1; LDA_ivector=1; NAP_ivector=0; WCCN_ivector=1;
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
