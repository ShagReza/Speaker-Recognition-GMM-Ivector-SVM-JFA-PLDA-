
%Rename and AlawToWave

%--------------------------------------------------------------------------
% Train:
path1='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\Sahab-Data-toolani-prj---10-spkr---Mr.Att-91.09.27_final\Train';
path2='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\sh\Train';

Folderpath=dir(path1);
for i=3:length(Folderpath)
    wavpath=dir([path1,'\',Folderpath(i).name,'\*.wav']);
    for j=1:length(wavpath)
        Alawname=[path1,'\',Folderpath(i).name,'\',wavpath(j).name];
        Alawname2=[path1,'\',Folderpath(i).name,'\',Folderpath(i).name,'_',num2str(j),'.wav'];
        copyfile(Alawname,Alawname2);
        mkdir([path2,'\',Folderpath(i).name]);
        wavname=[path2,'\',Folderpath(i).name,'\Train_',Folderpath(i).name,'_',num2str(j),'.wav'];
        dos(['ALawConvert.exe ' Alawname2,' ', wavname]);
        delete(Alawname2);
    end
end
%--------------------------------------------------------------------------





%--------------------------------------------------------------------------
% Test:
path1='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\Sahab-Data-toolani-prj---10-spkr---Mr.Att-91.09.27_final\Test';
path2='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\sh\Test';

Folderpath=dir(path1);
for i=3:length(Folderpath)
    wavpath=dir([path1,'\',Folderpath(i).name,'\*.wav']);
    mkdir([path2,'\',Folderpath(i).name]);
    for j=1:length(wavpath)
        Alawname=[path1,'\',Folderpath(i).name,'\',wavpath(j).name];
        Alawname2=[path1,'\',Folderpath(i).name,'\',Folderpath(i).name,'_',num2str(j),'.wav'];
        copyfile(Alawname,Alawname2);     
        wavname=[path2,'\',Folderpath(i).name,'\Test_',Folderpath(i).name,'_',num2str(j),'.wav'];
        dos(['ALawConvert.exe ' Alawname2,' ', wavname]);
        delete(Alawname2);
    end
end
%--------------------------------------------------------------------------




%--------------------------------------------------------------------------
% Impostors:
path1='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\Impostors';
path2='G:\Bistoon-Ph1AndIvector\Data\DataAmali_mobile10spks\Waves-for-Test\sh\Imp';
Folderpath=dir(path1);
for i=3:length(Folderpath)
    Alawname=[path1,'\',Folderpath(i).name];
    Alawname2=[path1,'\Imp.wav'];
    copyfile(Alawname,Alawname2);
    wavname=[path2,'\Imp_',num2str(i-2),'.wav'];    
    dos(['ALawConvert.exe ' Alawname2,' ', wavname]);
    delete(Alawname2);
end
%--------------------------------------------------------------------------







