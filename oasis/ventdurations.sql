select icustay_id, min(charttime) as starttime, max(charttime) as endtime, DATETIME_DIFF(max(charttime), min(charttime), HOUR) AS duration_hours, ventnum
from `datathon-korea-2018.team_7.vd2`
group by icustay_id, ventnum
having min(charttime) != max(charttime)
and max(mechvent) = 1
order by icustay_id, ventnum;