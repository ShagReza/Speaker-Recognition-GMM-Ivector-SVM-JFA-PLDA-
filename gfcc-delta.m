function [gfccfeature, gf,cf] = gfcc_delta(input,fs,numChannels,WinFlag)

preEmphFlag = 1;

% ERB SPACE PARAM.
lowFreq     = 50.00;
HighFreq    = 8000.00;

% preemphasis filter
if preEmphFlag==1
    preEmphasized = filter([1 -.97], 1, input);
else
    preEmphasized = input;
end

% cepstral analysis
cepstralCoefficients = 30;
gfccDCTMatrix = 1/sqrt(numChannels/2)*cos((0:(cepstralCoefficients-1))' * ...
    (2*(0:(numChannels-1))+1) * pi/2/numChannels);
gfccDCTMatrix(1,:) = gfccDCTMatrix(1,:) * sqrt(2)/2;

% Hamming Window
windowSize = 256;
windowStep = 80;
HamWindow(:,1) = 0.54 - 0.46*cos(2*pi*(0:windowSize-1)/windowSize);

% center of filters
T = 1/fs;
if length(numChannels) == 1
    cf = ERBSpace(lowFreq, HighFreq, numChannels);
else
    cf = numChannels(1:end);
    if size(cf,2) > size(cf,1)
        cf = cf';
    end
end

%gammatone filter
num_fram = fix((length(input)-windowSize)/windowStep);
gf=zeros(numChannels,num_fram);
gfcubicroot=gf;
bm=zeros(1,num_fram);

%post processing

if WinFlag==1 % 

    for k=1:cepstralCoefficients
        bm = gammatone_c(preEmphasized, fs, cf(numChannels-k+1));
        
        % windowing 
        % windows of duration 32 ms with 10 ms shift
        for start=0:num_fram-1
            first = start*windowStep + 1;
            last = first + windowSize-1;
            gf(k,start+1)= abs(bm(1,first:last))*HamWindow;
%            gf(k,start+1)= mean(abs(bm(1,first:last)));
        end
    end
    %
else % downsample
     for k=1:cepstralCoefficients
        temp=[];
        bm = gammatone_c(preEmphasized, fs, cf(numChannels-k+1));
        temp=downsample(bm,windowStep);
        gf(k,:)=temp(1:num_fram);
    end
end

% cubic root operation
gfcubicroot=((abs(gf)).^(1/3));
gfccfeature=gfccDCTMatrix*gfcubicroot;
gfccfeature_del=gfccfeature;
% delta
MeanFeature(:,1)=mean(gfccfeature');
gfccfeature=gfccfeature-MeanFeature*ones(1,num_fram);
%CVN
VarFeature(:,1)=sqrt(var(gfccfeature'));
gfccfeature=gfccfeature./((VarFeature+0.00001)*ones(1,num_fram));
for t=3:num_fram-3
    temp=[];
    temp=(gfccfeature(:,t+1)-gfccfeature(:,t-1));
    temp=temp+2*(gfccfeature(:,t+2)-gfccfeature(:,t-2));
    gfccfeature_del(:,t)=temp/10;    
end
gfccfeature_st_dy=[gfccfeature ; gfccfeature_del];


% 
% coch=gf(1:128,:);
% for j=1:size(coch,1)
% c=max(coch(j,:),0);
% c=filter([1],[1 -.99],c);
% coch(j,:)=c;
% end
% imagesc(coch);
%CMN
