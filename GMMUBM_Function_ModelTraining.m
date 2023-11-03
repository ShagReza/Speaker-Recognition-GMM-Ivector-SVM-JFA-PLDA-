function GMMUBM_Function_ModelTraining(Path_Stats,ListName,TrainPath)

load(Path_Stats);
SNR=50;
Add_Noise=0;
fs_new=8000;

% wav/ model and feature path ....
Path_ModelSpeakers_Train = TrainPath

Pth_Models_Train_Labels   = [Path.s_Labels,ListName,'-Speakers-Train\'];
mkdir(Pth_Models_Train_Labels);
Pth_Models_Train_Features = [Path.s_Features,ListName,'-Speakers-Train\'];
mkdir(Pth_Models_Train_Features);
ModelFiles = dir(Path_ModelSpeakers_Train);
 
% function

ft_func     = ['function_',Methods.ft];
ftsel_func  = ['function_',Methods.ftsel];
lab_func    = ['function_',Methods.lab];

for i=3:length(ModelFiles)
    
    ModelFolders = [Path_ModelSpeakers_Train,ModelFiles(i).name];
    mkdir([Pth_Models_Train_Labels,ModelFiles(i).name]);
    mkdir([Pth_Models_Train_Features,ModelFiles(i).name]);
    PthList = [Path.s_Lists, ListName, num2str(i-2),'.lst'];
    fid_nonTrg_train = fopen(PthList,'w');
    fprintf(fid_nonTrg_train,'%s  ',ModelFiles(i).name);
    ModelWaves   = dir(ModelFolders);    
    NWav=(length(ModelWaves));
 % we limitd the number of wave file used for nontargetmodel training
    NWav= length(ModelWaves);
    if (length(ModelWaves))>=3
       NWav= 3;
    else 
%        rmdir(ModelFolders);
    end
       
    for j=3:NWav
        
        ModelName = [ModelWaves(j).name];
        ModelName(end-3:end) = [];                                                                
        ModelFeatPth = [Pth_Models_Train_Features,ModelFiles(i).name,'\'];
        ModelLabelPth = [Pth_Models_Train_Labels,ModelFiles(i).name,'\'];
        TestName=  [ModelFeatPth,ModelName,'.wav'];
        ModelWavePth=[ModelFolders,'\',ModelName,'.wav'];
    
        [xx,fs] = wavread(ModelWavePth);
        s_o = 0.99* resample(xx,fs_new,fs);
        if Add_Noise==1
            s = awgn(s_o,SNR,'measured');
        else
            s=s_o;
        end
        wavwrite(s,fs_new,TestName);
 
        % label .....
        eval([lab_func,'(ModelName,ModelFeatPth,ModelLabelPth)']);
        
        % feature extraction .....
         eval([ft_func,'(ModelName,ModelFeatPth,ModelFeatPth)']);
         
        % feature masking ....
        [Masking, FeatSize ] = eval(ftsel_func);    
        fprintf(fid_nonTrg_train,' %s',ModelName);            
      
    end    
    fprintf(fid_nonTrg_train,'\n');
    fclose all;
    
    FeatPth  = [Pth_Models_Train_Features,ModelFiles(i).name,'\'];
    LabelPth = [Pth_Models_Train_Labels,ModelFiles(i).name,'\'];
    s_modelTargets =['TrainTarget.exe --config trainTarget.cfg --targetIdList ',Path.s_Lists,ListName,num2str(i-2),'.lst',...
                    ' --mixtureFilesPath ',Path.s_Models,' --featureFilesPath ',FeatPth,' --lstPath ',Path.s_Test,...
                    ' --labelFilesPath ',LabelPth,   '  --featureServerMask ', Masking, ' --vectSize ', FeatSize]
                
     dos(s_modelTargets);
end
