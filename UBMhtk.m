IvectorSvmpath='';
Path.Prog='';
Path.UBM='';

tc=8198;% MFCC-0
fp=0.01;
little_end=1;
dirpathUBM=dir(Path.UBM);
ftrpath=[IvectorSvmpath,'\Features'];
featpath=[IvectorSvmpath,'\htkFeatures'];mkdir(featpath);
lblpath=[IvectorSvmpath,'\Labels'];
labpath=[IvectorSvmpath,'\htklabels'];mkdir(labpath);
TrainMFCC=[Path.Prog,'\TrainMFCC.txt']; fid_TrainMFCC=fopen(TrainMFCC,'w');
Lab=[Path.Prog,'\Lab.mlf']; fid_Lab=fopen(Lab,'w');

for i=3:length(dirpathUBM)
    wav=dirpathUBM(i).name;wav(end-3:end)=[];
    ftr=[ftrpath,'\',wav,'.ftr'];
    fea=[featpath,'\',wav,'.fea'];
    [F,nSamples,sampPeriod,sampSize,parmKind]=readHTK(ftr,0);
    writehtk_sarraf(fea,F',fp,tc,little_end);  % write be formate big-endian
    
    lbl=[lblpath,'\',wav,'.lbl'];
    lab=[labpath,'\',wav,'.lab'];
    [S1,S2,Str]=textread(lbl,'%f%f%s');
    a=S2/fp;
    fid_lbl=fopen(lab,'w');
    fprintf(fid_lbl,'%d %d %s',1*10^7,(a-1)*fp*10^7,'UBM');
    fclose(fid_lbl);
    fprintf(fid_TrainMFCC,'%s\n',fea);
end
fclose(fid_TrainMFCC);
fprintf(fid_Lab,'%s\n%s%s%s','#!MLF!#','"*" -> "',labpath,'"');


HMM00=[IvectorSvmpath,'\HMM00']; mkdir(HMM00);
HMM01=[IvectorSvmpath,'\HMM01']; mkdir(HMM01);
HMM02=[IvectorSvmpath,'\HMM02']; mkdir(HMM02);
Logs=[IvectorSvmpath,'\Logs']; mkdir(Logs);

Hinit=['Hinit -C Config-HTK.txt -T 1 -S TrainMFCC.txt -i 30 -e 0.0001 -v 0.0010 -o ','UBM',' -M ',HMM01,' -l ','UBM',' -I Lab.mlf ',HMM00,'\UBM > ',Logs,'\HMM01-','UBM','.txt'];
dos(Hinit);
HRest=['HRest -C Config-HTK.txt -T 1 -S TrainMFCC.txt -i 30 -e 0.0001 -v 0.0010 -M ',HMM02,' -l ','UBM',' -I Lab.mlf -H ',HMM01,'\','UBM',' ','UBM',' > ',Logs,'\HMM02-','UBM','.txt'];
dos(HRest);

