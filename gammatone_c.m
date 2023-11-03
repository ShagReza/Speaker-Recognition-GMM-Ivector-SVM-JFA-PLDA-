%GAMMATONE_C: An efficient C implementation of the 4th order gammatone filter
%

clear;clc;
tic
[input,fs,b]=wavread('H:\Speaker-Recognition\programs-with-MFCC-1024-Corrected\Robust-Features\AuditoryToolbox\Speaker26_mic_s2_TestNormal_M2temp.wav');
numChannels=128;
WinFlag=1;
[gfccfeature, gf,cf] = gfcc(input,fs,numChannels,WinFlag);

featurefile='H:\Speaker-Recognition\programs-with-MFCC-1024-Corrected\Robust-Features\AuditoryToolbox\Speaker26_mic_s2_TestNormal_M2temp.ftr';
C0_LogE  = 1 ;	
WinStep  = 80;
gfccfeatureftr=single(gfccfeature);
parmKind = int16(6 + C0_LogE * 8192 + (1-C0_LogE) * 64  );
SampPeriod =int32(WinStep/fs*1.0E+7);
SampSize=int16(4*size(gfccfeatureftr,1));
nSamples=int32(size(gfccfeatureftr,2));
toc;
%  nSamples  = fread(fp,1,'int32');
%  sampPeriod= fread(fp,1,'int32');
%  sampSize  = fread(fp,1,'int16');
%  parmKind = fread(fp,1,'int16');

fid=fopen('featurefile','w');
fwrite(fid,nSamples,'integer*4');
fwrite(fid,SampPeriod,'integer*4');
fwrite(fid,SampSize,'integer*2');
fwrite(fid,parmKind,'integer*2');
fwrite(fid,gfccfeatureftr,'float32');
fclose(fid);

featurefile='H:\Speaker-Recognition\programs-with-MFCC-1024-Corrected\Robust-Features\AuditoryToolbox\Features\UBM\FAR-1.ftr'
[X,nSamples,sampPeriod,sampSize,parmKind]=readHTK(featurefile,0);


%[bm, env, instp, instf] = gammatone_c(x, fs, cf, hrect) 
%
%  x     - input signal
%  fs    - sampling frequency (Hz)
%  cf    - centre frequency of the filter (Hz)
%  hrect - half-wave rectifying if hrect = 1 (default 0)
%
%  bm    - basilar membrane displacement
%  env   - instantaneous envelope
%  instp - instantaneous phase (unwrapped radian)
%  instf - instantaneous frequency (Hz)
%
%
%  The gammatone filter is commonly used in models of the auditory system.
%  The algorithm is based on Martin Cooke's Ph.D work (Cooke, 1993) using 
%  the base-band impulse invariant transformation. This implementation is 
%  highly efficient in that a mathematical rearrangement is used to 
%  significantly reduce the cost of computing complex exponentials. For 
%  more detail on this implementation see
%  http://www.dcs.shef.ac.uk/~ning/resources/gammatone/
%
%  Once compiled in Matlab this C function can be used as a standard 
%  Matlab function:
%mex gammatone_c.c
% bm = gammatone_c(x, 16000, 200);
%
%  Ning Ma, University of Sheffield
%  n.ma@dcs.shef.ac.uk, 09 Mar 2006
% 
