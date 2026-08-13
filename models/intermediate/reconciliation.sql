

select *,
case when (settled_amount is null
or settled_amount=0) and lower(status) not in('pending', 'failed')
and date(current_date)>
date(transaction_timestamp)+ interval 1 day then  'MISSING_SETTLEMENT'

when (settled_amount is null
or settled_amount=0) and lower(status) not in('pending', 'failed') then 'Pending Settlement'
-- Settlement exists but amount differs by more than ₹1
WHEN ABS(amount-settled_amount) > 1 and lower(status) not in('pending', 'failed')
    THEN 'AMOUNT_MISMATCH'
-- Within allowed reconciliation tolerance
when lower(status) not in('pending', 'failed') then 'MATCHED'

END AS reconciliation_status,
case when ABS(amount-settled_amount) > 1 and lower(status) not in('pending', 'failed')
then ABS(amount-settled_amount) else 0 end as amount_difference

from  (
select txn.*,upi.*except(txn_id),
sum(coalesce(settle.settled_amount,0)) settled_amount,
max(settlement_date) max_settlement_date,
min(settlement_date) min_settlement_date
 FROM {{ ref('deduped_transactions') }} as txn
 left join  {{ ref('deduped_settlement') }} settle
 on lower(txn.txn_id)=lower(settle.txn_id)
 left join {{ ref('deduped_upi_response') }} upi
 on lower(txn.txn_id)=lower(upi.txn_id)
 group by all
 )
