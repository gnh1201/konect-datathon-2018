select ie.SUBJECT_ID, ie.HADM_ID, ie.ICUSTAY_ID
-- The minimum GCS is determined by the above row partition, we only join if IsMinGCS=1
, GCS as MinGCS
, coalesce(GCSMotor,GCSMotorPrev) as GCSMotor
, coalesce(GCSVerbal,GCSVerbalPrev) as GCSVerbal
, coalesce(GCSEyes,GCSEyesPrev) as GCSEyes
, EndoTrachFlag as EndoTrachFlag

-- subselect down to the cohort of eligible patients
from `physionet-data.mimiciii_clinical.icustays` ie
left join `datathon-korea-2018.team_7.gcs_final` gs
  on ie.ICUSTAY_ID = gs.ICUSTAY_ID and gs.IsMinGCS = 1
ORDER BY ie.ICUSTAY_ID;
