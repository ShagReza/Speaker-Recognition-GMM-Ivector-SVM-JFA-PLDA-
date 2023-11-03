function  [x,y,z,Min_A]=MIN3Dimention(A)
Min_A = min(min(min(A)));

[a1,b1]=min(A,[],1);
[a2,b2]=min(a1,[],2);
[a3,b3]=min(a2,[],3);

z = b3;
y = b2(:,:,z);
x=b1(:,y,z);




