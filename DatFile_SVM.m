function DatFile_SVM(scores,CLASS,ProgramsPath,task)

fid=fopen([ProgramsPath,'\SVM_',task,'.txt'],'w');
for i=1:size(scores,1)
        fprintf(fid,'%d%s', CLASS(i) , ' ');
    for j=1:size(scores,2)
        fprintf(fid,'%d%s', j , ':');
        fprintf(fid,'%f%s', scores(i,j) , ' ');
    end
    fprintf(fid,'\n');
end
fclose(fid);


