--select 'drop table '||tname||' cascade constraint purge;' from tab;

DROP TABLE JENIS CASCADE CONSTRAINT PURGE;
DROP TABLE OBAT CASCADE CONSTRAINT PURGE;
DROP TABLE DETAILRESEP CASCADE CONSTRAINT PURGE;
DROP TABLE PEGAWAI CASCADE CONSTRAINT PURGE;
DROP TABLE CUSTOMER CASCADE CONSTRAINT PURGE;
DROP TABLE HJUALRESEP CASCADE CONSTRAINT PURGE;
DROP TABLE DOKTER CASCADE CONSTRAINT PURGE;
DROP TABLE HJUALOBAT CASCADE CONSTRAINT PURGE;
DROP TABLE DJUALOBAT CASCADE CONSTRAINT PURGE;
DROP TRIGGER obat_seq_tr;
DROP TRIGGER jenis_seq_tr;
DROP TRIGGER dokter_seq_tr;
DROP TRIGGER KDPEGAWAI_BI;
DROP TRIGGER KDCUS_BI;
DROP TRIGGER NORESEP_BI;
DROP TRIGGER NOJUAL_BI;

create table JENIS(
    KDJENIS VARCHAR2(3) CONSTRAINT PK_JENIS PRIMARY KEY,
    NMJENIS VARCHAR2(30) CONSTRAINT NN_JENIS NOT NULL
);

CREATE TABLE PEGAWAI(
    KDPEGAWAI VARCHAR2(5) CONSTRAINT PK_PEGAWAI PRIMARY KEY,
    NAMAPEGAWAI VARCHAR2(30),
    USERNAME VARCHAR2(30),
    PASSWORD VARCHAR2(30),
	STATUS VARCHAR2(3)
);

CREATE TABLE CUSTOMER(
    KDCUST VARCHAR2(5) CONSTRAINT PK_CUST PRIMARY KEY,
    NAMACUST VARCHAR2(50),
    ALAMATCUST VARCHAR2(50),
    HPCUST VARCHAR2(15),
    UMURCUST NUMBER
);

CREATE TABLE DOKTER(
    KDDOKTER VARCHAR2(5) CONSTRAINT PK_DOKTER PRIMARY KEY,
    NAMADOKTER VARCHAR2(50),
    ALAMATDOKTER VARCHAR2(50),
    HPDOKTER VARCHAR2(15)
);

CREATE TABLE OBAT(
    KDOBAT VARCHAR2(5) CONSTRAINT PK_OBAT PRIMARY KEY,
    KDJENIS VARCHAR2(3),
    CONSTRAINT FK_JENIS
        FOREIGN KEY (KDJENIS)
        REFERENCES JENIS(KDJENIS),
    NAMAOBAT VARCHAR2(40),
    STOKOBAT NUMBER,
    HARGAOBAT NUMBER,
    DESKRIPSIOBAT VARCHAR2(100)
);

CREATE TABLE HJUALOBAT (
    NOJUAL  VARCHAR2(5) CONSTRAINT PK_HJUAL PRIMARY KEY,
    KDPEGAWAI VARCHAR2(5) CONSTRAINT FK_KDPEGAWAI
        REFERENCES PEGAWAI(KDPEGAWAI),
    TGLJUAL DATE,
    TOTALJUAL NUMBER
);

CREATE TABLE DJUALOBAT(
    NOJUAL VARCHAR2(5) CONSTRAINT PK_DJUAL PRIMARY KEY,
    KDOBAT VARCHAR2(5) CONSTRAINT FK_KDOBAT
        REFERENCES OBAT(KDOBAT),
    JUMLAHOBAT  NUMBER,
    HARGAJUALOBAT NUMBER
);

CREATE TABLE HJUALRESEP(
    NORESEP VARCHAR2(5) CONSTRAINT PK_HJUALRESEP PRIMARY KEY,
    KDCUST VARCHAR2(5) CONSTRAINT FK_KDCUSTHJR
        REFERENCES CUSTOMER(KDCUST),
    KDDOKTER VARCHAR2(5) CONSTRAINT FK_DOKTERHJR
        REFERENCES DOKTER(KDDOKTER),
    KDPEGAWAI VARCHAR2(5) CONSTRAINT FK_KDPEGAWAIHJR
        REFERENCES PEGAWAI(KDPEGAWAI),
    TGLRESEP DATE,
    TOTALRESEP NUMBER,
    STATUSKIRIM VARCHAR2(1)
);

CREATE TABLE DETAILRESEP(
    NORESEP VARCHAR2(5),
    CONSTRAINT FK_NORESEPDR 
        FOREIGN KEY (NORESEP)
        REFERENCES HJUALRESEP(NORESEP),
    KDOBAT VARCHAR2(5),
    CONSTRAINT FK_KDOBATDR
        FOREIGN KEY(KDOBAT)
        REFERENCES OBAT(KDOBAT),
    URUTAN NUMBER,
    CONSTRAINT PK_DETAILRESEP
        PRIMARY KEY(NORESEP,KDOBAT,URUTAN),
    JUMLAHPAK NUMBER,
    HARGASATUAN NUMBER,
    CARAMINUM VARCHAR2(20)
);


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
BEFORE INSERT ON HJUALRESEP FOR EACH ROW
DECLARE
	SPASI NUMBER;
	NUM NUMBER;
	TEMP VARCHAR2(5);
