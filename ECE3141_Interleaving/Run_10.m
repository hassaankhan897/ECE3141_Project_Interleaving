clc; clear; close all;

N = 1000;
burst_freq   = 3;
burst_length = 5;
ntrials      = 10;

% pre-allocate
ber_no   = zeros(1,ntrials);
ber_blk  = zeros(1,ntrials);
ber_conv = zeros(1,ntrials);

% interleaver params
rows1 = 350; cols1 = 5;
nrows = 5;   slope = 3;
delay = nrows*(nrows-1)*slope;

for t = 1:ntrials
    %--------------- common data ----------------%
    data = randi([0 1],1,N);
    
    %% 1) Non-interleaved
    cw = encode(data,7,4,'hamming');
    cw_cor = burst_error(cw, burst_length, burst_freq);
    rcw    = decode(cw_cor,7,4,'hamming');
    rcw    = rcw(1:N);
    [ber_no(t), ~] = compute_ber(data, rcw);

    %% 2) Block-interleaved
    cw_i = encode(data,7,4,'hamming');
    bi   = matintrlv(cw_i, rows1, cols1);
    bi_cor = burst_error(bi, burst_length, burst_freq);
    bdi    = matdeintrlv(bi_cor, rows1, cols1);
    rbi    = decode(bdi,7,4,'hamming');
    rbi    = rbi(1:N);
    [ber_blk(t), ~] = compute_ber(data, rbi);

    %% 3) Convolutional-interleaved
    ccw = encode(data,7,4,'hamming');
    padded = [ccw, zeros(1,delay)];
    ci     = convintrlv(padded, nrows, slope);
    ci_cor = burst_error(ci, burst_length, burst_freq);
    cdi    = convdeintrlv(ci_cor, nrows, slope);
    cdi    = cdi(delay+1 : delay+length(ccw));
    rci    = decode(cdi,7,4,'hamming');
    [ber_conv(t), ~] = compute_ber(data, rci);
end

% display mean ± std
fprintf('Non-interleaved:        mean BER = %.4e ± %.4e\n', mean(ber_no),  std(ber_no));
fprintf('Block-interleaved:      mean BER = %.4e ± %.4e\n', mean(ber_blk), std(ber_blk));
fprintf('Convolutional-interleaved: mean BER = %.4e ± %.4e\n', mean(ber_conv), std(ber_conv));

% bar-plot the 10 trials
figure;
bar([ber_no; ber_blk; ber_conv]', 'grouped');
xlabel('Trial');
ylabel('Bit-Error Rate');
legend('None','Block','Conv','Location','Best');
title(sprintf('BER over %d Trials', ntrials));
grid on;
