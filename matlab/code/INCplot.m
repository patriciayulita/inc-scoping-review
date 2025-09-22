%% set paths

clear;

path_to_input_folder = '../data';

path_to_output_folder = '../result';

dataframe_file = 'dataFrame_final.csv';

%% set up

% look if the path to the output folder exist. If not, make it
if ~exist(path_to_output_folder,'dir')
    mkdir(path_to_output_folder)
end

dataframe = readtable(strcat(path_to_input_folder, '/', dataframe_file));

dataframe = dataframe(~strcmp(dataframe.AnalysisGrouping, 'MultiPublication'), :);

%% tabulate country (n=55 unique reports)

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'Country'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest from the databases' data frame

% create the table
countryTable = table(var(:,1), var(:,2),'VariableNames',{'Country1','Country2'}); % creating the table

% save the table into excel file
table_name = 'Country.csv';

writetable(countryTable,strcat(path_to_output_folder, '/',table_name));

var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
countryTableFreq = table(categories',N','VariableNames',{'Country','Counts'}); % creating the table
countryTableFreq = sortrows(countryTableFreq,"Counts","descend"); % sort into descending order based on the frequency

% save the table into excel file
table_name = 'CountryFreq.csv';

writetable(countryTableFreq,strcat(path_to_output_folder, '/', table_name));

%% plot study sites (n=55 unique reports)

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
fig_name = 'Study_site.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot study sites horizontally (n=55 unique reports)

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'StudySite'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category
[N,idx] = sort(N); % sort the counts array in descending order and get the indices
categoriesSorted = categories(idx);

% create the figure
figure;
barh(N);
yticks(1:numel(categoriesSorted));
yticklabels(categoriesSorted);
xlim([0,max(N)+2]);
for i = 1:numel(N)
    text(N(i) + 0.2, i, string(N(i)), 'VerticalAlignment','middle');
end
grid on;

% name the x and y axis of the figure
ylabel("Data collection sites");
xlabel("Frequency");

% save the figure
fig_name = 'Study_site_horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Data collection sites")

% save the figure
fig_name = 'Study_site_horizontal_title.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% Authors to be contacted for data (n=55 unique reports)
columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'PersonToContactForData'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest

var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
corr_authors_data = table(categories',N','VariableNames',{'Authors','Counts'});
corr_authors_data = sortrows(corr_authors_data,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'corr_authors_data.csv';
writetable(corr_authors_data, strcat(path_to_output_folder, '/', table_name));

%% Authors to be contacted for authorship (n=55 unique reports)
columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'PersonToContactForAuthorship'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest

var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
corr_authors_auth = table(categories',N','VariableNames',{'Authors','Counts'});
corr_authors_auth = sortrows(corr_authors_auth,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'corr_authors_authorship.csv';
writetable(corr_authors_auth, strcat(path_to_output_folder, '/', table_name));

%% plot studies by year (n=55 unique reports)

columnsToExtract = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'Year'));
columnsToExtract_rt = dataframe.Properties.VariableNames(contains(dataframe.Properties.VariableNames, 'RecordType'));

var = dataframe{:,columnsToExtract}; % extract all rows of the column of interest from the databases' data frame

categories = categorical(min(var):max(var)); % make an array with a value range of the minimum and the maximum of the data, then change it back to categorical type
subcategories = {'Clinical trial registration' 'Peer-reviewed and published methods paper' 'Peer-reviewed and published protocol' 'Published paper containing analysable EEG details'}; % create the group for record type categories

% replace all non methods, non protocol paper, and non-CTR to 'Published paper containing analysable EEG details'
num_row_df = size(dataframe,1);

for i = 1:num_row_df
    if strcmp(dataframe.RecordType{i}, 'Clinical trial registration')
        % Do nothing, keep 'Clinical trial registration' as it is
    elseif strcmp(dataframe.RecordType{i}, 'Peer-reviewed and published methods paper')
        % Do nothing, keep 'Peer-reviewed and published methods paper' as it is
    elseif strcmp(dataframe.RecordType{i}, 'Peer-reviewed and published protocol')
        % Do nothing, keep 'Peer-reviewed and published protocol' as it is
    else
        % Replace non-'Peer-reviewed and published methods paper' and non-'Peer-reviewed and published protocol' cells with 'Published paper containing analysable EEG details'
        dataframe.RecordType{i} = 'Published paper containing analysable EEG details';
    end
