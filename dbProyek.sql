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

INSERT INTO JENIS VALUES (' ','BEBAS');
INSERT INTO JENIS VALUES (' ','TERBATAS');
INSERT INTO JENIS VALUES (' ','KERAS');
INSERT INTO JENIS VALUES (' ','NARKOTIKA');

insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Marietta Karolowski', '940 Westridge Road', '619 210 8129');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Jolee Vivash', '035 Monica Pass', '846 431 3684');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Tyrone Chelley', '62296 Fulton Point', '724 929 7426');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Lissi Eteen', '4165 Utah Court', '478 866 2135');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Libbie Goodsal', '245 Fairfield Alley', '298 431 3940');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Avrom Thornber', '815 Eastlawn Trail', '768 511 1018');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Alyse Mounfield', '7426 Nobel Park', '577 968 1895');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Yule Hallett', '50613 Cardinal Court', '595 956 2414');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Fabian Marshland', '75 Bartillon Road', '300 151 6377');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Jeniece Rosier', '6 Swallow Street', '727 357 2340');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Kennie Henke', '63677 Corry Crossing', '289 502 4547');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Melamie Ouchterlony', '11 Cambridge Place', '655 518 6181');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Derron Monroe', '01 Florence Point', '632 694 6355');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Herminia Bishopp', '45 Nevada Point', '745 503 9363');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Steve Shiels', '1125 Goodland Park', '628 537 2757');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Garey Eteen', '170 Tomscot Point', '958 206 8320');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Kirstin Reeday', '02745 Southridge Road', '288 709 4334');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Gail Pattington', '4 Elka Pass', '952 998 6354');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Mada Fitkin', '103 Cardinal Hill', '300 223 0856');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Briney Zima', '0 Meadow Vale Park', '252 679 3059');
insert into DOKTER (KDDOKTER, NAMADOKTER, ALAMATDOKTER, HPDOKTER) values ('''''', 'Steven Boyfield', '8764 Butternut Parkway', '306 171 3784');

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
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Degree', 49, 33277, 'deskripsi3');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'TE1', 'B-PLEX 100', 86, 126049, 'deskripsi4');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'Conchae Argentum', 10, 97441, 'deskripsi3');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Flumazenil', 87, 22819, 'deskripsi3');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'Bamboo Sap Patch', 36, 115345, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'SPF 25 UVA/UVB', 25, 123215, 'deskripsi4');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'BE1', 'Senna laxative', 98, 122643, 'deskripsi4');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', '3 CONCEPT EYES HONEY FACE CHIFFON FLUID 002', 73, 149690, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'NA1', 'Bystolic', 38, 75009, 'deskripsi2');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'BE1', 'CVS Gentle Laxative', 77, 130010, 'deskripsi1');
insert into OBAT (KDOBAT, KDJENIS, NAMAOBAT, STOKOBAT, HARGAOBAT, DESKRIPSIOBAT) values (null, 'KE1', 'AGARICUS MUSCARIUS', 47, 32128, 'deskripsi1');


insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Laure Knapper', '8 Dawn Junction', '(119) 6300458', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Tades Suerz', '5 Mallard Circle', '(830) 4257936', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Giffie MacGiolla', '7 8th Avenue', '(728) 7658804', 21);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Glenn Aspey', '0932 Lakeland Hill', '(123) 1255431', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Syd Vreede', '829 Lien Place', '(331) 9598099', 23);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Grissel Corley', '33 Oriole Road', '(955) 7387339', 21);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Abner Dowers', '7909 Loftsgordon Park', '(886) 1842850', 21);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Rafaelia Beaven', '212 Del Sol Trail', '(888) 7530783', 23);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Waly McDell', '88445 Carioca Street', '(544) 1824565', 23);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Kasper Maple', '03037 Fremont Circle', '(198) 5372646', 23);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Simonette Hrishchenko', '3398 Weeping Birch Pass', '(100) 4454086', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Kassie Camamile', '94283 Del Mar Pass', '(131) 8993064', 20);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Filbert Coalbran', '23 Starling Crossing', '(697) 2041796', 20);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Gerrie Lethbury', '606 Roth Plaza', '(652) 2682003', 20);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Vikki Taleworth', '99 Bobwhite Center', '(228) 8126733', 20);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Pris Sparshett', '6 Tony Parkway', '(469) 1731574', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Annora Giacaponi', '91762 Caliangt Court', '(549) 9525754', 21);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Shannen Egginson', '051 Bartelt Hill', '(376) 4630442', 23);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Idelle Keinrat', '1 Monica Terrace', '(714) 9486056', 22);
insert into CUSTOMER (KDCUST, NAMACUST, ALAMATCUST, HPCUST, UMURCUST) values ('', 'Cindie Gandey', '5915 Shasta Pass', '(709) 1999470', 20);


insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Sibella Bufton', 'sbufton0', 'cI7ntJID4e', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Eba McNeilley', 'emcneilley1', 'JpPdA7x', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Andria Cowcha', 'acowcha2', 'WwRL1Z', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Dwain Haggleton', 'dhaggleton3', 'RlSbXh', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Anselma Tinghill', 'atinghill4', 'gqPqdA', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Britt Tandey', 'btandey5', 'nlh25ZY2rXh', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Mallorie Dudill', 'mdudill6', 'Yk9LRQQ8OHQ', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Graham Stading', 'gstading7', 'IbQg724', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Willie Heinke', 'wheinke8', 'RPGvf8', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Darda Cohen', 'dcohen9', 'Gzy4hoou', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Anitra Sekulla', 'asekullaa', 'Z9yA3z', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Stuart Lindell', 'slindellb', '1ugkAT', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Gale MacClancey', 'gmacclanceyc', 'IFgD4U9Z', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Rosmunda Crombie', 'rcrombied', '96PzR3qA', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Pryce Tiller', 'ptillere', 'fBkgJpbwWAO', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Luisa Shippam', 'lshippamf', 'KZvPpaH', 1);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Ody Cobain', 'ocobaing', '8Z9BHgcqv0kc', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Lotte Fowlds', 'lfowldsh', 'Au3xA5pQ8', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Max Driffill', 'mdriffilli', 'g0RlrZ', 0);
insert into PEGAWAI (KDPEGAWAI, NAMAPEGAWAI, USERNAME, PASSWORD, STATUS) values ('', 'Shirl Higounet', 'shigounetj', 'cFolKdlnhOaT', 0);


COMMIT;