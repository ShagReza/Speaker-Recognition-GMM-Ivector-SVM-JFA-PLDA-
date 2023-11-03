function SCORE_test=changScrFormat(SCORE_test,NL_test,NumOfTest_test,NumOfSegments_test,Class_test)
SCORE_test=SCORE_test';
for i=1:size(SCORE_test,2)
    SCORE_test(:,i)=(SCORE_test(:,i)-mean(SCORE_test(:,i)))/var(SCORE_test(:,i));
end

SCORE_test2=zeros(NL_test,size(SCORE_test,2));
I=sum(NumOfTest_test);
j = 1;   jj = 0;
for i = 1:I
    scr=[];
    j = jj+1;   jj = j+NumOfSegments_test(i)-1;
    scr=SCORE_test(:,j:jj)-mean(SCORE_test(:,j:jj))/var(SCORE_test(:,j:jj));
    SCORE_test2(Class_test(i),j:jj)=scr(1,:);
end
SCORE_test=SCORE_test2';
