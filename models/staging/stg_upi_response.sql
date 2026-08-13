


{{ config(materialized='table') }}

SELECT
    TRIM(txn_id) AS txn_id,
    SAFE_CAST(timestamp AS TIMESTAMP) AS timestamp,
    lower(TRIM(upi_ref)) AS upi_ref,
    lower(TRIM(payer_vpa)) AS payer_vpa,
    LOWER(TRIM(note)) AS note,
    lower(TRIM(payee_vpa)) AS payee_vpa,
    SAFE_CAST(response_code AS NUMERIC) AS response_code,
    lower(TRIM(error_message)) AS error_message
FROM {{ source('payments', 'upi_response') }}
WHERE txn_id IS NOT NULL



