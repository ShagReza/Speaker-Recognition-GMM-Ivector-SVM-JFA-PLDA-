function NumOfSegments=Scoring(Path_Stats,WavePath,WaveName,ModelOfTestingFile,SegmentLen,OverlapLen,NoModels,NoTargetModels,MaxLength,SNR)
%function NumOfSegments=Scoring(Path_Stats,WavePath,WaveName,ModelOfTestingFile,SegmentLen,OverlapLen,MaxLength,NoModels,NoTargetModels,SNR,NormMethod)
% This function call ComputeTest.exe and ComputeNorm.exe

load (Path_Stats);

%=====================================================================

% function
ft_func     = ['function_',Methods.ft];     % feature extraction function
ftsel_func  = ['function_',Methods.ftsel];  % feature selection function
lab_func    = ['function_',Methods.lab];    % labeling function
norm_func   = ['function_',Methods.nor];    % normalization function
%=====================================================================

% Parameters
fs_new = 8000;
MinSegLen=10; % minimum length of segment (second)
W     = SegmentLen*fs_new;   %Segment length(x second * fs_new);
OverW = OverlapLen*fs_new;   %Overlap length(x second * fs_new);

%=======================================================================
ProgPath = Path.Prog ;

q1 = [' --featureFilesPath ',Path.TestFeatures];
q2 = [' --mixtureFilesPath ',Path.s_Models ];
q3 = [' --lstPath '         ,Path.s_Test      ];
q4 = [' --labelFilesPath '  ,Path.TestLabels ];

rmdir(Path.TestWaves,'s');      mkdir(Path.TestWaves);
rmdir(Path.TestFeatures,'s');   mkdir(Path.TestFeatures);
fid1=fopen([Path.TestResults,'A.LST'],'w'); % models

%==========================================================================

% Add Noise
if nargin<8
    FlagAddNoise=0;
elseif SNR==Inf
    FlagAddNoise=0;
else
    FlagAddNoise=1;
end

TestPath = [WavePath,WaveName,'.wav'];
[xx,fs] = wavread(TestPath);
s_o = 0.99* resample(xx,fs_new,fs);  %
if FlagAddNoise==0
    s=s_o;
else
    SNR
    s = awgn(s_o,SNR,'measured');
end
%==========================================================================

% maximum length of signal
if nargin<7
    MaxLength=length(s);
end

i = 0;
if length(s)>=(MaxLength*fs_new)
    s=s(1:MaxLength*fs_new);
end

% segmentation

while length(s)>=(W)
    s1 = s(1:W);
    s(1:W-OverW) = [];
    i  = i+1;
    fprintf(fid1,'%s\n', [WaveName,'_',num2str(i),'  ',ModelOfTestingFile]);
    TestName    = [Path.TestWaves,WaveName,'_',num2str(i),'.wav'];
    wavwrite(s1,fs_new,TestName);
end

if length(s)<W && length(s)>fs_new*MinSegLen
    s1 = s;
    i  = i+1;
    fprintf(fid1,'%s\n', [WaveName,'_',num2str(i),'  ',ModelOfTestingFile]);
    TestName    = [Path.TestWaves,WaveName,'_',num2str(i),'.wav'];
    wavwrite(s1,fs_new,TestName);
end

fclose (fid1);
NumOfSegments = i;

%==========================================================================
% Feature extraction and labeling

pathDir3   = [Path.TestWaves,'*.wav'];
dirFiles3  = dir(pathDir3);
for b2 = 1:length(dirFiles3)

    W_nam = dirFiles3(b2).name;
    W_nam(end-3:end) = [];
    % feature extraction .....

    eval([ft_func,'(W_nam,Path.TestWaves,Path.TestFeatures)']);

    % label .....
    eval([lab_func,'(W_nam,Path.TestWaves,Path.TestLabels)']);

    % feature masking ...
    [Masking, FeatSize ] = eval(ftsel_func);

end

%==========================================================================
%Running ComputeTest...

expr = (['ComputeTest.exe --config computeTest.cfg --ndxFilename  ',Path.TestResults, 'A.LST' ,...
    ' --inputWorldFilename UBM --outputFilename ',Path.TestScore,WaveName,'.res',q1,q2,q3,q4, '  --featureServerMask ', Masking, ' --vectSize ', FeatSize]);
dos(expr);

%==========================================================================


%running ComputeNorm...

if isequal(norm_func,'function_t_norm_alize')

    dos_norm=(['ComputeNorm.exe --config computeNorm.cfg',...
        ' --tnormNistFile ',Path.TestScore         ,WaveName,'.res',...
        ' --testNistFile ' ,Path.TestScore         ,WaveName,'.res',...
        ' --outputFile '   ,Path.TestScoreNorm,'\Norm_',WaveName,'.res']);
    dos(dos_norm);
end
if isequal(norm_func,'function_t_norm')

    [Gender, ModelName, sign, TestFileName, scores]=textread([Path.TestScore,WaveName,'.res'],'%s %s %s %s %f');

    fid_norm= fopen([Path.TestScoreNorm,'Norm_',WaveName,'.res'],'w');
    FlagNorm=Param.Flag ;
    t_norm_scores = eval([norm_func,'(scores,NoModels,NoTargetModels,FlagNorm)']);
    
    for cnt=1:length(t_norm_scores)
        fprintf(fid_norm, '%s\t', Gender{cnt});
        fprintf(fid_norm, '%s\t', ModelName{cnt});
        fprintf(fid_norm, '%s\t', sign{cnt});
        fprintf(fid_norm, '%s\t', TestFileName{cnt});
        fprintf(fid_norm, '%f\n', t_norm_scores(cnt));
    end
    fclose(fid_norm);   
end

if isequal(norm_func,'function_a_t_norm')

    [Gender, ModelName, sign, TestFileName, scores]=textread([Path.TestScore,WaveName,'.res'],'%s %s %s %s %f');
    
    fid_norm= fopen([Path.TestScoreNorm,'Norm_',WaveName,'.res'],'w');
    Dist = function_cohort_selection(Path_Stats);
    t_norm_scores = eval([norm_func,'(scores,NoModels,NoTargetModels,Dist)']);
   
    for cnt=1:length(t_norm_scores)
        fprintf(fid_norm, '%s\t', Gender{cnt});
        fprintf(fid_norm, '%s\t', ModelName{cnt});
        fprintf(fid_norm, '%s\t', sign{cnt});
        fprintf(fid_norm, '%s\t', TestFileName{cnt});
        fprintf(fid_norm, '%f\n', t_norm_scores(cnt));
    end
    fclose(fid_norm);   
end

