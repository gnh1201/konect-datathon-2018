  select ie.icustay_id
    , max(case
        when lower(curr_service) like '%surg%' then 1
        when curr_service = 'ORTHO' then 1
    else 0 end) as surgical
  from `physionet-data.mimiciii_clinical.icustays` ie
  left join `physionet-data.mimiciii_clinical.services` se
    on ie.hadm_id = se.hadm_id
    and se.transfertime < DATETIME_ADD(ie.intime, interval 1 day)
group by ie.icustay_id