%% set paths

clear;

path_to_input_folder = '..//data';

path_to_output_folder = '../result_ctrial';

dataframe_file = 'data_frame_ctrial.xlsx';

%% set up

% look if the path to the output folder exist. If not, make it
if ~exist(path_to_output_folder,'dir')
    mkdir(path_to_output_folder)
end

dataframe = readtable(strcat(path_to_input_folder, '/', dataframe_file));

%% Recruitment status

var = dataframe{:,"RecruitmentStatus"};
var = categorical(var);
[Nrec,categories_rec] = histcounts(var);

% create horizontal bar chart
figure;
barh(0,Nrec,'stacked');

% Customize the axes
set(gca, 'ytick', [], 'yticklabel', []);
xlim([0 sum(Nrec)]);

% Add labels
text(Nrec(1)/2, 0, 'Completed', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
text(Nrec(1) + Nrec(2)/2, 0, 'Ongoing', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);

% Add title
title('Recruitment status');

% Remove y-axis
set(gca, 'YColor', 'none');

%% Study design

var = dataframe{:,"StudyDesignLevel1"};
var = categorical(var);
[Ndes,categories_des] = histcounts(var);

% create horizontal bar chart
figure;
barh(0,Ndes,'stacked');

% Customize the axes
set(gca, 'ytick', [], 'yticklabel', []);
xlim([0 sum(Ndes)]);

% Add labels
text(Ndes(1)/2, 0, 'Observational', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
text(Ndes(1) + Ndes(2)/2, 0, 'RCT', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);

% Add title
title('Study design');

% Remove y-axis
set(gca, 'YColor', 'none');

%% Age criteria

dataframe.AgeCriteria = {'Term'; 'Preterm'; 'Preterm and term'; 'Preterm and term'; 'Preterm and term'; 'Preterm'; 'Preterm'};
var = dataframe{:,"AgeCriteria"};
var = categorical(var);
var = reordercats(var,["Preterm" "Term" "Preterm and term"]); % reorder the categories
[Nage,categories_age] = histcounts(var);

% create horizontal bar chart
figure;
barh(0,Nage,'stacked');

% Customize the axes
set(gca, 'ytick', [], 'yticklabel', []);
xlim([0 sum(Nage)]);

% Add labels
text(Nage(1)/2, 0, 'Preterm', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
text(Nage(1) + Nage(2)/2, 0, 'Term', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
text(Nage(1) + Nage(2) + Nage(3)/2, 0, 'Preterm and term', 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);

% Add title
title('Age criteria');

% Remove y-axis
set(gca, 'YColor', 'none');

%% chart combination of recruitment status, study design, age

cat_all = {'Recruitment status'; 'Study design'; 'Age criteria'};
categories_all = categorical(cat_all);
categories_all = reordercats(categories_all,["Recruitment status" "Study design" "Age criteria"]); % reorder the categories

N_all = {Nrec Ndes Nage};

% Labels for the subcategories
recruitment_labels = {'Completed', 'Ongoing'};
study_design_labels = {'Observational', 'RCT'};
age_labels = {'Preterm', 'Term', 'Preterm and term'};

% All subcategory labels combined for the legend
all_labels = [recruitment_labels, study_design_labels, age_labels];
all_colors = lines(length(all_labels)); % Generate colors for each subcategory

% Determine the maximum number of subcategories
max_subcategories = max(cellfun(@length, N_all));

% Pad data with zeros to make sure each row has the same number of columns
N_all_padded = cellfun(@(x) [x, zeros(1, max_subcategories - length(x))], N_all, 'UniformOutput', false);
N_all_padded = vertcat(N_all_padded{:});

% create a figure
figure;
h = barh(categories_all,N_all_padded,'stacked');

% Customize the axes
xlabel('Number of clinical trial registrations');
title('Registrations distribution by various categories');

% Correctly map labels for each category
sub_labels_all = {recruitment_labels, study_design_labels, age_labels};

% Add text labels to the bars
for k = 1:size(N_all_padded, 1)
    x_offset = 0; % To accumulate the position for the label
    sub_labels = sub_labels_all{k}; % Get the labels for the current category
    for i = 1:length(sub_labels)
        if N_all_padded(k, i) > 0
            x_coord = x_offset + N_all_padded(k, i) / 2;
            y_coord = k;
            text(x_coord, y_coord, sub_labels{i}, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
            x_offset = x_offset + N_all_padded(k, i); % Update x_offset for the next label
        end
    end
end

% save the figure
fig_name = 'age,study_design,recruitment_stat_ctr.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot clinical pain scale horizontally

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'ClinicalPainScale'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_cps,categories] = histcounts(var); % counts the frequency of each category
[N_cps,idx] = sort(N_cps); % sort the counts array in descending order and get the indices
categoriesSorted_cps = categories(idx);

figure;
barh(N_cps);
yticks(1:numel(categoriesSorted_cps));
yticklabels(categoriesSorted_cps);
xlim([0,max(N_cps)+2]);
grid on;
% name the x and y axis of subplot 1
ylabel("Clinical pain scale")
xlabel("Frequency")
title("Clinical pain scales recorded alongside EEG")

% save the figure
fig_name = 'Clinical_pain_scale_ctr, horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot non-EEG recording horizontally

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'NonEEGRecording'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_neeg,categories] = histcounts(var); % counts the frequency of each category
[N_neeg,idx] = sort(N_neeg); % sort the counts array in descending order and get the indices
categoriesSorted_neeg = categories(idx);

figure;
barh(N_neeg);
yticks(1:numel(categoriesSorted_neeg));
yticklabels(categoriesSorted_neeg);
xlim([0,max([N_cps,N_neeg])+2]);
grid on;
% name the x and y axis of subplot 2
ylabel("Non-EEG recording")
xlabel("Frequency")
title("Non-EEG measures recorded alongside EEG")


% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.2, 0.2, 0.70, 0.50]);


% save the figure
fig_name = 'Non_EEG_recording_ctr, horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot clinical pain scale and non-EEG recording horizontally

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'ClinicalPainScale'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_cps,categories] = histcounts(var); % counts the frequency of each category
[N_cps,idx] = sort(N_cps); % sort the counts array in descending order and get the indices
categoriesSorted_cps = categories(idx);

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'NonEEGRecording'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_neeg,categories] = histcounts(var); % counts the frequency of each category
[N_neeg,idx] = sort(N_neeg); % sort the counts array in descending order and get the indices
categoriesSorted_neeg = categories(idx);

