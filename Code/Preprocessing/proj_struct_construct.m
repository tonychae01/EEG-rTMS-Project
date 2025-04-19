function s = generate_type_list(events)
    s = [];
    for i = 1:length(events)
        if isnan(str2double(events(i).type)),
            s = [s;0];
        else
            s = [s;str2double(events(i).type)];
        end
    end
end

function s = generate_pos_list(events)
    s = [];
    for i = 1:length(events)
        if isnan(double(events(i).latency)),
            s = [s;0];
        else
            s = [s;events(i).latency];
        end
    end
end

load("subject204.mat");
load("subject210.mat");

subject_210_run1 = load("Subject_210_run1.mat");
subject_210_run2 = load("Subject_210_run2.mat");
subject_210_run3 = load("Subject_210_run3.mat");
subject_210_run4 = load("Subject_210_run4.mat");
subject_210_run5 = load("Subject_210_run5.mat");
subject_210_run6 = load("Subject_210_run6.mat");
subject_210_run7 = load("Subject_210_run7.mat");
subject_210_run8 = load("Subject_210_run8.mat");
subject_210_run9 = load("Subject_210_run9.mat");
subject_210_run10 = load("Subject_210_run10.mat");

subject_204_run1 = load("Subject_204_run1.mat");
subject_204_run2 = load("Subject_204_run2.mat");
subject_204_run3 = load("Subject_204_run3.mat");
subject_204_run4 = load("Subject_204_run4.mat");
subject_204_run5 = load("Subject_204_run5.mat");
subject_204_run6 = load("Subject_204_run6.mat");
subject_204_run7 = load("Subject_204_run7.mat");
subject_204_run8 = load("Subject_204_run8.mat");
subject_204_run9 = load("Subject_204_run9.mat");
subject_204_run10 = load("Subject_204_run10.mat");

proj_subj_204 = struct;
proj_subj_204.online = struct;
proj_subj_204.online.run(1).eeg = subject_204_run1;
proj_subj_204.online.run(2).eeg = subject_204_run2;
proj_subj_204.online.run(3).eeg = subject_204_run3;
proj_subj_204.online.run(4).eeg = subject_204_run4;
proj_subj_204.online.run(5).eeg = subject_204_run5;
proj_subj_204.online.run(6).eeg = subject_204_run6;
proj_subj_204.online.run(7).eeg = subject_204_run7;
proj_subj_204.online.run(8).eeg = subject_204_run8;
proj_subj_204.online.run(9).eeg = subject_204_run9;
proj_subj_204.online.run(10).eeg = subject_204_run10;

proj_subj_204.online.run(1).header = struct;
proj_subj_204.online.run(2).header = struct;
proj_subj_204.online.run(3).header = struct;
proj_subj_204.online.run(4).header = struct;
proj_subj_204.online.run(5).header = struct;
proj_subj_204.online.run(6).header = struct;
proj_subj_204.online.run(7).header = struct;
proj_subj_204.online.run(8).header = struct;
proj_subj_204.online.run(9).header = struct;
proj_subj_204.online.run(10).header = struct;

proj_subj_204.online.run(1).header.fs = 512;
proj_subj_204.online.run(2).header.fs = 512;
proj_subj_204.online.run(3).header.fs = 512;
proj_subj_204.online.run(4).header.fs = 512;
proj_subj_204.online.run(5).header.fs = 512;
proj_subj_204.online.run(6).header.fs = 512;
proj_subj_204.online.run(7).header.fs = 512;
proj_subj_204.online.run(8).header.fs = 512;
proj_subj_204.online.run(9).header.fs = 512;
proj_subj_204.online.run(10).header.fs = 512;

proj_subj_204.online.run(1).header.triggers = struct;
proj_subj_204.online.run(2).header.triggers = struct;
proj_subj_204.online.run(3).header.triggers = struct;
proj_subj_204.online.run(4).header.triggers = struct;
proj_subj_204.online.run(5).header.triggers = struct;
proj_subj_204.online.run(6).header.triggers = struct;
proj_subj_204.online.run(7).header.triggers = struct;
proj_subj_204.online.run(8).header.triggers = struct;
proj_subj_204.online.run(9).header.triggers = struct;
proj_subj_204.online.run(10).header.triggers = struct;


proj_subj_204.online.run(1).header.triggers.TYP = generate_type_list(subject204.session(1).run(1).events);
proj_subj_204.online.run(2).header.triggers.TYP = generate_type_list(subject204.session(1).run(2).events);
proj_subj_204.online.run(3).header.triggers.TYP = generate_type_list(subject204.session(1).run(3).events);
proj_subj_204.online.run(4).header.triggers.TYP = generate_type_list(subject204.session(1).run(4).events);
proj_subj_204.online.run(5).header.triggers.TYP = generate_type_list(subject204.session(2).run(1).events);
proj_subj_204.online.run(6).header.triggers.TYP = generate_type_list(subject204.session(2).run(2).events);
proj_subj_204.online.run(7).header.triggers.TYP = generate_type_list(subject204.session(2).run(3).events);
proj_subj_204.online.run(8).header.triggers.TYP = generate_type_list(subject204.session(2).run(4).events);
proj_subj_204.online.run(9).header.triggers.TYP = generate_type_list(subject204.session(2).run(5).events);
proj_subj_204.online.run(10).header.triggers.TYP = generate_type_list(subject204.session(2).run(6).events);

