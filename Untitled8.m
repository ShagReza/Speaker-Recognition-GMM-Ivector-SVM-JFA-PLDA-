%---------------------------------------------------------
%---------------------------------------------------------
fid1=fopen('list.txt','w');
A=dir('G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\imp_fix');
for i=1:(length(A)-2)
    B=A(i+2).name; B(end-3:end)=[];
    fprintf(fid1,'%s %s\n','G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\imp_fix', B);
end
A=dir('G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_1ch_fix\A_Jafarpur');
for i=1:(length(A)-2)
    B=A(i+2).name; B(end-3:end)=[];
    fprintf(fid1,'%s %s\n','G:\Bistoon-Ph1AndIvector\Data\data_tahereh_910303\spk_24_test_1ch_fix\A_Jafarpur', B);
end
fclose (fid1);
%---------------------------------------------------------
%---------------------------------------------------------

progPath='G:\Bistoon-Ph1AndIvector\prog_sh\bistoon_run\prog_dataamali';
path='G:\Bistoon-Ph1AndIvector\Test';
modelpath='G:\Bistoon-Ph1AndIvector\TestIvectorToC\Spk920729\modelsSpk';

[as,bs]=textread('list.txt','%s %s');
for j=1:length(as)
    fid=fopen('res.txt','a');

    wavpath1=[as{j,1},'\',bs{j,1},'.wav'];
    name=[bs{j,1}];
    
    ftrPath=[path,'\',name,'.ftr'];
    lblPath=[path,'\',name,'.lbl'];
    
    %%%%%%baraye moshabeh shodan ba marahele barname matlab:%%%%%%%%%%%%%%%
    [xx,fs] = wavread(wavpath1);
    s = 0.99* resample(xx,8000,fs);
    wavpath=[path,'\',bs{j,1},'.wav'];
    wavwrite(s,8000,wavpath);
    dos(['VAD.exe ',wavpath,' ',lblPath,' 5 10 10  0  SNR.txt 0.03 ']);
    dos(['Clip-VOICE.exe ' ,wavpath,' ',lblPath, ' ', [path,'\','a.wav']]);
    dos(['Add-Noise.exe ' , [path,'\','a.wav'],' ', wavpath, ' ','0.32767']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    dos(['MFCC.exe ',wavpath,' ',ftrPath ]);
    dos(['VAD.exe ',wavpath,' ',lblPath,' 0 -1 -1  0  SNR.txt 0 ']);
    dos(['TestIvector3.exe CfgIvecSpk_2048.txt ',path,' ',path,' ',modelpath,' ',name,' ',path,' Test.lst UBM 1024 ThrSpkFix4Chan.txt']);
    A=textread([path,'\',name,'.emt'],'%s');
    scr=str2num(A{2,1});
    if scr>0.5
        fprintf(fid,'%s:%s\n',name,'accept');
    else
        fprintf(fid,'%s:%s\n',name,'reject');
    end
    fclose(fid);
end
