ALTER TABLE "F1_RACES" ADD CONSTRAINT "F1_RACES_FK1" FOREIGN KEY ("CIRCUITID")
	  REFERENCES "F1_TRACKS" ("CIRCUITID") ENABLE;