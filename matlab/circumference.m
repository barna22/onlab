clear all;
load data.mat;
data1 = p1(1).d(:,1);
wname = 'db4';
level = 10;
fs= 2048;
t = 0:length(data1)-1 / fs;
highfreqlevel = 1;

%% calculate window length
c = 2 * 3.14 * 0.92 / 2;
speed = 70 / 3.6;
wtime = c / speed;
wsamples = round(round(fs * wtime) / power(2, highfreqlevel));

%%
for level = 2:10
    [c, l] = wavedec(data1, level, wname);
    lvl_a = c(1:l(1));
    lvl_d = c(l(1)+1:2*l(1));
    inverse{level} = idwt(lvl_a, lvl_d, wname);
end

%% reconstruct, add, and find peaks
dec = decimate(inverse{7}, 2);
sum1 = inverse{8}(1:size(dec)) + dec;
[peaks, idx] = findpeaks(sum1);

%% threshold
j = 1;
threshold = 20;
for i = 1:length(peaks)
    if peaks(i) > threshold
        passby_reconst(j) = idx(i);
        j = j+1;
    end
end

%% calculate pass-by indexes in original signal
l = 1;
for k = 1:length(passby_reconst)
    passby_original(l) = round(length(data1) * (passby_reconst(k) / length(sum1)));
    l = l+1;
end

%% mask the first-level transform
masked = zeros(1, length(inverse{highfreqlevel + 1}));
epsilon = wsamples;
for m = 1:length(passby_reconst)
    peak_idx = round(length(inverse{highfreqlevel + 1}) * (passby_reconst(m) / length(sum1)));
    masked(peak_idx-epsilon:peak_idx+epsilon) = inverse{highfreqlevel + 1}(peak_idx-epsilon:peak_idx+epsilon);
    windowed_rms(m) = rms(masked(peak_idx-epsilon:peak_idx+epsilon));
end

%%
figure('Name','masked')
plot(masked)

figure()
plot(data1)

figure()
plot(windowed_rms)
