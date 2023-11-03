function [I, NumOfSegments]=Segmentation_Gsl(bb,SegmentLen,FS,OverlapLen,TestPath,new,LAN)
W     = SegmentLen*FS;   %segmen length(x second * 8000);
OverW = OverlapLen*FS;
I = 0; % number of files's segments

%TestPath = [DataPath,'\',LAN, '\',PathWaves(bb,1).name];
[xx,fs] = wavread(TestPath);
s = 0.99* resample(xx,8000,fs);
i = 0;
while length(s)>=(W)
    s1 = s(1:W);
    s(1:W-OverW) = [];
    i  = i+1;
    TestName    = [new,'\Waves\',LAN,'-',num2str(bb),'-',num2str(i),'.wav'];
    wavwrite(s1,8000,TestName);
end

if length(s)<W && length(s)>1600
    s1 = s;
    i  = i+1;
    TestName    = [new,'\Waves\',LAN,'-',num2str(bb),'-',num2str(i),'.wav'];
    wavwrite(s1,8000,TestName);
end

I = I+1;
NumOfSegments(I) = i;