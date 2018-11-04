select
  a.*,
  c.callout_service as callout_service,
  c.post_op as post_op,
  b.insurance as insurance,
  b.admission_type as admission_type,
  b.admission_location as admission_location,
  b.discharge_location as discharge_location,
  b.ethnicity as ethnicity,
  b.language as language,
  b.religion as religion,
  b.marital_status as marital_status,
  b.diagnosis as diagnosis
from
  `datathon-korea-2018.team_7.indays` a,
  `physionet-data.mimiciii_clinical.admissions` b
left join (
  select
    subject_id,
    hadm_id,
    callout_service,
    1 as post_op
  from `physionet-data.mimiciii_clinical.callout`
  where callout_service like '%SURG' or callout_service in ('ORTHO', 'GYN', 'ENT')
) c on (
  a.subject_id = c.subject_id and b.subject_id = c.subject_id and a.hadm_id = c.hadm_id and b.hadm_id = c.hadm_id
)
where
  a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
order by min_dischtime desc, callout_service desc;
