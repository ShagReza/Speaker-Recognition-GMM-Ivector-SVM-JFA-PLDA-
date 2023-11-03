function FANT ( InputFile , OutputFile , FilterType )
% FilterType : 'irs' , 'mirs' , 'g712' , 'p341'

% FANT ( 'MM73.wav' , 'MM73-irs.wav'  , 'irs'  );
% FANT ( 'MM73.wav' , 'MM73-mirs.wav' , 'mirs' );

% The Sampling Rate of Input File Must Be 8 kHz

[xx,Fs,NBits]=wavread(InputFile);

xx = resample ( xx , 8000 , Fs );
Fs = 8000 ;

fprintf(1,'\n Length of  %s  is  %f  seconds\n',InputFile,length(xx)/Fs); 

% Converting '.wav' file to a 16-bit '.raw' file
fid = fopen ( 'Temp-in.raw' , 'wb' );
fwrite(fid,32768*xx,'int16');
fclose(fid);

% Creating List Files
fid = fopen ( 'in.list' , 'w' );
fprintf ( fid , 'Temp-in.raw\n' );
fclose(fid);
fid = fopen ( 'out.list' , 'w' );
fprintf ( fid , 'Temp-out.raw\n' );
fclose(fid);

%%%%%%%%%%%%%%
%  FANT      %
%%%%%%%%%%%%%%
str1 = [ 'filter_add_noise.exe  -i in.list  -o out.list  -f ' FilterType ];

dos ( str1);

% Converting 16-bit '.raw' file to a '.raw' file

fid = fopen ('Temp-out.raw','rb');
yy = fread(fid,'int16');
fclose(fid);
wavwrite ( yy/32768, Fs, NBits, OutputFile );