end

M = zeros(numel(subcategories),numel(categories));

dataframe.Year = categorical(dataframe.Year);
dataframe.RecordType = categorical(dataframe.RecordType);

for i = 1:numel(categories)
    for j = 1:numel(subcategories)
        M(j,i) = sum(dataframe.Year(:)==categories(i) & dataframe.RecordType(:)==subcategories(j));
    end
end

% count frequency per year
var = categorical(var); % convert array to categorical
N = histcounts(var,categories);

% Define colors for each subcategory
colors = [0.84 0.31 0.04;  % Subcategory 1 color RGB ('Clinical trial registration')
          0.95 0.73 0.02;  % Subcategory 2 color RGB ('Peer-reviewed and published methods paper')
          0.94 0.94 0.79;  % Subcategory 3 color hexcode ('Peer-reviewed and published protocol')
          0.15 0.37 0.61]; % Subcategory 4 color hexcode ('Published paper containing analysable EEG details')

% create the stacked figure
%--------------------------
figure;
bar(M','stacked');
xticks(1:numel(categories));
xticklabels(categories);
for i = 1:numel(N)
    text(i, N(i), cellstr(num2str(N(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N)+1]);
grid on;

% customise color
for i = 1:size(M, 1)
    set(gca, 'ColorOrder', colors, 'NextPlot', 'replacechildren');
end

% name the x and y axis of the figure
xlabel("Year");
ylabel("Number of studies");

legend(subcategories, 'Location', 'northwest'); % Legend for subcategories

% scale the figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.2, 0.1, 0.45, 0.75]);

% save the figure
fig_name = 'Number_of_studies_by_year_stacked.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Number of studies per year",'FontSize',12)

% save the figure
fig_name = 'Number_of_studies_by_year_stacked_titled.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% create the NON-stacked figure
%--------------------------
figure;
bar(N);
xticks(1:numel(categories));
xticklabels(categories);
yticks(0:2:numel(N));
for i = 1:numel(N)
    text(i, N(i), cellstr(num2str(N(i))), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
ylim([0,max(N)+1]);
grid on;

% name the x and y axis of the figure
xlabel("Year");
ylabel("Number of publication");

% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.3, 0.3, 0.7, 0.4]);

% save the figure
fig_name = 'Number_of_published_studies_by_year.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Number of published studies by year",'FontSize',12)

% save the figure
fig_name = 'Number_of_published_studies_by_year_titled.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% set up_2

dataframe_f = dataframe(strcmp(dataframe.AnalysisGrouping, 'DetailedStudy'), :);

% keep columns with data only
dataframe_f(:,all(ismissing(dataframe_f)))=[];

%% sample size (n=44 reports containing analysable EEG details)

var = rmmissing(dataframe_f.SampleSize);

% save the table
table_name = 'sampleSize.csv';
writematrix(var, strcat(path_to_output_folder, '/', table_name));

medianSampleSize = quantile(var,0.5); % median
p25ss = quantile(var,0.25);  % lower quartile
p75ss = quantile(var,0.75);  % upper quartile
rss = iqr(var); % interquartile range

% count the number of studies included in calculations
rows_with_non_nan_SS = sum(~isnan(dataframe_f{:,'SampleSize'}));

% create raincloud plot
figure;
raincloud_plot_PG(var, 'color', [0.15 0.37 0.61], 'band_width',0.2, 'xlim_ks', [0 270],'box_on', 1, 'box_dodge', 1, 'cloud_edge_col', [0.15 0.37 0.61], 'lwr_bnd', 0.8);
xticks(0:10:max(var)+10);
xlabel("Number of babies")

% Remove default y-tick marks and labels
yticks([]);          % Set y-tick marks to empty array
yticklabels({});     % Set y-tick labels to empty cell array

