# inc-scoping-review

This repository supports a scoping review of EEG-based studies of neonatal pain. It includes all the data, scripts, and visualizations used in the analysis and thesis manuscript. There is a separate repository for analysis and generating figures used in the manuscript submitted for publication in peer-reviewed journal.

The repository is organized into two folders:
- `matlab/`: Main MATLAB-based data analysis and figure generation
- `vosviewer/`: Co-authorship network analysis using VOSviewer

Each folder contains its own `README.md` file with detailed usage instructions.

## Folder Structure

```
📁 matlab/      # MATLAB analysis: runs statistics and creates figures
📁 vosviewer/   # VOSviewer network: co-authorship map of included studies
```

## How to Use This Repository

1. Start with the `matlab/` folder:
   - Run the main analysis script to generate all summary statistics and outputs.

3. Explore the `vosviewer/` folder:
   - Recreate or view the co-authorship network from the included `.ris` file or the exported map and network files.
   - Instructions are provided to reproduce the version used in the thesis.

Each folder has its own `README.md` with step-by-step guidance.

## Software Requirements

To use this repository fully, you’ll need:

- [MATLAB](https://www.mathworks.com/help/install/ug/install-products-with-internet-connection.html)  
- [VOSviewer](https://www.vosviewer.com/)

These tools work on most systems (Windows, macOS, Linux).

## Summary

This repository provides a fully reproducible workflow for the descriptive analysis of studies included in a scoping review on neonatal EEG and pain. It combines matlab-based data analysis and bibliometric visualization using VOSviewer, published in my doctoral thesis.

For questions or collaboration, please contact the repository maintainer.
