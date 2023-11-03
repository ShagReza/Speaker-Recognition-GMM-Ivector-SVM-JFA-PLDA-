function function_AFEETSI(WaveFile,Pth_Wav,Pth_Feature)


InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
FeaturePath_pre    = [Pth_Feature,WaveFile,'.mfcc0'];
PitchFeatFile   = [Pth_Feature,WaveFile,'.pitch'];
ClassFeatFile   = [Pth_Feature,WaveFile,'.class'];
OutputFeaturelFile = [Pth_Feature,WaveFile,'.ftr'];

%AFA-ETSI
%feature extraction
str=['ExtAdvFrontEnd.exe ' InputWaveFile ' ' FeaturePath_pre '  ' PitchFeatFile '  ' ClassFeatFile ' -F RAW -nologE -skip_header_bytes 44'];
dos(str);
ftr_mfcc_afeetsi = ['Hcopy.exe -T 1 -C Config-HTK-Convert.txt ',' ',FeaturePath_pre,' ',OutputFeaturelFile ];
dos(ftr_mfcc_afeetsi);

dos(ftr_mfcc_afeetsi);
delete(FeaturePath_pre);
delete(PitchFeatFile);
delete(ClassFeatFile);