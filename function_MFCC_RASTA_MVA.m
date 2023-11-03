function function_MFCC_RASTA_MVA(WaveFile,Pth_Wav,Pth_Feature)

FlagRASTA='0';  %FlagRASTA
Order='2';      %ARMA filter order


InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
FeaturePath_pre = [Pth_Feature,WaveFile,'_temp.ftr'];
OutputFeaturelFile = [Pth_Feature,WaveFile,'.ftr'];
ftr_mfcc = ['MFCC-RASTA.exe ',InputWaveFile,' ',FeaturePath_pre, ' ',FlagRASTA];%     
dos(ftr_mfcc);
ftr_mfcc_mva     = ['MVA.exe ',Order,' ', FeaturePath_pre, ' ',OutputFeaturelFile];
dos(ftr_mfcc_mva);
delete(FeaturePath_pre);


