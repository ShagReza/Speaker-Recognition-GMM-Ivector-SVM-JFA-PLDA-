function GSM_AMR_Encode_Decode_suffix_amr_time_enc_dec ( InputFile , OutputFile , CompressionRate )

[xx,Fs,NBits]=wavread(InputFile);

fprintf(1,'\n Length of  %s  is  %f  seconds\n',InputFile,length(xx)/Fs); 

fid = fopen ( 'Temp-1.raw' , 'wb' );
fwrite(fid,32768*xx,'int16');
fclose(fid);

tic

%%%%%%%%%%%%%%
%  Encoding  %
%%%%%%%%%%%%%%
str1 = [ 'Encoder.exe ' CompressionRate ' Temp-1.raw BitStream.amr' ];

dos ( str1);

fprintf ( 1 , '\n\nEncoding\n' );
fprintf ( 1 , '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n' );
toc
fprintf ( 1 , '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< \n\n' );

%%%%%%%%%%%%%%
%  Decoding  %
%%%%%%%%%%%%%%

tic

str2 = [ 'Decoder.exe BitStream.amr Temp-2.raw' ];

dos ( str2);

fprintf ( 1 , '\n\nDecoding\n' );
fprintf ( 1 , '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n' );
toc
fprintf ( 1 , '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< \n\n' );

fid = fopen ('Temp-2.raw','rb');
yy = fread(fid,'int16');
fclose(fid);
wavwrite ( yy/32768, Fs, NBits, OutputFile );
