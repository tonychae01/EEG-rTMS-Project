%% Extract PSD Features
function [channels_psd_right, channels_psd_left] = get_psd(run)
    fs = 512;
    nfft = 256;
    window_len = nfft/2;
    overlap = window_len/2;
    frequency_low = 4;
    frequency_high = 30;
    channels_psd_right = [];
    channels_psd_left = [];

    t = run.header.triggers.TYP;
    p = run.header.triggers.POS;
    idx = find(t == 1000);
    ide = find(t == 32766);
    trial_psd_right = [];
    trial_psd_left = [];
    for k = 1:length(idx)-1
        %test = run_psd_eeg(p(idx(k)):p(idx(k+1)));
        ts = t(idx(k):idx(k+1));
        isRight = any(ts == 7691);
        if isRight,
            trial_psd_right = [];
            for j = 1:64
                eeg = (run.eeg.data)';
                eeg = eeg(:,j);
                eeg = eeg(p(idx(k)):p(idx(k+1)));
                [pxx, f] = pwelch(eeg, window_len, overlap, nfft, fs);
                id = find(f >= frequency_low & f <= frequency_high);
                pxx = pxx(id);
                trial_psd_right= [trial_psd_right;pxx];
            end
            channels_psd_right = [channels_psd_right, trial_psd_right];
        else
             trial_psd_left = [];
            for j = 1:64
                eeg = (run.eeg.data)';
                eeg = eeg(:,j);
                eeg = eeg(p(idx(k)):p(idx(k+1)));
                [pxx, f] = pwelch(eeg, window_len, overlap, nfft, fs);
                id = find(f >= frequency_low & f <= frequency_high);
                pxx = pxx(id);
                trial_psd_left= [trial_psd_left;pxx];
            end
            channels_psd_left = [channels_psd_left, trial_psd_left];
        end
    end
    ts = t(idx(end):ide(1));
    isRight = any(ts == 7691);
    if isRight,
        trial_psd_right = [];
        for j = 1:64
            eeg = (run.eeg.data)';
            eeg = eeg(:,j);
            eeg = eeg(p(idx(k)):p(idx(k+1)));
            [pxx, f] = pwelch(eeg, window_len, overlap, nfft, fs);
            id = find(f >= frequency_low & f <= frequency_high);
            pxx = pxx(id);
            trial_psd_right= [trial_psd_right;pxx];
        end
        channels_psd_left = [channels_psd_left, trial_psd_left];
    else
        trial_psd_left = [];
        for j = 1:64
            eeg = (run.eeg.data)';
            eeg = eeg(:,j);
            eeg = eeg(p(idx(k)):p(idx(k+1)));
            [pxx, f] = pwelch(eeg, window_len, overlap, nfft, fs);
            id = find(f >= frequency_low & f <= frequency_high);
            pxx = pxx(id);
            trial_psd_left= [trial_psd_left;pxx];
        end
        channels_psd_left = [channels_psd_left, trial_psd_left];
    end

end

subj1_psd = struct;

subj1_psd.session(1) = struct;
subj1_psd.session(2) = struct;
subj1_psd.session(3) = struct;

subj1_psd.session(1).run(1) = struct;
subj1_psd.session(1).run(2) = struct;
subj1_psd.session(1).run(3) = struct;
subj1_psd.session(1).run(4) = struct;
subj1_psd.session(2).run(1) = struct;
subj1_psd.session(2).run(2) = struct;
subj1_psd.session(2).run(3) = struct;
subj1_psd.session(3).run(1) = struct;
subj1_psd.session(3).run(2) = struct;
subj1_psd.session(3).run(3) = struct;

