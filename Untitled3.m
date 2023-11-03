%Atnorm:
Path.PLDA='G:\Bistoon-Ph1AndIvector\Data\Atnorm\3channel';
save( Path.stats, 'Methods', 'Path','Param');
[y,classTest]=ivecExt(pathstates,IvectorSvmpath,JFA_eigen_lists);
Norm_ivector=1; LDA_ivector=1;WCCN_ivector=1;
y=ApplyNormLdaWccnNap(y,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
%---
ivector_test=ApplyNormLdaWccnNap(ivector_test,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
ivector_imp=ApplyNormLdaWccnNap(ivector_imp,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
[SCORE_test,SCORE_imp,index_norm]=AdaptiveTnormFastScr(ivector_train,y,ivector_test,ivector_imp);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
Min_metric,minError