figure;
% subplot 1
subplot(1,2,1);
barh(N_cps);
yticks(1:numel(categoriesSorted_cps));
yticklabels(categoriesSorted_cps);
xlim([0,max([N_cps,N_neeg])+2]);
grid on;
% name the x and y axis of subplot 1
ylabel("Clinical pain scale")
xlabel("Frequency")
title("Clinical pain scales recorded alongside EEG")


% subplot 2
subplot(1,2,2);
barh(N_neeg);
yticks(1:numel(categoriesSorted_neeg));
yticklabels(categoriesSorted_neeg);
xlim([0,max([N_cps,N_neeg])+2]);
grid on;
% name the x and y axis of subplot 2
ylabel("Non-EEG recording")
xlabel("Frequency")
title("Non-EEG measures recorded alongside EEG")


% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.2, 0.2, 0.70, 0.50]);

% save the figure
fig_name = 'Clinical_pain_scale,Non_EEG_recording_ctr, horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))


%% 3 subplots

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'ClinicalPainScale'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_cps,categories] = histcounts(var); % counts the frequency of each category
[N_cps,idx] = sort(N_cps); % sort the counts array in descending order and get the indices
categoriesSorted_cps = categories(idx);

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'NonEEGRecording'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_neeg,categories] = histcounts(var); % counts the frequency of each category
[N_neeg,idx] = sort(N_neeg); % sort the counts array in descending order and get the indices
categoriesSorted_neeg = categories(idx);


figure;
subplot(2,2,1);
h = barh(categories_all,N_all_padded,'stacked');

% Customize the axes
xlabel('Number of clinical trial registrations');
title('Registrations distribution by various categories');

% Correctly map labels for each category
sub_labels_all = {recruitment_labels, study_design_labels, age_labels};

