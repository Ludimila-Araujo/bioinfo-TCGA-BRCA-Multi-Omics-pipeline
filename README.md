## About the Project 🧬

This project develops an end-to-end data engineering pipeline for the integration and analytical exploration of the TCGA-BRCA multi-omics dataset.

The project focuses on the molecular characterization of invasive ductal carcinoma (IDC) and invasive lobular carcinoma (ILC), integrating selected clinical, gene expression, and somatic mutation data.

The resulting analytical model supports exploratory analysis and visualization through an interactive Power BI dashboard.

## Bioinformatic Scope 🔬

The project investigates molecular differences between invasive ductal carcinoma (IDC) and invasive lobular carcinoma (ILC) using selected clinical, gene expression, and somatic mutation data.

The analysis focuses on:

- Population and receptor profile by histological type
- Mutation frequency across selected genes
- Gene expression of selected markers
- FOXA1 mutation–expression patterns

The analysis is exploratory and descriptive, with no individual clinical prediction or treatment recommendation.

## Data Source 📊

The project uses the **BRCA Multi-Omics (TCGA)** dataset distributed through Kaggle.

The dataset contains 705 breast cancer samples and 1,936 molecular features across gene expression, copy number, somatic mutation, and protein expression data, together with clinical and histological metadata.

For this project, the analytical population includes 574 IDC samples and 131 ILC samples.

## Data Architecture 🏗️

The pipeline follows a layered architecture:

**Source → Staging → Analytical Layer → BI**

The source data are ingested into PostgreSQL through Pentaho Data Integration (PDI) 9.4. The staging layer preserves the original wide-format structure, while the analytical layer organizes selected clinical and molecular data for analysis.

The final analytical layer is consumed by Power BI for interactive visualization.

## Analytical Model 🧩

The analytical layer is organized into:

| Structure | Grain | Purpose |
|---|---|---|
| `dim_sample` | Sample | Clinical and histological attributes |
| `fact_expression` | Sample × Gene | Selected gene expression measurements |
| `fact_mutation` | Sample × Gene | Selected mutation status |

Analytical views derived from these structures provide the data used for the exploratory analyses and Power BI dashboard.

## ETL Pipeline ⚙️

The ETL workflow is implemented in Pentaho Data Integration (PDI) 9.4, covering data ingestion, staging, normalization, and analytical view creation. The workflow is orchestrated through a Pentaho job, providing a reproducible path from the source dataset to the analytical layer consumed by Power BI.

## Data Quality 🔎

Data quality checks were performed in PostgreSQL before the analytical layer was used for visualization.

The validation process covered record counts, null values, categorical values, histological classification, and the integrity of the normalized analytical tables.

Validation scripts are organized in:

```text
sql/validations/
```

These checks support the consistency of the data throughout the pipeline.

## Power BI Dashboard 📊

The analytical layer is connected to an interactive Power BI dashboard designed to explore the molecular and clinical characteristics of IDC and ILC.

The dashboard is organized into two pages:

- **Overview**: population distribution, receptor profile, and selected gene expression.
- **Molecular Profile**: mutation frequency and FOXA1 mutation–expression patterns.

The dashboard supports interactive exploration by histological type.

## Project Structure 📁

```text
├── dashboard/
├── data/
├── etl/
└── sql/
├── dashboard/    # Power BI dashboard
├── data/         # Project data files
├── etl/          # Pentaho transformations and orchestration
└── sql/          # Analytical views and data validation scripts
```

## Technologies 🛠️

- **Pentaho Data Integration 9.4** — ETL and pipeline orchestration
- **PostgreSQL** — data staging and analytical layer
- **Power BI** — data visualization and interactive analysis
- **Python / SQL** — data analysis and validation
- **Git / GitHub** — version control

## Author 👩‍💻

**Ludimila de Araújo Costa**

MBA in Data Science and Engineering

[LinkedIn](https://www.linkedin.com/in/ludimila-araújo-costa)