%Convolutional interleaving implemented with padding - 
%CORRECT VERSION - 

% ----- parameters -----
nrows  = 5;
slope  = 12;
Dpair  = nrows*(nrows-1)*slope;           % 240 symbols

% ----- encode -----
conv_encode = encode(data,7,4,'hamming'); % length = 1750 for N=1000

% ----- PRIME by appending zeros (flush later) -----
padded_in   = [conv_encode , zeros(1,Dpair)];

% ----- interleave -----
tx_intlv    = convintrlv(padded_in, nrows, slope);

% ----- channel -----
rx_corrupt  = burst_error(tx_intlv, burst_length, burst_freq);

% ----- de‑interleave -----
rx_deintlv  = convdeintrlv(rx_corrupt, nrows, slope);

% ----- FLUSH the first Dpair symbols -----
useful_bits = rx_deintlv(Dpair+1 : Dpair+length(conv_encode));

% quick sanity – should print 15 (your 3 bursts × 5 bits)
disp("raw errors inside codewords = " + ...
     sum(useful_bits ~= conv_encode))

% ----- decode and BER -----
decoded_bits = decode(useful_bits, 7, 4, 'hamming');
[ber, errs]  = compute_ber(data, decoded_bits(1:N));
fprintf('Conv‑intlv BER = %.4e  (errors = %d)\n', ber, errs);
