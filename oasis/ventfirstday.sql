SELECT
  subject_id,
  hadm_id,
  icustay_id,
  MAX(vent) AS vent
FROM (
  SELECT
    *
  FROM
    `datathon-korea-2018.team_7.ventfirstday_partA`
  UNION ALL
  SELECT
    *
  FROM
    `datathon-korea-2018.team_7.ventfirstday_partB` )
GROUP BY
  subject_id,
  hadm_id,
  icustay_id
ORDER BY
  subject_id,
  hadm_id,
  icustay_id;
