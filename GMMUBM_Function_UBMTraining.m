function GMMUBM_Function_UBMTraining(Path_Stats)

load(Path_Stats);

% wav/ model and feature path ....
fid_UBM = fopen(['.\FeatureFiles-List-Train-UBM.lst'],'w');
Pth_UBM_Labels   = [Path.s_Labels,'UBM\'];     mkdir(Pth_UBM_Labels);
Pth_UBM_Features = [Path.s_Features,'UBM\'];   mkdir(Pth_UBM_Features);
UBMFiles    = dir([Path.UBM ]);
 

% parameters
fs_new=8000;
Add_Noise=0;
SNR =50;
% function
ft_func     = ['function_',Methods.ft];
ftsel_func  = ['function_',Methods.ftsel];
lab_func    = ['function_',Methods.lab];
% paremters

for i=3:length(UBMFiles)
    
    % files name
    
    UBMWavePth = [Path.UBM,UBMFiles(i).name];
    UBMName = [UBMFiles(i).name];
    UBMName(end-3:end) = [];
    
    TestName= [Pth_UBM_Features,UBMName,'.wav'];
    [xx,fs] = wavread(UBMWavePth);
  
    s_o = 0.99* resample(xx,fs_new,fs);
    if Add_Noise==1
        s = awgn(s_o,SNR,'measured');
    else
        s=s_o;
    end
    wavwrite(s,fs_new,TestName);

    % label ...
    eval([lab_func,'(UBMName,Pth_UBM_Features,Pth_UBM_Labels)']);
    
    % feature extraction ...
    eval([ft_func,'(UBMName,Pth_UBM_Features,Pth_UBM_Features)']);

    % feature masking ...
    [Masking, FeatSize ] = eval(ftsel_func);
    fprintf(fid_UBM,'%s\n',UBMName);    
end

fclose all;
s_ubm = ['TrainWorld.exe --config trainWorld.cfg --featureFilesPath ',Pth_UBM_Features,...
        ' --mixtureFilesPath ',Path.s_Models,' --lstPath ',Path.s_Test,' --labelFilesPath ',Pth_UBM_Labels,...
        '  --featureServerMask ', Masking, ' --vectSize ', FeatSize];

dos(s_ubm);

