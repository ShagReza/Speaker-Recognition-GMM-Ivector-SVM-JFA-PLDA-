
function NS=FeatureSegmentation(SegmentLen,OverlapLen,OutputFeatureFile,OutputLabelFile,new,name)

W     = SegmentLen*100;   %segmen length(x second * 8000);
OverW = OverlapLen*100;


[VV,nSamples,sampPeriod,sampSize,parmKind] = readHTK(OutputFeatureFile,0);
[st,en,lab]=textread(OutputLabelFile,'%f %f %s');
FF=[];
for j=1:length(st)
    FF=[FF,VV(:,st(j)*100:en(j)*100)];
end
VV=[]; VV=FF;

i=0;
while size(VV,2)>=(W)
    FF=[];
    FF = VV(:,1:W);
    VV(:,1:W-OverW) = [];
    i  = i+1;
    TestName    = [new,'\Features\',name,'-',num2str(i),'.ftr'];
    writeHTK(TestName,FF,size(FF,2),sampPeriod,sampSize,parmKind, 0); 
end

if size(VV,2)<W 
    FF=[];
    FF = VV;
    [VV,nSamples,sampPeriod,sampSize,parmKind] = readHTK(OutputFeatureFile,0);
    if size(VV,2)>W 
        FF=VV(:,end-W:end);
    end
    i  = i+1;
    TestName    = [new,'\Features\',name,'-',num2str(i),'.ftr'];
    writeHTK(TestName,FF,size(FF,2),sampPeriod,sampSize,parmKind, 0); 
end
NS=i;
