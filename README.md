## About the Project

This repository contains an academic project developed for the MBA in Data Science and Engineering.

The project implements an end-to-end data engineering pipeline for the integration and analytical exploration of the TCGA-BRCA multi-omics dataset, focusing on the molecular characterization of invasive ductal carcinoma (IDC) and invasive lobular carcinoma (ILC).

The pipeline transforms a wide-format multi-omics dataset into a structured analytical model in PostgreSQL, integrating sample-level clinical and histological information with selected gene expression and mutation data. The resulting analytical layer supports the investigation of molecular patterns across histological groups and their visualization through an interactive Power BI dashboard.

The project combines data engineering, bioinformatics, and business intelligence practices to demonstrate a reproducible workflow from raw data ingestion to analytical visualization.

## Scientific Scope & Research Questions

The analytical scope of this project is the molecular characterization of invasive ductal carcinoma (IDC) and invasive lobular carcinoma (ILC) using selected clinical, gene expression, and somatic mutation features.

The central research question is:

> How can clinical and molecular data be integrated to identify patterns that contribute to the characterization and molecular stratification of breast tumors, with potential applications in precision oncology?

The analytical workflow addresses the following questions:

1. **Population characterization**  
   How is the study population distributed according to histological type and selected clinical receptor characteristics?

2. **Mutation profile**  
   Which selected genes show differences in mutation frequency between IDC and ILC?

3. **Gene expression profile**  
   How does the expression of selected genes differ between IDC and ILC?

4. **Mutation–expression integration**  
   How does FOXA1 expression behave according to mutation status and histological type?

The analyses are exploratory and descriptive. The project does not aim to establish clinical biomarkers, predict individual treatment response, infer causal relationships, or provide individual clinical recommendations.

## Data Source & Dataset

The project uses the **BRCA Multi-Omics (TCGA)** dataset distributed through Kaggle.

The dataset contains 705 breast cancer samples and 1,936 molecular features distributed across multiple omics domains:

- **604** gene expression features (`rs_`)
- **860** copy number features (`cn_`)
- **249** somatic mutation features (`mu_`)
- **223** protein expression features (`pp_`)

The dataset also contains clinical and histological metadata used in the analytical model, including:

- vital status
- estrogen receptor (ER) status
- progesterone receptor (PR) status
- HER2 final status
- histological type

For this project, the analytical population comprises:

- **574** invasive ductal carcinoma (IDC) samples
- **131** invasive lobular carcinoma (ILC) samples

The original dataset is maintained in a wide format, with one row representing a sample and molecular features represented as columns. This structure is preserved in the staging layer before the data are normalized into the analytical model.

### Data Provenance

The dataset was obtained from the Kaggle **BRCA Multi-Omics (TCGA)** dataset and used as the source dataset for the MBA project.

The scientific interpretation of the molecular characterization of invasive lobular and ductal breast carcinomas is supported by the study:

> Ciriello et al. (2015). *Comprehensive Molecular Portraits of Invasive Lobular Breast Cancer*. Cell.

The article is used as a scientific reference for the biological context and interpretation of the analytical questions, rather than as a direct source for the project dataset.	

## Architecture & Tech Stack

The project follows a layered data engineering architecture, separating data ingestion, staging, analytical transformation, and business intelligence.

### Data Pipeline

