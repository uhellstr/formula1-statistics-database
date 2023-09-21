
  CREATE OR REPLACE EDITIONABLE FUNCTION "F1_LOGIK"."CONVERT_TIME_TO_NUMERIC" (p_time_string IN VARCHAR2)
  RETURN NUMBER
IS
  v_numeric_value NUMBER;
BEGIN
  -- Remove the colons and the dot from the time string
  v_numeric_value := TO_NUMBER(REPLACE(REPLACE(p_time_string, ':', ''), '.', ''));

  RETURN v_numeric_value;
END;
