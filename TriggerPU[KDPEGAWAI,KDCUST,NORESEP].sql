
CREATE OR REPLACE TRIGGER KDPEGAWAI_BI
BEFORE INSERT ON PEGAWAI FOR EACH ROW
DECLARE
	SPASI NUMBER;
	NUM NUMBER;
	TEMP VARCHAR2(5);
BEGIN
	 SPASI := INSTR(:NEW.NAMAPEGAWAI,' ',1,1);
	 IF SPASI >0 THEN 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMAPEGAWAI,1,1))||UPPER(SUBSTR(:NEW.NAMAPEGAWAI,SPASI+1,1));
	 ELSE 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMAPEGAWAI,1,2));
	 END IF;
	 SELECT COUNT(*) INTO NUM FROM PEGAWAI WHERE SUBSTR(KDPEGAWAI,1,2) = TEMP;
	 IF NUM >0 THEN 
	 TEMP:= TEMP||LPAD(NUM+1,3,'0');
	 ELSE 
	 TEMP:= TEMP||'001';
	 END IF;
	 :NEW.KDPEGAWAI := TEMP;
END;
/
SHOW ERR;

CREATE OR REPLACE TRIGGER KDCUS_BI
BEFORE INSERT ON CUSTOMER FOR EACH ROW
DECLARE
	SPASI NUMBER;
	NUM NUMBER;
	TEMP VARCHAR2(5);
BEGIN
	 SPASI := INSTR(:NEW.NAMACUST,' ',1,1);
	 IF SPASI >0 THEN 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMACUST,1,1))||UPPER(SUBSTR(:NEW.NAMACUST,SPASI+1,1));
	 ELSE 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMACUST,1,2));
	 END IF;
	 SELECT COUNT(*) INTO NUM FROM CUSTOMER WHERE SUBSTR(KDCUST,1,2) = TEMP;
	 IF NUM >0 THEN 
	 TEMP:= TEMP||LPAD(NUM+1,3,'0');
	 ELSE 
	 TEMP:= TEMP||'001';
	 END IF;
	 :NEW.KDCUST := TEMP;
END;
/
SHOW ERR;


CREATE OR REPLACE TRIGGER NORESEP_BI
BEFORE INSERT ON CUSTOMER FOR EACH ROW
DECLARE
	SPASI NUMBER;
	NUM NUMBER;
	TEMP VARCHAR2(5);
BEGIN
	 SPASI := INSTR(:NEW.NAMACUST,' ',1,1);
	 IF SPASI >0 THEN 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMACUST,1,1))||UPPER(SUBSTR(:NEW.NAMACUST,SPASI+1,1));
	 ELSE 
	 TEMP:= UPPER(SUBSTR(:NEW.NAMACUST,1,2));
	 END IF;
	 SELECT COUNT(*) INTO NUM FROM CUSTOMER WHERE SUBSTR(KDCUST,1,2) = TEMP;
	 IF NUM >0 THEN 
	 TEMP:= TEMP||LPAD(NUM+1,3,'0');
	 ELSE 
	 TEMP:= TEMP||'001';
	 END IF;
	 :NEW.KDCUST := TEMP;
END;
/
SHOW ERR;