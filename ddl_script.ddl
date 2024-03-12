CREATE TABLE bilety (
    nazwa    VARCHAR2(40) NOT NULL,
    cena     NUMBER(5, 2) NOT NULL,
    max_czas TIMESTAMP NOT NULL);

CREATE TABLE bilety_strefy (
    strefy_nazwa_strefy VARCHAR2(40) NOT NULL,
    bilety_nazwa        VARCHAR2(40) NOT NULL);

CREATE TABLE odwiedajacy_bilety (
    bilety_nazwa       VARCHAR2(40) NOT NULL,
    odwiedzaj¹cy_pesel INTEGER NOT NULL);

CREATE TABLE odwiedzaj¹cy (
    pesel           INTEGER NOT NULL,
    imie            VARCHAR2(40) NOT NULL,
    nazwisko        VARCHAR2(40) NOT NULL,
    godzina_wejscia TIMESTAMP NOT NULL,
    nr_telefonu     INTEGER);

CREATE TABLE pracownicy_wydarzenie (
    wydarzenie_nazwa VARCHAR2(40) NOT NULL,
    pracownik_pesel  INTEGER NOT NULL);

CREATE TABLE pracownik (
    pesel               INTEGER NOT NULL,
    nazwisko            VARCHAR2(40) NOT NULL,
    stanowisko          VARCHAR2(40) NOT NULL,
    data_zatrudnienia   DATE NOT NULL,
    nr_telefonu         INTEGER,
    strefy_nazwa_strefy VARCHAR2(40) NOT NULL,
    placa               NUMBER(6, 2) NOT NULL);

CREATE TABLE strefy (
    nazwa_strefy VARCHAR2(40) NOT NULL,
    powierzchnia NUMBER(10, 2) NOT NULL,
    opis         VARCHAR2(200) NOT NULL);

CREATE TABLE wydarzenie (
    nazwa               VARCHAR2(40) NOT NULL,
    data_rozpoczecia    TIMESTAMP NOT NULL,
    data_zakonczenia    TIMESTAMP NOT NULL,
    opis                VARCHAR2(400),
    strefy_nazwa_strefy VARCHAR2(40) NOT NULL);

CREATE TABLE zwierzeta_wydarzenie (
    wydarzenie_nazwa    VARCHAR2(40) NOT NULL,
    zwierzêta_id_zwierz NUMBER NOT NULL);

CREATE TABLE zwierzêta (
    id_zwierz           NUMBER(10) NOT NULL,
    imie                VARCHAR2(30) NOT NULL,
    gatunek             VARCHAR2(30) NOT NULL,
    data_urodzenia      DATE NOT NULL,
    plec                VARCHAR2(20) NOT NULL,
    waga                NUMBER(8, 2),
    strefy_nazwa_strefy VARCHAR2(40) NOT NULL);

ALTER TABLE bilety ADD CONSTRAINT bilety_pk PRIMARY KEY ( nazwa );

ALTER TABLE bilety_strefy ADD CONSTRAINT bilety_strefy_pk PRIMARY KEY ( strefy_nazwa_strefy, bilety_nazwa );

ALTER TABLE odwiedajacy_bilety ADD CONSTRAINT odwiedz_bilety_pk PRIMARY KEY ( bilety_nazwa, odwiedzaj¹cy_pesel );

ALTER TABLE odwiedzaj¹cy ADD CONSTRAINT odwiedzaj¹cy_pk PRIMARY KEY ( pesel );

ALTER TABLE pracownicy_wydarzenie ADD CONSTRAINT prac_wydarz_pk PRIMARY KEY ( wydarzenie_nazwa, pracownik_pesel );

ALTER TABLE pracownik ADD CONSTRAINT pracownik_pk PRIMARY KEY ( pesel );

ALTER TABLE strefy ADD CONSTRAINT strefy_pk PRIMARY KEY ( nazwa_strefy );

ALTER TABLE wydarzenie ADD CONSTRAINT wydarzenie_pk PRIMARY KEY ( nazwa );

