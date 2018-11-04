select
  a.*, b.gender as gender
from
  `datathon-korea-2018.team_7.adm_final` a,
  `physionet-data.mimiciii_clinical.patients` b
where
  a.subject_id = b.subject_id
order by a.death desc;
