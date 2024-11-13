
BEGIN 
dbms_scheduler.create_program('"AUTO_LOAD_NEW_F1_DATA"','STORED_PROCEDURE',
'f1_init_pkg.load_json'
,0, TRUE,
'Call stored packaged procedure'
);
COMMIT; 
END; 
/ 