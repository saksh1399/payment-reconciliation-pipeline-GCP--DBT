WITH ranked AS (

    SELECT
        *,

        ROW_NUMBER() OVER (
            PARTITION BY txn_id
            ORDER BY transaction_timestamp DESC
        ) AS rn

    FROM {{ ref('check_transaction_quality') }}

--    WHERE data_quality_status = 'VALID'
)

SELECT
    * EXCEPT(rn)

FROM ranked

WHERE rn = 1