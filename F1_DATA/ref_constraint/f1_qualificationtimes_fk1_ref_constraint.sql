ALTER TABLE "F1_QUALIFICATIONTIMES" ADD CONSTRAINT "F1_QUALIFICATIONTIMES_FK1" FOREIGN KEY ("DRIVERID")
	  REFERENCES "F1_DRIVERS" ("DRIVERID") ENABLE;