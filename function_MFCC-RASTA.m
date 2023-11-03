function function_MFCC_(WaveFile,Pth_Wav,Pth_Feature)


InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
OutputFeaturelFile = [Pth_Feature,WaveFile,'.ftr'];

ftr_mfcc = ['MFCC.exe ',InputWaveFile,' ',OutputFeaturelFile];%     
dos(ftr_mfcc);