[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(1).run(1));
subj1_psd.session(1).run(1).rest_psd = channels_psd_right;
subj1_psd.session(1).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(1).run(2));
subj1_psd.session(1).run(2).rest_psd = channels_psd_right;
subj1_psd.session(1).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(1).run(3));
subj1_psd.session(1).run(3).rest_psd = channels_psd_right;
subj1_psd.session(1).run(3).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(1).run(4));
subj1_psd.session(1).run(4).rest_psd = channels_psd_right;
subj1_psd.session(1).run(4).move_psd = channels_psd_left;

[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(2).run(1));
subj1_psd.session(2).run(1).rest_psd = channels_psd_right;
subj1_psd.session(2).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(2).run(2));
subj1_psd.session(2).run(2).rest_psd = channels_psd_right;
subj1_psd.session(2).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(2).run(3));
subj1_psd.session(2).run(3).rest_psd = channels_psd_right;
subj1_psd.session(2).run(3).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(3).run(1));
subj1_psd.session(3).run(1).rest_psd = channels_psd_right;
subj1_psd.session(3).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(3).run(2));
subj1_psd.session(3).run(2).rest_psd = channels_psd_right;
subj1_psd.session(3).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj1.online.session(3).run(3));
subj1_psd.session(3).run(3).rest_psd = channels_psd_right;
subj1_psd.session(3).run(3).move_psd = channels_psd_left;

subj2_psd = struct;

subj2_psd.session(1) = struct;
subj2_psd.session(2) = struct;
subj2_psd.session(3) = struct;

subj2_psd.session(1).run(1) = struct;
subj2_psd.session(1).run(2) = struct;
subj2_psd.session(1).run(3) = struct;
subj2_psd.session(1).run(4) = struct;
subj2_psd.session(2).run(1) = struct;
subj2_psd.session(2).run(2) = struct;
subj2_psd.session(2).run(3) = struct;
subj2_psd.session(3).run(1) = struct;
subj2_psd.session(3).run(2) = struct;
subj2_psd.session(3).run(3) = struct;

[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(1).run(1));
subj2_psd.session(1).run(1).rest_psd = channels_psd_right;
subj2_psd.session(1).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(1).run(2));
subj2_psd.session(1).run(2).rest_psd = channels_psd_right;
subj2_psd.session(1).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(1).run(3));
subj2_psd.session(1).run(3).rest_psd = channels_psd_right;
subj2_psd.session(1).run(3).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(1).run(4));
subj2_psd.session(1).run(4).rest_psd = channels_psd_right;
subj2_psd.session(1).run(4).move_psd = channels_psd_left;

[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(2).run(1));
subj2_psd.session(2).run(1).rest_psd = channels_psd_right;
subj2_psd.session(2).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(2).run(2));
subj2_psd.session(2).run(2).rest_psd = channels_psd_right;
subj2_psd.session(2).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(2).run(3));
subj2_psd.session(2).run(3).rest_psd = channels_psd_right;
subj2_psd.session(2).run(3).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(3).run(1));
subj2_psd.session(3).run(1).rest_psd = channels_psd_right;
subj2_psd.session(3).run(1).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(3).run(2));
subj2_psd.session(3).run(2).rest_psd = channels_psd_right;
subj2_psd.session(3).run(2).move_psd = channels_psd_left;
[channels_psd_right, channels_psd_left] = get_psd(subj2.online.session(3).run(3));
subj2_psd.session(3).run(3).rest_psd = channels_psd_right;
subj2_psd.session(3).run(3).move_psd = channels_psd_left;

%% Compute Fisher Score
function score = compute_fisher_score(class1, class2)
    score = abs(mean(class1) - mean(class2))/sqrt(std(class1)*std(class1) + std(class2)*std(class2));
end

