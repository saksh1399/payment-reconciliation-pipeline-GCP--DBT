# Payments Reconciliation Pipeline

## 1. Project Overview

---
    This project implements a modular payments reconciliation pipeline using
    Google BigQuery and dbt.
    
    The objective is to reconcile transaction records from an internal
    transaction ledger against bank settlement records and UPI/NPCI response
    data.
---

```
payment_reconciliation/
|
├── models/
│   |
│   ├── sources.yml
│   ├── schema.yml
│   |
│   ├── staging/
│   │   ├── stg_transactions.sql
│   │   ├── stg_settlements.sql
│   │   └── stg_upi_response.sql
│   |
│   ├── intermediate/
│   │   ├── check_transaction_quality.sql
│   │   ├── deduped_transaction.sql
│   │   ├── deduped_settlement.sql
│   │   ├── deduped_upi_response.sql
│   │   └── reconciliation.sql
│   |
│   └── marts/
│       └── reconciliation_summary.sql
│
├── tests/
│   └── success_transaction_reconciliation.sql
│
├── dbt_project.yml
└── README.md```



The pipeline identifies:

- Successfully reconciled transactions
- Settlement amount mismatches
- Missing settlements after the T+1 window
- Pending settlements
- Transaction data-quality issues
- Duplicate transaction and settlement events
- UPI response failures

The implementation uses SQL, dbt Core, and Google BigQuery.

---

# 2. Business Problem

Payment transactions are generated in an internal transaction system,
while settlement information is received from banking systems and payment
response information is received from UPI/NPCI systems.

These systems may contain different records or values because of:

- Duplicate events
- Partial settlements
- Settlement delays
- Amount differences
- Failed payment responses
- Missing settlement records
- Data-quality issues

The objective of this pipeline is to create a reliable reconciliation
process that combines these sources and produces a business-ready
reconciliation summary.

---

# 3. Technology Stack

| Component | Technology |
|---|---|
| Data Warehouse | Google BigQuery |
| Transformation | dbt Core |
| Query Language | SQL / BigQuery SQL |
| Source Formats | CSV / JSON |
| Authentication | Google Cloud Application Default Credentials |
| Testing | dbt tests |

---

# 4. Architecture
 
## 4.1 Current Implementation Architecture

The current implementation uses a batch-oriented architecture using
BigQuery and dbt.

```text
                    SOURCE FILES
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
   Transactions     Settlements     UPI Responses
       CSV              CSV              JSON
          |              |              |
          +--------------+--------------+
                         |
                         v
                +------------------+
                |     BigQuery     |
                |     RAW Layer    |
                +------------------+
                         |
                         v
                +------------------+
                |   STAGING Layer  |
                +------------------+
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
     Transactions    Settlements    UPI Responses
                         |
                         v
                +------------------+
                | INTERMEDIATE      |
                |     Layer         |
                +------------------+
                         |
          +--------------+--------------+
          |              |              |
          v              v              v
     Data Quality    Deduplication   Settlement
                                     Aggregation
                         |
                         v
                +------------------+
                |  Reconciliation   |
                +------------------+
                         |
                         v
                +------------------+
                |    MART Layer     |
                |                  |
                | reconciliation_  |
                | summary           |
                +------------------+
                         |
                         v
                Analysts / BI /
                Monitoring



