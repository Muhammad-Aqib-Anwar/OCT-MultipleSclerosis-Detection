# Deep Learning Framework Leveraging Graph-Based Retinal Layers Segmentation in Volumetric OCT with Custom CNN for Multiple Sclerosis Detection

[Propose Framework](https://github.com/user-attachments/files/29804784/Block.Diagram.v3.pdf)

## 📌 Overview

This repository contains the complete implementation code for the paper:

**"Deep Learning Framework Leveraging Graph-Based Retinal Layers Segmentation in Volumetric OCT with Custom CNN for Multiple Sclerosis Detection"**

Classifies **Multiple Sclerosis (MS)** vs **Control** participants using a public dataset.

Pipeline:
- **MATLAB**: Volumetric → PNG frame extraction, retinal **layer segmentation**, **thickness** computation.
- **Python (PyTorch)**: **frame-level** and **participant-level** classification with a **custom CNN** benchmark.

---

## 1) Dataset

Public dataset link (Data resource for Multiple Sclerosis and Healthy Controls):  
**➡️ DATASET URL:** `<http://iacl.jhu.edu/Resources>`

Download to `data/raw/`. Ensure compliance with the dataset’s license/terms.

---

## 2) Repository Structure
``` bash
├── README.md
├── env.yml
├── requirements.txt
├── configs/
│ ├── config_example.yaml
│ └── class_map.json
├── data/
│ ├── raw/
│ ├── interim/
│ └── processed/
├── matlab/
│ ├── volumetric_to_png.m
│ ├── segment_layers.m
│ ├── compute_thickness.m
│ └── utils/
└── src/
├── data_prep/
│ ├── split_dataset.py
│ └── build_frame_index.py
├── models/
│ ├── custom_cnn.py
│ └── backbones.py
├── train.py
├── eval_frame.py
└── eval_participant.py
---
```
## 3) MATLAB: Preprocessing & Feature Generation

Edit file names/paths in these scripts where indicated.

### Volumetric → PNG
`matlab/volumetric_to_png.m`
- **Inputs:** volumes in `data/raw/` (e.g., Volumatric `.vol`, DICOM)
- **Outputs:** `data/interim/frames/<SUBJECT_ID>/*.png`
- **Edit placeholders:**
  - `<INPUT_VOLUME_DIR>` → e.g., `../data/raw/`
  - `<OUTPUT_FRAME_DIR>` → e.g., `../data/interim/frames/`

### Layer Segmentation (e.g., GCL, RNFL)
`matlab/segment_layers.m`
- **Inputs:** PNG frames
- **Outputs:** `data/interim/masks/<SUBJECT_ID>/*_mask.png`
- **Edit:**
  - `<FRAME_DIR>` → `../data/interim/frames/`
  - `<MASK_OUT_DIR>` → `../data/interim/masks/`

### Thickness Measurement
`matlab/compute_thickness.m`
- **Inputs:** 
- **Outputs:** ``
- **Edit:**
  - `<MASK_DIR>`, `<METRIC_OUT_CSV>` → e.g., `../data/interim/metrics/thickness.csv`

> Keep **SUBJECT_ID** consistent across frames, masks, and metrics.

---

## 4) Python Environment

### Conda
```bash
conda env create -f env.yml
conda activate ms_cls
project_name: "MS_vs_Control"

paths:
  frames_dir: ""
  masks_dir: ""
  thickness_csv: ""
  splits_dir: ""
  class_map: ""
data:
  dataset_url: "<PASTE_DATASET_URL_HERE>"
  subject_id_pattern: "<SUBJECT_ID_REGEX_OR_FORMAT>"  # e.g., "SUBJ_(\\d+)"
  image_ext: ".png"
  use_thickness_features: true

splits:
  seed: ""
  val_ratio: ""
  test_ratio: ""
  subject_wise: ""

training:
  model: "custom_cnn"
  input_size: ""
  batch_size: ""
  epochs: ""
  optimizer: ""
  learning_rate: ""
  weight_decay: ""
  scheduler: ""
  dropout: ""
  num_workers: ""
  class_weights: ""
  early_stopping_patience: ""

evaluation:
  metrics: ["acc", "auc", "f1_score", "sens", "spec"]
  save_confusion_matrix: 

aggregation:
  method: ""   # or "mean_prob"
  tie_break: ""     # or "prefer_Control"
```
---
## 5) Citing This Work
If you are using this project in your research or project, please cite it as follows:

```bibtex
@article{muhammad2025,
  title={},
  author={},
  journal={},
  volume={},
  pages={},
  year={},
  publisher={}
 } 
 ```
---
## Support
For any issues or questions regarding the use of this project, please open an issue on our GitHub repository or contact us directly via email at [muan88621@hbku.edu.qa](mailto:muan88621@hbku.edu.qa). We are committed to providing support and will do our best to assist you.

