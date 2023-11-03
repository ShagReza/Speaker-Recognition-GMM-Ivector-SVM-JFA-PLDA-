function [Files]=Resampler(FsOut,DIRWav,DIRIn)
% function [Flag]=InitSegmentation(BICTSeq,BICTHi,CompHi,FD)
%        FSout : Sampeling Ferequancy
%  output:
%        Write generated wave files         
%
% 



InDirec     = [DIRWav, '\*.wav'];
Files       = dir(InDirec);
if size( Files )<1
   Flag=0; error(['there is no file in the reference folder']);
    
end
LenFiles    = length(Files);
Space = 32;

for cntf = 1:LenFiles 
    InFileName = [];
    FileName = Files(cntf).name;
    InFileName = [[DIRWav,'\'] FileName];
    [X, Fs, Nb] = wavread(InFileName);
    OutFileName = [[DIRIn,'\'] FileName];
    q=Fs;p=FsOut;
    Y = resample(X,p,q);
    %part 2        
    wavwrite(Y,FsOut,OutFileName);
end
Flag =1;
