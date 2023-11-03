function ModelTrainingUBM(pathstates,IvectorSvmpath)
load( [pathstates,'\Methods'] );
load( [pathstates,'\Path']);
load( [pathstates,'\Param'] );

%%%%%%%%%%%%
% (UBM):
dirFiles  = dir(Path.UBM);
fclose all;
fid = fopen([Path.Prog,'\FeatureFiles-List-Train-UBM.lst'], 'w');
for i=3:length(dirFiles)
    dirFiles(i).name(end-3:end)=[];
    fprintf(fid,'%s', dirFiles(i).name);
    fprintf(fid,'\n');
end
fclose(fid);

TestPath=[IvectorSvmpath,'\Features\',dirFiles(i).name,'.ftr'];
[F,nSamples,sampPeriod,sampSize,parmKind] = readHTK (TestPath , 0 );
Dim=size(F,1);

q1=[' --featureFilesPath ',IvectorSvmpath,'\Features\'];
q2=[' --mixtureFilesPath ',IvectorSvmpath,'\Models\'];
q3=[' --lstPath ',IvectorSvmpath,'\Test\'];
q4=[' --labelFilesPath ',IvectorSvmpath,'\Labels\'];
q5=[' --featureServerMask			0-',num2str(Dim-1),' '];
q6=[' --vectSize 					',num2str(Dim),' '];
q7=['--mixtureDistribCount     	',num2str(Param.NumGMM)];
s=['TrainWorld.exe --config trainWorld.cfg',q1,q2,q3,q4,q5,q6,q7];  dos(s);
%%%%%%%%%%%%%