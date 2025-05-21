# Smartphone-Based Pupillometry for Stress Monitoring

## Project Overview
This repository contains the R code and documentation for a research study investigating the feasibility of using smartphone-based pupillometry to monitor psychological stress levels. The study explores the relationship between pupil size (measured as pupil-to-iris ratio) and heart rate variability (HRV) under varying stress conditions induced by playing the Tetris game at different difficulty levels. The experiments aim to validate pupil size as a non-invasive, cost-effective physiological indicator of stress, using HRV as a benchmark.

The project includes two experiments:
1. **Experiment 1**: Examines the effect of stress levels (easy vs. difficult Tetris levels) on pupil size and HRV with 18 participants.
2. **Experiment 2**: Refines the experimental design with a baseline measurement, increased Tetris difficulty (Level 15), and procedural improvements, involving 17 participants.

Additionally, a pre-study assesses the effect of screen luminance on pupil size to rule out confounding factors.

## Repository Contents
- **R Scripts**:
  - `stress_analysis.R`: Main script for data processing, statistical analysis (ANOVA, sign tests, Wilcoxon signed-rank tests, McNemar's tests), and visualization (bar plots, violin plots with boxplots).
  - The script processes data from Excel files (`test 2.xlsx` and `Fyp Data.xlsx`), performs statistical tests, and generates visualizations to analyze pupil size and HRV under different stress conditions.
- **Data**:
  - `test 2.xlsx`: Dataset for the second experiment, containing pupil-to-iris ratio and HRV measurements for baseline (R1), break (R2), Level 1, and Level 15 conditions.
  - `Fyp Data.xlsx`: Dataset for the pre-study and additional analyses, including screen vs. no-screen pupil measurements and Level 1 vs. Level 10 comparisons.
- **Figures**:
  - Bar plots for mean pupil size and HRV across conditions.
  - Violin plots with boxplots for visualizing the distribution of pupil size and HRV.
- **Tables**:
  - Contingency tables for analyzing the interdependence of pupil size and HRV changes.
  - Statistical test results (sign tests, Wilcoxon signed-rank tests, McNemar's tests).
- **Documentation**:
  - `Abstract`: Summarizes the study's objectives, methods, and findings.
  - `Contents`: Outlines the structure of the research report.
  - `List of Figures and Tables`: References visualizations and tables used in the analysis.
  - `Introduction, Literature Review, Methodology, Results and Discussion, Conclusion`: Detailed sections from the research report, providing context, background, experimental design, results, and future work.

## Prerequisites
To run the R script, ensure the following are installed:
- **R** (version 4.0 or higher)
- **R Packages**:
  ```R
  install.packages(c("readxl", "ggpubr", "ez", "dplyr", "reshape2", "coin", "nparld", "gtools", "BSDA"))
  ```
- **Excel Files**:
  - Place `test 2.xlsx` and `Fyp Data.xlsx` in the working directory: `C:/Users/sints/OneDrive - City University of Hong Kong - Student/Desktop/Fyp Test/FypTest2 Data`.

## Installation and Setup
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/stress-pupillometry.git
   ```
2. Set the working directory in R:
   ```R
   setwd("path/to/your/directory")
   ```
3. Ensure the required Excel files are in the specified directory.
4. Run the R script:
   ```R
   source("stress_analysis.R")
   ```

## Usage
The R script performs the following tasks:
1. **Data Loading and Preprocessing**:
   - Reads Excel files and reshapes data into a long format for analysis.
   - Creates a `Condition` variable to categorize measurements (e.g., R1Ratio, R1HRV, Level1Ratio, Level15HRV).
2. **Statistical Analysis**:
   - Conducts repeated measures ANOVA to test the effect of stress conditions on pupil size and HRV.
   - Performs post-hoc sign tests and Wilcoxon signed-rank tests for pairwise comparisons.
   - Uses McNemar's test to analyze the interdependence of pupil size and HRV changes.
3. **Visualization**:
   - Generates bar plots for mean pupil size and HRV across conditions.
   - Creates violin plots with boxplots to show the distribution of pupil size and HRV.
4. **Pre-Study Analysis**:
   - Tests the effect of screen luminance on pupil size using sign tests and Wilcoxon signed-rank tests.

To reproduce the results:
- Ensure the Excel files are correctly formatted and located in the specified directory.
- Run the script in R or RStudio to generate statistical outputs and visualizations.

## Key Findings
- **Screen Luminance**: No significant effect of screen light on pupil size was found (p > 0.05), indicating minimal confounding influence in the experimental setup.
- **First Experiment**: No significant differences in pupil size or HRV between easy and difficult Tetris levels, possibly due to insufficient stress induction or measurement issues (e.g., wristband placement, glasses removal).
- **Second Experiment**:
  - ANOVA revealed significant effects of stress conditions on both HRV (p < 0.001) and pupil size (p < 0.001).
  - Post-hoc tests showed significant differences in HRV and pupil size between high-difficulty (Level 15) and baseline/lower-difficulty conditions.
  - McNemar's tests indicated significant interdependence between pupil size and HRV changes under high-stress conditions (e.g., R1 vs. Level 15, p = 0.0003).
- **Conclusion**: Smartphone-based pupillometry is a feasible, non-invasive method for stress monitoring, with pupil size changes correlating with HRV under high-stress conditions.

## Limitations
- **Environmental Factors**: Variations in ambient light may affect pupil size measurements in real-world settings.
- **Device Variability**: Differences in smartphone camera quality and processing power may impact the accuracy of pupillometry.
- **Sample Size**: The small sample size (18 and 17 participants) limits the generalizability of findings.

## Future Work
- Increase sample size to enhance statistical power and enable parametric testing.
- Develop machine learning models for continuous stress monitoring using pupil data in diverse environments.
- Explore compatibility with various smartphone models to improve scalability.

## References
The full list of references is included in the research report (see `References` section). Key citations include:
- Hess and Polt (1964) on pupil size and cognitive effort.
- Pedrotti et al. (2014) on pupil diameter for stress detection.
- Yelamanchili et al. (2017) on Tetris as a stress-inducing method.

## Contact
For questions or contributions, please contact sintsun01@gmail.com
