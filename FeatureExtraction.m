function  FeatureExtraction(new,fw,pathstates)
load(pathstates);

EnhSegmentsPath   = dir([new,'\EnhancedWaves\*.wav']);
ft_func     = ['function_',Methods.ft];

if fw~=1
    for i = 1:length(EnhSegmentsPath)
        WavPath      = [new,'\EnhancedWaves\',EnhSegmentsPath(i).name];
        W_nam=EnhSegmentsPath(i).name; W_nam(end-3:end) = [];
        FeaturePath  = [new,'\Features\',W_nam,'.ftr'];
        wav=[new,'\EnhancedWaves\'];
        feat=[new,'\Features\'];
            eval([ft_func,'(W_nam,wav,feat)']);
    end
end
