function  function_GFCC_MFCC(WaveFile,Pth_Wav,Pth_Feature)
% combined GFCC and MFCC features

% parameters
lowFreq     = 50.00;    %low frequency
HighFreq    = 4000.00;  %High frequency
numChannels = 20;
WinFlag     = 1;  % Modified GFCC: using average of the filter bank output instead of downsampling
% Otherwise:     downsampling


InputWaveFile     = [Pth_Wav,WaveFile,'.wav'];
FeatureFileMFCC  = [Pth_Feature,WaveFile,'MFCC.ftr'];
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
SampSizeGFCC = int16(4*size(gfccfeatureftr,1));
nSamplesGFCC=int32(size(gfccfeatureftr,2));

% MFCC
ftr_mfcc = ['MFCC.exe ',InputWaveFile,' ',FeatureFileMFCC];%     
dos(ftr_mfcc);
[X,nSamplesMFCC,SampPeriodMFCC,SampSizeMFCC,parmKindMFCC]=readHTK(FeatureFileMFCC,0);
nSamples = min(nSamplesMFCC,nSamplesGFCC);
  
% concating GFCC and MFCC features
gfccmfccfeatureftr = [X(:,1:nSamples) ;gfccfeatureftr(:,1:nSamples)];
fid = fopen(OutputFeaturelFile,'w');
fwrite(fid,nSamples,'integer*4');
fwrite(fid,SampPeriod,'integer*4');
fwrite(fid,SampSizeMFCC+SampSizeGFCC,'integer*2');
fwrite(fid,parmKind,'integer*2');
fwrite(fid,gfccmfccfeatureftr,'float32');
fclose(fid);
delete(FeatureFileMFCC);
end


