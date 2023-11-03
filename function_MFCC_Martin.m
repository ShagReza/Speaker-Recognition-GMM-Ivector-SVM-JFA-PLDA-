function function_MFCC_Martin(WaveFile,Pth_Wav,Pth_Feature)


FlagEnhance='1'; 
InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
OutputFeaturelFile = [Pth_Feature,WaveFile,'.ftr'];
ftr_mfcc_enhance = ['MFCC-Enh.exe ',InputWaveFile,' ',OutputFeaturelFile, ' ',FlagEnhance];%     
dos(ftr_mfcc_enhance);