% adjust the figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.3, 0.5, 0.45, 0.25]);

% save the figure
fig_name = 'Sample_size_raincloud.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Number of babies with EEG recorded per study")

% save the figure
fig_name = 'Sample_size_raincloud_titled.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% sex ratio

% create variable for total number of male and female
dataframe_f.MaleFemaleTotal = dataframe_f.MaleN + dataframe_f.FemaleN;

% create variable for female percentage
dataframe_f.FemalePercentage = (dataframe_f.FemaleN ./ dataframe_f.MaleFemaleTotal) * 100;

% calculate the mean of the percentages
meanFemaleP = mean(dataframe_f.FemalePercentage,"omitnan");
meanMaleP = 100-meanFemaleP;

% count the number of studies included in calculations
rows_with_non_nan_FemaleP = sum(~isnan(dataframe_f{:,'FemalePercentage'}));

%% calculate min, max of age at birth

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'AgeAtBirthM'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = rmmissing(var);
r_newvar = size(var,2) .* size(var,1);
var = reshape(var,[r_newvar,1]);

minAgeBirth = min(var);
maxAgeBirth = max(var);

% count the number of studies included in the calculations
rows_with_non_nan_ageAtBirth = sum(any(~isnan(dataframe_f{:,{'AgeAtBirthMin','AgeAtBirthMax'}}),2));

%% calculate min, max of age at study

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'AgeAtStudyM'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = rmmissing(var);
r_newvar = size(var,2) .* size(var,1);
var = reshape(var,[r_newvar,1]);

minAgeStudy = min(var);
maxAgeStudy = max(var);

% count the number of studies included in the calculations
rows_with_non_nan_ageAtStudy = sum(any(~isnan(dataframe_f{:,{'AgeAtStudyMin','AgeAtStudyMax'}}),2));

%% calculate average of age at birth and age of study

var2_b = rmmissing(dataframe_f.AgeAtBirthAvg);
avgAgeBirth = mean(var2_b); 

medianAgeAtBirthAvg = quantile(var2_b,0.5); % median
p25birthAvg = quantile(var2_b,0.25);  % lower quartile
p75birthAvg = quantile(var2_b,0.75);  % upper quartile

var2_s = rmmissing(dataframe_f.AgeAtStudyAvg);
avgAgeStudy = mean(var2_s);

medianAgeAtStudyAvg = quantile(var2_s,0.5); % median
p25studyAvg = quantile(var2_s,0.25);  % lower quartile
p75studyAvg = quantile(var2_s,0.75);  % upper quartile

% create raincloud plot for avg of age at birth

figure;
raincloud_plot_PG(var2_b, 'color', [0.15 0.37 0.61], 'band_width',0.2, 'xlim_ks', [round(min([var2_b;var2_s]))-1, round(max([var2_b;var2_s]))+1], 'box_on', 1, 'box_dodge', 1, 'cloud_edge_col', [0.15 0.37 0.61], 'lwr_bnd', [0.8]);
xticks(round(min([var2_b;var2_s]))-1:3:round(max([var2_b;var2_s]))+1);
xlim([round(min([var2_b;var2_s]))-1,round(max([var2_b;var2_s]))+1]);
xlabel("Gestational age (weeks)")

% Remove default y-tick marks and labels
yticks([]);          % Set y-tick marks to empty array
yticklabels({});     % Set y-tick labels to empty cell array

% adjust the figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.3, 0.3, 0.6, 0.30]);

% save the figure
fig_name = 'Age_at_birth_avg_raincloud.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Average age at birth of babies included in the studies")

% save the figure
fig_name = 'Age_at_birth_avg_raincloud_titled.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% count the number of studies included in the calculations
rows_with_non_nan_AvgAgeAtBirth = sum(~isnan(dataframe_f{:,'AgeAtBirthAvg'}));

%% create raincloud plot for avg of age at study
% note: average at birth section must be run prior to running this

