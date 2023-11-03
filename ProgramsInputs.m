
%------------------ Programs Inputs ---------------------
function pathstates=ProgramsInputs



disp('Do you want to use dafault settings?,');
def=input('(0:yes, 1:no  [default:1]) ', 's');
if (isempty(def)|| (def~='1' && def~='0'))
    def='1'; end;



%--------------------------------------
if def=='0'
    %Default settings:
    Path.Prog='E:\pattern_prog\programs2';
    Path.UBM='E:\pattern_prog\Data\UBM';
    Path.TargetSpeakers_Train='E:\pattern_prog\Data\Train';
    Path.TargetSpeakers_Test='E:\pattern_prog\Data\Test';
    Path.Impostors_Test='E:\pattern_prog\Data\Impostor';
    Path.LDA='E:\pattern_prog\Data\PLDA';
    Path.SADmodels='E:\KavoshgarGooyande\SADmodels';
    
    Methods.ft='MFCC';
    Methods.ftsel='Selection_MFCC_39';
    Methods.lab='VAD';
    Methods.nor='t_norm_alize';
    
    Param.SegLen=30;
    Param.LapLen=15;
    Param.NumGMM=256;
    Param.kerneltype='2';
    Param.c=32;
    Param.g=0.125;
    Param.ny=100;
    Param.Norm_ivector=1;
    Param.NAPivector_Dim=0;
    Param.LDA_ivector=0;
    Param.NAP_ivector=0;
    Param.WCCN_ivector=0;
    Param.TrainMethod=1;
    Param.NormScrs_target=0;
    Param.NormScrs=1;
    Param.art_data=0;
    Param.trainmethod='4';
    Param.RealTestData=1;
    Param.LDAdim=180;
    %--------------------------------------
    
    
    %------------------------
