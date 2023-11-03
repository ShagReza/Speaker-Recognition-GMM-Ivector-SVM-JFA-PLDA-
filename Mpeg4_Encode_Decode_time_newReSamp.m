function Mpeg4_Encode_Decode_time ( InputFile , OutputFile , BitRate )

% ReSampling

tic

% The input file for 'wavResample.exe' must not be open (for Read or Write)
Str1 = [ 'ssrc.exe  --rate 44100 ' InputFile ' .\Temp.wav' ]
dos ( Str1 );

%pause(0.1);

Str1 = [ 'enhAacPlusEnc_mono_wo_PrFr.exe   .\Temp.wav  .\Temp.3gp ' BitRate '  m' ]
dos ( Str1 );

toc

%pause(0.1);

tic

Str1 = [ 'enhAacPlusDec_mono_wo_PrFr.exe   .\Temp.3gp  .\Temp1.wav  m08' ]
dos ( Str1 );

%pause(0.1);

[x,Fs,NBit] = wavread ( '.\Temp1.wav' );

Idx = 0.094 * Fs ;

x1 = [ x(Idx+1:end,1); zeros(Idx,1); ];

wavwrite ( x1 , Fs , NBit , OutputFile );
%wavwrite ( x(:,1) , Fs , NBit , OutputFile );

fprintf(1,'\n Length of  %s  is  %f  seconds\n',InputFile,length(x)/Fs); 

toc

Str1 = [ 'del   .\Temp.wav' ];
dos ( Str1 );
Str1 = [ 'del   .\Temp1.wav' ];
dos ( Str1 );
Str1 = [ 'del   .\Temp.3gp' ];
%dos ( Str1 );
