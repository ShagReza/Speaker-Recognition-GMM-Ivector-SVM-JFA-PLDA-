
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function trains N SVM classifier (N: number of training languages)
% each SVM classifies super vectors of one class from super vectors of the
% other classes.
% inputs:
%         DataTrainSvm: super vectors of training data 
%         class: class of super vectors
%         ProgramsPath: path of programs
%         c,g: SVM parameters (RBF kernel)
%         task:'train'
%         SVM_Matlab: if 1 : SVM will be trained with MATLAB function
%                     but we set it zero because of low memory problems
%                     and unsatisfying results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function MatlabSVM_train=OneVersusRest_SVM(DataTrainSvm,class,ProgramsPath,c,g,SVM_Matlab,kerneltype,task)

I=max(class)+1;
SVM='LibSVM_train';
%if SVM_Matlab==1, SVM='MatlabSVM_train'; end;

for i=1:I
    ClassNew=[];
    for j=1:size(DataTrainSvm,1)
        if class(j)==(i-1)
            ClassNew(j)=1;
        else
            ClassNew(j)=0;
        end
    end
    
    if SVM_Matlab==1
        %SVMnew=[SVM,num2str(i),'.libsvm'];
        sigma=sqrt(1/(2*g));
        MatlabSVM_train{1,i}=svmtrain(DataTrainSvm,ClassNew,'KERNEL_FUNCTION', 'rbf','RBF_Sigma',sigma,'Autoscale', 'false');
       % MatlabSVM_train{1,i}=svmtrain(DataTrainSvm,ClassNew,'KERNEL_FUNCTION', 'rbf','RBF_Sigma',sigma);
        %MatlabSVM_train{1,i}=svmtrain(DataTrainSvm,ClassNew);
        %fid=fopen(SVMnew);      
    else
        DatFile_SVM(DataTrainSvm,ClassNew,ProgramsPath,task);
        SVMnew=[SVM,num2str(i),'.libsvm'];
        if (kerneltype=='2')
            dos(['svm-train.exe   -b 1  -s 0  -t 2 -c ', num2str(c),'  -g ', num2str(g),' SVM_train.txt  ',SVMnew]);
        elseif (kerneltype=='1')
            dos(['svm-train.exe   -b 1  -s 0  -t 0 -c ', num2str(c),' SVM_train.txt  ',SVMnew]);
        end
        
        MatlabSVM_train=[];
    end
end
%svmStruct = svmtrain(data,groups)
%classes = svmclassify(svmStruct,data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




