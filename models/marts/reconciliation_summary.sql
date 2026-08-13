SELECT
    COUNT(*) AS total_transactions,
    countif(lower(status)='pending') as pending_transaction,
    countif(lower(status)='failed') as failed_transaction,
    countif(lower(status)='success') as success_transaction,
    COUNTIF(reconciliation_status = 'MATCHED')
        AS matched_transactions,

    COUNTIF(reconciliation_status = 'AMOUNT_MISMATCH')
        AS amount_mismatches,

    COUNTIF(reconciliation_status = 'MISSING_SETTLEMENT')
        AS missing_settlements,
    COUNTIF(reconciliation_status = 'PENDING_SETTLEMENT')
        AS pending_settlements,


    sum(case when lower(status)='success' then amount else 0 end)
        AS total_success_txn_amount,
    sum(amount) as total_txn_amount,

    SUM(case when lower(status)='success' then COALESCE(settled_amount, 0)  else 0 end)
        AS total_settled_amount,

    SUM(
        CASE
            WHEN reconciliation_status = 'AMOUNT_MISMATCH'
            THEN ABS(amount_difference)
            ELSE 0
        END
    ) AS total_mismatch_amount,

    SAFE_DIVIDE(
        COUNTIF(reconciliation_status = 'MATCHED'),
        COUNT(*)
    ) * 100 AS reconciliation_rate

FROM {{ ref('reconciliation') }}