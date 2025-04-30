
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

%%
session1 = 1:1:40;
session2 = 41:1:70;
session3 = 71:1:100;
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
