


{{ config(materialized='table') }}

SELECT
    TRIM(txn_id) AS txn_id,
    SAFE_CAST(amount AS NUMERIC) AS amount,
    SAFE_CAST(timestampe AS TIMESTAMP) AS transaction_timestamp,
    UPPER(TRIM(status)) AS status,
    TRIM(merchant_id) AS merchant_id,
    UPPER(TRIM(currency)) AS currency,
    LOWER(TRIM(channel)) AS channel
FROM {{ source('payments', 'raw_transactions') }}
WHERE txn_id IS NOT NULL



