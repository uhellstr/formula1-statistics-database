--
-- Run as F1_LOGIK to check wether or not job succeeded
--
select * from USER_SCHEDULER_JOB_RUN_DETAILS
order by log_date desc;