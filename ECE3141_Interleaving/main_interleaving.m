%% ECE3141 PROJECT, Xiaofan Hua - 33809852, Malik Hassaan Khan- 33636729 
% Interleaving project - 

clc ; clear ; close all ; 

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
fprintf('--- Non-Interleaved ---\n BER = %.4f, Errors = %d\n', ber, numErrors);

%% Block Interleaving applied to data - 

% Apply the hamming code - (ECC)

codeword_interleave = encode(data,7,4,'hamming') ;
%debug statement - 
fprintf("%d\n", length(codeword_interleave)) ; 

%Apply block interleaving - 

rows1 = 350 ; 
cols1 = 5 ; 
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

% Display result
fprintf('--- Block Interleaved ---\n BER = %.4f, Errors = %d\n', block_ber, block_numErrors);

%% Convolutional Interleaving applied to data - 

% Apply the hamming code - (ECC)

conv_encode= encode(data,7,4,'hamming') ;

%Apply block interleaving - 

nrows = 5; % Use 5 shift registers
slope = 8; % Delays are 0, 3, 6, 9, and 12.
conv_interleave = convintrlv(conv_encode,nrows,slope);

%Intentionally corrupt bits - 

conv_error_interleave = burst_error(conv_interleave, burst_length, burst_freq) ;

%De-interleave - 

conv_deinterleave = convdeintrlv(conv_error_interleave,nrows,slope) ;

%Decode ECC - 
conv_received_interleave = decode(conv_deinterleave, 7, 4, 'hamming') ; 

% Calculate BER - 

[conv_ber, conv_numErrors] = compute_ber(data,conv_received_interleave);

% Display result
fprintf('--- Convolutional Interleaved ---\n BER = %.4f, Errors = %d\n', conv_ber, conv_numErrors);