figure;
raincloud_plot_PG(var2_s, 'color', [0.15 0.37 0.61], 'band_width',0.2, 'xlim_ks', [round(min([var2_b;var2_s]))-1, round(max([var2_b;var2_s]))+1], 'box_on', 1, 'box_dodge', 1, 'cloud_edge_col', [0.15 0.37 0.61], 'lwr_bnd', [0.8]);
xticks(round(min([var2_b;var2_s]))-1:3:round(max([var2_b;var2_s]))+1);
xlim([round(min([var2_b;var2_s]))-1,round(max([var2_b;var2_s]))+1]);
xlabel("Post-menstrual age (weeks)")

% Remove default y-tick marks and labels
yticks([]);          % Set y-tick marks to empty array
yticklabels({});     % Set y-tick labels to empty cell array

% adjust the figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.3, 0.3, 0.6, 0.30]);

% save the figure
fig_name = 'Age_at_study_avg_raincloud.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% add title
title("Average age at study of babies included in the studies")

% save the figure
fig_name = 'Age_at_study_avg_raincloud_titled.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% count the number of studies included in the calculations
rows_with_non_nan_AvgAgeAtStudy = sum(~isnan(dataframe_f{:,'AgeAtStudyAvg'}));

%% stimulus type

columnsToExtract_st = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'Stimulus'));

var = dataframe_f{:,columnsToExtract_st}; % extract all rows of the column of interest
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
fig_name = 'Stimulus_type.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% body location

columnsToExtract_bl = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'BodyLocation'));

var = dataframe_f{:,columnsToExtract_bl}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_bl,categories_bl] = histcounts(var); % counts the frequency of each category
[N_bl,idx_bl] = sort(N_bl,"descend"); % sort the counts array in descending order and get the indices

% matching the stimulus type and body location
% NOTE: section 'stimulus type' should be run prior to running this line
st_per_bl = groupsummary(dataframe_f, [columnsToExtract_bl,columnsToExtract_st]);

% save the table into excel file
table_name = 'stimulus_bodyloc.csv';

writetable(st_per_bl,strcat(path_to_output_folder, '/', table_name));
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
fig_name = 'Body_location.png';

% save the figure
exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot horizontal stimulus type and body location side by side
% (note: this command can only be run after running the section for
% stimulus type and for body location)

columnsToExtract_st = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'Stimulus'));

var = dataframe_f{:,columnsToExtract_st}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_st,categories_st] = histcounts(var); % counts the frequency of each category
[N_st,idx_st] = sort(N_st,"ascend"); % sort the counts array in ascending order and get the indices

columnsToExtract_bl = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'BodyLocation'));

var = dataframe_f{:,columnsToExtract_bl}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_bl,categories_bl] = histcounts(var); % counts the frequency of each category
[N_bl,idx_bl] = sort(N_bl,"ascend"); % sort the counts array in ascending order and get the indices

figure;
% subplot 1
subplot(2,1,1);
bst=barh(N_st);
yticks(1:numel(categories_st));
yticklabels(categories_st(idx_st));
xticks(0:5:max(N_st)+3);
xlim([0,max(N_st)+3]);
for i = 1:numel(N_st)
    text(N_st(i) + 0.2, i, string(N_st(i)), 'VerticalAlignment','middle');
end
grid on;
% name the x and y axis of subplot 1
ylabel("Stimulus type")
xlabel("Frequency")

% subplot 2
subplot(2,1,2);
bbl=barh(N_bl);
yticks(1:numel(categories_bl));
yticklabels(categories_bl(idx_bl));
xticks(0:5:max(N_bl)+3);
xlim([0,max(N_bl)+3]);
for i = 1:numel(N_bl)
    text(N_bl(i) + 0.2, i, string(N_bl(i)), 'VerticalAlignment','middle');
end
grid on;
% name the x and y axis of subplot 2
ylabel("Body location")
xlabel("Frequency")

% % maximize the figure to cover the entire screen
% set(gcf, 'Units', 'normalized', 'OuterPosition', [0.2, 0.2, 0.70, 0.50]);
% 
% save the figure
fig_name = 'Stimulus_type,Body_location_horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% summarise electrode placement method

