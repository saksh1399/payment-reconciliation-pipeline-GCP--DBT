SELECT
    txn_id,
    status,
    reconciliation_status

FROM {{ ref('reconciliation') }}

WHERE status = 'SUCCESS'
  AND reconciliation_status IS NULL