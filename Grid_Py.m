



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Grid_Py(DataTrainSvm,class,ProgramsPath,task)

i=1;
ClassNew=[];
for j=1:size(DataTrainSvm,1)
    if class(j)==(i-1)
        ClassNew(j)=1;
    else
        ClassNew(j)=0;
    end
end

DatFile_SVM(DataTrainSvm,ClassNew,ProgramsPath,task);
dos('grid_wo_plot.py  -v 5  -svmtrain svm-train.exe SVM_train.txt');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




