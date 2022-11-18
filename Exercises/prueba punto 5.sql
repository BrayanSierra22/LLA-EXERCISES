WITH
Tabla_Clasificacion_Dias_Mora as(
SELECT
    oldest_unpaid_bill_dt,
    dt,
    date_diff('DAY',  CAST (CONCAT(SUBSTR(oldest_unpaid_bill_dt, 1,4),'-',SUBSTR(oldest_unpaid_bill_dt, 5,2),'-', SUBSTR(oldest_unpaid_bill_dt, 7,2)) AS Date), CAST(dt AS Date)) as DIAS_MORA_ACTUAL
    
FROM "db-analytics-prod"."tbl_postpaid_cwc" 

WHERE account_type = 'Residential'
    AND org_id = '338'
    AND extract(Day from cast(dt as date)) = 1
    AND extract(Month from cast(dt as date)) = 10 
    AND extract(Year from cast(dt as date)) = 2022
)

SELECT 
    DIAS_MORA_ACTUAL,
    CASE WHEN DIAS_MORA_ACTUAL >= 90 THEN 'INACTIVOS' 
    WHEN DIAS_MORA_ACTUAL <90 THEN 'ACTIVOS' ELSE 'ACTIVO' end as clasificacion
FROM Tabla_Clasificacion_Dias_Mora
GROUP BY 1
ORDER BY 1