```text
Raw CSV
   │
   ▼
Pentaho Data Integration (PDI)
   │
   ▼
Staging Layer
   │
   ▼
Analytical Layer
   │
   ├── Dimension
   │    └── dim_sample
   │
   ├── Facts
   │    ├── fact_expression
   │    └── fact_mutation
   │
   └── Analytical Views
        ├── Expression by Histology
        ├── Mutation by Histology
        ├── Mutation Frequency
        ├── Expression Summary
        └── FOXA1 Mutation–Expression Integration
   │
   ▼
Power BI

### Technology Stack

| Layer                 | Technology                   | Purpose                                          |
| --------------------- | ---------------------------- | ------------------------------------------------ |
| Data source           | CSV                          | Source multi-omics dataset                       |
| ETL                   | Pentaho Data Integration 9.4 | Data ingestion, normalization, and orchestration |
| Staging               | PostgreSQL                   | Persistent landing layer for the source dataset  |
| Analytical database   | PostgreSQL                   | Dimensional and fact-based analytical model      |
| Data validation       | SQL                          | Structural and data quality validation           |
| Business Intelligence | Power BI                     | Interactive analytical dashboard                 |
| Version control       | Git / GitHub                 | Source code and project versioning               |


The architecture separates the wide source representation from the analytical model. The staging layer preserves the source structure, while the analytical layer organizes selected molecular and clinical attributes according to their analytical grain.

The ETL workflow is orchestrated through Pentaho jobs, which execute the ingestion, normalization, analytical view creation, and validation steps in a controlled sequence.

## Analytical Model

The analytical layer is organized around sample-level data and selected molecular measurements.

### Sample Dimension

**Table:** `analytical.dim_sample`

**Grain:** one row per sample.

The dimension contains the sample identifier and selected clinical and histological attributes:

- `sample_id`
- `histological_type`
- `er_status`
- `pr_status`
- `her2_final_status`
- `vital_status`

The `sample_id` is a technical identifier generated during ingestion and represents the original row of the source dataset. It is intentionally named `sample_id` rather than `patient_id`, since the available source data do not establish a separate patient-level identifier.

### Expression Fact

**Table:** `analytical.fact_expression`

**Grain:** one row per sample and gene.

The fact table contains selected gene expression measurements for:

- `FOXA1`
- `ESR1`
- `PGR`

The wide-format expression attributes from the staging layer are normalized into a long analytical structure containing:

- `sample_id`
- `gene_name`
- `expression_value`

### Mutation Fact

**Table:** `analytical.fact_mutation`

**Grain:** one row per sample and gene.

The fact table contains mutation status for the selected molecular panel:

- `CDH1`
- `PTEN`
- `TBX3`
- `RUNX1`
- `PIK3CA`
- `TP53`
- `GATA3`
- `ERBB2`
- `FOXA1`

The normalized structure contains:

- `sample_id`
- `gene_name`
- `mutation_status`

### Analytical Views

The analytical views provide structures optimized for downstream analysis and Power BI consumption:

| View | Purpose |
|---|---|
| `vw_expression_by_histology` | Gene expression by sample and histological type |
| `vw_mutation_by_histology` | Mutation status by sample and histological type |
| `vw_mutation_frequency` | Mutation frequency by gene and histological type |
| `vw_expression_summary` | Descriptive expression statistics by gene and histological type |
| `vw_foxa1_mutation_expression` | FOXA1 mutation status integrated with expression and histological type |
| `vw_foxa1_mutation_expression_summary` | Descriptive FOXA1 expression statistics by mutation status and histological type |

This structure separates normalized analytical data from presentation-oriented views, allowing the same underlying facts to support different analytical questions and BI visualizations.

## ETL Pipeline

The ETL workflow is implemented in Pentaho Data Integration (PDI) 9.4 using transformations (`.ktr`) and a job (`.kjb`) for pipeline orchestration.

### Staging Ingestion

The source CSV is ingested into the PostgreSQL staging layer through the transformation:

```text
etl/tr_staging_ingestion.ktr

The digestion flow:

CSV File Input
      │
      ▼
Add Sequence
      │
      ▼
Select Values
      │
      ▼
Table Output
      │
      ▼
staging.brca_sample_wide

A sequential sample_id is generated during ingestion to provide a technical identifier for each source row.

Analytical Transformations

The staging dataset is subsequently transformed into normalized analytical structures:

staging.brca_sample_wide
        │
        ├──► tr_dim_sample.ktr
        │        └──► analytical.dim_sample
        │
        ├──► tr_fact_expression_normalization.ktr
        │        └──► analytical.fact_expression
        │
        └──► tr_fact_mutation_normalization.ktr
                 └──► analytical.fact_mutation

The molecular transformations convert selected wide-format attributes into long-format analytical structures using Pentaho's row normalization capabilities.

Pipeline Orchestration

The complete workflow is orchestrated by:

etl/jb_orquestrador_views.kjb

The job executes the pipeline in sequence:

Start
  │
  ▼
TR_Staging_Ingestion
  │
  ▼
TR_Dim_Sample
  │
  ▼
TR_Fact_Expression
  │
  ▼
TR_Fact_Mutation
  │
  ▼
SQL_001_Create_Expression_View
  │
  ▼
SQL_002_Create_Mutation_View
  │
  ▼
SQL_003_Create_Mutation_Frequency_View
  │
  ▼
SQL_004_Create_Expression_Summary_View
  │
  ▼
SQL_005_Create_FOXA1_Integration_View
  │
  ▼
SQL_006_Create_FOXA1_Summary_View
  │
  ▼
Success

This orchestration provides a reproducible execution path from raw data ingestion to the analytical views consumed by the BI layer.