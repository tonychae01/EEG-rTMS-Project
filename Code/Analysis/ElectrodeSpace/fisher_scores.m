%% Calculate the fisher score by session, of each features (14 bands, 64 channel)


%% Elemental Mean Per Session 
for i = 1:3
    subject_1.mean_rest{i} = zeros(14, 64);
    subject_1.mean_move{i} = zeros(14,64);
    subject_2.mean_rest{i} = zeros(14, 64);
    subject_2.mean_move{i} = zeros(14,64);
end


for i = 1:3
    session_size = size(subject_1.rest_feats.session{1, i});
    session_trials = session_size(2);
    for j = 1:session_trials
        subject_1.mean_rest{i} = subject_1.mean_rest{i} + subject_1.rest_feats.session{1, i}{1, j};
        subject_1.mean_move{i} = subject_1.mean_move{i} + subject_1.move_feats.session{1, i}{1, j};

        subject_2.mean_rest{i} = subject_2.mean_rest{i} + subject_2.rest_feats.session{1, i}{1, j};
        subject_2.mean_move{i} = subject_2.mean_move{i} + subject_2.move_feats.session{1, i}{1, j};
    end
    subject_1.mean_rest{i} = subject_1.mean_rest{i}./session_trials;
    subject_1.mean_move{i} = subject_1.mean_move{i}./session_trials;

    subject_2.mean_rest{i} = subject_2.mean_rest{i}./session_trials;
    subject_2.mean_move{i} = subject_2.mean_move{i}./session_trials;
end

%% Elemental Variance Per Session 
nSess = 3;
for i = 1:nSess
    % number of trials in this session
    session_trials = numel( subject_1.rest_feats.session{1,i} );
    
    % preallocate accumulators for squared deviations
    subject_1.var_rest{i} = zeros(14,64);
    subject_1.var_move{i} = zeros(14,64);
    subject_2.var_rest{i} = zeros(14,64);
    subject_2.var_move{i} = zeros(14,64);
    
    % pull out the already‑computed means
    mu1R = subject_1.mean_rest{i};
    mu1M = subject_1.mean_move{i};
    mu2R = subject_2.mean_rest{i};
    mu2M = subject_2.mean_move{i};
    
    for j = 1:session_trials
        % grab the j‑th trial’s 14×64 feature matrix
        x1R = subject_1.rest_feats.session{1,i}{1,j};
        x1M = subject_1.move_feats.session{1,i}{1,j};
        x2R = subject_2.rest_feats.session{1,i}{1,j};
        x2M = subject_2.move_feats.session{1,i}{1,j};
        
        % accumulate squared‑deviation
        subject_1.var_rest{i} = subject_1.var_rest{i} + (x1R - mu1R).^2;
        subject_1.var_move{i} = subject_1.var_move{i} + (x1M - mu1M).^2;
        subject_2.var_rest{i} = subject_2.var_rest{i} + (x2R - mu2R).^2;
        subject_2.var_move{i} = subject_2.var_move{i} + (x2M - mu2M).^2;
    end
    
    % divide by N for the population variance
    subject_1.var_rest{i}  = subject_1.var_rest{i}  / (session_trials-1);
    subject_1.var_move{i}  = subject_1.var_move{i}  / (session_trials-1);
    subject_2.var_rest{i}  = subject_2.var_rest{i}  / (session_trials-1);
    subject_2.var_move{i}  = subject_2.var_move{i}  / (session_trials-1);
    %disp(session_trials)
    
end

%% Fisher Scoring
for i = 1:3
    subject_1.fisher_score{i} = zeros(14, 64);
    subject_2.fisher_score{i} = zeros(14, 64);
end

for i = 1:3
    numerator = abs(subject_1.mean_rest{i} - subject_1.mean_move{i});
    denominator = sqrt(subject_1.var_rest{i} + subject_1.var_move{i});
    subject_1.fisher_score{i} = numerator./denominator;

    numerator = abs(subject_2.mean_rest{i} - subject_2.mean_move{i});
    denominator = sqrt(subject_2.var_rest{i} + subject_2.var_move{i});
    subject_2.fisher_score{i} = numerator./denominator;
end
