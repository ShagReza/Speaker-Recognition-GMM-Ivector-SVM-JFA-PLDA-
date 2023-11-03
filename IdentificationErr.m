function IdentificationError(TargetScoreFiles,NoSegTgt,TotalTgtScoresMat,NumOfTest)

%=============================================
D = 0;
for i=1:length(NumOfTest)
    D=[D, sum(NumOfTest(1:i))];
end
for i=1:length(TargetScoreFiles)-2
    clear scoresMat;
    NFR = 0; NA = 0 ; FId = 0; Ntrueident = 0 ;
    j = 1; jj = 0;
    j = jj+1 ;
    jj = j+NoSegTgt(i)-1;
    tempV = find(D-i>=0);
    lan = tempV(1) - 1;
    scoresMat = TotalTgtScoresMat(j:jj,:);
    [a,b] = max(scoresMat);
    b
    if b==lan
        Ntrueident = Ntrueident+1;
    else
        FId = FId +1;
    end
    
end
FId