proj_subj_204.online.run(1).header.triggers.POS = generate_pos_list(subject204.session(1).run(1).events);
proj_subj_204.online.run(2).header.triggers.POS = generate_pos_list(subject204.session(1).run(2).events);
proj_subj_204.online.run(3).header.triggers.POS = generate_pos_list(subject204.session(1).run(3).events);
proj_subj_204.online.run(4).header.triggers.POS = generate_pos_list(subject204.session(1).run(4).events);
proj_subj_204.online.run(5).header.triggers.POS = generate_pos_list(subject204.session(2).run(1).events);
proj_subj_204.online.run(6).header.triggers.POS = generate_pos_list(subject204.session(2).run(2).events);
proj_subj_204.online.run(7).header.triggers.POS = generate_pos_list(subject204.session(2).run(3).events);
proj_subj_204.online.run(8).header.triggers.POS = generate_pos_list(subject204.session(2).run(4).events);
proj_subj_204.online.run(9).header.triggers.POS = generate_pos_list(subject204.session(2).run(5).events);
proj_subj_204.online.run(10).header.triggers.POS = generate_pos_list(subject204.session(2).run(6).events);

proj_subj_210 = struct;
proj_subj_210.online = struct;
proj_subj_210.online.run(1).eeg = subject_210_run1;
proj_subj_210.online.run(2).eeg = subject_210_run2;
proj_subj_210.online.run(3).eeg = subject_210_run3;
proj_subj_210.online.run(4).eeg = subject_210_run4;
proj_subj_210.online.run(5).eeg = subject_210_run5;
proj_subj_210.online.run(6).eeg = subject_210_run6;
proj_subj_210.online.run(7).eeg = subject_210_run7;
proj_subj_210.online.run(8).eeg = subject_210_run8;
proj_subj_210.online.run(9).eeg = subject_210_run9;
proj_subj_210.online.run(10).eeg = subject_210_run10;

proj_subj_210.online.run(1).header = struct;
proj_subj_210.online.run(2).header = struct;
proj_subj_210.online.run(3).header = struct;
proj_subj_210.online.run(4).header = struct;
proj_subj_210.online.run(5).header = struct;
proj_subj_210.online.run(6).header = struct;
proj_subj_210.online.run(7).header = struct;
proj_subj_210.online.run(8).header = struct;
proj_subj_210.online.run(9).header = struct;
proj_subj_210.online.run(10).header = struct;

proj_subj_210.online.run(1).header.fs = 512;
proj_subj_210.online.run(2).header.fs = 512;
proj_subj_210.online.run(3).header.fs = 512;
proj_subj_210.online.run(4).header.fs = 512;
proj_subj_210.online.run(5).header.fs = 512;
proj_subj_210.online.run(6).header.fs = 512;
proj_subj_210.online.run(7).header.fs = 512;
proj_subj_210.online.run(8).header.fs = 512;
proj_subj_210.online.run(9).header.fs = 512;
proj_subj_210.online.run(10).header.fs = 512;

proj_subj_210.online.run(1).header.triggers = struct;
proj_subj_210.online.run(2).header.triggers = struct;
proj_subj_210.online.run(3).header.triggers = struct;
proj_subj_210.online.run(4).header.triggers = struct;
proj_subj_210.online.run(5).header.triggers = struct;
proj_subj_210.online.run(6).header.triggers = struct;
proj_subj_210.online.run(7).header.triggers = struct;
proj_subj_210.online.run(8).header.triggers = struct;
proj_subj_210.online.run(9).header.triggers = struct;
proj_subj_210.online.run(10).header.triggers = struct;

proj_subj_210.online.run(1).header.triggers.TYP = generate_type_list(subject210.session(1).run(1).events);
proj_subj_210.online.run(2).header.triggers.TYP = generate_type_list(subject210.session(1).run(2).events);
proj_subj_210.online.run(3).header.triggers.TYP = generate_type_list(subject210.session(1).run(3).events);
proj_subj_210.online.run(4).header.triggers.TYP = generate_type_list(subject210.session(1).run(4).events);
proj_subj_210.online.run(5).header.triggers.TYP = generate_type_list(subject210.session(2).run(1).events);
proj_subj_210.online.run(6).header.triggers.TYP = generate_type_list(subject210.session(2).run(2).events);
proj_subj_210.online.run(7).header.triggers.TYP = generate_type_list(subject210.session(2).run(3).events);
proj_subj_210.online.run(8).header.triggers.TYP = generate_type_list(subject210.session(2).run(4).events);
proj_subj_210.online.run(9).header.triggers.TYP = generate_type_list(subject210.session(2).run(5).events);
proj_subj_210.online.run(10).header.triggers.TYP = generate_type_list(subject210.session(2).run(6).events);

proj_subj_210.online.run(1).header.triggers.POS = generate_pos_list(subject210.session(1).run(1).events);
proj_subj_210.online.run(2).header.triggers.POS = generate_pos_list(subject210.session(1).run(2).events);
proj_subj_210.online.run(3).header.triggers.POS = generate_pos_list(subject210.session(1).run(3).events);
proj_subj_210.online.run(4).header.triggers.POS = generate_pos_list(subject210.session(1).run(4).events);
proj_subj_210.online.run(5).header.triggers.POS = generate_pos_list(subject210.session(2).run(1).events);
proj_subj_210.online.run(6).header.triggers.POS = generate_pos_list(subject210.session(2).run(2).events);
proj_subj_210.online.run(7).header.triggers.POS = generate_pos_list(subject210.session(2).run(3).events);
proj_subj_210.online.run(8).header.triggers.POS = generate_pos_list(subject210.session(2).run(4).events);
proj_subj_210.online.run(9).header.triggers.POS = generate_pos_list(subject210.session(2).run(5).events);
proj_subj_210.online.run(10).header.triggers.POS = generate_pos_list(subject210.session(2).run(6).events);