BEGIN
	select count(*) into num from hjualresep;
	TEMP:='NO'||LPAD(NUM+1,3,'0');
	:NEW.NORESEP:=TEMP;
END;
/
SHOW ERR;

CREATE OR REPLACE TRIGGER NOJUAL_BI
BEFORE INSERT ON HJUALOBAT FOR EACH ROW
DECLARE
	SPASI NUMBER;
	NUM NUMBER;
	TEMP VARCHAR2(5);
BEGIN
	select count(*) into num from hjualobat;
	TEMP:='NO'||LPAD(NUM+1,3,'0');
	:NEW.NOJUAL:=TEMP;
END;
/
SHOW ERR;

COMMIT;

INSERT INTO JENIS VALUES (' ','BEBAS');
INSERT INTO JENIS VALUES (' ','TERBATAS');
INSERT INTO JENIS VALUES (' ','KERAS');
INSERT INTO JENIS VALUES (' ','NARKOTIKA');


insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Jolee Vivash', '035 Monica Pass', '846 431 3684');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Tyrone Chelley', '62296 Fulton Point', '724 929 7426');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Lissi Eteen', '4165 Utah Court', '478 866 2135');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Libbie Goodsal', '245 Fairfield Alley', '298 431 3940');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Avrom Thornber', '815 Eastlawn Trail', '768 511 1018');

insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'Methocarbamol', 22, 58395, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'BE1', 'Furosemide', 29, 105983, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'PCMX with Emollient', 57, 23457, 'deskripsi2');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Saline Nasal', 29, 52234, 'deskripsi4');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Natural herb', 75, 63355, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Naproxen', 79, 127461, 'deskripsi2');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'Torsemide', 1, 14227, 'deskripsi4');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'BE1', 'Glycopyrrolate', 62, 68006, 'deskripsi2');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'PurKlenz', 16, 122545, 'deskripsi3');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'BE1', 'Haloperidol Decanoate', 11, 43626, 'deskripsi2');

insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Laure Knapper', '8 Dawn Junction', '(119) 6300458', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Tades Suerz', '5 Mallard Circle', '(830) 4257936', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Giffie MacGiolla', '7 8th Avenue', '(728) 7658804', 21);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Glenn Aspey', '0932 Lakeland Hill', '(123) 1255431', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Syd Vreede', '829 Lien Place', '(331) 9598099', 23);

insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Sibella Bufton', 'sbufton0', 'cI7ntJID4e', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Eba McNeilley', 'emcneilley1', 'JpPdA7x', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Andria Cowcha', 'acowcha2', 'WwRL1Z', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Dwain Haggleton', 'dhaggleton3', 'RlSbXh', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Anselma Tinghill', 'atinghill4', 'gqPqdA', 1);

insert into hjualresep values('a','LK001','TC1','DH001',to_date('29/03/2019','dd/mm/yyyy'),1,'1');
insert into hjualresep values('a','LK001','AT1','AT001',to_date('02/04/2019','dd/mm/yyyy'),3,'1');
insert into hjualresep values('a','GA001','LG1','AC001',to_date('05/04/2019','dd/mm/yyyy'),2,'0');
insert into hjualresep values('a','TS001','JV1','EM001',to_date('08/04/2019','dd/mm/yyyy'),6,'0');
insert into hjualresep values('a','SV001','AT1','SB001',to_date('25/04/2019','dd/mm/yyyy'),2 ,'0');

insert into detailresep values('NO001','HD001',6,12,122545,'3x1');
insert into detailresep values('NO002','PU001',7,8,63355,'2x1');
insert into detailresep values('NO003','GL001',8,2,105983,'3x1');
insert into detailresep values('NO004','TO001',9,3,52234,'3x1');
insert into detailresep values('NO005','NA001',10,2,127461,'2x1');

insert into hjualobat values('','DH001',to_date('02/01/2019','dd/mm/yyyy'),3);
insert into hjualobat values('','AT001',to_date('12/01/2019','dd/mm/yyyy'),2);
insert into hjualobat values('','AC001',to_date('28/02/2019','dd/mm/yyyy'),4);
insert into hjualobat values('','AT001',to_date('13/03/2019','dd/mm/yyyy'),3);
insert into hjualobat values('','SB001',to_date('29/04/2019','dd/mm/yyyy'),1);

insert into djualobat values('NO001','HD001',3,58395);
insert into djualobat values('NO002','NA001',2,127461);
insert into djualobat values('NO003','TO001',4,87441);
insert into djualobat values('NO004','GL001',3,32128);
insert into djualobat values('NO005','PU001',1,130010);

COMMIT;