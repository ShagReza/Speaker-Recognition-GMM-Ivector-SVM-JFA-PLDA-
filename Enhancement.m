function Enhancement (new,Enh)
SegmentsPath   = dir([new,'\Waves\*.wav']);
for b1=1:length(SegmentsPath)
    speech=[new,'\Waves\',SegmentsPath(b1).name];
    speechEnhaned=[new,'\EnhancedWaves\',SegmentsPath(b1).name];
    if Enh==0
        copyfile(speech,speechEnhaned);
    else
        s=['TestDenoise-8k-with-Header-wo-Delay.exe ', speech,' ',  speechEnhaned];
        dos(s);
    end
end