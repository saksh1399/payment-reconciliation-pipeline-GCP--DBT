
SELECT distinct *
FROM {{ ref('stg_settlements') }}
WHERE txn_id IS NOT NULL


--assuming case of partial settlement as well in such case removing
--the data with latest or earliest record will lead
--to incorrect data interpretation