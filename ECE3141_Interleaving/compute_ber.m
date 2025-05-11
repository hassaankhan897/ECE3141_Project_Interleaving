%% ECE3141 PROJECT, Xiaofan Hua - 33809852, Malik Hassaan Khan- 33636729 
% Interleaving project, Error rate compute - 
%Adapted from Lab 6, ECE3141 - 

function [BER, NumErrors] = compute_ber(original_bits, received_bits)
    Erroredbit_array = mod(original_bits + received_bits, 2);
    NumErrors = sum(Erroredbit_array);
    BER = NumErrors / length(original_bits);
end 

