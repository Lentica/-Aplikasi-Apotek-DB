--Kevin
CREATE OR REPLACE TRIGGER obat_seq_tr
BEFORE INSERT ON obat FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.namaobat,' ')=0)then
		kodemember:=upper(substr(:new.namaobat,1,2));
	else
		kodemember:=upper(substr(:new.namaobat,1,1))||upper(substr(:new.namaobat,instr(:new.namaobat,' ')+1,1));
	end if;
	select to_number(max(substr(kdobat,-1,3))) into tempMax from obat where kdobat like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kdobat:=kodemember||lpad(tempMax,3,'0');
END;
/

CREATE OR REPLACE TRIGGER jenis_seq_tr
BEFORE INSERT ON jenis FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.nmjenis,' ')=0)then
		kodemember:=upper(substr(:new.nmjenis,1,2));
	else
		kodemember:=upper(substr(:new.nmjenis,1,1))||upper(substr(:new.nmjenis,instr(:new.nmjenis,' ')+1,1));
	end if;
	select to_number(max(substr(kdjenis,-1,3))) into tempMax from jenis where kdjenis like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kdjenis:=kodemember||tempMax;
END;
/

CREATE OR REPLACE TRIGGER dokter_seq_tr
BEFORE INSERT ON dokter FOR EACH ROW
DECLARE
	kodemember varchar2(20);
	tempMax number;
BEGIN
	if(instr(:new.namadokter,' ')=0)then
		kodemember:=upper(substr(:new.namadokter,1,2));
	else
		kodemember:=upper(substr(:new.namadokter,1,1))||upper(substr(:new.namadokter,instr(:new.namadokter,' ')+1,1));
	end if;
	select to_number(max(substr(kddokter,-1,3))) into tempMax from dokter where kddokter like kodemember||'%';
	if tempMax is null then
		tempMax:=0;
	end if;
	tempMax:=tempMax+1;
	:new.kddokter:=kodemember||tempMax;
END;
/

--pu
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

COMMIT;