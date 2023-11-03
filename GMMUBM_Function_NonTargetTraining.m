function GMMUBM_Function_NonTargetTraining(Path_Stats)

load(Path_Stats);
SNR=50;
Add_Noise=0;

% wav/ model and feature path ....

Path_NonTargetSpeakers_Train = Path.NonTargetSpeakers_Train;

Pth_NonTargets_Train_Labels   = [Path.s_Labels,'Non-Target-Speakers-Train\'];
mkdir(Pth_NonTargets_Train_Labels);
Pth_NonTargets_Train_Features = [Path.s_Features,'Non-Target-Speakers-Train\']; 
mkdir(Pth_NonTargets_Train_Features);
NonTargetFiles = dir(Path_NonTargetSpeakers_Train);
 
for i=3:length(NonTargetFiles)
    
    NonTargetFolders = [Path_NonTargetSpeakers_Train,NonTargetFiles(i).name];
    mkdir([Pth_NonTargets_Train_Labels,NonTargetFiles(i).name]);
    mkdir([Pth_NonTargets_Train_Features,NonTargetFiles(i).name]);
    PthList = [s_Lists,'NonTarget',num2str(i-2),'.lst'];
    fid_nonTrg_train = fopen(PthList,'w');
    fprintf(fid_nonTrg_train,'%s  ',NonTargetFiles(i).name);
    NonTargetWaves   = dir(NonTargetFolders);    
    
    % we limitd the number of wave file used for nontargetmodel training
    NWav= length(NonTargetWaves);
    if (length(NonTargetWaves))>=3
       NWav= 3;
    else 
       rmdir(NonTargetFolders);
    end
       
    for j=3:NWav
        
        NonTargetWavePth = [NonTargetFolders,'\',NonTargetWaves(j).name,'\'];       
        NonTargetName = [NonTargetWaves(j).name];
        NonTargetName(end-3:end) = [];                                                                
        NonTargetLabelPth = [Pth_NonTargets_Train_Labels,NonTargetFiles(i).name,'\'];
        NonTargetFeatPth = [Pth_NonTargets_Train_Features,NonTargetFiles(i).name,'\'];
        
        TestName= [NonTargetFeatPth,NonTargetName,'.wav'];
        NonTargetWavePth= [NonTargetFeatPth,NonTargetName,'\',NonTargetName,'.wav'];
        [xx,fs] = wavread(NonTargetWavePth);
        s_o = 0.99* resample(xx,fs_new,fs);
        if Add_Noise==1
            s = awgn(s_o,SNR,'measured');
        else
            s=s_o;
        end
        wavwrite(s,fs_new,TestName);
 
        % label .....
        eval(lab_func,'(NonTargetName,NonTargetFeatPth,NonTargetLabelPth)');
        NonTargetFeatPth = [NonTargetFeatPth,NonTargetName,'.ftr'];
        
        
        % feature extraction .....
         eval(ft_func,'(s,NonTargetFeatPth)');
         
        % config parameters  (features).....
        [Masking, FeatSize ] = eval(ftsel_func);
         fprintf(fid_nonTrg_train,' %s',NonTargetName);            

    end    
    fprintf(fid_nonTrg_train,'\n');
    fclose all;
    FeatPth  = [Pth_NonTargets_Train_Features,NonTargetFiles(i).name,'\'];
    LabelPth = [Pth_NonTargets_Train_Labels,NonTargetFiles(i).name,'\'];
    s_modelTargets=['TrainTarget.exe --config trainTarget.cfg --targetIdList ',s_Lists,'NonTarget',num2str(i-2),'.lst',...
                    ' --mixtureFilesPath ',Path.s_Models,' --featureFilesPath ',FeatPth,' --lstPath ',Path.s_Test,...
                    ' --labelFilesPath ',LabelPth,   '  --featureServerMask ', Masking, ' --vectSize ', FeatSize];
    dos(s_modelTargets);
end