columnsToExtract_pm = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'ElectrodePlacementMethod'));

var = dataframe_f{:,columnsToExtract_pm}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
placementMethod = table(categories',N','VariableNames',{'PlacementMethod','Counts'});
placementMethod = sortrows(placementMethod,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'placementMethod.csv';
writetable(placementMethod, strcat(path_to_output_folder, '/', table_name));

% count the number of studies included in calculations
rows_with_non_nan_pm = sum(~ismissing(dataframe_f{:,columnsToExtract_pm}));

%% summarise electrode placement system

columnsToExtract_ps = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'ElectrodePlacementSystem'));

var = dataframe_f{:,columnsToExtract_ps}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category

% create the table
placementSys = table(categories',N','VariableNames',{'PlacementSystem','Counts'});
placementSys = sortrows(placementSys,"Counts","descend"); % sort into descending order based on the frequency

% save the table
table_name = 'placementSystem.csv';
writetable(placementSys, strcat(path_to_output_folder, '/', table_name));

% count the number of studies included in calculations
rows_with_non_nan_ps = sum(any(~ismissing(dataframe_f{:,columnsToExtract_ps}),2));

% matching the electrodes placement method and system
% NOTE: section 'summarise electrode placement method' should be run prior
% to running this line
ps_per_pm = groupsummary(dataframe_f, [columnsToExtract_pm,columnsToExtract_ps]);

% save the table
table_name = 'placementMethod_and_System.csv';
writetable(ps_per_pm, strcat(path_to_output_folder, '/', table_name));

%% plot electrodes position

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'e_position'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
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
ylim([0,max(N)+2]);
grid on;

% name the x and y axis of the figure
xlabel("Electrodes' position");
ylabel("Counts");

% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0, 0, 1, 1]);

% save the figure
fig_name = 'electrodes_position.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

% count the number of studies included in calculations
rows_with_non_nan_epos = sum(any(~ismissing(dataframe_f{:,columnsToExtract}),2));

%% plot reproducible epoch rejection method

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'ReproducibleEpochRejectionMethod'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
var = renamecats(var,{'y' 'n' 'mixed' 'np'},{'Yes' 'No' 'Mixed' 'Not provided'}); % rename the categories
var = reordercats(var,["Yes" "No" "Mixed" "Not provided"]); % reorder the categories
[N,~] = histcounts(var); % counts the frequency of each category

figure;
p = pie(var);

% modify the figure to include counts on top of percentages
pText = findobj(p,'Type','text'); % find the text in the figure
str_counts = string(N(:)); % reshape from row to column array (to match the pText format) then convert it to string
percent = round((N ./ sum(N)) * 100); % create an array for the percentages
str_percent = string(percent(:)); % reshape from row to column array (to match the pText format) then convert it to string

% create the template for the text in the figure
txt1 = {'Yes: ';'No: ';'Mixed: ';'Not provided: '};
txt2 = {' (';' (';' (';' ('};
txt3 = {'%)';'%)';'%)';'%)'};
combinedtext = strcat(txt1,str_counts,txt2,str_percent,txt3);

% apply the modified text to the figure
pText(1).String = combinedtext(1);
pText(2).String = combinedtext(2);
pText(3).String = combinedtext(3);

% add title
title("Epoch rejection method",'FontSize',14)

% save the figure
fig_name = 'Reproducible_epoch_rejection_method.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot epoch rejection method

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'EpochRejMethod'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
var = reordercats(var,["Objective" "Subjective" "Mixed" "Undocumented"]); % reorder the categories
var = renamecats(var,["Automatic" "Manual" "Semi-automatic" "Undocumented"]);
[N,cat] = histcounts(var); % counts the frequency of each category

figure;
p = pie(var);

% modify the figure to include counts on top of percentages
pText = findobj(p,'Type','text'); % find the text in the figure
str_counts = string(N(:)); % reshape from row to column array (to match the pText format) then convert it to string
percent = round((N ./ sum(N)) * 100); % create an array for the percentages
str_percent = string(percent(:)); % reshape from row to column array (to match the pText format) then convert it to string

