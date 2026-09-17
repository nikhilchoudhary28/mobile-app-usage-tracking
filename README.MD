# 📱 End-to-End Mobile App Analytics Pipeline

An end-to-end data engineering and analytics solution processing **~180 million rows (~46.5 GB)** of mobile telemetry logs into an executive Looker Studio dashboard via DuckDB and Google BigQuery.

🔗 **[Live Looker Studio Dashboard](https://datastudio.google.com/reporting/a1451cf5-c4d2-404f-aadd-d24f8380a376)**

---

## 🏗️ Architecture


46.5 GB CSVs ──> DuckDB (ZSTD Parquet) ──> Aggregation Layer (65 MB) ──> Google BigQuery ──> Looker Studio





1. **Local Pipeline & Ingestion**: Streamed raw CSV chunks directly into column-oriented Parquet using DuckDB without memory saturation.
2. **Storage Optimization**: Compressed 46.5 GB of row logs to 2.5 GB Parquet (18x reduction), then aggregated to 65.8 MB daily metrics.
3. **Cloud Warehouse**: Partitioned and clustered analytical tables inside Google BigQuery.
4. **BI Layer**: Visualized core product telemetry KPIs (Active Users, Sessions, Cohorts, and Crash Stability) in Looker Studio.

---

## 📊 Core Performance Metrics


| Metric | Raw CSV Logs | Optimized Parquet | Daily Aggregated Model |
| :--- | :--- | :--- | :--- |
| **Total Rows** | 179,921,470 | 179,921,470 | 6,344,206 |
| **Total Size** | 46.49 GB | 2.50 GB | 65.87 MB |
| **Query Engine** | Disk Bound | DuckDB / Vectorized | Google BigQuery |
| **Looker Query Latency** | N/A | Local Only | Sub-second |

---

## 🛠️ Tech Stack

* **Processing Engine**: DuckDB (Out-of-core SQL execution & Parquet streaming)
* **Languages**: Python, SQL
* **Data Storage**: Apache Parquet (Zstandard compression)
* **Cloud Warehouse**: Google BigQuery
* **Data Visualization**: Looker Studio

---

## 🚀 How to Run Locally

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/](https://github.com/)<your-username>/mobile-app-usage-tracking.git
   cd mobile-app-usage-tracking