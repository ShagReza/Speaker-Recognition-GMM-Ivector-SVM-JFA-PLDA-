
%----------------------------------------------
function FeatLabelExtracNormFiles(pathstates,IvectorSvmpath,segmentation_train)

load(pathstates);
task=IvectorSvmpath;
mkdir(task);
mkdir([task,'\Models'          ]);
mkdir([task,'\EnhancedWaves'  ]);
mkdir([task,'\Features'       ]);
mkdir([task,'\Labels'         ]);
mkdir([task,'\normWaves'          ]);
mkdir([task,'\Test'          ]);
%--------
W=30*8000;
OverW=15*8000;
LanFolders=dir(Path.NormSpeak);
NL=length(LanFolders)-2;

TrainNorm=[]; k=0;
for nl = 1:NL
    LAN  = char(LanFolders(nl+2).name); % language nl
    PathWaves  = dir([Path.NormSpeak,'\',LAN, '\*.wav']);
    NumOfTest(nl) = length(PathWaves); % number of wave files in language nl folder
    for nt = 1:NumOfTest(nl)
        TestPath = [Path.NormSpeak,'\',LAN, '\',PathWaves(nt,1).name];
        TestName    = [task,'\normWaves\',PathWaves(nt,1).name];
        if segmentation_train==0
            copyfile(TestPath,TestName);
        else
            [xx,fs] = wavread(TestPath);
            s = 0.99* resample(xx,8000,fs);
            i = 0;
            while length(s)>=(W)
                s1 = s(1:W);
                s(1:W-OverW) = [];
                i  = i+1;
                Name=PathWaves(nt,1).name; Name(end-3:end)=[];
                TestName    = [task,'\normWaves\',Name,'_',num2str(i),'.wav'];
                wavwrite(s1,8000,TestName);
                k=k+1;
                TrainNorm.class(k)=nl;
                TrainNorm.name{k}=[Name,'_',num2str(i)];
                TrainNorm.classname{k}=LAN;
            end 
            if length(s)<W && length(s)>1600
                s1 = s;
                i  = i+1;
                TestName    = [task,'\normWaves\',Name,'_',num2str(i),'.wav'];
                wavwrite(s1,8000,TestName);
                k=k+1;
                TrainNorm.class(k)=nl;
                TrainNorm.name{k}=[Name,'_',num2str(i)];
                TrainNorm.classname{k}=LAN;
            end
        end
    end
end
TrainNorm.NumSpeaker=NL;
save( [Path.stats,'trainNorm'], 'TrainNorm');
%-------
%Enhancement (task,Enh);
%--------
ft_func     = ['function_',Methods.ft];
ftsel_func  = ['function_',Methods.ftsel];
lab_func    = ['function_',Methods.lab,'2'];
%--------
WavPath   = dir([task,'\normWaves\*.wav']);
for b1=1:length(WavPath)
    speech=[task,'\normWaves\',WavPath(b1).name];
    dos(['VAD.exe ',speech,' lbl.lbl',' 5 10 10  0  SNR.txt 0.03 ']);
    dos(['Clip-VOICE.exe ' , speech,' lbl.lbl', ' ', 'a.wav']);
    dos(['Add-Noise.exe ' , 'a.wav',' ', speech, ' ','0.32767']);
    pathwav=[task,'\normWaves\'];
    pathfeat=[task,'\Features\'];
    pathLabel=[task,'\Labels\'];
    Name=WavPath(b1).name; Name(end-3:end)=[];
    eval([ft_func,'(Name,pathwav,pathfeat)']);
    eval([lab_func,'(Name,pathwav,pathLabel)']);
    [Masking, FeatSize ] = eval(ftsel_func);
end
%-------------------------------------------

