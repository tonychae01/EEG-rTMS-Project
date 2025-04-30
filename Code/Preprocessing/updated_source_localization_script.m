
%% Load Data
subj1 = load("proj_subj_204.mat");
subj2 = load("proj_subj_210.mat");
sub1_decoder1 = load("Subject_204_Experiment_FES_mode_Visual_classes__Decoder_2025_03_20_11_48_49.mat");
sub1_decoder2 = load("Subject_204_Experiment_FES_mode_Visual_classes__NoiseCovUpdate_Decoder_2025_03_21_09_33_03.mat");

sub2_decoder1 = load("Subject_210_Experiment_FES_mode_Visual_classes__Decoder_2025_04_03_16_00_59.mat");
sub2_decoder2 = load("Subject_210_Experiment_FES_mode_Visual_classes__Decoder_2025_04_03_16_00_59.mat");

%% Extract Task Periods
subject_1.rest_EEG = {};
subject_1.move_EEG = {};
[subject_1.rest_EEG{end + 1}, subject_1.move_EEG{end+1}] = extract_trials(subj1.proj_sub_204.online);

subject_2.rest_EEG = {};
subject_2.move_EEG = {};
[subject_2.rest_EEG{end + 1}, subject_2.move_EEG{end+1}] = extract_trials(subj2.proj_sub_210.online);

%% Bandpass in Mu and Inverse Operation
fs = 512;
[bMu, aMu] = butter(4, [8 13]/(fs/2), 'bandpass');

invOp1_1 = sub1_decoder1.decoder.preprocessing.inverse_operator;
invOp1_2 = sub1_decoder2.decoder.preprocessing.inverse_operator;
invOp2_1 = sub2_decoder1.decoder.preprocessing.inverse_operator;
invOp2_2 = sub2_decoder2.decoder.preprocessing.inverse_operator;

sensorimotor_idx = [ ...
    4,5,6,7,8, 9,10,11,12, ...
    15,16,17, 20,21,22,23, ...
    24,25,26,27,28, 37,38,39,40, ...
    41,42,43, 44,45,46,47, ...
    48,49,50,51,52,53 ...
];

subject_1.rest_SRC = {}; subject_1.move_SRC = {};
subject_2.rest_SRC = {}; subject_2.move_SRC = {};

