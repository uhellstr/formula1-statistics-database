--
-- RUn this script to start running job manually
begin
   dbms_scheduler.run_job(job_name => 'F1_LOGIK.AUTO_ERGAST_LOAD_JOB');
end;
/