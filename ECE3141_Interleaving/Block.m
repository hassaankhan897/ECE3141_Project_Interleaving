%% Block Interleaving applied to data - 
clear all;
% Apply the hamming code - (ECC)
N= 12 ; 
data = [1:N]
rows1 = 4 ; 
cols1 = 3 ; 
block_interleave = matintrlv(data,rows1,cols1)
block_deinterleave = matdeintrlv(block_interleave, rows1,cols1)