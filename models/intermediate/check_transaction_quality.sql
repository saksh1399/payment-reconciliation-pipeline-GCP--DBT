SELECT
    *,

    CASE
        WHEN txn_id IS NULL
            THEN 'NULL_TXN_ID'

        WHEN amount IS NULL
            THEN 'NULL_AMOUNT'

        WHEN amount < 0
            THEN 'NEGATIVE_AMOUNT'

--        WHEN status NOT IN ('SUCCESS', 'FAILED', 'PENDING')
--            THEN 'INVALID_STATUS'
--
--        WHEN currency IS NULL
--            THEN 'MISSING_CURRENCY'
--
--        WHEN channel IS NULL
--            THEN 'MISSING_CHANNEL'

        ELSE 'VALID'
    END AS data_quality_status

FROM {{ ref('stg_transactions') }}