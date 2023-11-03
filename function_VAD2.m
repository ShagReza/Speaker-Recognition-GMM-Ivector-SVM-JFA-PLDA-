function function_VAD2(WaveFile,Pth_Wav,Pth_Labels)
%function function_VAD(WaveFile,Pth_Wav,Pth_Labels)


% lable file generation: this function call VAD.exe and generates lable
% file 

InputWaveFile   = [Pth_Wav,WaveFile,'.wav'];
OutputLabelFile = [Pth_Labels,WaveFile,'.lbl'];
 
MedFiltLen = 0;          %VAD.exe program's parammeter: median filter length
MinThr     = -1;         %VAD.exe program's parammeter: minimum thershold
InitThr    = -1;         %VAD.exe program's parammeter: maximum thershold
LowHighRat = 0;       %VAD.exe program's parammeter: high/low thershold
 
s_vad = ['VAD.exe ','"', InputWaveFile,'"',' ','"',OutputLabelFile,'"',' ',num2str(MedFiltLen),' ',num2str(MinThr),' ',num2str(InitThr),'   0  SNR.txt, ',num2str(LowHighRat) ];
dos(s_vad);
 