for i = 1:100
    if i <= 40
        invOp1 = invOp1_1;
    else
        invOp1 = invOp1_2;
    end
    trial_rest1 = double(subject_1.rest_EEG{1}{i}(:, sensorimotor_idx));
    trial_move1 = double(subject_1.move_EEG{1}{i}(:, sensorimotor_idx));
    trial_rest1_filt = filtfilt(bMu, aMu, trial_rest1);
    trial_move1_filt = filtfilt(bMu, aMu, trial_move1);
    for p = 1:4
        parcel = invOp1{p};
        subject_1.rest_SRC{i}(p,:) = mean(parcel * trial_rest1_filt', 1);
        subject_1.move_SRC{i}(p,:) = mean(parcel * trial_move1_filt', 1);
    end

    if i <= 40
        invOp2 = invOp2_1;
    else
        invOp2 = invOp2_2;
    end
    trial_rest2 = double(subject_2.rest_EEG{1}{i}(:, sensorimotor_idx));
    trial_move2 = double(subject_2.move_EEG{1}{i}(:, sensorimotor_idx));
    trial_rest2_filt = filtfilt(bMu, aMu, trial_rest2);
    trial_move2_filt = filtfilt(bMu, aMu, trial_move2);
    for p = 1:4
        parcel = invOp2{p};
        subject_2.rest_SRC{i}(p,:) = mean(parcel * trial_rest2_filt', 1);
        subject_2.move_SRC{i}(p,:) = mean(parcel * trial_move2_filt', 1);
    end
end


%% Compute Covariance Matrices for Each Trial (Subject 1 & 2)

% Initialize storage
subject_1.rest_cov = cell(1, 100);
subject_1.move_cov = cell(1, 100);
subject_2.rest_cov = cell(1, 100);
subject_2.move_cov = cell(1, 100);

for i = 1:100
    % Subject 1
    rest_src_1 = subject_1.rest_SRC{i};  % size: 4 × T
    move_src_1 = subject_1.move_SRC{i};

    subject_1.rest_cov{i} = cov(rest_src_1');  % → 4×4
    subject_1.move_cov{i} = cov(move_src_1');

    % Subject 2
    rest_src_2 = subject_2.rest_SRC{i};
    move_src_2 = subject_2.move_SRC{i};

    subject_2.rest_cov{i} = cov(rest_src_2');
    subject_2.move_cov{i} = cov(move_src_2');
end
%% Feature Extraction (From Covariance Matrices)
num_trials = 100;

% Preallocate
subject_1.features_rest = zeros(num_trials, 2);
subject_1.features_move = zeros(num_trials, 2);
subject_2.features_rest = zeros(num_trials, 2);
subject_2.features_move = zeros(num_trials, 2);

for i = 1:num_trials
    % Subject 1 – Rest
    C = subject_1.rest_cov{i};
    eigVals = eig(C);
    subject_1.features_rest(i,1) = max(abs(eigVals));     % Largest eigenvalue
    subject_1.features_rest(i,2) = norm(C, 'fro');        % Frobenius norm

    % Subject 1 – Move
    C = subject_1.move_cov{i};
    eigVals = eig(C);
    subject_1.features_move(i,1) = max(abs(eigVals));
    subject_1.features_move(i,2) = norm(C, 'fro');

    % Subject 2 – Rest
    C = subject_2.rest_cov{i};
    eigVals = eig(C);
    subject_2.features_rest(i,1) = max(abs(eigVals));
    subject_2.features_rest(i,2) = norm(C, 'fro');

    % Subject 2 – Move
    C = subject_2.move_cov{i};
    eigVals = eig(C);
    subject_2.features_move(i,1) = max(abs(eigVals));
    subject_2.features_move(i,2) = norm(C, 'fro');
end
%% --- Extended Feature Extraction (5 features) ---

num_trials = 100;
feature_names = {...
  'MaxEig', ...            % λ_max
  'EigRatio', ...          % λ_max / λ_min
  'FrobeniusNorm', ...     % ‖C‖_F
  'LogDet', ...            % log det(C)
  'Trace' ...              % tr(C)
};

% Preallocate [trials × 5]
subject_1.features_rest = zeros(num_trials,5);
subject_1.features_move = zeros(num_trials,5);
subject_2.features_rest = zeros(num_trials,5);
subject_2.features_move = zeros(num_trials,5);

for i = 1:num_trials
  % --- Subject 1 ---
  C = subject_1.rest_cov{i};
  lambda = eig(C);
  subject_1.features_rest(i,:) = [ ...
    max(lambda), ...
    max(lambda)/min(lambda), ...
    norm(C,'fro'), ...
    log(det(C)), ...
    trace(C) ...
  ];
  
  C = subject_1.move_cov{i};
  lambda = eig(C);
  subject_1.features_move(i,:) = [ ...
    max(lambda), ...
    max(lambda)/min(lambda), ...
    norm(C,'fro'), ...
    log(det(C)), ...
    trace(C) ...
  ];

  % --- Subject 2 ---
  C = subject_2.rest_cov{i};
  lambda = eig(C);
  subject_2.features_rest(i,:) = [ ...
    max(lambda), ...
    max(lambda)/min(lambda), ...
    norm(C,'fro'), ...
    log(det(C)), ...
    trace(C) ...
  ];

  C = subject_2.move_cov{i};
  lambda = eig(C);
  subject_2.features_move(i,:) = [ ...
    max(lambda), ...
    max(lambda)/min(lambda), ...
    norm(C,'fro'), ...
    log(det(C)), ...
    trace(C) ...
  ];
end
%% --- Fisher‐Score Computation per Session & Feature ---

% we already have:
%   subject_1.features_rest  (100×5), subject_1.features_move  (100×5)
%   subject_2.features_rest  (100×5), subject_2.features_move  (100×5)

sessions   = {1:40, 41:70, 71:100};
session_names = {'Session 1','Session 2','Session 3'};
nFeat = 5;   % number of features
nSess = numel(sessions);

% Preallocate
subject_1.fisher_scores = zeros(nSess,nFeat);
subject_2.fisher_scores = zeros(nSess,nFeat);
group_fisher         = zeros(nSess,nFeat);

for subj = 1:2
  % pick the right fields
  feats_rest = eval(sprintf('subject_%d.features_rest',subj));  % 100×5
  feats_move = eval(sprintf('subject_%d.features_move',subj));  % 100×5
  
  F = zeros(nSess,nFeat);
  for s = 1:nSess
    idx = sessions{s};
    R = feats_rest(idx,:);    % nTrials×5
    M = feats_move(idx,:);

    muR = mean(R,1);          % 1×5
    muM = mean(M,1);
    varR = var(R,0,1);        % 1×5  (unbiased via N–1)
    varM = var(M,0,1);

    F(s,:) = abs(muR - muM) ./ sqrt(varR + varM);
  end

  eval(sprintf('subject_%d.fisher_scores = F;',subj));
end

%% --- (Optional) Group‐level Fisher, pooling both subjects ---

for s = 1:nSess
  idx = sessions{s};

  R_all = [ subject_1.features_rest(idx,:)
            subject_2.features_rest(idx,:) ];
  M_all = [ subject_1.features_move(idx,:)
            subject_2.features_move(idx,:) ];

  muR = mean(R_all,1);
  muM = mean(M_all,1);
  varR = var(R_all,0,1);
  varM = var(M_all,0,1);

  group_fisher(s,:) = abs(muR - muM) ./ sqrt(varR + varM);
end

%% --- Display as a table or bar chart ---

% Subject 1
disp('Subject 1 Fisher scores (sessions × features):');
disp(array2table(subject_1.fisher_scores, ...
  'VariableNames',feature_names, ...
  'RowNames',session_names));

% bar-plot for Subject 1
figure;
bar(subject_1.fisher_scores);
set(gca,'XTick',1:3,'XTickLabel',session_names);
legend(feature_names,'Interpreter','none','Location','best');
ylabel('Fisher Score');
title('Subject 1 Discriminability per Feature across Sessions');

% --- Continue from your Subject 1 plot block ---

% Subject 2
disp('Subject 2 Fisher scores (sessions × features):');
disp(array2table(subject_2.fisher_scores, ...
  'VariableNames',feature_names, ...
  'RowNames',session_names));

figure;
bar(subject_2.fisher_scores);
set(gca,'XTick',1:3,'XTickLabel',session_names);
legend(feature_names,'Interpreter','none','Location','best');
ylabel('Fisher Score');
title('Subject 2 Discriminability per Feature across Sessions');
grid on;

% Group-level
disp('Group-level Fisher scores (sessions × features):');
disp(array2table(group_fisher, ...
  'VariableNames',feature_names, ...
  'RowNames',session_names));

figure;
bar(group_fisher);
set(gca,'XTick',1:3,'XTickLabel',session_names);
legend(feature_names,'Interpreter','none','Location','best');
ylabel('Fisher Score');
title('Group-level Discriminability per Feature across Sessions');
grid on;


%% --- Pairwise scatter plots ---

% define sessions
sessions   = {1:40, 41:70, 71:100};
session_names = {'Session 1','Session 2','Session 3'};
pairs = nchoosek(1:5,2);

colors = lines(2);   % [blue; red]

for subj = 1:2
  feats_rest = eval(sprintf('subject_%d.features_rest', subj));
  feats_move = eval(sprintf('subject_%d.features_move', subj));
  for s = 1:3
    idx = sessions{s};
    for p = 1:size(pairs,1)
      f1 = pairs(p,1);
      f2 = pairs(p,2);

      figure;
      hold on;
      scatter( feats_rest(idx,f1), feats_rest(idx,f2), 40, colors(1,:), 'filled' );
      scatter( feats_move(idx,f1), feats_move(idx,f2), 40, colors(2,:), 'filled' );
      xlabel(feature_names{f1}, 'Interpreter','none');
      ylabel(feature_names{f2}, 'Interpreter','none');
      title(sprintf('Subject %d — %s: %s vs %s', subj, session_names{s}, ...
        feature_names{f1}, feature_names{f2}));
      legend('Rest','Move','Location','best');
      grid on;
      hold off;
    end
  end
end

%% --- Group-level plots (overlay Subj1 & Subj2) ---
for s = 1:3
  idx = sessions{s};
  for p = 1:size(pairs,1)
    f1 = pairs(p,1);
    f2 = pairs(p,2);

    figure;
    hold on;
    % Subj1
    scatter( subject_1.features_rest(idx,f1), subject_1.features_rest(idx,f2), 36, 'o', ...
             'MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','k', 'DisplayName','Rest S1');
    scatter( subject_1.features_move(idx,f1), subject_1.features_move(idx,f2), 36, 'o', ...
             'MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','k', 'DisplayName','Move S1');
    % Subj2
    scatter( subject_2.features_rest(idx,f1), subject_2.features_rest(idx,f2), 36, 's', ...
             'MarkerFaceColor',colors(1,:), 'MarkerEdgeColor','k', 'DisplayName','Rest S2');
    scatter( subject_2.features_move(idx,f1), subject_2.features_move(idx,f2), 36, 's', ...
             'MarkerFaceColor',colors(2,:), 'MarkerEdgeColor','k', 'DisplayName','Move S2');

    xlabel(feature_names{f1}, 'Interpreter','none');
    ylabel(feature_names{f2}, 'Interpreter','none');
    title(sprintf('Group — %s: %s vs %s', session_names{s}, ...
      feature_names{f1}, feature_names{f2}));
    legend('Location','best');
    grid on;
    hold off;
  end
end


%% Feature Discriminability
% Define session indices
session1 = 1:40;
session2 = 41:70;
session3 = 71:100;

% Colors
colors = lines(2); % 1: rest (blue), 2: move (red)

sessions = {session1, session2, session3};
session_names = {'Session 1', 'Session 2', 'Session 3'};

% SUBJECT 1 PLOTS
for s = 1:3
    idx = sessions{s};

    figure;
    hold on;
    scatter(subject_1.features_rest(idx, 1), subject_1.features_rest(idx, 2), 50, colors(1,:), 'filled', 'DisplayName', 'Rest');
    scatter(subject_1.features_move(idx, 1), subject_1.features_move(idx, 2), 50, colors(2,:), 'filled', 'DisplayName', 'Move');
    title(['Subject 1 — ', session_names{s}]);
    xlabel('Largest Eigenvalue');
    ylabel('Frobenius Norm');
    legend;
    grid on;
    hold off;
end

% SUBJECT 2 PLOTS
for s = 1:3
    idx = sessions{s};

    figure;
    hold on;
    scatter(subject_2.features_rest(idx, 1), subject_2.features_rest(idx, 2), 50, colors(1,:), 'filled', 'DisplayName', 'Rest');
    scatter(subject_2.features_move(idx, 1), subject_2.features_move(idx, 2), 50, colors(2,:), 'filled', 'DisplayName', 'Move');
    title(['Subject 2 — ', session_names{s}]);
    xlabel('Largest Eigenvalue');
    ylabel('Frobenius Norm');
    legend;
    grid on;
    hold off;
end

% GROUP LEVEL PLOTS
for s = 1:3
    idx = sessions{s};

    figure;
    hold on;
    scatter(subject_1.features_rest(idx, 1), subject_1.rest_feat(idx, 2), 40, colors(1,:), 'o', 'DisplayName', 'Rest S1');
    scatter(subject_1.features_move(idx, 1), subject_1.move_feat(idx, 2), 40, colors(2,:), 'o', 'DisplayName', 'Move S1');
    scatter(subject_2.features_rest(idx, 1), subject_2.rest_feat(idx, 2), 40, colors(1,:), 's', 'DisplayName', 'Rest S2');
    scatter(subject_2.features_move(idx, 1), subject_2.move_feat(idx, 2), 40, colors(2,:), 's', 'DisplayName', 'Move S2');
    title(['Group — ', session_names{s}]);
    xlabel('Largest Eigenvalue');
    ylabel('Frobenius Norm');
    legend;
    grid on;
    hold off;
end



%% Functions
function [left_trials, right_trials] = extract_trials(session)
    left_trials = {};
    right_trials = {};
    for i = 1:length(session.run)
        EEG = session.run(i).eeg.data';
        left_idx = find(session.run(i).header.triggers.TYP == 7691);
        right_idx = find(session.run(i).header.triggers.TYP == 7701);
        left_start = session.run(i).header.triggers.POS(left_idx);
        left_end = session.run(i).header.triggers.POS(left_idx+1);
        right_start = session.run(i).header.triggers.POS(right_idx);
        right_end = session.run(i).header.triggers.POS(right_idx+1);
        for j = 1:length(left_start)
            left_trials{end+1} = EEG(left_start(j):left_end(j), :);
            right_trials{end+1} = EEG(right_start(j):right_end(j), :);
        end
    end
end
