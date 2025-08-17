--
-- Run as F1_LOGIK to check wether or not job succeeded
--
select log_id,log_date, owner, job_name, status, error#, REQ_START_DATE
actual_start_date, run_duration,additional_info 
from USER_SCHEDULER_JOB_RUN_DETAILS
order by log_date desc;