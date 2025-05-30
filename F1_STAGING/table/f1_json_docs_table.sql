  CREATE TABLE "F1_JSON_DOCS" 
   (	"DOC_ID" NUMBER NOT NULL ENABLE,
	"DOC_TYPE" NUMBER NOT NULL ENABLE,
	"DATE_LOADED" TIMESTAMP(6) NOT NULL ENABLE,
	"SEASON" NUMBER,
	"RACE" NUMBER,
	"LAPNUMBER" NUMBER,
	"RACETYPE" NUMBER,
	"F1_DOCUMENT" JSON NOT NULL ENABLE,
	CONSTRAINT "F1_JSON_DOCS_PK" PRIMARY KEY ("DOC_ID")
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
 JSON ("F1_DOCUMENT") STORE AS  (
  TABLESPACE "USERS" CHUNK 8192 RETENTION MIN 1800
  STORAGE( INITIAL 262144 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT))