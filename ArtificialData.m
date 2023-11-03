
%----------------------------------------------
function ArtificialData(pathstates,AmbePath)

load(pathstates);
mkdir([Path.Prog,'\ArtificialWaves']);
LanFolders=dir(Path.TargetSpeakers_Train);
NL=length(LanFolders)-2;
for nl = 1:NL
    LAN  = char(LanFolders(nl+2).name); % language nl
    mkdir([Path.Prog,'\ArtificialWaves\',LAN]);
    PathWaves  = dir([Path.TargetSpeakers_Train,'\',LAN, '\*.wav']);
    NumOfTest(nl) = length(PathWaves); % number of wave files in language nl folder
    for nt = 1:NumOfTest(nl)
        TestPath = [Path.TargetSpeakers_Train,'\',LAN, '\',PathWaves(nt,1).name];
        TestName    = [Path.Prog,'\ArtificialWaves\',LAN,'\',PathWaves(nt,1).name];
        copyfile(TestPath,TestName);
        
        %TestPath_AMBE=[AmbePath,'\',LAN,'\',PathWaves(nt,1).name];
        %TestName_AMBE = [Path.Prog,'\ArtificialWaves\',LAN,'\AMBE_',PathWaves(nt,1).name];
        %copyfile(TestPath_AMBE,TestName_AMBE);
        
        TestName_Fix = [Path.Prog,'\ArtificialWaves\',LAN,'\Fix_',PathWaves(nt,1).name];
        FANT ( TestPath,TestName_Fix ,'irs');
        
        TestName_Voip = [Path.Prog,'\ArtificialWaves\',LAN,'\Voip_',PathWaves(nt,1).name];
        G729_Annex_Cp_time_enc_dec ( TestPath ,TestName_Voip , '0' );
        
        TestName_GSM = [Path.Prog,'\ArtificialWaves\',LAN,'\GSM_',PathWaves(nt,1).name];
        GSM_AMR_Encode_Decode_suffix_amr_time_enc_dec ( TestPath, TestName_GSM, 'MR475' );   
    end
end
Path.TargetSpeakers_Train=[Path.Prog,'\ArtificialWaves'];
%save(pathstates);
save( Path.stats, 'Methods', 'Path','Param');
