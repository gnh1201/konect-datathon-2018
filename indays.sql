select
  d.subject_id as subject_id,
  d.hadm_id as hadm_id,
  d.min_dischtime as min_dischtime,
  g.min_intime as min_intime,
  g.min_dod as min_dod,
  datetime_diff(min_dischtime, min_intime, DAY) as indays_disch,
  datetime_diff(min_dod, min_intime, DAY) as indays_dod
from (
 select b.subject_id as subject_id, c.hadm_id as hadm_id, min(c.dischtime) as min_dischtime from
     `physionet-data.mimiciii_clinical.patients` b,
     `physionet-data.mimiciii_clinical.admissions` c
   where b.subject_id = c.subject_id
   group by subject_id, hadm_id order by min_dischtime desc
) d, (
 select e.subject_id as subject_id, f.hadm_id as hadm_id, min(f.intime) as min_intime, min(e.dod) as min_dod from
     `physionet-data.mimiciii_clinical.patients` e,
     `physionet-data.mimiciii_clinical.icustays` f
   where e.subject_id = f.subject_id
   group by subject_id, hadm_id  order by min_intime desc
) g
where d.subject_id = g.subject_id and d.hadm_id = g.hadm_id
order by min_dischtime desc;