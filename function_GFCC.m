function  function_GFCC(WaveFile,Pth_Wav,Pth_Feature)
% parameters
lowFreq     = 50.00;    %low frequency
HighFreq    = 4000.00;  %High frequency
numChannels = 20;
WinFlag = 1;  % Modified GFCC: using average of the filter bank output instead of downsampling
% Otherwise:     downsampling
InputWaveFile       = [Pth_Wav,WaveFile,'.wav'];
OutputFeaturelFile  = [Pth_Feature,WaveFile,'.ftr'];
s = wavread(InputWaveFile);
C0_LogE  = 1 ;
WinStep  = 80;
parmKind = int16(6 + C0_LogE * 8192 + (1-C0_LogE) * 64  );
fs_new=8000;
% GFCC
[gfccfeature] = gfcc_delta(s,fs_new,WinFlag,numChannels,lowFreq,HighFreq);
gfccfeatureftr=single(gfccfeature);
SampPeriod =int32(WinStep/fs_new*1.0E+7);
SampSize=int16(4*size(gfccfeatureftr,1));
nSamples=int32(size(gfccfeatureftr,2));
fid = fopen(OutputFeaturelFile,'w');
fwrite(fid,nSamples,'integer*4');
fwrite(fid,SampPeriod,'integer*4');
fwrite(fid,SampSize,'integer*2');
fwrite(fid,parmKind,'integer*2');
fwrite(fid,gfccfeatureftr,'float32');
fclose(fid);
end
