
BEGIN 
dbms_scheduler.disable1_calendar_check();
dbms_scheduler.create_schedule('"AUTO_LOAD_JSON_SCHEDULE"',TO_TIMESTAMP_TZ('21-DEC-2024 12.13.26,000000000 PM EUROPE/STOCKHOLM','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'),
'FREQ=DAILY;BYHOUR=20;BYMINUTE=0;BYSECOND=0;',
NULL,
'Autoload any new ergast data'
);
COMMIT; 
END; 
/ 