% Add text labels to the bars
for k = 1:size(N_all_padded, 1)
    x_offset = 0; % To accumulate the position for the label
    sub_labels = sub_labels_all{k}; % Get the labels for the current category
    for i = 1:length(sub_labels)
        if N_all_padded(k, i) > 0
            x_coord = x_offset + N_all_padded(k, i) / 2;
            y_coord = k;
            text(x_coord, y_coord, sub_labels{i}, 'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', 'Color', 'white', 'FontSize', 12);
            x_offset = x_offset + N_all_padded(k, i); % Update x_offset for the next label
        end
    end
end

subplot(2,2,2);
barh(N_cps);
yticks(1:numel(categoriesSorted_cps));
yticklabels(categoriesSorted_cps);
xlim([0,max([N_cps,N_neeg])+1]);
grid on;
% name the x and y axis of subplot 1
ylabel("Clinical pain scale")
xlabel("Frequency")
title("Clinical pain scales recorded alongside EEG")



subplot(2,2,4);
barh(N_neeg);
yticks(1:numel(categoriesSorted_neeg));
yticklabels(categoriesSorted_neeg);
xlim([0,max([N_cps,N_neeg])+1]);
grid on;
% name the x and y axis of subplot 2
ylabel("Non-EEG recording")
xlabel("Frequency")
title("Non-EEG measures recorded alongside EEG")


% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0.1, 0.9, 0.70]);

%% save the figure
fig_name = 'Age_design_recruitstat,Clinical_pain_scale,Non_EEG_recording_ctr, horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))


%% tabulate country

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'Country'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
countryTable = table(categories',N','VariableNames',{'Country','Counts'}); % creating the table
countryTable = sortrows(countryTable,"Counts","descend"); % sort into descending order based on the frequency

% save the table into excel file
table_name = 'ctr_Country.csv';

writetable(countryTable,strcat(path_to_output_folder, '/', table_name));

%% plot study sites

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'StudySite'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category
[N,idx] = sort(N,"descend"); % sort the counts array in descending order and get the indices

% create the figure
figure;
bar(N);
xticks(1:numel(categories));
xticklabels(categories(idx));
for i = 1:numel(N)
    text(i, N(i), cellstr(num2str(N(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N)+1]);
grid on;

% name the x and y axis of the figure
xlabel("Study site");
ylabel("Frequency");

% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);

% save the figure
fig_name = 'ctr_Study_site.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% sample size

var = rmmissing(dataframe.SampleSize);
medianSampleSize = quantile(var,0.5); % median
p25ss = quantile(var,0.25);  % lower quartile
p75ss = quantile(var,0.75);  % upper quartile
rss = iqr(var); % interquartile range

% count the number of studies included in calculations
rows_with_non_nan_SS = sum(~isnan(dataframe{:,'SampleSize'}));

%% age

% calculate min and max of age at birth
var = rmmissing(dataframe.AgeAtBirthMin);
minAgeBirth = min(var);

var = rmmissing(dataframe.AgeAtBirthMax);
maxAgeBirth = max(var);

% calculate min and max of age at study
var = rmmissing(dataframe.AgeAtStudyMin);
minAgeStudy = min(var);

var = rmmissing(dataframe.AgeAtStudyMax);
maxAgeStudy = max(var);

% count the number of studies included in the calculations
rows_with_non_nan_ageAtBirth = sum(any(~isnan(dataframe{:,{'AgeAtBirthMin','AgeAtBirthMax'}}),2));
rows_with_non_nan_ageAtStudy = sum(any(~isnan(dataframe{:,{'AgeAtStudyMin','AgeAtStudyMax'}}),2));

%% stimulus type

columnsToExtract_st = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'Stimulus'));

var = dataframe{:,columnsToExtract_st}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_st,categories_st] = histcounts(var); % counts the frequency of each category
[N_st,idx_st] = sort(N_st,"descend"); % sort the counts array in descending order and get the indices

%% plot stimulus type as a single plot
figure;
bar(N_st);
xticks(1:numel(categories_st));
xticklabels(categories_st(idx_st));
for i = 1:numel(N_st)
    text(i, N_st(i), cellstr(num2str(N_st(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N_st)+3]);
grid on;

% name the x and y axis of the figure
xlabel("Stimulus type")
ylabel("Frequency")

% save the figure
fig_name = 'ctr_Stimulus_type.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% body location

columnsToExtract_bl = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'BodyLocation'));

var = dataframe{:,columnsToExtract_bl}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_bl,categories_bl] = histcounts(var); % counts the frequency of each category
[N_bl,idx_bl] = sort(N_bl,"descend"); % sort the counts array in descending order and get the indices


