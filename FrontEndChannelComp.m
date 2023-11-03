% Front End Channel Compensation

%-------------------------------------------------------
%PCA:
%UBMhtk.m
%-------------------------------------------------------


%function [NewCov,A]=FrontEndChComp_LDA()
%-------------------------------------------------------
% LDA:
m=load('models/ubm_means')';
v=load('models/ubm_variances')';
w=load('models/ubm_weights')';
n_mixtures  = size(w, 1);
dim         = size(m, 1) / n_mixtures;
m = reshape(m, dim, n_mixtures);
v = reshape(v, dim, n_mixtures);
%data = load(asciname, '-ascii')'; %data:Nframe*Nfeature
%[N F gammas] = collect_suf_stats(data', m, v, w);  %gammas: Ngmm*Nframe

% talime LDA roye dadegane NIST na UBM:
load(pathstates);
Path.PLDA='G:\Bistoon-Ph1AndIvector\Data\nist8side';
task='PLdaData';
new=[IvectorSvmpath,'\',task];
mkdir(new);
mkdir([new,'\Waves'          ]);
mkdir([new,'\EnhancedWaves'  ]);
mkdir([new,'\Models']);
mkdir([new,'\Features']);
mkdir([new,'\Labels']);
PathSpks  = dir(Path.PLDA); % waves path of language nl
Sbg(n_mixtures,dim,dim)=0; Sbg0(1,dim,dim)=0;
Swg(n_mixtures,dim,dim)=0; Swg0(1,dim,dim)=0;


mean=m';
for j = 1:(length(PathSpks)-2)
    pathWavs=dir([Path.PLDA,'\',PathSpks(j+2).name,'\*.wav']);
    rmdir([new,'\Waves\'          ],'s'); mkdir([new,'\Waves\'          ]);
    rmdir([new,'\EnhancedWaves\'  ],'s'); mkdir([new,'\EnhancedWaves\'  ]);
    rmdir([new,'\Features\'       ],'s'); mkdir([new,'\Features\'       ]);
    rmdir([new,'\Labels\'       ],'s'); mkdir([new,'\Labels\'       ]);
    
    for i=1:length(pathWavs)
        TestPath = [Path.PLDA,'\',PathSpks(j+2).name, '\',pathWavs(i,1).name];      
        copyfile(TestPath,[new,'\Waves\',pathWavs(i,1).name]);
    end
    FeatureLabelExtraction_ivectorTest(pathstates,new);
    
    dirFiles=dir([new,'\Labels\'       ]);
    XbarGs=0; Allgammas=[]; Alldata=[];
    for jj=3:length(dirFiles)
        dirFiles(jj).name(end-3:end)=[];
        data = readHTK([new,'\Features\', dirFiles(jj).name,'.ftr'],0)';
        [N F gammas] = collect_suf_stats(data', m, v, w); 
        XbarGs=XbarGs+gammas*data;
        Allgammas=[Allgammas,gammas];
        Alldata=[Alldata;data];
    end
    XbarGs=XbarGs/(length(dirFiles)-2);
    NsG=sum(Allgammas,2);
    for i=1:n_mixtures
        Sbg0(1,:,:)=(XbarGs(i,:)-mean(i,:))'*(XbarGs(i,:)-mean(i,:));
        Sbg(i,:,:)=Sbg(i,:,:)+Sbg0(1,:,:); 
    end
    
    for i=1:n_mixtures
        g=Allgammas(i,:)'; gg=repmat(g,1,dim);
        Swg0(1,:,:)=(gg.*(Alldata-repmat(XbarGs(i,:),size(Alldata,1),1)))'*(Alldata-repmat(XbarGs(i,:),size(Alldata,1),1));
        Swg(i,:,:)=Swg(i,:,:)+Swg0(1,:,:);
    end
end
Sbg=Sbg/(length(PathSpks)-2);
Swg=Swg/(length(PathSpks)-2);

reg=0.001;
new_dim=25;
%A(n_mixtures,dim,dim)=0;
A(n_mixtures,dim,new_dim)=0;
A0(1,dim,new_dim)=0;
for i=1:n_mixtures
    Sw(1,dim,dim)=0; Sw=Swg(i,:,:); Sw=Sw(:); Sw=reshape(Sw,dim,dim);
    Sb(1,dim,dim)=0; Sb=Sbg(i,:,:); Sb=Sb(:); Sb=reshape(Sb,dim,dim);
    [V,D] = eig ( inv ( Sw + reg * eye(dim) ) * Sb );
    [D,inx] = sort(diag(D),1,'descend');
    A0=V(:,inx(1:new_dim));
    A(i,:,:)=A0;
end
%-------------------------------------------------------




%-------------------------------------------------------
NewCov(n_mixtures,new_dim,new_dim)=0;
for i=1:n_mixtures
    Amix=A(1,:,:); Amix=Amix(:); Amix=reshape(Amix,dim,new_dim);
    Vmix=[]; Vmix=v(:,1);  Vmix=diag(Vmix);
    NewCov(i,:,:)=Amix'*Vmix*Amix;
end
%-------------------------------------------------------



Afeat=A;
save( [Path.Prog,'\ResultIvector\Afeat'], 'Afeat');
save( [Path.Prog,'\ResultIvector\NewCov'], 'NewCov');