ALTER TABLE zwierzeta_wydarzenie ADD CONSTRAINT zwierz_wydarz_pk PRIMARY KEY ( wydarzenie_nazwa, zwierzêta_id_zwierz );

ALTER TABLE zwierzêta ADD CONSTRAINT zwierzêta_pk PRIMARY KEY ( id_zwierz );

ALTER TABLE zwierzêta ADD CONSTRAINT zwierzêta__un UNIQUE ( imie, gatunek );

ALTER TABLE bilety_strefy
    ADD CONSTRAINT bilety_strefy_bilety_fk FOREIGN KEY ( bilety_nazwa )
        REFERENCES bilety ( nazwa );

ALTER TABLE bilety_strefy
    ADD CONSTRAINT bilety_strefy_strefy_fk FOREIGN KEY ( strefy_nazwa_strefy )
        REFERENCES strefy ( nazwa_strefy );

ALTER TABLE odwiedajacy_bilety
    ADD CONSTRAINT odwiedz_bilety_bilety_fk FOREIGN KEY ( bilety_nazwa )
        REFERENCES bilety ( nazwa );

ALTER TABLE odwiedajacy_bilety
    ADD CONSTRAINT odwiedz_bilety_odwiedz_fk FOREIGN KEY ( odwiedzaj¹cy_pesel )
        REFERENCES odwiedzaj¹cy ( pesel );

ALTER TABLE pracownicy_wydarzenie
    ADD CONSTRAINT prac_wydarz_prac_fk FOREIGN KEY ( pracownik_pesel )
        REFERENCES pracownik ( pesel );

ALTER TABLE pracownicy_wydarzenie
    ADD CONSTRAINT prac_wydarz_wydarz_fk FOREIGN KEY ( wydarzenie_nazwa )
        REFERENCES wydarzenie ( nazwa );

ALTER TABLE pracownik
    ADD CONSTRAINT pracownik_strefy_fk FOREIGN KEY ( strefy_nazwa_strefy )
        REFERENCES strefy ( nazwa_strefy );

ALTER TABLE wydarzenie
    ADD CONSTRAINT wydarzenie_strefy_fk FOREIGN KEY ( strefy_nazwa_strefy )
        REFERENCES strefy ( nazwa_strefy );

ALTER TABLE zwierzeta_wydarzenie
    ADD CONSTRAINT zwierz_wydarz_wydarz_fk FOREIGN KEY ( wydarzenie_nazwa )
        REFERENCES wydarzenie ( nazwa );

ALTER TABLE zwierzeta_wydarzenie
    ADD CONSTRAINT zwierz_wydarz_zwierz_fk FOREIGN KEY ( zwierzêta_id_zwierz )
        REFERENCES zwierzêta ( id_zwierz );

ALTER TABLE zwierzêta
    ADD CONSTRAINT zwierzêta_strefy_fk FOREIGN KEY ( strefy_nazwa_strefy )
        REFERENCES strefy ( nazwa_strefy );


ALTER TABLE bilety
    ADD CONSTRAINT bilety_cena_check CHECK (cena > 0);

ALTER TABLE strefy
    ADD CONSTRAINT strefy_powierzchnia_check CHECK (powierzchnia > 0);

ALTER TABLE wydarzenie
    ADD CONSTRAINT wydarzenie_czas_check CHECK (data_rozpoczecia < data_zakonczenia);

ALTER TABLE zwierzêta
    ADD CONSTRAINT zwierzêta_waga_check CHECK (waga > 0);
ALTER TABLE odwiedzajacy
    ADD CONSTRAINT odwiedzajacy_pesel_length_check CHECK (LENGTH(TO_CHAR(pesel)) = 11);

ALTER TABLE odwiedzajacy
    ADD CONSTRAINT odwiedzajacy_nr_telefonu_length_check CHECK (LENGTH(TO_CHAR(nr_telefonu)) = 9);

