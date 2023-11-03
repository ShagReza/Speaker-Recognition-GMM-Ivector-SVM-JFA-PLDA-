function [I, NumOfSegments]=Segmentation_imp(nt,SegmentLen,FS,OverlapLen,DataPath,ScrPath,PathWaves,fidtxt,fidtxt2,Langauge,LAN,AdaptLLR,NameAdaptLLRData)
W     = SegmentLen*FS;   %segmen length(x second * 8000);
OverW = OverlapLen*FS;
I = 0; % number of files's segments
TestPath = [DataPath, '\',PathWaves(nt,1).name];
[xx,fs] = wavread(TestPath);
s = 0.99* resample(xx,8000,fs);
i = 0;
while length(s)>=(W)
    s1 = s(1:W);
    s(1:W-OverW) = [];
    i  = i+1;
    TestName    = [ScrPath,'\Waves\',LAN,'-',num2str(nt),'-',num2str(i),'.wav'];
    fprintf(fidtxt,'%s\n', [LAN,'-',num2str(nt),'-',num2str(i), '   ' ,Langauge]);
    fprintf(fidtxt2,'%s\n', [LAN,'-',num2str(nt),'-',num2str(i)]);
    wavwrite(s1,8000,TestName);
end

if length(s)<W && length(s)>1600
    s1 = s;
    i  = i+1;
    TestName    = [ScrPath,'\Waves\',LAN,'-',num2str(nt),'-',num2str(i),'.wav'];
    fprintf(fidtxt ,'%s\n', [LAN,'-',num2str(nt),'-',num2str(i), '   ' ,Langauge]);
    fprintf(fidtxt2,'%s\n', [LAN,'-',num2str(nt),'-',num2str(i)]);
    wavwrite(s1,8000,TestName);
end
fclose(fidtxt);
fclose(fidtxt2);
I = I+1;
NumOfSegments(I) = i;