%% Convolutional Interleaving applied to data - 
clear all;
% Apply the hamming code - (ECC)
N= 10 ; 
data = [1:N]
nrows = 3; % Use 5 shift registers
slope = 1; % Delays are 0, 3, 6, 9, and 12
delay=nrows*(nrows-1)*slope;  
padded = [data, zeros(1, delay) ]
conv_interleave = convintrlv(data,nrows,slope)

conv_deinterleave = convdeintrlv(conv_interleave,nrows,slope) 
