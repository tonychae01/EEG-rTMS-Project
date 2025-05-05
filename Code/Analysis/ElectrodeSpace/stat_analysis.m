%% stat_analysis get the fisher score per session (use mean of each EEG channel features(14-->1) ) 
% 64 points per session 1,2,3
% we have selected 38 channel of SMR base electrodes 

%% Sensorimotor Indices (from 1–64 chanloc list) - we use 
sensorimotor_idx = [ ...
    4,5,6,7,8,...        % F7,F3,Fz,F4,F8
    9,10,11,12,...       % FC5,FC1,FC2,FC6
    15,16,17,...         % C3,Cz,C4
    20,21,22,23,...      % CP5,CP1,CP2,CP6
    24,25,26,27,28,...   % P7,P3,Pz,P4,P8
    37,38,39,40,...      % F5,F1,F2,F6
    41,42,43,...         % FC3,FCz,FC4
    44,45,46,47,...      % C5,C1,C2,C6
    48,49,50,51,52,53    % CP3,CP4,P5,P1,P2,P6
];

%% All‑Channel Fisher Summary
for i = 1:3
    % Subject 1
    F1_all = subject_1.fisher_score{i};       % 14×64
    subject_1.all_mean_fisher(i) = mean(F1_all(:));
    subject_1.all_med_fisher(i)  = median(F1_all(:));
    
    % Subject 2
    F2_all = subject_2.fisher_score{i};
    subject_2.all_mean_fisher(i) = mean(F2_all(:));
    subject_2.all_med_fisher(i)  = median(F2_all(:));
end
%% Display All‑Channel Summaries
disp('--- Subject 1 all‑channel mean Fisher per session ---')
disp(subject_1.all_mean_fisher)
disp('--- Subject 1 all‑channel median Fisher per session ---')
disp(subject_1.all_med_fisher)

disp('--- Subject 2 all‑channel mean Fisher per session ---')
disp(subject_2.all_mean_fisher)
disp('--- Subject 2 all‑channel median Fisher per session ---')
disp(subject_2.all_med_fisher)
%% Sensorimotor‐Only Fisher Summary
for i = 1:3
    % Subject 1
    smF1 = subject_1.fisher_score{i}(:, sensorimotor_idx);  % 14×38
    subject_1.sm_mean_fisher(i)   = mean(smF1(:));         % overall avg
    subject_1.sm_med_fisher(i)    = median(smF1(:));       % median
    subject_1.sm_chan_scores(i,:) = sum(smF1, 1);          % 1×38 per-channel sum

    % Subject 2
    smF2 = subject_2.fisher_score{i}(:, sensorimotor_idx);
    subject_2.sm_mean_fisher(i)   = mean(smF2(:));
    subject_2.sm_med_fisher(i)    = median(smF2(:));
    subject_2.sm_chan_scores(i,:) = sum(smF2, 1);
end

%% Display Sensorimotor Summaries
disp('--- Subject 1 sensorimotor mean Fisher per session ---')
disp(subject_1.sm_mean_fisher)
disp('--- Subject 1 sensorimotor median Fisher per session ---')
disp(subject_1.sm_med_fisher)

disp('--- Subject 2 sensorimotor mean Fisher per session ---')
disp(subject_2.sm_mean_fisher)
disp('--- Subject 2 sensorimotor median Fisher per session ---')
disp(subject_2.sm_med_fisher)
%% --- Subject-Level Session‑means t‑tests ---

% preallocate
chanMean   = zeros(2,3,64);   % subj × session × channel
smChanMean = zeros(2,3,38);   % subj × session × ROI-channel

% compute channel‑means
for subj=1:2
  if subj == 1
        S = subject_1;
    else
        S = subject_2;
    end
  for sess=1:3
    F       = S.fisher_score{sess};          % 14×64
    chanMean(subj,sess,:)   = mean(F,1);     % 1×64
    smChanMean(subj,sess,:) = mean(F(:,sensorimotor_idx),1); % 1×38
  end
end

pairs = [1 2; 2 3; 1 3];
names = {'S1→S2','S2→S3','S1→S3'};

for subj=1:2
  fprintf('\n*** Subject %d: Full‑Head means ***\n', subj);
  for k=1:3
    A = squeeze(chanMean(subj,pairs(k,1),:));
    B = squeeze(chanMean(subj,pairs(k,2),:));
    [~,p,~,stats] = ttest(B,A);
    d = mean(B-A)/std(B-A);
    fprintf('%s: Δ=%.4f, t(%d)=%.2f, p=%.2e, d=%.2f\n', ...
            names{k}, mean(B)-mean(A), stats.df, stats.tstat, p, d);
  end

  fprintf('\n*** Subject %d: Sensorimotor means ***\n', subj);
  for k=1:3
    A = squeeze(smChanMean(subj,pairs(k,1),:));
    B = squeeze(smChanMean(subj,pairs(k,2),:));
    [~,p,~,stats] = ttest(B,A);
    d = mean(B-A)/std(B-A);
    fprintf('%s: Δ=%.4f, t(%d)=%.2f, p=%.2e, d=%.2f\n', ...
            names{k}, mean(B)-mean(A), stats.df, stats.tstat, p, d);
  end
