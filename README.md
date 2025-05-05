# EEG-rTMS-Project-Report

## 📄 Evaluating the Impact of Inhibitory rTMS on Source-Localized BCI Training for Motor Imagery 

[![View PDF Report](https://img.shields.io/badge/View%20Report-PDF-blue?style=flat-square&logo=adobe)](Neural_Engineering_Project_Report.pdf)

> **Note:** You can also click the badge above or use the link below  
> [**Open the full PDF report**](Neural_Engineering_Project_Report.pdf)
>


Based on your project structure, code files, and detailed content in the report, here is a professional `README.md` suitable for a GitHub repository:

---

# Inhibitory rTMS Impact on Source-Localized MI-BCI Training

This repository contains the code, data, and analysis scripts used in our project: **"Evaluating the Impact of Inhibitory rTMS on Source-Localized BCI Training for Motor Imagery"**. We investigate how low-frequency repetitive transcranial magnetic stimulation (rTMS) affects brain–computer interface (BCI) learning, comparing feature discriminability and performance across sensor and source space.

---

## 📁 Project Directory

```
.
├── Code
│   ├── Analysis
│   │   ├── ElectrodeSpace
│   │   │   ├── feature_extraction.m
│   │   │   ├── fisher_scores.m
│   │   │   ├── integral_psd.m
│   │   │   ├── stat_analysis.m
│   │   │   └── topoplot.m
│   │   └── SourceSpace
│   │       └── feature_extraction.m
│   └── Preprocessing
│       ├── convertGDFtoMAT.m
│       └── task_segmentation.m
├── chanlocs64.mat
├── subj_204.mat
└── subj_210.mat
```

---

## 📌 Key Components

### `Preprocessing/`

* `ConvertgdftoMAT.m`: Converts raw `.gdf` EEG files into MATLAB-readable `.mat` structs.
* `task_segmentation.m`: Segments trials into `rest_EEG` and `move_EEG` (100 trials each per session: S1=40, S2=30, S3=30 trials per class).

### `Analysis/ElectrodeSpace/`

* `FeatureExtraction.m`: Extracts 64x14 PSD features (4–30 Hz, 2 Hz resolution) per channel per trial using Welch's method.
* `fisher_scores.m`: Computes Fisher scores for each PSD feature across sessions.
* `stat_analysis.m`: Performs statistical t-tests comparing feature discriminability across sessions using both full-head and 38-channel SMR subset.
* `topoplot.m`: Generates session-wise scalp maps of Fisher scores to visualize spatial changes in MI separability.
* `integral_psd.m`: Computes area under PSD curves to analyze energy distribution by frequency band.

### `Analysis/SourceSpace/`

* `FeatureExtraction.m`: Extracts Riemannian geometry-based features from source-level covariance matrices.

  * Features: `MaxEig`, `EigRatio`, `FrobeniusNorm`, `LogDet`, `Trace`
  * Evaluates Fisher score of each feature over sessions.

---

## Results Overview

* **Sensor-space**:

  * Statistically significant improvements in Fisher scores from Session 1→2.
  * Decrease in scores post-rTMS (Session 2→3), confirming inhibitory effect.
  * Topoplots visually highlight changes across 64 EEG channels.

* **Source-space**:

  * No clear trend of training improvement or rTMS degradation.
  * Feature discriminability remained flat across sessions.
  * Suggests potential mismatch between TMS-targeted parcels and actual subject strategy.

---

## Report

Read our full report here: [`Neural_Engineering_Project_Report.pdf`](./Neural_Engineering_Project_Report.pdf)

---

## Requirements

* MATLAB R2023a+
* EEGLAB Toolbox
* Python (for `.gdf` reading with MNE)
* FieldTrip (optional for inverse modeling support)

---

## Citation

> Chae, T., Fletcher, E., Niu, H., Zhou, Y. (2025). *Evaluating the Impact of Inhibitory rTMS on Source-Localized BCI Training for Motor Imagery*. UT Austin, Neural Engineering Course 374N/385J.

