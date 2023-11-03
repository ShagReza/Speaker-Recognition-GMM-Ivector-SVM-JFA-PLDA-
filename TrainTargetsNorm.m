function TrainTargetsNorm(pathstates,IvectorSvmpath)
%------------------------------
load(pathstates);
dirFiles  = dir(Path.UBM);
 dirFiles(3).name(end-3:end)=[];
TestPath=[IvectorSvmpath,'\Features\',dirFiles(3).name,'.ftr'];
[F,nSamples,sampPeriod,sampSize,parmKind] = readHTK (TestPath , 0 );
Dim=size(F,1);

q1=[' --featureFilesPath ',IvectorSvmpath,'\Features\'];
q2=[' --mixtureFilesPath ',IvectorSvmpath,'\Models\'];
q3=[' --lstPath ',IvectorSvmpath,'\Test\'];
q4=[' --labelFilesPath ',IvectorSvmpath,'\Labels\'];
q5=[' --featureServerMask			0-',num2str(Dim-1),' '];
q6=[' --vectSize 					',num2str(Dim),' '];
q7=['--mixtureDistribCount     	',num2str(Param.NumGMM)];
%------------------------------
%------------------------------
load([pathstates,'\trainNorm']);
dirTargets=dir(Path.NormSpeak);
for i=1:TrainNorm.NumSpeaker
    fid = fopen([Path.Prog,'\FeatureFiles-List-Targets.LST'], 'w');
    fprintf(fid,'%s ', dirTargets(i+2).name);
    for j=1:length(TrainNorm.class)
        if TrainNorm.class(j)==i
            fprintf(fid,'%s ',TrainNorm.name{j});
        end
    end
    fprintf(fid,'\n ');
    fclose(fid)
    s=['TrainTarget.exe --config trainTarget-HTK.cfg',q1,q2,q3,q4,q5,q6,q7];  dos(s);    
end
%------------------------------





