  CREATE TABLE "F1_DATA"."F1_TRACKS" 
   (	"CIRCUITID" VARCHAR2(30) NOT NULL ENABLE,
	"INFO" VARCHAR2(100),
	"CIRCUITNAME" VARCHAR2(50),
	"LAT" NUMBER,
	"LONGITUD" NUMBER(*,6),
	"LOCALITY" VARCHAR2(50),
	"COUNTRY" VARCHAR2(30),
	CONSTRAINT "F1_TRACKS_PK" PRIMARY KEY ("CIRCUITID")
  USING INDEX
  PCTFREE 10 INITRANS 2 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 NOCOMPRESS LOGGING
  STORAGE( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"