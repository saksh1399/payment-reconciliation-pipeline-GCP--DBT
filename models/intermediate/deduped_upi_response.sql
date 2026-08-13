WITH ranked AS (

    SELECT
        *,
--taking here the latest response as final response
        ROW_NUMBER() OVER (
            PARTITION BY txn_id
            ORDER BY timestamp DESC
        ) AS rn

    FROM {{ ref('stg_upi_response') }}

    WHERE txn_id IS NOT NULL
)

SELECT
    * EXCEPT(rn)

FROM ranked

WHERE rn = 1