


{{ config(materialized='table') }}

SELECT
    TRIM(txn_id) AS txn_id,
    SAFE_CAST(settled_amount AS NUMERIC) AS settled_amount,
    SAFE_CAST(settlement_date AS DATE) AS settlement_date,
    UPPER(TRIM(bank_ref)) AS bank_ref,
    UPPER(TRIM(settlement_status)) AS settlement_status,
    UPPER(TRIM(bank_name)) AS bank_name
FROM {{ source('payments', 'raw_settlements') }}
WHERE txn_id IS NOT NULL



