%-------------------------------------------------------------------------------------
wavpath='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\sh\Test';
dirwavpath=dir(wavpath);
k=0; len=[];
for i=3:length(dirwavpath)   
    filepath=dir([wavpath,'\',dirwavpath(i).name,'\*.wav']);
    for j=1:length(filepath)
        [s,fs]=wavread([wavpath,'\',dirwavpath(i).name,'\',filepath(j).name]);
        k=k+1
        len(k)=length(s)/8000;
    end
end
%-------------------------------------------------------------------------------------
wavpath='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\sh\Imp';
dirwavpath=dir([wavpath,'\*.wav']);
for i=1:length(dirwavpath)
    [s,fs]=wavread([wavpath,'\',dirwavpath(i).name]);
    k=k+1
    len(k)=length(s)/8000;
end
%-------------------------------------------------------------------------------------
mean(len(1:168)),var(len(1:168))
mean(len(169:end)),var(len(169:end))
mean(len(:)),var(len(:))

x=1:2500;
subplot(3,1,1),hist(len(1:168),x),hold on
subplot(3,1,2),hist(len(169:end),x),hold on
subplot(3,1,3),hist(len(:),x)
%-------------------------------------------------------------------------------------