end
%% — Group‐Level t‐tests on Channel Means, with Cohen’s d — 

% build sess1,… as before
sess1 = [ squeeze(chanMean(1,1,:)); squeeze(chanMean(2,1,:)) ];
sess2 = [ squeeze(chanMean(1,2,:)); squeeze(chanMean(2,2,:)) ];
sess3 = [ squeeze(chanMean(1,3,:)); squeeze(chanMean(2,3,:)) ];

groupData = [ sess1, sess2, sess3 ];   % 128×3
pairs     = [1 2; 2 3; 1 3];
sessLabs  = {'S1','S2','S3'};

fprintf('\n=== Group‐Level Full‑Head Channel Means ===\n');
for k = 1:size(pairs,1)
    A = groupData(:, pairs(k,1));
    B = groupData(:, pairs(k,2));
    [~, p, ~, stats] = ttest(B, A);
    d = mean(B - A) / std(B - A);    % Cohen’s d for paired samples
    fprintf('S%d→S%d: t(%d)=%.2f, p=%.2e, d=%.2f\n', ...
            pairs(k,1), pairs(k,2), stats.df, stats.tstat, p, d);
end

figure;
boxplot(groupData, 'Labels', sessLabs);
hold on;
xline(2.5,'--r','LineWidth',2,'DisplayName','rTMS');
hold off;
title('Group‑Level Full‑Head Channel Means');
ylabel('Mean Fisher Score per Channel');
xlabel('Session');
legend('Location','best');

%% — Group‐Level Sensorimotor Channel Means, with Cohen’s d — 

sm1     = [ squeeze(smChanMean(1,1,:)); squeeze(smChanMean(2,1,:)) ];
sm2     = [ squeeze(smChanMean(1,2,:)); squeeze(smChanMean(2,2,:)) ];
sm3     = [ squeeze(smChanMean(1,3,:)); squeeze(smChanMean(2,3,:)) ];
groupSM = [ sm1, sm2, sm3 ];  % 76×3

fprintf('\n=== Group‑Level Sensorimotor Channel Means ===\n');
for k = 1:size(pairs,1)
    A = groupSM(:, pairs(k,1));
    B = groupSM(:, pairs(k,2));
    [~, p, ~, stats] = ttest(B, A);
    d = mean(B - A) / std(B - A);
    fprintf('S%d→S%d: t(%d)=%.2f, p=%.2e, d=%.2f\n', ...
            pairs(k,1), pairs(k,2), stats.df, stats.tstat, p, d);
end

figure;
boxplot(groupSM, 'Labels', sessLabs);
hold on;
xline(2.5,'--r','LineWidth',2,'DisplayName','rTMS');
hold off;
title('Group‑Level Sensorimotor Channel Means');
ylabel('Mean Fisher Score per Channel');
xlabel('Session');
legend('Location','best');



%% Subject-Level Box Plotting
% sessions labels
sessLabs = {'S1','S2','S3'};

for subj = 1:2
    % pick the right data
    if subj==1
        FH = squeeze(chanMean(1,:,:));      % 3×64
        SM = squeeze(smChanMean(1,:,:));    % 3×38
    else
        FH = squeeze(chanMean(2,:,:));
        SM = squeeze(smChanMean(2,:,:));
    end

    % Full‑Head boxplot
    figure;
    boxplot(FH', 'Labels', sessLabs);
    hl = xline(2.5, '--r', 'LineWidth', 2, 'DisplayName', 'Inhibitory rTMS');
    legend('Location','best');
    title(sprintf('Subject %d — Full‑Head Mean Fisher', subj));
    ylabel('Mean Fisher Score Per Channel');
    xlabel('Session');
    grid on;

    % Sensorimotor‑Only boxplot
    figure;
    boxplot(SM', 'Labels', sessLabs);
    hl = xline(2.5, '--r', 'LineWidth', 2, 'DisplayName', 'Inhibitory rTMS');
    legend('Location','best');
    title(sprintf('Subject %d — Sensorimotor Electrodes Mean Fisher', subj));
    ylabel('Mean Fisher Score Per Channel');
    xlabel('Session');
    grid on;
end