% create the template for the text in the figure
txt1 = {' (';' (';' (';' ('};
txt2 = {'%)';'%)';'%)';'%)'};
combinedtext = strcat(str_counts,txt1,str_percent,txt2);

% apply the modified text to the figure
pText(1).String = combinedtext(1);
pText(2).String = combinedtext(2);
pText(3).String = combinedtext(3);
pText(4).String = combinedtext(4);

set(findobj(p,'type','text'),'fontsize',10);

% Create legend
legend(cat,'Location','bestoutside','FontSize',12);

% add title
title("Epoch rejection method",'FontSize',14)

% save the figure
fig_name = 'Epoch_rejection_method.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% data loss percentage

% generate new variable for data loss percentage
dataframe_f.DataLossPercentage = (dataframe_f.NumDataLossQualityIssue ./ dataframe_f.SampleSize) * 100;

% save the table
table_name = 'dataFrame_f_dlp.csv';
writetable(dataframe_f, strcat(path_to_output_folder, '/', table_name));

% calculate the median of data loss percentage
var = rmmissing(dataframe_f.DataLossPercentage);
medianDataLossP = quantile(var,0.5); % median
p25dlp = quantile(var,0.25);  % lower quartile
p75dlp = quantile(var,0.75);  % upper quartile
min_dlp = min(var);
max_dlp = max(var);

% count the number of studies included in calculations
rows_with_non_nan_dlp = sum(~isnan(dataframe_f{:,'DataLossPercentage'}));

% create raincloud plot for data loss percentage
figure;
raincloud_plot_PG(var, 'color', [0.15 0.37 0.61], 'band_width', [0.2], 'xlim_ks', [-1 50], 'box_on', 1, 'box_dodge', 1, 'cloud_edge_col', [0.15 0.37 0.61], 'lwr_bnd',[0.8]);
xticks(0:5:50);
xlim([0,50]);
xlabel("Percentage of data loss")

% Remove default y-tick marks and labels
yticks([]);          % Set y-tick marks to empty array
yticklabels({});     % Set y-tick labels to empty cell array

% adjust the figure
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.3, 0.3, 0.45, 0.30]);

% add title
title("Data loss due to artefacts")

% save the figure
fig_name = 'data_loss_percentage.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% EEG outcomes - create pie-chart figure

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'OutcomeDomain'));
var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
%var = fillmissing(var,'constant','No information');
var = reordercats(var,["Temporal" "Frequency" "Time-frequency"]); % reorder the categories
[N,categories] = histcounts(var); % counts the frequency of each category

% pie figure with count and percentage
figure;
p = pie(var);

% modify the figure to include counts on top of percentages
pText = findobj(p,'Type','text'); % find the text in the figure
str_counts = string(N(:)); % reshape from row to column array (to match the pText format) then convert it to string
percent = round((N ./ sum(N)) * 100); % create an array for the percentages
str_percent = string(percent(:)); % reshape from row to column array (to match the pText format) then convert it to string

% create the template for the text in the figure
% txt1 = {'Amplitude threshold: ';'Subjective method: ';'Algorithm-visual inspection combination: ';'No information: '};
txt2 = {' (';' (';' ('};
txt3 = {'%)';'%)';'%)'};
combinedtext = strcat(str_counts,txt2,str_percent,txt3);

% apply the modified text to the figure
pText(1).String = combinedtext(1);
pText(2).String = combinedtext(2);
pText(3).String = combinedtext(3);
%pText(4).String = combinedtext(4);

set(findobj(p,'type','text'),'fontsize',8);

% Create legend
legend(categories,'Location','bestoutside','FontSize',12);

% add title
title("EEG outcome domain",'FontSize',14)

% save the figure
fig_name = 'Outcome_domain_pie_counts.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% Outcome-modifier horizontal bar

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'PharmacologicalModifier'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N,categories] = histcounts(var); % counts the frequency of each category
[N,idx] = sort(N,"ascend"); % sort the counts array in descending order and get the indices