else
    OneVersusRest=1;

    Path.Prog='';
    Path.Prog =input('Input programs path: ', 's');
    if isequal(Path.Prog,''),Path.Prog='G:\Bistoon-Ph1\shaghayegh\prog2'; end
    
    Path.UBM='';
    Path.UBM =input('Input path of UBM Data: ', 's');
    if isequal(Path.UBM,''),Path.UBM='G:\Bistoon-Ph1\data\ubm'; end
    
    Path.TargetSpeakers_Train='';
    Path.TargetSpeakers_Train =input('Input path of Target Speakers(Train): ', 's');
    if isequal(Path.TargetSpeakers_Train,''),Path.TargetSpeakers_Train='G:\Bistoon-Ph1\data\spk_24_fix'; end
    
    Path.TargetSpeakers_Test='';
    Path.TargetSpeakers_Test =input('Input path of Target Speakers(Test): ', 's');
    if isequal(Path.TargetSpeakers_Test,''),Path.TargetSpeakers_Test='G:\Bistoon-Ph1\data\spk_24_test_1ch_fix'; end
    
    Path.Impostors_Test='';
    Path.Impostors_Test =input('Input path of Imposters (Test): ', 's');
    if isequal(Path.Impostors_Test,''),Path.Impostors_Test='G:\Bistoon-Ph1\data\imp_tel_fixed'; end
    
    Path.LDA='';
    Path.LDA =input('Input path of data for training LDA: ', 's');
    if isequal(Path.LDA,''),Path.LDA='G:\Bistoon-Ph1\data_testMic\LDAdata'; end
    
    Path.SADmodels='';
    Path.SADmodels=input('Input path of SAD models: ', 's');
    if isequal(Path.SADmodels,''),Path.SADmodels='G:\Bistoon-Ph1\data_testMic\LDAdata'; end
    %------------------------
    
    
    
    
    %------------------------
    Methods.ft='MFCC';
    %fprintf('\n %s ',' feature extraction method list  ');
    %fprintf('\n %s ',' MFCC  ');
    %fprintf('\n %s ',' MFCC_RASTA  ');
    %fprintf('\n %s ',' MFCC_Martin  ');
    %fprintf('\n %s ',' MFCC_RASTA_MVA  ');
    %fprintf('\n %s ',' GFCC_MFCC  ');
    %fprintf('\n %s ',' GFCC  ');
    %Methods.ft=input('feature extraction method name: ','s') ;
    %if isequal(Methods.ft,''),Methods.ft='MFCC'; end
    
    
    Methods.ftsel='Selection_MFCC_39';
    %fprintf('\n\n %s ',' feature selection method list  ');
    %fprintf('\n %s ',' Selection_MFCC_39  ');
    %fprintf('\n %s ',' Selection_MFCC_25  ');
    %fprintf('\n %s ',' Selection_GFCC  ');
    %fprintf('\n %s ',' Selection_MFCC_GFCC  ');
    %Methods.ftsel=input('feature selection method name: ','s') ;
    %if isequal(Methods.ftsel,''),Methods.ftsel='Selection_MFCC_25'; end
    
    Methods.lab='VAD';
    %fprintf('\n\n %s',' labeling method (voice discrimination) list ');
    %fprintf('\n %s ',' VAD  ');
    %fprintf('\n %s ',' pitch_lab  ');
    %Methods.lab=input('labeling method name: ','s') ;
    %if isequal(Methods.lab,''),Methods.lab='VAD'; end
    
    Methods.nor='t_norm_alize';
    %fprintf('\n\n %s ','  normalization method list');
    %fprintf('\n %s ',' t_norm_alize  ');
    %fprintf('\n %s ',' t_norm  ');
    %fprintf('\n %s\n ',' a_t_norm  ');
    %Methods.nor=input(' normalization method name: ','s') ;
    %if isequal(Methods.nor,''),Methods.nor='t_norm_alize'; end
    
    
    % Param.Flag=0;
    % if isequal(Methods.nor,'t_norm')
    %    Param.Flag = str2num(input('normalization flag: ','s')) ;
    %    % Flag==1 --> used all target and nontarget models as cohort models
    %    % Flag==0 --> used only  nontarget models as cohort models
    % end
    %
    % if isequal(Methods.nor,'a_t_norm')
    %    Param.MinNoCohortModel =str2num(input('minimum number of chort models: ','s')) ;
    % end
    %------------------------
    
    
    
    %------------------------
    Param.SegLen=0; Param.LapLen=0;
    disp(['test parameters:']);
    Param.SegLen=input('Input Segments"s length: [default:50]', 's');
    Param.SegLen = str2num(Param.SegLen);
    if isempty(Param.SegLen), Param.SegLen=50; end;
    Param.LapLen=input('Input Overlap of Segments: [default:25]', 's');
    Param.LapLen = str2num(Param.LapLen);
    if isempty(Param.LapLen), Param.LapLen=25; end;
    %------------------------
    
    
    %------------------------
    Param.NumGMM=0;
    numgmm=input('number of GMM? (defualt:512) ', 's'); Param.NumGMM = str2num(numgmm);
    if isempty(Param.NumGMM), Param.NumGMM=512; end;
    %------------------------
    kerneltype='2';
    if (OneVersusRest==1)
        disp('Do you want to train SVM with Linear or RBF kernel?,...');
        kerneltype=input('(1:Linear, 2:RBF [default:2]) ', 's');
        if (isempty(kerneltype)|| (kerneltype~='1' && kerneltype~='2'))
            kerneltype='2'; end;
    end
    %---
    c=32; g=0.125;
    if kerneltype=='1'
        c =input('input c for linear kernel [default:32]', 's');  c=str2num(c);
        if isempty(c), c=32; end;
    else
        c =input('input c for RBF kernel [default:32]', 's');  c=str2num(c);
        if isempty(c), c=32; end;
        g =input('input g for RBF kernel [default:0.125]', 's');  g=str2num(g);
        if isempty(g), g=0.125; end;
    end
    %---
    ny=200;
    ny=input('number of Variability Factors? (defualt:200) ', 's'); ny = str2num(ny);
    if isempty(ny), ny=200; end;
    %---
    NAPivector_Dim=0;
    Norm_ivector =input('Do you want to normalize ivectors:0/1 (1:yes,0:no,default:1)', 's'); Norm_ivector=str2num(Norm_ivector);
    if isempty(Norm_ivector), Norm_ivector=1; end;
    LDA_ivector =input('Do you want to apply LDA on ivectors:0/1 (1:yes,0:no,default:0)', 's');  LDA_ivector=str2num(LDA_ivector);
    if isempty(LDA_ivector), LDA_ivector=0; end;
    if (LDA_ivector==1)
        LDAdim=input('LDA dimention? ', 's'); LDAdim= str2num(LDAdim);
    end
    
    NAP_ivector =input('Do you want to apply NAP on ivectors:0/1 (1:yes,0:no,default:0)', 's');  NAP_ivector=str2num(NAP_ivector);
    if isempty(NAP_ivector), NAP_ivector=0; end;
    if (NAP_ivector==1)
        NAPivector_Dim=input('NAP dimention? (defualt:20) ', 's'); NAPivector_Dim = str2num(NAPivector_Dim);
        if isempty(NAPivector_Dim), NAPivector_Dim=20; end;
    end
    
    
    WCCN_ivector =input('Do you want to apply WCCN on ivectors:0/1 (1:yes,0:no,default:0)', 's'); WCCN_ivector=str2num(WCCN_ivector);
    if isempty(WCCN_ivector), WCCN_ivector=0; end;
    
    
    LDAmodel=[]; P_NAP=[]; B_WCCN=[];
    %----
    disp('ivector train method? 1/2');
    TrainMethod=input('1:for short amount of data (Fast), 2:for large amount of data(slow)', 's');
    TrainMethod=str2num(TrainMethod);
    if isempty(TrainMethod), TrainMethod=1; end;
    
    %------------------------------------Normalize Scores----------------------
    NormScrs_target =input('Normalize Scores(with target speakers)? :0/1 (1:yes,0:no,default:0)', 's');  NormScrs_target=str2num(NormScrs_target);
    if isempty(NormScrs_target), NormScrs_target=0; end;
    
    NormScrs =input('Normalize Scores(with nontarget speakers)? :0/1 (1:yes,0:no,default:0)', 's');  NormScrs=str2num(NormScrs);
    if isempty(NormScrs), NormScrs=0; end;
    
    if (NormScrs==1)
        Path.NormSpeak =input('Path of speakers for LLR or tnorm: ', 's');
        save( Path.stats, 'Methods', 'Path','Param');
    end
    %--------------------------------------------------------------------------
    
    
    
    %------------------------------ Artificial data for train  ----------------
    art_data =input('Do you want to use artificial data :0/1 (1:yes,0:no,default:0)', 's');  art_data=str2num(art_data);
    if isempty(art_data), art_data=0; end;
    %--------------------------------------------------------------------------
    
    
    
    %---- train method:
    disp('which train method?,');
    trainmethod=input('(3:SVM, 4:fast scoring  [default:4]) ', 's');
    if (isempty(trainmethod)|| (trainmethod~='3' && trainmethod~='4'))
        trainmethod='4'; end;
   %--------------------------------------------------------------------------
   
   
   
    RealTestData =input('Do you want to test on real data :0/1 (1:yes,0:no,default:0)', 's');  RealTestData=str2num(RealTestData);
    if isempty(RealTestData), RealTestData=0; end;
    
    
    Param.kerneltype=kerneltype;
    Param.c=c;
    Param.g=g;
    Param.ny=ny;
    Param.Norm_ivector=Norm_ivector;
    Param.NAPivector_Dim=NAPivector_Dim;
    Param.LDA_ivector=LDA_ivector;
    Param.NAP_ivector=NAP_ivector;
    Param.WCCN_ivector=WCCN_ivector;
    Param.LDAdim=LDAdim;
    Param.TrainMethod=TrainMethod;
    Param.NormScrs_target=NormScrs_target;
    Param.NormScrs=NormScrs;
    Param.art_data=art_data;
    Param.trainmethod=trainmethod;
    Param.RealTestData=RealTestData;
end


%------------------------
Path.stats =[Path.Prog,'\stats\'];
pathstates=Path.stats;
mkdir(Path.stats);
save( [pathstates,'\Methods'] ,'Methods');
save( [pathstates,'\Path'] ,'Path');
save( [pathstates,'\Param'] ,'Param');
%------------------------







