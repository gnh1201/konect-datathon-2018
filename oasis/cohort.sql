select ie.subject_id, ie.hadm_id, ie.icustay_id
      , ie.intime
      , ie.outtime
      , adm.deathtime
      , datetime_diff(ie.intime, adm.admittime, SECOND) as PreICULOS
      , floor(datetime_diff(ie.intime, pat.dob, DAY) / 365.242) as age
      , gcs.mingcs
      , vital.heartrate_max
      , vital.heartrate_min
      , vital.meanbp_max
      , vital.meanbp_min
      , vital.resprate_max
      , vital.resprate_min
      , vital.tempc_max
      , vital.tempc_min
      , vent.vent as mechvent
      , uo.urineoutput

      , case
          when adm.ADMISSION_TYPE = 'ELECTIVE' and sf.surgical = 1
            then 1
          when adm.ADMISSION_TYPE is null or sf.surgical is null
            then null
          else 0
        end as ElectiveSurgery

      -- age group
      , case
        when ( datetime_diff(ie.intime, pat.dob, DAY) / 365.242 ) <= 1 then 'neonate'
        when ( datetime_diff(ie.intime, pat.dob, DAY) / 365.242 ) <= 15 then 'middle'
        else 'adult' end as ICUSTAY_AGE_GROUP

      -- mortality flags
      , case
          when adm.deathtime between ie.intime and ie.outtime
            then 1
          when adm.deathtime <= ie.intime -- sometimes there are typographical errors in the death date
            then 1
          when adm.dischtime <= ie.outtime and adm.discharge_location = 'DEAD/EXPIRED'
            then 1
          else 0 end
        as ICUSTAY_EXPIRE_FLAG
      , adm.hospital_expire_flag
from `physionet-data.mimiciii_clinical.icustays` ie
inner join `physionet-data.mimiciii_clinical.admissions` adm
  on ie.hadm_id = adm.hadm_id
inner join `physionet-data.mimiciii_clinical.patients` pat
  on ie.subject_id = pat.subject_id
left join `datathon-korea-2018.team_7.surgflag` sf
  on ie.icustay_id = sf.icustay_id
-- join to custom tables to get more data....
left join `datathon-korea-2018.team_7.gcsfirstday` gcs
  on ie.icustay_id = gcs.icustay_id
left join `datathon-korea-2018.team_7.vitalsfirstday` vital
  on ie.icustay_id = vital.icustay_id
left join `datathon-korea-2018.team_7.uofirstday` uo
  on ie.icustay_id = uo.icustay_id
left join `datathon-korea-2018.team_7.ventfirstday` vent
on ie.icustay_id = vent.icustay_id