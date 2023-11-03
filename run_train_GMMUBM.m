%%%  Speaker Verification Tool %%%

clc;  clear all;  close all;
clear all; clc;

%%variable Def.
global Path ;
global Methods;  
global fs_new;
fs_new = 8000;

%%wave path and program path ... 

fprintf('\n %s \n','               GMM UBM Method          ');
fprintf ('\n%s\n','------------------File Path------------------------') ;

question1 = input('Do you want to change default wav pass?(y/n)  : ','s') ;
question2 = input('Do you want to change default pass program pass?(y/n) : ','s') ;

if question1 == 'y'
    WavePath=input('Enter a new wav path: ','s') ;
else
    WavePath='I:\speaker-recognition-mfiles\data'; % Default Directory for original data
end

if question2 == 'y'
    ProgPath=input('Enter a new Prog. path : ','s') ;
else
    ProgPath='I:\rcisp-bistoonprj-ph1\Speaker-Recognition-Tool'; % Default Directory for original data
end

WavePath = [WavePath '\'];
ProgPath = [ProgPath '\'];
Path.Prog = ProgPath;
% change cuttent directory to the new path
cd(ProgPath);

% UBM and Training .... 
Path.NonTargetSpeakers_Train  = [WavePath,'nist-imp\'];                 %Path of nontarget speaker wave files for train
Path.TargetSpeakers_Train     = [WavePath,'spk_24_fix\'];               %Path of target speaker wave files for train
Path.UBM                      = [WavePath,'UBM\'];                      %Path of wave files for making UBM Model

% Test files ....
Path.TargetSpeakers_Test      = [WavePath,'spk_24_test_1ch_fix\'];      %Path of target wave files for testing
Path.Impostors_Test           = [WavePath,'imp_tel_fixed\'];            %Path of impostor wave files for testing
 
%%Making necessary folders...

Path.s_Labels   =[ProgPath,'Labels\'];  
Path.s_Features =[ProgPath,'Features\'];   
Path.s_Models   =[ProgPath,'Models\'];    
Path.s_Lists    =[ProgPath,'Lists\'];    
Path.s_Test     =[ProgPath,'Test\'];  
Path.s_New_wav  =[ProgPath,'Wav\'];  
Path.stats      =[ProgPath,'stats\'];


mkdir(Path.s_Labels);
mkdir(Path.s_Features);
mkdir(Path.s_Models);
mkdir(Path.s_Lists);
mkdir(Path.s_Test);
mkdir(Path.s_New_wav);
mkdir(Path.stats);

Path.TestResults=[ProgPath,'TestResults\'];
Path.TestWaves=[ProgPath,'TestResults\Waves\'];
Path.TestFeatures=[ProgPath,'TestResults\Features\'];
Path.TestLabels=[ProgPath,'TestResults\Labels\'];
Path.TestScore=[ProgPath,'TestResults\ComputeTestResults\' ];
Path.TestScoreNorm=[ProgPath,'TestResults\ComputeNormTestResults\' ];
Path.TestScoreNormMultiTgt=[ProgPath,'TestResults\ComputeNormTestResults\Targets_multiTgt\' ];
Path.TestScoreNormSingleTgt=[ProgPath,'TestResults\ComputeNormTestResults\Targets_singleTgt\' ];
Path.TestScoreNormImp=[ProgPath,'TestResults\ComputeNormTestResults\Impostors\' ];

mkdir(Path.TestResults);
mkdir(Path.TestWaves);
mkdir(Path.TestFeatures);
mkdir(Path.TestLabels);
mkdir(Path.TestScore);
mkdir(Path.TestScoreNorm);
mkdir(Path.TestScoreNormMultiTgt);
mkdir(Path.TestScoreNormSingleTgt);
mkdir(Path.TestScoreNormImp);

%%Methods ...
% Methods.ft--> feature extraction and enhancement method name
% Methods.ftsel--> feature selection method
% Methods.lab-->  masking or selection of useful frames of signal
% Methods.nor-->  score norm alization methods
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('\n %s \n','            HELP            ');
fprintf('\n %s ',' feature extraction method list  ');
fprintf('\n %s ',' MFCC  ');
fprintf('\n %s ',' MFCC_RASTA  ');
fprintf('\n %s ',' MFCC_Martin  ');
fprintf('\n %s ',' MFCC_RASTA_MVA  ');
fprintf('\n %s ',' GFCC_MFCC  ');
fprintf('\n %s ',' GFCC  ');

fprintf('\n\n %s ',' feature selection method list  ');
fprintf('\n %s ',' Selection_MFCC_39  ');
fprintf('\n %s ',' Selection_MFCC_25  ');
fprintf('\n %s ',' Selection_GFCC  ');
fprintf('\n %s ',' Selection_MFCC_GFCC  ');

fprintf('\n\n %s',' labeling method (voice discrimination) list ');
fprintf('\n %s ',' VAD  ');
fprintf('\n %s ',' pitch_lab  ');

fprintf('\n\n %s ','  normalization method list');
fprintf('\n %s ',' t_norm_alize  ');
fprintf('\n %s ',' t_norm  ');
fprintf('\n %s\n ',' a_t_norm  ');

Methods.ft=input('feature extraction method name: ','s') ;
% feature extraction method must be selected from this functions

% Examples:
% Methods.ft='MFCC';
% Methods.ft='MFCC_RASTA';
% Methods.ft='MFCC_Martin';
% Methods.ft='MFCC_RASTA_MVA';
% Methods.ft='GFCC';
% Methods.ft='GFCC_MFCC'; %combined feature

Methods.ftsel=input('feature selection method name: ','s') ; 
% Methods.ftsel= 'Selection_MFCC_39'
% Methods.ftsel= 'Selection_MFCC_25'
% Methods.ftsel= 'Selection_GFCC'
% Methods.ftsel= 'Selection_MFCC_GFCC'

Methods.lab=input('labeling method name: ','s') ;
% Examples:
%  Methods.lab='VAD';
%  Methods.lab='pitch_lab';


Methods.nor=input(' normalization method name: ','s') ;
% Examples:
% Methods.nor='t_norm_alize';
% Methods.nor='t_norm';
% Methods.nor='a_t_norm';

Param.Flag=0;
if isequal(Methods.nor,'t_norm')
   Param.Flag = str2num(input('normalization flag: ','s')) ;
   % Flag==1 --> used all target and nontarget models as cohort models 
   % Flag==0 --> used only  nontarget models as cohort models 
end

if isequal(Methods.nor,'a_t_norm')
   Param.MinNoCohortModel =str2num(input('minimum number of chort models: ','s')) ;
   Param.MaxNoCohortModel =str2num(input('maximum number of chort models: ','s')) ;   
end
 
save( Path.stats, 'Methods', 'Path','Param');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%% Training %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

fprintf('\n %s \n','   UBM Training          ');
tic;
% This function calculates UBM model 
GMMUBM_Function_UBMTraining(Path.stats);
fprintf('\n %s \n','     GMM model Training: NonTarget        ');
% This function calculates GMM model for Target and NonTarget speakers
GMMUBM_Function_ModelTraining(Path.stats,'NonTarget',Path.NonTargetSpeakers_Train);
fprintf('\n %s \n','     GMM model Training: Target          ');
GMMUBM_Function_ModelTraining(Path.stats,'Target',Path.TargetSpeakers_Train);
Time_TrainingPhse = toc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Test  %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

load  (Path.stats);
Param.SegmentLen = str2num(input(' Segment Length: ','s')) ;
Param.OverlapLen = str2num(input(' Overlap Length : ','s'));
Param.MaxLength  = str2num(input(' Maximum Signal Length : ','s'));

Param.TargetSNR = Inf;
Param.ImpSNR    = Inf;

%Threshold Parameters
% Def . Valuse
Param.sigma2        = 0.1;
Param.min_sigma1    = 0.1;                 
Param.step_sigma1   = .45;         
Param.max_sigma1    = 1;
Param.min_t1        = -4;%min(-3*sqrt(var(TotalImpScores)),-3*sqrt(var(TotalTgtScores2)));     
Param.nStep_t1      = 59;  
Param.max_t1        = 4% max(3*sqrt(var(TotalImpScores)),3*sqrt(var(TotalTgtScores2)));
Param.min_t2        = -4;%min(-3*sqrt(var(TotalImpScores)),-3*sqrt(var(TotalTgtScores2)));     
Param.nStep_t2      = 109;          
Param.max_t2        = 4% max(4*sqrt(var(TotalImpScores)),4*sqrt(var(TotalTgtScores2)));

save( Path.stats, 'Methods', 'Path','Param');
function_GMMUBM_Test(Path.stats);

