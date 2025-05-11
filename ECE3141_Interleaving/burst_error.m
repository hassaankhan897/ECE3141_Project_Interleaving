%% ECE3141 PROJECT - Burst Error Insertion Function
% Malik Hassaan Khan - 33636729, Xiaofan Hua - 33809852

function [errored_array] = burst_error(original_bits, burst_length, burst_freq)
        
    errored_array = original_bits;
    total_len = length(original_bits);

    for j = 1:burst_freq
        %Out of bounds error checking - 
        max_start= total_len - burst_length + 1;
        if max_start < 1
            printf("Burst length is too large for the input size.\n");
            return;
        end
        
        %Choose a random location for the error to be placed - 
        start = randi([1, max_start]);

        %Inserting the burst errors - 
        for i = start : start + burst_length - 1
            errored_array(i) = ~errored_array(i);
        end
    end
end
