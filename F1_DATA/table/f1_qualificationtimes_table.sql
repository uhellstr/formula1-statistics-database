  CREATE TABLE "F1_DATA"."F1_QUALIFICATIONTIMES" 
   (	"SEASON" NUMBER,
	"ROUND" NUMBER,
	"RACEDATE" DATE,
	"RACETIME" VARCHAR2(20),
	"POSITION" NUMBER,
	"DRIVERID" VARCHAR2(30),
	"CONSTRUCTORID" VARCHAR2(30),
	"Q1" VARCHAR2(20),
	"Q2" VARCHAR2(20),
	"Q3" VARCHAR2(20),
	CONSTRAINT "F1_QUALIFICATIONTIMES_FK1" FOREIGN KEY ("DRIVERID")
	 REFERENCES "F1_DATA"."F1_DRIVERS" ("DRIVERID") ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 NOCOMPRESS LOGGING
  STORAGE( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"