% matching the stimulus type and body location
% NOTE: section 'stimulus type' should be run prior to running this line
st_per_bl = groupsummary(dataframe, [columnsToExtract_bl,columnsToExtract_st]);

%% plot body location as a single plot
figure;
bar(N_bl);
xticks(1:numel(categories_bl));
xticklabels(categories_bl(idx_bl));
for i = 1:numel(N_bl)
    text(i, N_bl(i), cellstr(num2str(N_bl(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N_bl)+2]);
grid on;

% name the x and y axis of the figure
xlabel("Body Location for Skin-Breaking Procedures")
ylabel("Frequency")

% name the figure
fig_name = 'ctr_Body_location.png';

% save the figure
exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot stimulus type and body location side by side
% (note: this command can only be run after running the section for
% stimulus type and for body location)

figure;
% subplot 1
subplot(1,2,1);
bar(N_st);
xticks(1:numel(categories_st));
xticklabels(categories_st(idx_st));
for i = 1:numel(N_st)
    text(i, N_st(i), cellstr(num2str(N_st(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max([N_bl,N_st])+2]);
grid on;
% name the x and y axis of subplot 1
xlabel("Stimulus type")
ylabel("Frequency")

% subplot 2
subplot(1,2,2);
bar(N_bl);
xticks(1:numel(categories_bl));
xticklabels(categories_bl(idx_bl));
for i = 1:numel(N_bl)
    text(i, N_bl(i), cellstr(num2str(N_bl(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max([N_bl,N_st])+2]);
grid on;
% name the x and y axis of subplot 2
xlabel("Body location")
ylabel("Frequency")

% save the figure
fig_name = 'ctr_Stimulus_type,Body_location.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% summarise electrode placement method

columnsToExtract_pm = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'ElectrodePlacementMethod'));

var = dataframe{:,columnsToExtract_pm}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
placementMethod = table(categories',N','VariableNames',{'PlacementMethod','Counts'});
placementMethod = sortrows(placementMethod,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'ctr_placementMethod.csv';
writetable(placementMethod, strcat(path_to_output_folder, '/', table_name));

% count the number of studies included in calculations
rows_with_non_nan_pm = sum(~ismissing(dataframe{:,columnsToExtract_pm}));

%% summarise electrode placement system

columnsToExtract_ps = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'ElectrodePlacementSystem'));

var = dataframe{:,columnsToExtract_ps}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
placementSys = table(categories',N','VariableNames',{'PlacementSystem','Counts'});
placementSys = sortrows(placementSys,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'ctr_placementSystem.csv';
writetable(placementSys, strcat(path_to_output_folder, '/', table_name));

% count the number of studies included in calculations
rows_with_non_nan_ps = sum(any(~ismissing(dataframe{:,columnsToExtract_ps}),2));

% matching the electrodes placement method and system
% NOTE: section 'summarise electrode placement method' should be run prior
% to running this line
ps_per_pm = groupsummary(dataframe, [columnsToExtract_pm,columnsToExtract_ps]);

%% EEG outcomes

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'OutcomeDomain'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category
[N,idx] = sort(N,"descend"); % sort the counts array in descending order and get the indices

% create the figure
figure;
bar(N);
xticks(1:numel(categories));
xticklabels(categories(idx));
for i = 1:numel(N)
    text(i, N(i), cellstr(num2str(N(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N)+1]);
grid on;

% name the x and y axis of the figure
xlabel("EEG Outcomes Domain");
ylabel("Frequency");

% save the figure
fig_name = 'ctr_Outcome_domain.png'; 

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name)) 

%% plot pharmacological modifier

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'PharmacologicalModifier'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category
[N,idx] = sort(N,"descend"); % sort the counts array in descending order and get the indices

% create the figure
figure;
bar(N);
xticks(1:numel(categories));
xticklabels(categories(idx));
for i = 1:numel(N)
    text(i, N(i), cellstr(num2str(N(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N)+1]);
grid on;

% name the x and y axis of the figure
xlabel("Pharmacological modifier");
ylabel("Frequency");

% save the figure
fig_name = 'ctr_Pharmacological_modifier.png'; 

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name)) 

%% close all figures
close all