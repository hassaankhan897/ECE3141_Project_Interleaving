%% ECE3141 PROJECT, Xiaofan Hua - 33809852, Malik Hassaan Khan- 33636729 
% Interleaving project - 



%Generate block of data - 
N= 1000 ; 
data = randi([0 1], 1, N);
burst_freq = 3 ; 
burst_length = 5 ; 

%% Non-interleaved block of data - 
 
% Apply the hamming code - (ECC) 

codeword = encode(data,7,4,'hamming') ; 

%Intentionally corrupt bits - 

corrupted_codeword = burst_error(codeword, burst_length, burst_freq) ;

%Decode ECC - 
received_codeword = decode(corrupted_codeword, 7, 4, 'hamming') ; 

% Calculate BER - 

received_trimmed = received_codeword(1:N);

[ber, numErrors] = compute_ber(data, received_trimmed);

% Display result
fprintf('--- Non-Interleaved, Burst Length = %d ---\n BER = %.4f, Errors = %d\n', burst_length, ber, numErrors);

%% Block Interleaving applied to data - 

% Apply the hamming code - (ECC)

codeword_interleave = encode(data,7,4,'hamming') ;
%debug statement - 
fprintf("%d\n", length(codeword_interleave)) ; 

%Apply block interleaving - 

rows1 = 70 ; 
cols1 = 25 ; 
block_interleave = matintrlv(codeword_interleave,rows1,cols1) ; 

%Intentionally corrupt bits - 

error_interleave = burst_error(block_interleave, burst_length, burst_freq) ;

%De-interleave - 

block_deinterleave = matdeintrlv(error_interleave, rows1,cols1) ; 

%Decode ECC - 
received_deinterleave = decode(block_deinterleave, 7, 4, 'hamming') ; 

%Calculate BER - 
block_received_trimmed = received_deinterleave(1:N);
[block_ber, block_numErrors] = compute_ber(data, block_received_trimmed);
figure
plot(1:1000,data-block_received_trimmed,"o")
string=sprintf(" Block interleaving : Bit error rate is %.4f",block_ber);
title(string)
% Display result
fprintf('--- Block Interleaved, Burst Depth = %d ---\n BER = %.4f, Errors = %d\n',cols1, block_ber, block_numErrors);

%% Convolutional Interleaving applied to data - 

% Apply the hamming code - (ECC)

conv_encode= encode(data,7,4,'hamming') ;

%Apply block interleaving - 

nrows = 5; % Use 5 shift registers
slope = 3; % Delays are 0, 3, 6, 9, and 12
delay=nrows*(nrows-1)*slope;  
padded = [ conv_encode, zeros(1, delay) ];
conv_interleave = convintrlv(padded,nrows,slope);

%Intentionally corrupt bits - 

conv_error_interleave = burst_error(conv_interleave, burst_length, burst_freq) ;

%De-interleave - 

conv_deinterleave = convdeintrlv(conv_error_interleave,nrows,slope) ;

conv_deinterleave = conv_deinterleave(delay+1 : delay+length(conv_encode));
%Decode ECC - 
conv_received_interleave = decode(conv_deinterleave, 7, 4, 'hamming') ; 

% Calculate BER - 

[conv_ber, conv_numErrors] = compute_ber(data,conv_received_interleave);
figure
plot(1:1000,data-conv_received_interleave,"o")
string=sprintf("Convolutional Interleaving - Bit error rate is %.4f",conv_ber);
title(string)
% Display result
fprintf('--- Convolutional Interleaved, Burst Length = %.4f ---\n BER = %.4f, Errors = %d\n', burst_length, conv_ber, conv_numErrors);
