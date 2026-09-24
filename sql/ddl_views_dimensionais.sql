/*
Project: TCGA-BRCA Multi-Omics Data Warehouse
Author: Ludimila de Araújo Costa
Objective: Creation of virtual dimensional Views (Star Schema) for optimized consumption in Power BI.
*/

-- ============================================================================
-- 1. Patient Dimension: Clinical and demographic profile (Unique count)
-- ============================================================================
CREATE OR REPLACE VIEW dim_pacient AS
SELECT DISTINCT
	"vital.status",
	"PR.Status",
	"ER.Status",
	"HER2.Final.Status",
	"histological.type"
FROM tb_brca_data;

-- ============================================================================
-- 2. Histological Signature Dimension: Average expression by cancer type
-- ============================================================================
CREATE OR REPLACE VIEW dim_hist_signature AS
SELECT
	"histological.type",
	gene_name,
	AVG(expression_level) AS avg_expression
FROM tb_brca_data
GROUP BY
	"histological.type",
	gene_name;


-- ============================================================================
-- 3. Mutational Impact Dimension: Dynamic genetic panel
-- ============================================================================
CREATE OR REPLACE VIEW dim_mutational_impact AS
SELECT 
	"histological.type",
	gene_name,
	CASE
		WHEN gene_name = 'rs_CDH1' THEN mu_CDH1
        WHEN gene_name = 'rs_TP53' THEN mu_TP53
        WHEN gene_name = 'rs_PIK3CA' THEN mu_PIK3CA
        WHEN gene_name = 'rs_GATA3' THEN mu_GATA3
        WHEN gene_name = 'rs_FOXA1' THEN mu_FOXA1
        ELSE NULL
    END AS mutation_status,
    AVG(expression_level) AS avg_expression
FROM tb_brca_data
WHERE gene_name IN ('rs_CDH1', 'rs_TP53', 'rs_PIK3CA', 'rs_GATA3', 'rs_FOXA1')
GROUP BY 
    "histological.type",
    gene_name,
    CASE 
        WHEN gene_name = 'rs_CDH1' THEN mu_CDH1
        WHEN gene_name = 'rs_TP53' THEN mu_TP53
        WHEN gene_name = 'rs_PIK3CA' THEN mu_PIK3CA
        WHEN gene_name = 'rs_GATA3' THEN mu_GATA3
        WHEN gene_name = 'rs_FOXA1' THEN mu_FOXA1
        ELSE NULL
    END;


-- ============================================================================
-- 4. Clinical Receptors Dimension: Cross-validation of RNA levels
-- ============================================================================
CREATE OR REPLACE VIEW dim_receptores_clinicos AS
SELECT 
    "ER.Status",
    "PR.Status",
    "HER2.Final.Status",
    gene_name,
    AVG(expression_level) AS avg_expression
FROM tb_brca_data
WHERE gene_name IN ('rs_ESR1', 'rs_PGR', 'rs_ERBB2')
GROUP BY 
    "ER.Status",
    "PR.Status",
    "HER2.Final.Status",
    gene_name;