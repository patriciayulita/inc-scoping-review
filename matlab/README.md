# Scoping review analysis (MATLAB)

This folder contains the MATLAB-based analysis used in a scoping review of neonatal EEG and pain. It generates all summary statistics, figures, and output data files included in the published article, based on the extracted data provided in this repository.

The analysis is designed to be run in a single step. All figures and tables will be saved automatically to an output folder.

## Folder contents

```
matlab/
├── code/
│   └── setup_working_dir.m     # Script to set up working directory
│   └── INCplot.m               # Main script to run the analysis 
│   └── raincloud_plot_PG.m     # Function to create raincloud plots (https://github.com/RainCloudPlots/RainCloudPlots.git)
├── data/
│   └── dataFrame_final.csv     # Dataset used in the analysis
└── result/                     # Created automatically when the script is run
```

## How to use this folder

1. Open `setup_working_dir.m` in MATLAB. Run the script. This sets the correct working directory. If a pop-up message appear asking to change working directory or add to path, choose change working directory.
2. Open `INCplot.m` in MATLAB. Run the script. All outputs will be saved to the `result/` folder.

## Output files and usage

Running the script generates:

- Seven `.csv` files:

  - `corr_authors_authorship.csv`   # list of all corresponding authors to invite to be involved in the scoping review project
  - `corr_authors_data.csv`         # list of all corresponding authors to invite for data sharing (the IPD meta-analysis project)
  - `CountryFreq.csv`               # list of countries where data for eligible studies were collected, using ISO (International Organization for Standardization) 3166-1 alpha-3 codes, alongside the number of studies for each country
  - `placementMethod_and_System.csv`# list of electrode placement methods used in eligible studies, alongside electrode placement system used and the number of studies for each group
  - `placementMethod.csv`           # list of electrode placement methods used in eligible studies and the number of studies for each method
  - `placementSystem.csv`           # list of electrode placement systems used in eligible studies and the number of studies for each system
  - `stimulus_bodyloc.csv`          # list of noxious skin-breaking stimulus type studied in eligible studies, alongside the body locations where each stimulus was applied and the number of studies for each group

- Twenty five `.png` figures:

  - `Age_at_birth_avg_raincloud_titled.png` 
  - `Age_at_birth_avg_raincloud.png`
  - `Age_at_study_avg_raincloud_titled.png`
  - `Age_at_study_avg_raincloud.png`
  - `Body_location.png`
  - `Clinical_pain_scale_barh.png`
  - `Clinical_pain_scale,Non_EEG_recording,horizontal.png`
  - `data_loss_percentage.png`
  - `electrodes_position.png`
  - `Epoch_rejection_method.png`
  - `Non_EEG_recording_horizontal.png`
  - `Number_of_published_studies_by_year_titled.png`
  - `Number_of_published_studies_by_year.png`
  - `Number_of_studies_by_year_stacked_titled.png`
  - `Number_of_studies_by_year_stacked.png`
  - `Outcome_domain_pie_counts.png`
  - `Outcome_modifier_barh.png`
  - `Reproducible_epoch_rejection_method.png`
  - `Sample_size_raincloud_titled.png`
  - `Sample_size_raincloud.png`
  - `Stimulus_type,Body_location_horizontal.png`
  - `Stimulus_type.png`
  - `Study_site_horizontal_title.png`
  - `Study_site_horizontal.png`
  - `Study_site.png`