function function_pitch_lab(WaveFile,Pth_Wav,Pth_Labels)

% lable file generation by using signal pitch
% this function call ExtAdvFrontEnd.exe  (Advanced front end feature extraction for calculating signsal frame's pitch)
Fs_new=8000;

InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
OutputLabelFile = [Pth_Labels,WaveFile,'.lbl'];
MFCCFeatFile    = [Pth_Labels,WaveFile,'.mfcc0'];
PitchFeatFile   = [Pth_Labels,WaveFile,'.pitch'];
ClassFeatFile   = [Pth_Labels,WaveFile,'.class'];

%AFA-ETSI
%feature extraction
str=['ExtAdvFrontEnd.exe ' InputWaveFile ' ' MFCCFeatFile '  ' PitchFeatFile '  ' ClassFeatFile ' -F RAW -nologE -skip_header_bytes 44'];
dos(str);

fid=fopen(PitchFeatFile,'rb');
Pitch=fread(fid,'float');
fclose(fid);

delete(MFCCFeatFile);
delete(PitchFeatFile);
delete(ClassFeatFile);

%labeling pahse ...
% 
L=length(Pitch);
for ii=1:L,
    if Pitch(ii)>eps
        Pitch(ii)=Fs_new/Pitch(ii);
    end
end
Win=0; %  Length of Win.
PitchMed = zeros(L,1);
fid_vad = fopen(OutputLabelFile,'w'); % label file generation
tempstart=0;
FlagVad=0;

% Threshold 
MinNumofFram =  7;  % the minimum number of frame in each voiced tag segment 
FrameDuration =0.01;
MinSegDuration = MinNumofFram*FrameDuration;


for ii=1:L,
    Beg = ii - Win ;
    End = ii + Win ;
    if ii < (Win+1),
        Beg = 1 ;
    end
    if ii > (L-Win),
        End = L ;
    end
    PitchMed(ii)=median(Pitch(Beg:End)); % Median Filter

    if ii>1
        if PitchMed(ii)>FrameDuration
            if PitchMed(ii-1)<FrameDuration
                tempstart=(ii-1)*FrameDuration;
                FlagVad=1;
            end
        end
        if PitchMed(ii)<FrameDuration
            if PitchMed(ii-1)>FrameDuration
                tempend=(ii-1)*FrameDuration;
                if tempend>(tempstart+MinSegDuration)
                    fprintf(fid_vad,'%f\t',tempstart);
                    fprintf(fid_vad,'%f\t%s\n',tempend, 'voice');
                end
                FlagVad=0;
            end
        end
    end
end;
fclose(fid_vad);

