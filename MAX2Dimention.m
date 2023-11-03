function  [Max_A,x,y]=MAX2Dimention(A)
Max_A = max(max(A));

[a1,b1]=max(A,[],1);
[a2,b2]=max(a1,[],2);

y=b2;
x=b1(b2);




