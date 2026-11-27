--
SELECT s.type,
       ROUND(AVG(a.value), 1) AS mean_no2
FROM air_quality a
JOIN stations s ON a.station_code = s.station_code
WHERE a.pollutant = 'NO2'
GROUP BY s.type
--
SELECT s.type,
       CASE WHEN strftime('%w', a.time_utc) IN ('0', '6')
            THEN 'weekend' ELSE 'weekday' END AS day_type,
       ROUND(AVG(a.value), 1) AS mean_no2,
       COUNT(*) AS n_rows
FROM air_quality a
JOIN stations s ON a.station_code =s.station_code
WHERE a.pollutant = 'NO2'
GROUP BY s.type, day_type
--
SELECT CASE WHEN t.temp_c < 5  THEN '1_below_5C'
            WHEN t.temp_c < 15 THEN '2_5_to_15C'
            ELSE '3_15C_and_above' END AS temp_band,
       ROUND(AVG(a.value), 1) AS mean_no2,
       COUNT(*) AS n_rows
FROM air_quality a
JOIN temperature t
ON a.time_utc =t.time_utc
WHERE a.pollutant = 'NO2'
AND t.temp_c IS NOT NULL
GROUP BY temp_band
--
SELECT substr(a.time_utc, 1, 10) AS day,
       s.name AS station,
       s.type AS station_type,
       a.pollutant,
       ROUND(AVG(a.value), 1) AS mean_value,
       ROUND(AVG(t.temp_c), 1) AS mean_temp,
       CASE WHEN strftime('%w', a.time_utc) IN ('0', '6') THEN 1 ELSE 0 END AS is_weekend
FROM air_quality a
JOIN stations s ON a.station_code = s.station_code
LEFT JOIN temperature t ON a.time_utc = t.time_utc
GROUP BY day, s.name, s.type, a.pollutant, is_weekend
"""
daily = pd.read_sql(q4, conn)
print(daily.shape)
print(daily.head())
