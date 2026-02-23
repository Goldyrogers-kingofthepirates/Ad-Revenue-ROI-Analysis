# Instagram-Video-Engagement-Ad-ROI-Pipeline-Analysis

This project provides a comprehensive ETL (Extract, Transform, Load) pipeline to audit content performance across 150+ high-growth reels in the 2026 Instagram landscape.

## Executive Summary

This project delivers a comprehensive **ETL (Extract, Transform, Load) pipeline** to audit content performance across 150+ high-growth Instagram Reels in the 2026 landscape.

By leveraging **Python-based scraping** and **SQL-driven business intelligence**, the analysis:

* Identifies the **“Golden Hours”** for engagement
* Quantifies the **ROI of sponsored content vs. organic creator averages**
* Detects viral outliers using performance indexing

## Repository Structure

```
├── analysis/
│   ├── queries_and_results.sql  # Raw SQL logic & data snapshots
│   └── findings_report.md       # Narrative analysis for stakeholders
├── data/
│   ├── insta_project.db         # Final SQLite Database
│   └── video_data.csv           # Anonymized raw dataset
├── scripts/
│   ├── scraper.py               # Extraction engine
│   └── db_setup.py              # ETL & SQL transformation
└── README.md                    # Project overview
```

## Getting Started

### Prerequisites

Ensure you have Python 3.x installed. You will need the following libraries:

```bash
pip install pandas instaloader
```

### Installation

1.  Clone the repository:
    ```bash
    git clone <repository-url>
    cd Ad-Revenue-ROI-Analysis
    ```

2.  Install dependencies (as listed above).

### Usage

1.  **Run the Scraper:**
    Extract data from target profiles.
    ```bash
    python scripts/scraper.py
    ```
    *Note: This script gathers data and saves it to `data/video_data.csv`.*

2.  **Initialize Database:**
    Load the CSV data into the SQLite database.
    ```bash
    python scripts/db_setup.py
    ```
    *Note: This creates/updates `data/insta_project.db`.*

3.  **Analyze Data:**
    Use a database client (like DBeaver or VS Code SQL tools) to open `data/insta_project.db` and run queries from `analysis/queries_and_results.sql`.

## Key Project Features

### Automated Data Extraction

Engineered a custom Python scraper to pull engagement metrics while maintaining 2026 security compliance.

### Privacy-First Architecture

Implemented a data anonymization strategy to protect creator identities.

### Advanced SQL Analysis

Built a relational database (SQLite) to calculate complex metrics like:

* **Performance Index**
* **Relative ROI**
* Viral Outlier Detection

### Console-Based Visualization

Developed custom SQL functions to generate “Sparkline” bar charts directly in the terminal for rapid insight verification.

## Core Findings & Insights

### Peak Engagement Windows (IST)

The analysis identified two distinct traffic surges:

* **00:00 IST (Midnight)** → High individual virality
* **18:00 – 20:00 IST** → Most reliable window for consistent reach

**Conclusion:** While midnight can produce viral spikes, **evening hours (18:00–20:00 IST)** are optimal for predictable performance.

### Sponsored Content Audit (ROI)

The study revealed an **“Ad-Aura Effect”** in certain creators, where sponsored content outperformed organic averages by:

> **+145% ROI**

However, some accounts showed **negative ROI**, indicating audience resistance to overt promotional content.

## Tech Stack & Tools

* **Language:** Python 3.x
  * Pandas
  * SQLite3
* **Database:** SQLite (Relational DB Management)
* **IDE:** VS Code (with SQL Extension)
* **Key Metrics:**
  * ROI %
  * Performance Index
  * Viral Outlier Detection

## Technical SQL Implementation

The backbone of this project is a series of optimized SQL queries designed to extract high-level business intelligence from raw engagement data.

### Database Schema

The `video_trends` table includes:

* **Temporal Tracking:** `Time` (IST), `Date`
* **Engagement Metrics:** `Views`, `Likes`, `Comments`
* **Content Metadata:** `Account`, `Caption`, `Hashtags`

### Advanced Query Highlights

#### 1. Relational ROI Modeling (Joins & Arithmetic)

Instead of simple averages, this query joins the main table with an aggregated sub-dataset to calculate the **Relative ROI** of sponsored content against each creator’s organic baseline.

```sql
SELECT v.Account, 
       ROUND(((v.Views - avg_table.Avg_Views) * 100.0 / avg_table.Avg_Views), 1) AS ROI_Percent
FROM video_trends v
JOIN (
    SELECT Account, AVG(Views) AS Avg_Views 
    FROM video_trends 
    GROUP BY Account
) avg_table 
ON v.Account = avg_table.Account
WHERE v.Caption LIKE '%#ad%';
```

#### 2. Performance Indexing (Subqueries)

This window-style subquery creates a performance multiplier for every post to identify viral outliers.

```sql
SELECT Account, Date, Views,
       ROUND((Views * 100.0 / 
              (SELECT AVG(Views) 
               FROM video_trends 
               WHERE Account = v.Account)), 1) AS Perf_Index
FROM video_trends v
WHERE Perf_Index > 200;
```

#### 3. Temporal Data Transformation (`strftime`)

SQLite's date-time functions were used to:

* Normalize international timestamps
* Convert data into **India Standard Time (IST)**
* Isolate the Golden Hour window (19:00–21:00 IST)
