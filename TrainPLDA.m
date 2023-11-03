
function PLDAModel=TrainPLDA(DataPLDA,classTest,N_ITER,Ny,Nx)
%------------------
%NORM:
for i=1:size(DataPLDA,1)
    DataPLDA(i,:)=DataPLDA(i,:)./norm(DataPLDA(i,:));
end
%------------------
ID=zeros(length(classTest),max(classTest));
for i=1:length(classTest)
    ID(i,classTest(i))=1;
end
ID=sparse(ID);
%------------------
PLDAModel = PLDA_Train(DataPLDA',ID, N_ITER,Ny,Nx);
%------------------
