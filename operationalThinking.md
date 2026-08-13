# Operational Thinking

## 1. Monitoring

For a production payment reconciliation pipeline, I would monitor the following metrics:

### 1. Reconciliation Rate

Monitor the percentage of successful transactions that are successfully reconciled with settlement records.

**Metric:**
- Reconciliation Rate = Matched Transactions / Eligible Successful Transactions

I would configure an alert when the reconciliation rate drops significantly below the expected baseline.

A sudden drop could indicate:
- Settlement files are delayed
- An upstream source has failed
- Reconciliation logic has changed unexpectedly
- Transaction or settlement data has quality issues

---

### 2. Missing Settlements

Monitor the number of successful transactions for which no settlement record is available within the expected T+1 settlement window.

A sudden increase in missing settlements could indicate:
- Delayed settlement files
- Bank-side processing issues
- Missing or incomplete source data
- Issues in the reconciliation pipeline

This metric is particularly important because missing settlements can directly affect financial reconciliation.

---

### 3. Amount Mismatches

Monitor both:

- Number of transactions with settlement amount mismatches
- Total monetary value of the mismatches

For example, a transaction may have:

- Transaction amount = ₹1,000
- Settled amount = ₹950
- Amount difference = ₹50

I would alert when either the mismatch count or total mismatch amount exceeds an expected threshold.

---

### 4. Data Quality and Pipeline Test Failures

Monitor failures in data quality checks and dbt tests, including:

- Duplicate transaction IDs
- Null values in critical fields
- Invalid transaction statuses
- Invalid or unexpected source values
- Reconciliation validation failures

Any critical dbt test failure should be treated as a pipeline health issue and investigated before downstream reporting is trusted.

---

### 5. Pipeline Freshness

Monitor whether transaction, settlement and UPI response data are arriving within the expected SLA.

For example:

- Transaction data should arrive within the expected ingestion window.
- Settlement data should be available within the expected T+1 window.

If expected data does not arrive on time, an alert should be triggered before the reconciliation process produces misleading results.

---

## 2. Backfill

If a bug is discovered in the reconciliation logic that affected data from the previous week, I would avoid blindly rebuilding the entire warehouse.

The process would be:

1. Identify the affected date range.
2. Identify which dbt models are affected by the logic change.
3. Fix the transformation logic and validate it on a small sample.
4. Reprocess the affected historical date range.
5. Rebuild the affected downstream models.
6. Rerun all relevant dbt tests.
7. Compare the corrected reconciliation metrics with the previous results.
8. Validate the updated results in the reconciliation summary and dashboard.
9. Document the backfill and the reason for the correction.

For an incremental production implementation, I would use a date-based incremental strategy with an appropriate `unique_key` and merge strategy.

A small lookback window can also be used to handle late-arriving transactions or settlement records.

For example:

```text
Bug identified
      ↓
Identify affected dates
      ↓
Fix dbt transformation
      ↓
Backfill affected data
      ↓
Run dbt tests
      ↓
Validate reconciliation results
      ↓
Refresh dashboard