%% P Welch All Task Periods (Extract Features)
freqs = 4:2:30; % 2Hz resolution, 4-30 Hz, total 14 points per channel per trial t:  t x (64 x 14) 


for j = 1:100
        [subject_1.all_features.rest_features{j}, F] = pwelch(subject_1.rest_EEG{1,1}{1,j}, [], [], freqs, 512);
        [subject_1.all_features.move_features{j}, F] = pwelch(subject_1.move_EEG{1,1}{1,j}, [], [], freqs, 512);
end

for j = 1:100
        [subject_2.all_features.rest_features{j}, F] = pwelch(subject_2.rest_EEG{1,1}{1,j}, [], [], freqs, 512);
        [subject_2.all_features.move_features{j}, F] = pwelch(subject_2.move_EEG{1,1}{1,j}, [], [], freqs, 512);
end



%% Segment Features by Session
session1 = 1:1:40; %run 1-4
session2 = 41:1:70; %run 5-7
session3 = 71:1:100; %run 8-10

subject_1.rest_feats.session{1} = subject_1.all_features.rest_features(session1);
subject_1.rest_feats.session{2} = subject_1.all_features.rest_features(session2);
subject_1.rest_feats.session{3} = subject_1.all_features.rest_features(session3);

subject_1.move_feats.session{1} = subject_1.all_features.move_features(session1);
subject_1.move_feats.session{2} = subject_1.all_features.move_features(session2);
subject_1.move_feats.session{3} = subject_1.all_features.move_features(session3);


subject_2.rest_feats.session{1} = subject_2.all_features.rest_features(session1);
subject_2.rest_feats.session{2} = subject_2.all_features.rest_features(session2);
subject_2.rest_feats.session{3} = subject_2.all_features.rest_features(session3);

subject_2.move_feats.session{1} = subject_2.all_features.move_features(session1);
subject_2.move_feats.session{2} = subject_2.all_features.move_features(session2);
subject_2.move_feats.session{3} = subject_2.all_features.move_features(session3);


%% Clip Redundant Sensors/Columns (Drop Columns 65:68)
for i = 1:3
    session_size = size(subject_1.rest_feats.session{1, i});
    session_trials = session_size(2);
    for j = 1:session_trials
        %disp(size(subject_1.rest_feats.session{1, i}{1, j}(:, 1:64)));
        subject_1.rest_feats.session{1, i}{1, j} = subject_1.rest_feats.session{1, i}{1, j}(:, 1:64);
        subject_1.move_feats.session{1, i}{1, j} = subject_1.move_feats.session{1, i}{1, j}(:, 1:64);

        subject_2.rest_feats.session{1, i}{1, j} = subject_2.rest_feats.session{1, i}{1, j}(:, 1:64);
        subject_2.move_feats.session{1, i}{1, j} = subject_2.move_feats.session{1, i}{1, j}(:, 1:64);

        %disp(size(subject_1.rest_feats.session{1, i}{1, j}))
        %disp(size(subject_1.move_feats.session{1, i}{1, j}))
        %disp(size(subject_2.rest_feats.session{1, i}{1, j}))
        %disp(size(subject_2.move_feats.session{1, i}{1, j}))
    end
end
