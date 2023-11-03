function G729_Annex_Cp_time_enc_dec ( InputFile , OutputFile , CompressionRate )

[xx,Fs,NBits]=wavread(InputFile);

fprintf(1,'\n Length of  %s  is  %f  seconds\n',InputFile,length(xx)/Fs); 

fid = fopen ( 'Temp-1.raw' , 'wb' );
fwrite(fid,32768*xx,'int16');
fclose(fid);

tic

%%%%%%%%%%%%%%
%  Encoding  %
%%%%%%%%%%%%%%
str1 = [ 'codercp_wo_PrntFr.exe  Temp-1.raw  BitStream.g729  0  ' CompressionRate];

fprintf ( 1 , '\n\nEncoding .......\n\n' );

dos ( str1);

fprintf ( 1 , '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n' );
toc
fprintf ( 1 , '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< \n\n' );

%%%%%%%%%%%%%%
%  Decoding  %
%%%%%%%%%%%%%%

tic

str2 = [ 'decodcp_wo_PrntFr.exe  BitStream.g729  Temp-2.raw' ];

fprintf ( 1 , '\n\nDecoding .......\n\n' );

dos ( str2);

fprintf ( 1 , '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n' );
toc
fprintf ( 1 , '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< \n\n' );

fid = fopen ('Temp-2.raw','rb');
yy = fread(fid,'int16');
fclose(fid);
wavwrite ( yy/32768, Fs, NBits, OutputFile );
