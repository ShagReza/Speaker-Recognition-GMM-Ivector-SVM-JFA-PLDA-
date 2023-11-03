

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [LDAmodel,P_NAP,B_WCCN]=VariabilityCompensation2_2(pathstates,IvectorSvmpath,JFA_eigen_lists,LDAdim,Norm_ivector,LDA_ivector,NAP_ivector,WCCN_ivector,NAPivector_Dim)

LDAmodel=[];P_NAP=[];B_WCCN=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[DataPLDA,classTest]=ivecExt(pathstates,IvectorSvmpath,JFA_eigen_lists);
[DataPLDA,classTest]=ivecExt2(pathstates,IvectorSvmpath,JFA_eigen_lists);
y=DataPLDA;
class=classTest;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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










