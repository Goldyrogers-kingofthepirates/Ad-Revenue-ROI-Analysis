/* PROJECT: Instagram Video & Ad Performance Analysis (2026)
PURPOSE: Multi-dimensional engagement analysis for portfolio documentation.
*/

-- ==========================================================
-- 1. BEST TIME TO POST (IST)
-- Goal: Identify the "Golden Hour" for maximum organic reach.
-- ==========================================================
SELECT 
    strftime('%H', Time) as Hour_IST, 
    COUNT(*) as Video_Count,
    ROUND(AVG(Views), 0) as Avg_Views
FROM video_trends
WHERE Views > 0
GROUP BY Hour_IST
ORDER BY Avg_Views DESC;

/* EXPECTED RESULTS SNAPSHOT (Generated on Feb 22, 2026):
-----------------------------------------------------------
Hour_IST | Video_Count | Avg_Views
-----------------------------------------------------------
00       | 5           | 535966.0   <-- Highest Average (Viral)
19       | 23          | 456499.0   <-- Peak Frequency (Prime Time)
20       | 25          | 368930.0
18       | 26          | 362802.0
-----------------------------------------------------------
ANALYSIS: 
While midnight (00:00) shows the highest average, it is based on 
a smaller sample. The 18:00 - 20:00 window represents the most 
consistent high-engagement period with the largest volume of posts.
*/

-- ==========================================================
-- 2. AD ROI ANALYSIS
-- Goal: Calculate if sponsored content performs better than organic average.
-- ==========================================================
SELECT 
    v.Account, 
    ROUND(((v.Views - avg_table.Avg_Views) * 100.0 / avg_table.Avg_Views), 1) as ROI_Percent,
    PRINTF('%.' || CAST(ABS((v.Views - avg_table.Avg_Views) * 100.0 / avg_table.Avg_Views)/10 AS INT) || 'c', '█') as ROI_Visual
FROM video_trends v
JOIN (
    SELECT Account, AVG(Views) as Avg_Views 
    FROM video_trends 
    GROUP BY Account
) avg_table ON v.Account = avg_table.Account
WHERE v.Caption LIKE '%#ad%' OR v.Caption LIKE '%#sponsored%'
ORDER BY ROI_Percent DESC;

/* EXPECTED RESULTS SNAPSHOT (Generated on Feb 22, 2026):
-----------------------------------------------------------
Account   | ROI_Percent | ROI_Visual
-----------------------------------------------------------
User_ID_2 | 145.2       | ██████████████  <-- Exceptional ROI
User_ID_5 | 22.4        | ██              <-- Healthy Performance
User_ID_1 | -5.1        |                 <-- Below Average
-----------------------------------------------------------
ANALYSIS: 
User_ID_2 demonstrates a significant 'Ad-Aura,' where sponsored 
posts consistently outperform their organic content by over 140%. 
User_ID_1 shows a slight negative ROI, suggesting their audience 
may resist direct promotional content.
*/

-- ==========================================================
-- 3. VIRAL CONTENT AUDIT (OUTLIER DETECTION)
-- Goal: Isolate videos that performed 2x (200%) better than the creator's mean.
-- ==========================================================
SELECT 
    Account, 
    Date, 
    Views, 
    ROUND((Views * 100.0 / (SELECT AVG(Views) FROM video_trends WHERE Account = v.Account)), 1) as Performance_Index
FROM video_trends v
WHERE Performance_Index > 200
ORDER BY Performance_Index DESC;

/* EXPECTED RESULTS SNAPSHOT (Generated on Feb 22, 2026):
-----------------------------------------------------------
Account   | Date       | Views   | Performance_Index (%)
-----------------------------------------------------------
User_ID_3 | 2026-02-15 | 245000  | 285.4
User_ID_1 | 2026-02-10 | 180000  | 215.2
User_ID_2 | 2026-02-18 | 95000   | 202.1
-----------------------------------------------------------
ANALYSIS: 
The query successfully isolated 3 'Viral' events. User_ID_3 
achieved the highest surge, with content performing nearly 
3x better than their baseline average. 
*/