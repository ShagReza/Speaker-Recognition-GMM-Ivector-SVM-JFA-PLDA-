%________________________________________________________________________%
function [Class,NumOfSegments_imp,score] = ReadingScores_imp(NumOfSegments_imp,ScrPath_imp,DataPath_imp,GMMpath,NumImpSpeak,AdaptLLR)
PathWaves=dir([DataPath_imp,'\*.wav']);
NL=length(PathWaves)

% LanFolders=dir(DataPath_imp);
% NL=length(LanFolders)-2
m=length(dir(GMMpath))-4;
if AdaptLLR==1
    m=NumImpSpeak+1;
end

SCR=[];
WW=0;
score(1,1:m) = 1;
LAN='imp';
for a = 1:NL % nl: language counter (targets and non target)
        WW=WW+1;
        Class(WW)=a;
        pthNormRslt = [ScrPath_imp ,'\NormTestResults\Norm_',LAN,'-',num2str(a),'.res'];
        [A,B,C,D,Scrs] = textread(pthNormRslt,'%s %s %s %s %f');
        SCR=[SCR,Scrs'];
        %_________________________________%
        emt=0;
        for xx=1:NumOfSegments_imp(WW)
            s = [ScrPath_imp ,'\Labels\',LAN,'-',num2str(a),'-',num2str(xx),'.lbl'];
            [A,B,speech] = textread(s, '%f %f %s');
            if isempty(A)
                disp(['Label file (',LAN,'-',num2str(a),'-',num2str(xx),'.lbl)' ,' is empty']);
                emt=emt+1;
            end  
        end
        NumOfSegments_imp(WW)=NumOfSegments_imp(WW)-emt;  
        %_________________________________%
end

i=1;
for i=1:(length(SCR)/m)
    score(i,1:m) = SCR(m*(i-1)+(1:m));
end
%________________________________________________________________________%
     

