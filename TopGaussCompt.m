function [LLK ,TopG]= TopGaussCompt(x_t, GConst, MV, ICV)

global maxLLK minLLK C
x=repmat(x_t,1,size(MV,2));
LLK = -1e10;
 Pmix= GConst- 0.5*sum((x- MV).^ 2.* ICV);
    [B,IX] = sort(Pmix,'descend');
    TopG= IX(1:C);
    for c=1:C
        LLK= LogAdd(LLK,B(c));
    end
    if LLK >= maxLLK
       LLK = maxLLK;
    end
    if LLK <= minLLK
       LLK = minLLK;
    end
   
