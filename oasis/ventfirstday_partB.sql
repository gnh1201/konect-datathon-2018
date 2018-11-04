select
  ie.subject_id, ie.hadm_id, ie.icustay_id
  , max(case
      when vd.icustay_id is not null then 1
    else 0 end) as vent
from `physionet-data.mimiciii_clinical.icustays` as ie
left join `datathon-korea-2018.team_7.ventdurations` as vd
  on ie.icustay_id = vd.icustay_id and vd.starttime <= ie.intime and vd.endtime >= ie.intime
group by ie.subject_id, ie.hadm_id, ie.icustay_id