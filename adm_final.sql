select
  a.*,
  b.oasis,
  b.age,
  b.hospital_expire_flag,
  b.icustay_expire_flag,
  b.oasis_prob,
  b.age_score,
  b.preiculos,
  b.preiculos_score,
  b.gcs,
  b.gcs_score,
  b.heartrate,
  b.heartrate_score,
  b.meanbp,
  b.meanbp_score,
  b.resprate,
  b.resprate_score,
  b.temp,
  b.temp_score,
  b.urineoutput,
  b.UrineOutput_score,
  b.mechvent,
  b.mechvent_score,
  b.electivesurgery,
  b.electivesurgery_score,
  (case
    when indays_dod < 7 then 7
    when indays_dod <= 28 then 28
    when indays_dod <= 365 then 365
    else null end) as death,
  (case when indays_dod < 7 then 1 else 0 end) as death_7,
  (case when indays_dod < 28 then 1 else 0 end) as death_28,
  (case when indays_dod < 365 then 1 else 0 end) as death_365
from
  `datathon-korea-2018.team_7.indays_adminssions` a,
  ( select
      subject_id,
      hadm_id,
      max(oasis) as oasis,
      min(age) as age,
      max(hospital_expire_flag) as hospital_expire_flag,
      max(icustay_expire_flag) as icustay_expire_flag,
      max(OASIS_PROB) as oasis_prob,
      min(age_score) as age_score,
      max(preiculos) as preiculos,
      max(preiculos_score) as preiculos_score,
      max(gcs) as gcs,
      max(gcs_score) as gcs_score,
      max(heartrate) as heartrate,
      max(heartrate_score) as heartrate_score,
      max(meanbp) as meanbp,
      max(meanbp_score) as meanbp_score,
      max(resprate) as resprate,
      max(resprate_score) as resprate_score,
      max(temp) as temp,
      max(temp_score) as temp_score,
      max(urineoutput) as urineoutput,
      max(UrineOutput_score) as UrineOutput_score,
      max(mechvent) as mechvent,
      max(mechvent_score) as mechvent_score,
      max(electivesurgery) as electivesurgery,
      max(electivesurgery_score) as electivesurgery_score
    from `physionet-data.mimiciii_derived.oasis` group by subject_id, hadm_id
  )  b
where a.subject_id = b.subject_id and a.hadm_id = b.hadm_id
order by death desc;
