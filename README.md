# Network Meta-Analysis for Smoking Cessation

This project focuses on the network meta-analysis of smoking cessation interventions using the **netmeta** for frequentist and **gemtc** package for the Bayesian approach in R. The goal is to evaluate and compare different smoking cessation methods to identify the most effective interventions.

## Overview
Network meta-analysis allows for the comparison of multiple treatment options simultaneously, even when some treatments have not been compared directly in head-to-head trials. This approach is particularly useful in the context of smoking cessation, where numerous interventions, such as behavioral therapies, pharmacotherapy (nicotine replacement therapy, varenicline, and more), and combined approaches exist.

## Methodology
1. **Data Collection:** For carrying out these analyses, a dataset of smoking cessation treatments containing binary data was used. This dataset is publicly available within the netmeta package.
2. **Modelling:** The **netmeta** package will be used to perform the frequentist NMA. The **gemtc** package is used for performing the Bayesian approach NMA. 
3. **Interpretation:** Results will be interpreted in the context of clinical significance and implications for practice.

## Requirements
- R 
- netmeta package
- gemtc package


## Usage
Once the package is installed, users can implement network meta-analysis as per the examples provided in the **netmeta** documentation.