ALTER TABLE pracownik
    ADD CONSTRAINT odwiedzajacy_pesel1_length_check CHECK (LENGTH(TO_CHAR(pesel)) = 11);

ALTER TABLE pracownik
    ADD CONSTRAINT odwiedzajacy_nr_telefonu1_length_check CHECK (LENGTH(TO_CHAR(nr_telefonu)) = 9);
    
ALTER TABLE pracownik
    ADD CONSTRAINT nr_telefonu_check CHECK (nr_telefonu>0);

ALTER TABLE odwiedzajacy
    ADD CONSTRAINT nr_telefonu_check1 CHECK (nr_telefonu>0);


ALTER TABLE pracownik
    ADD CONSTRAINT pesel_check1123 CHECK (pesel>0);

ALTER TABLE odwiedzajacy
    ADD CONSTRAINT pesel_check123 CHECK (pesel>0);
ALTER TABLE pracownik
    ADD CONSTRAINT placa_check12213 CHECK (placa>=0);
    
CREATE OR REPLACE PROCEDURE zwieksz_place_pracownikow_w_strefie (
    p_przyrost    IN NUMBER,
    p_nazwa_strefy IN VARCHAR2
)
IS
BEGIN
    UPDATE pracownik
    SET placa = placa + p_przyrost
    WHERE strefy_nazwa_strefy = p_nazwa_strefy;
    DBMS_OUTPUT.PUT_LINE('Podwy¿ka p³acy dla pracowników w strefie ' || p_nazwa_strefy || ' o: ' || p_przyrost || ' zl.');
END;


CREATE OR REPLACE PROCEDURE zwieksz_wage_zwierzecia (
    p_id_zwierz IN NUMBER,
    p_przyrost  IN NUMBER
)
IS
    v_nowa_waga NUMBER(8, 2);
BEGIN
    SELECT waga INTO v_nowa_waga
    FROM zwierzêta
    WHERE id_zwierz = p_id_zwierz;

    v_nowa_waga := v_nowa_waga + p_przyrost;

    UPDATE zwierzêta
    SET waga = v_nowa_waga
    WHERE id_zwierz = p_id_zwierz;

    DBMS_OUTPUT.PUT_LINE('Waga zwierzêcia o ID: ' || p_id_zwierz || ', zosta³a zwiêkszona o ' || p_przyrost);
END;

CREATE OR REPLACE FUNCTION liczba_zwierzat_w_strefie (
    p_nazwa_strefy IN VARCHAR2
)
RETURN NUMBER
IS
    v_liczba_zwierzat NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_liczba_zwierzat
    FROM zwierzêta
    WHERE strefy_nazwa_strefy = p_nazwa_strefy;
    
    RETURN v_liczba_zwierzat;
END liczba_zwierzat_w_strefie;

/*
DECLARE
    v_liczba_zwierzat NUMBER;
BEGIN
    v_liczba_zwierzat := liczba_zwierzat_w_strefie('');
    DBMS_OUTPUT.PUT_LINE('Liczba zwierz¹t: ' || v_liczba_zwierzat);
END;
*/

CREATE SEQUENCE zwierzeta_seq
    START WITH 1
    INCREMENT BY 1;


/*
DROP TABLE zwierzeta_wydarzenie CASCADE CONSTRAINTS;
DROP TABLE odwiedajacy_bilety CASCADE CONSTRAINTS;
DROP TABLE pracownicy_wydarzenie CASCADE CONSTRAINTS;
DROP TABLE bilety_strefy CASCADE CONSTRAINTS;
DROP TABLE bilety CASCADE CONSTRAINTS;
DROP TABLE odwiedzaj¹cy CASCADE CONSTRAINTS;
DROP TABLE pracownik CASCADE CONSTRAINTS;
DROP TABLE strefy CASCADE CONSTRAINTS;
DROP TABLE wydarzenie CASCADE CONSTRAINTS;
DROP TABLE zwierzêta CASCADE CONSTRAINTS;*/