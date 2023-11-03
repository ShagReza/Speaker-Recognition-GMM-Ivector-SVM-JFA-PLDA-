function function_MFCC_RASTA(WaveFile,Pth_Wav,Pth_Feature)

FlagRASTA='1';  %FlagRASTA
InputWaveFile      = [Pth_Wav,WaveFile,'.wav'];
OutputFeaturelFile = [Pth_Feature,WaveFile,'.ftr'];
ftr_mfcc = ['MFCC-RASTA.exe ',InputWaveFile,' ',OutputFeaturelFile, ' ',FlagRASTA];%     
dos(ftr_mfcc);

