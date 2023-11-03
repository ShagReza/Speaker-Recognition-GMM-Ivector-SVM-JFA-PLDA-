function WCC = WithenClassCov(data)

[dim,num_data] = size(data.X);
nclass = max( data.y );
Sw=zeros(dim,dim);
for i = 1:nclass,
  inx_i = find( data.y==i);
  X_i = data.X(:,inx_i);
  Sw = Sw + (1/length(inx_i))*cov( X_i', 1);
end
WCC=Sw/nclass;