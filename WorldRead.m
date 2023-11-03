function  [GConst MV ICV]= WorldRead(WorldName)
[MSV,ICSV,W]= readALZgmmInv(WorldName);
Nmix= length(W);
D= length(MSV)/Nmix;
Const1= log(W)-D/2*log(2*pi);

for k= 1:Nmix
    MV(:,k)= MSV( (k-1)*D+1 : k*D );
    ICV(:,k)= ICSV( (k-1)*D+1 : k*D );
    Const2(k,1)= 0.5 * sum(log(ICV(:,k)));
end
GConst=(Const1+Const2)';