subj1_fisher = zeros(448,1);
for i = 1:448
    class1 = [];
    class2 = [];
    for j = 1:3
        for k = 1:length(subj1_psd.session(j).run)
            class1 = [class1;subj1_psd.session(j).run(k).rest_psd(i, :)'];
            class2 = [class2;subj1_psd.session(j).run(k).move_psd(i, :)'];
        end
    end
    subj1_fisher(i) = compute_fisher_score(class1, class2);
end

subj2_fisher = zeros(448,1);
for i = 1:448
    class1 = [];
    class2 = [];
    for j = 1:3
        for k = 1:length(subj2_psd.session(j).run)
            class1 = [class1;subj2_psd.session(j).run(k).rest_psd(i,:)'];
            class2 = [class2;subj2_psd.session(j).run(k).move_psd(i,:)'];
        end
    end
    subj2_fisher(i) = compute_fisher_score(class1, class2);
end

[subj1_top10, indices1] = maxk(subj1_fisher, 10);
[subj2_top10, indices2] = maxk(subj2_fisher, 10);

%% Sum the Fisher Score by Channel (64 channels)

function sum_scores = compute_sum_score_per_channel_per_session(session_scores)
    sum_scores = [];
    for j = 1:64
        scores = session_scores(j*14-13:j*14);
        sum_scores = [sum_scores;sum(scores)];
    end
end

subj1_sum_fisher = struct;

for j = 1:3
    scores_per_session = [];
    for i = 1:896
        class1 = [];
        class2 = [];
        for k = 1:length(subj1_psd.session(j).run)
            class1 = [class1;subj1_psd.session(j).run(k).rest_psd(i,:)'];
            class2 = [class2;subj1_psd.session(j).run(k).move_psd(i,:)'];
        end
        fisher = compute_fisher_score(class1, class2);
        scores_per_session = [scores_per_session; fisher];
    end
    subj1_sum_fisher.session(j).session_scores = scores_per_session;
end

for j = 1:3
    session_scores = subj1_sum_fisher.session(j).session_scores;
    sum_scores = compute_sum_score_per_channel_per_session(session_scores);
    subj1_sum_fisher.session(j).sum_scores = sum_scores;
end

subj2_sum_fisher = struct;

for j = 1:3
    scores_per_session = [];
    for i = 1:896
        class1 = [];
        class2 = [];
        for k = 1:length(subj2_psd.session(j).run)
            class1 = [class1;subj2_psd.session(j).run(k).rest_psd(i,:)'];
            class2 = [class2;subj2_psd.session(j).run(k).move_psd(i,:)'];
        end
        fisher = compute_fisher_score(class1, class2);
        scores_per_session = [scores_per_session; fisher];
    end
    subj2_sum_fisher.session(j).session_scores = scores_per_session;
end

for j = 1:3
    session_scores = subj2_sum_fisher.session(j).session_scores;
    sum_scores = compute_sum_score_per_channel_per_session(session_scores);
    subj2_sum_fisher.session(j).sum_scores = sum_scores;
end

%% Plot Topoplots

load('chanlocs64.mat');

figure('units','normalized','Position',[0.1,0.1,0.7,0.4]);
subplot(1,3,1)
topoplot(subj1_sum_fisher.session(1).sum_scores, chanlocs);
title("subject 1 - online session topoplot - 1");
subplot(1,3,2)
topoplot(subj1_sum_fisher.session(2).sum_scores, chanlocs);
title("subject 1 - online session topoplot - 2.1");
subplot(1,3,3)
topoplot(subj1_sum_fisher.session(3).sum_scores, chanlocs);
title("subject 1 - online session topoplot - 2.2");
colorbar;

figure('units','normalized','Position',[0.1,0.1,0.7,0.4]);
subplot(1,3,1)
topoplot(subj2_sum_fisher.session(1).sum_scores, chanlocs);
title("subject 2 - online session topoplot - 1");
subplot(1,3,2)
topoplot(subj2_sum_fisher.session(2).sum_scores, chanlocs);
title("subject 2 - online session topoplot - 2.1");
subplot(1,3,3)
topoplot(subj2_sum_fisher.session(3).sum_scores, chanlocs);
title("subject 2 - online session topoplot - 2.2");
colorbar;
