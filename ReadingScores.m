
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function reads the output of compute norm (or compte test)
% inputs:
%         NumOfSegments: Number Of Segments 
%         NumOfTest: Number of data in each folder
%         GMMpath: path of gaussian models of training languages
%         DataPath: path of data
%         nontargetName: name of non target folder
%         ScrPath_test: [ProgramsPath,'\GMMUBM']
% output:
%         Class: Class of each segments
%         NumOfSegments: Number Of Segments (files with empty labels is emited)
%         score: Scores of segments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%________________________________________________________________________%
function [Class,NumOfSegments,score] = ReadingScores(NumOfSegments,NumOfTest,ScrPath_test,DataPath,GMMpath,NumImpSpeak,AdaptLLR)

LanFolders=dir(DataPath);
NL=length(LanFolders)-2;
lanfolders=cell(1,NL);
for i=1:NL
        lanfolders(i)={LanFolders(i+2).name};
end
LanFolders=lanfolders;

m=length(dir(GMMpath))-4;
if AdaptLLR==1
    m=NumImpSpeak+1;
end

SCR=[];
WW=0;
score(1,1:m) = 1;

for a = 1:NL % nl: language counter (targets and non target)
    LAN  = char(LanFolders(a)); % language nl
    Scrs=[];
    for b=1:NumOfTest(a)
        WW=WW+1;
        Class(WW)=a;
        pthNormRslt = [ScrPath_test ,'\NormTestResults\Norm_',LAN,'-',num2str(b),'.res'];
        [A,B,C,D,Scrs] = textread(pthNormRslt,'%s %s %s %s %f');
        SCR=[SCR,Scrs'];
        %_________________________________%
        emt=0;
        for xx=1:NumOfSegments(WW)
            s = [ScrPath_test ,'\Labels\',LAN,'-',num2str(b),'-',num2str(xx),'.lbl'];
            [A,B,speech] = textread(s, '%f %f %s');
            if isempty(A)
                disp(['Label file (',LAN,'-',num2str(b),'-',num2str(xx),'.lbl)' ,' is empty']);
                emt=emt+1;
            end  
        end
        NumOfSegments(WW)=NumOfSegments(WW)-emt;  
        %_________________________________%
    end
end

i=1;
for i=1:(length(SCR)/m)
    score(i,1:m) = SCR(m*(i-1)+(1:m));
end
%________________________________________________________________________%
     

