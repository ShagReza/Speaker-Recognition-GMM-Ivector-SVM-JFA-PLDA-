
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % training UBM and GMM models (language models) 
    % inputs:
    %         ProgramsPath: path of programs
    %         UBM_DataPath: path of UBM data (GMM based methods)
    %         GMM_DataPath: path of languages' data
    %         NumGMM: Number of guassain mixtures
    %         new: [ProgramsPath,'\GMMUBM']
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%_________________________________________________________________________
function ModelTraining_GMMUBM(UBM_DataPath,new,GMM_DataPath,ProgramsPath,NumGMM)

%__________________________________________________________________________
i=1;
dirFiles  = dir(UBM_DataPath);
dirFiles(i+2).name(end-3:end)=[];
% TestPath=[new,'\Features\',dirFiles(i+2).name,'.ftr'];
% [F,nSamples,sampPeriod,sampSize,parmKind] = readHTK (TestPath , 0 );
% Dim=size(F,1);
Dim=39;
%_______________
%FeatureFiles-List (UBM):
dirFiles  = dir(UBM_DataPath);
fclose all;
fid = fopen([ProgramsPath,'\FeatureFiles-List.LST'], 'w');
for i=3:length(dirFiles)
    dirFiles(i).name(end-3:end)=[];
    fprintf(fid,'%s', dirFiles(i).name);
    fprintf(fid,'\n');
end
fclose(fid);
%_______________
%FeatureFiles-List-Targets (Target):
fclose all;
fid = fopen([ProgramsPath,'\FeatureFiles-List-Targets.LST'], 'w');
Lan = dir(GMM_DataPath);
for i=1:(length(Lan)-2)
    fprintf(fid,'%s', [Lan(i+2).name,' ']);
    dirFiles=dir([GMM_DataPath,'\',Lan(i+2).name, '\*.wav']);
    for j=1:length(dirFiles)
        dirFiles(j).name(end-3:end)=[];
        s=[dirFiles(j).name,' '];
        fprintf(fid,'%s', s);
    end
    fprintf(fid,'\n');
end
fclose(fid);
%__________________________________________________________________________
q1=[' --featureFilesPath ',new,'\Features\'];
q2=[' --mixtureFilesPath ',new,'\Models\'];
q3=[' --lstPath ',new,'\Test\'];
q4=[' --labelFilesPath ',new,'\Labels\'];
q5=[' --featureServerMask			0-',num2str(Dim-1),' '];
q6=[' --vectSize 					',num2str(Dim),' '];
q7=['--mixtureDistribCount     	',num2str(NumGMM)];

s=['TrainWorld.exe --config TrainWorld-HTK.cfg',q1,q2,q3,q4,q5,q6,q7];  dos(s);
s=['TrainTarget.exe --config TrainTarget-HTK.cfg',q1,q2,q3,q4,q5,q6,q7];  dos(s);
%__________________________________________________________________________
