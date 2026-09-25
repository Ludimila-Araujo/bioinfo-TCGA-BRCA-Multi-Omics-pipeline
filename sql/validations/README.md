# Data Validation

This directory contains SQL scripts used to validate the
data loaded into the PostgreSQL staging layer.

## Validation Scope

The validation scripts cover:

- staging cardinality
- sample identifier integrity
- staging structural integrity
- categorical domains
- clinical variable consistency
- histological subtype relationships

## Validation Naming Convention

Validation scripts follow the pattern:

`NNN_validate_<validation_scope>.sql`

## Execution

The scripts should be executed against the PostgreSQL
database after the staging layer has been populated.

## Validation Principle

The staging layer preserves the source data structure
and values. Validation scripts assess data integrity
without modifying the source-derived records.