% create the figure (horizontal bar)
figure;
barh(N);
yticks(1:numel(categories(idx)));
yticklabels(categories(idx));
xticks(0:1:max(N)+1);
xlim([0,max(N)+1]);
for i = 1:numel(N)
    text(N(i) + 0.1, i, string(N(i)), 'VerticalAlignment','middle');
end
grid on;

% name the x and y axis of the figure
ylabel("Pain-relief interventions");
xlabel("Frequency");

% add title
%title("Pain-relief interventions")

% save the figure
fig_name = 'Outcome_modifier_barh.png'; 

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name)) 

%% plot clinical pain scale horizontally

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'ClinicalPainScale'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_cps,categories] = histcounts(var); % counts the frequency of each category
[N_cps,idx] = sort(N_cps); % sort the counts array in ascending order and get the indices
categoriesSorted_cps = categories(idx);

figure;
barh(N_cps);
yticks(1:numel(categoriesSorted_cps));
yticklabels(categoriesSorted_cps);
xticks(0:1:max(N_cps)+1);
xlim([0,max(N_cps)+1]);
grid on;

% name the x and y axis of the figure
ylabel("Clinical pain scale");
xlabel("Frequency");

% add title
title("Clinical pain scales recorded alongside EEG")

% save the figure
fig_name = 'Clinical_pain_scale_barh.png'; 

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name)) 

%% plot non EEG recording horizontally

columnsToExtract = dataframe_f.Properties.VariableNames(contains(dataframe_f.Properties.VariableNames, 'NonEEGRecording'));

var = dataframe_f{:,columnsToExtract}; % extract all rows of the column of interest
var = categorical(var); % convert array to categorical
[N_neeg,categories] = histcounts(var); % counts the frequency of each category
[N_neeg,idx] = sort(N_neeg); % sort the counts array in descending order and get the indices
categoriesSorted_neeg = categories(idx);

% create the figure
figure;
barh(N_neeg);
yticks(1:numel(categoriesSorted_neeg));
yticklabels(categoriesSorted_neeg);
xlim([0,max(N_neeg)+2]);
grid on;

% name the x and y axis of the figure
ylabel("Non-EEG recording");
xlabel("Frequency");

% add title
title("Non-EEG measures recorded alongside EEG")

% save the figure
fig_name = 'Non_EEG_recording_horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))

%% plot horizontal clinical pain scales and non-EEG recordings side by side
% (note: this command can only be run after running the section for
% horizontal clinical pain scales and non-EEG recordings)

figure;
% subplot 1
subplot(1,2,1);
barh(N_cps);
yticks(1:numel(categoriesSorted_cps));
yticklabels(categoriesSorted_cps);
xticks(0:2:max(N_cps)+1);
xlim([0,max(N_cps)+1]);
for i = 1:numel(N_cps)
    text(N_cps(i) + 0.1, i, string(N_cps(i)), 'VerticalAlignment','middle');
end
grid on;
% name the x and y axis of subplot 1
ylabel("Clinical pain scale")
xlabel("Frequency")
%title("Clinical pain scales recorded alongside EEG")

% subplot 2
subplot(1,2,2);
barh(N_neeg);
yticks(1:numel(categoriesSorted_neeg));
yticklabels(categoriesSorted_neeg);
xticks(0:2:max(N_neeg)+2);
xlim([0,max(N_neeg)+2]);
for i = 1:numel(N_neeg)
    text(N_neeg(i) + 0.2, i, string(N_neeg(i)), 'VerticalAlignment','middle');
end
grid on;
% name the x and y axis of subplot 2
ylabel("Non-EEG recording")
xlabel("Frequency")
%title("Non-EEG measures recorded alongside EEG")

% maximize the figure to cover the entire screen
set(gcf, 'Units', 'normalized', 'OuterPosition', [0.2, 0.2, 0.70, 0.50]);

% save the figure
fig_name = 'Clinical_pain_scale,Non_EEG_recording,horizontal.png';

exportgraphics(gcf,strcat(path_to_output_folder, '/', fig_name))
%% close all figures
close all
