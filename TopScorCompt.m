function LLK = TopScorCompt(FtrVal, GConst, MVM, ICV,TopG,i)

global maxLLK minLLK C
clear  LLK Pmixg
LLK= (repmat(-1e10,size(FtrVal,2),1))';
for c= 1:C
    Pmixg= 0.5*sum((FtrVal - MVM(:,TopG(c,:),i)).^2 .* ICV(:,TopG(c,:)));
    if Pmixg >= maxLLK
        Pmixg = maxLLK;
    end
    if Pmixg <= minLLK
        Pmixg = minLLK;
    end
    Pmixg=GConst(TopG(c,:))- Pmixg;
    LLK= LogAdd(LLK,Pmixg);
end


