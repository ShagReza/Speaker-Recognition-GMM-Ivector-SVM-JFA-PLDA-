%LDA.WCCN,NAP:
Norm_ivector=1; LDA_ivector=1;WCCN_ivector=1; NAP_ivector=0; LDAdim=180; NAPivector_Dim=20;

y=DataPLDA;
class=classTest;

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
ivector_train=ApplyNormLdaWccnNap(ivector_train,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,LDAmodel,P_NAP,B_WCCN);
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
SCORE_test=ApplyLLR2(0.5*SCORE_test+0.5);
SCORE_imp=ApplyLLR2(0.5*SCORE_imp+0.5);
[Min_metric,minError,Thershold2,MED,MAD]=ThrFinding_pulled2_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
[Results,meanE]=ThrFinding_mean_OneParam(NumOfSegments_test,NumOfTest_test,SCORE_test,NumOfSegments_imp,SCORE_imp)
Min_metric,minError
%---------------------------------

