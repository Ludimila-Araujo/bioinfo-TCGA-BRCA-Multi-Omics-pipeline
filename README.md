# TCGA-BRCA Multi-Omics Data Warehouse & BI Analytics 🧬📊

---
## About the Project
This repository contains the final academic project for the modules Data Warehouse Architecture in Business Intelligence and Data and Business Analytics with Power BI, part of the MBA in Data Science and Engineering.

The project implements an end-to-end data pipeline focusing on the bioinformatics integration of the TCGA BRCA (Breast Cancer) multi-omics dataset. It aims to demonstrate advanced data engineering techniques by structuring a dimensional model optimized for precision medicine analytics.

## Architecture & Tech Stack
* *Data Extraction & Transformation (ETL)*: Pentaho Data Integration (PDI). Data cleansing, structural normalization (wide to long format pivoting), and domain isolation.

* *Data Storage & Modeling: PostgreSQL*: Construction of a Star Schema using idempotent SQL Views to aggregate clinical and transcriptomic data.

* *Data Visualization (BI)*: Power BI. Interactive dashboards for functional genomics and clinical profiling (dashboard upload pending).

## Dimensional Model
The analytical layer was constructed using virtual dimensions (Views) directly in the database to optimize BI performance and prevent data duplication:

* *dim_paciente*: Clinical profiling and demographics.

* *dim_assinatura_histologica*: Gene expression signatures grouped by histological type.

* *dim_impacto_mutacional_painel*: Dynamic genetic panel evaluating the functional impact of key somatic mutations (CDH1, TP53, PIK3CA, GATA3, FOXA1) on gene expression levels.

* *dim_receptores_clinicos*: Validation of ER, PR, and HER2 clinical receptor status against transcriptomic levels.

## Author
Ludimila de Araújo Costa
LinkedIn[www.linkedin.com/in/ludimila-araújo-costa]
