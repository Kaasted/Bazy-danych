CREATE TABLE kategorie (
    id_kategori    NUMBER(5) NOT NULL,
    nazwa_kategori VARCHAR2(50) NOT NULL
)
LOGGING;

ALTER TABLE kategorie ADD CONSTRAINT kategorie_pk PRIMARY KEY (id_kategori);

CREATE TABLE klienci (
    id_klienta NUMBER(5) NOT NULL,
    imie       VARCHAR2(50) NOT NULL,
    nazwisko   VARCHAR2(51) NOT NULL,
    adres      VARCHAR2(200) NOT NULL,
    email      VARCHAR2(100) NOT NULL,
    telefon    VARCHAR2(22) NOT NULL
)
LOGGING;

ALTER TABLE klienci ADD CONSTRAINT klienci_pk PRIMARY KEY (id_klienta);

CREATE TABLE kooperanci (
    id_kooperanta NUMBER(5) NOT NULL,
    typ           VARCHAR2(50) NOT NULL,
    nazwa         VARCHAR2(50) NOT NULL,
    adres         VARCHAR2(200) NOT NULL,
    telefon       VARCHAR2(22) NOT NULL
)
LOGGING;

ALTER TABLE kooperanci ADD CONSTRAINT kooperanci_pk PRIMARY KEY (id_kooperanta);

CREATE TABLE platnosci (
    id_platnosci     NUMBER(5) NOT NULL,
    metoda_platnosci VARCHAR2(20) NOT NULL,
    status           VARCHAR2(20) NOT NULL
)
LOGGING;

ALTER TABLE platnosci
    ADD CHECK (metoda_platnosci IN ('BLIK', 'Gotowka', 'Karta', 'Przelew'));

ALTER TABLE platnosci
    ADD CHECK (status IN ('oczekujaca', 'zrealizowana'));

ALTER TABLE platnosci ADD CONSTRAINT platnosci_pk PRIMARY KEY (id_platnosci);

CREATE TABLE producenci (
    id_producenta    NUMBER(5) NOT NULL,
    nazwa_producenta VARCHAR2(50) NOT NULL,
    adres            VARCHAR2(200) NOT NULL,
    telefon          VARCHAR2(22) NOT NULL
)
LOGGING;

ALTER TABLE producenci ADD CONSTRAINT producenci_pk PRIMARY KEY (id_producenta);

CREATE TABLE reklamacje (
    id_reklamacji            NUMBER(7) NOT NULL,
    data_reklamacji          DATE NOT NULL,
    opis                     VARCHAR2(500),
    status                   VARCHAR2(20) NOT NULL,
    zamowienia_id_zamowienia NUMBER(7) NOT NULL,
    klienci_id_klienta       NUMBER(5) NOT NULL,
    kooperanci_id_kooperanta NUMBER(5) NOT NULL
)
LOGGING;

ALTER TABLE reklamacje
    ADD CHECK (status IN ('nierozpatrzona', 'rozpatrzona'));

CREATE UNIQUE INDEX reklamacje__idx ON
    reklamacje (
        zamowienia_id_zamowienia
    ASC);

ALTER TABLE reklamacje ADD CONSTRAINT reklamacje_pk PRIMARY KEY (id_reklamacji);

CREATE TABLE stan_magazynu (
    id_stan             NUMBER(7) NOT NULL,
    dostepna_ilosc      NUMBER(5) NOT NULL,
    ilosc_zarezerwowana NUMBER(5) NOT NULL,
    towary_id_towaru    NUMBER(5) NOT NULL
)
LOGGING;

CREATE UNIQUE INDEX stan_magazynu__idx ON
    stan_magazynu (
        towary_id_towaru
    ASC);

ALTER TABLE stan_magazynu ADD CONSTRAINT stan_magazynu_pk PRIMARY KEY (id_stan);

CREATE TABLE towary (
    id_towaru                NUMBER(5) NOT NULL,
    nazwa_towaru             VARCHAR2(50) NOT NULL,
    parametry                VARCHAR2(50) NOT NULL,
    cena                     NUMBER(10, 2) NOT NULL,
    zdjecie                  BLOB,
    kategorie_id_kategori    NUMBER(5) NOT NULL,
    producenci_id_producenta NUMBER(5) NOT NULL
)
LOGGING;

ALTER TABLE towary ADD CONSTRAINT towary_pk PRIMARY KEY (id_towaru);

CREATE TABLE transakcje (
    id_transakcji          NUMBER(7) NOT NULL,
    data_transakcji        DATE NOT NULL,
    kwota                  NUMBER(10, 2) NOT NULL,
    status                 VARCHAR2(20) NOT NULL,
    platnosci_id_platnosci NUMBER(5) NOT NULL
)
LOGGING;

ALTER TABLE transakcje
    ADD CHECK (status IN ('anulowana', 'oczekujaca', 'zrealizowana'));

CREATE UNIQUE INDEX transakcje__idx ON
    transakcje (
        platnosci_id_platnosci
    ASC);

ALTER TABLE transakcje ADD CONSTRAINT transakcje_pk PRIMARY KEY (id_transakcji);

CREATE TABLE zamowione_towary (
    ilosc                    NUMBER(5) NOT NULL,
    cena_za_sztuke           NUMBER(10, 2) NOT NULL,
    zamowienia_id_zamowienia NUMBER(7) NOT NULL,
    towary_id_towaru         NUMBER(5) NOT NULL
)
LOGGING;

CREATE TABLE zamowienia (
    id_zamowienia            NUMBER(7) NOT NULL,
    kooperanci_id_kooperanta NUMBER(5) NOT NULL,
    klienci_id_klienta       NUMBER(5) NOT NULL,
    transakcje_id_transakcji NUMBER(7) NOT NULL
)
LOGGING;

ALTER TABLE zamowienia ADD CONSTRAINT zamowienia_pk PRIMARY KEY (id_zamowienia);

ALTER TABLE reklamacje
    ADD CONSTRAINT reklamacje_klienci_fk
        FOREIGN KEY (klienci_id_klienta)
            REFERENCES klienci (id_klienta)
            NOT DEFERRABLE;

ALTER TABLE reklamacje
    ADD CONSTRAINT reklamacje_kooperanci_fk
        FOREIGN KEY (kooperanci_id_kooperanta)
            REFERENCES kooperanci (id_kooperanta)
            NOT DEFERRABLE;

ALTER TABLE reklamacje
    ADD CONSTRAINT reklamacje_zamowienia_fk
        FOREIGN KEY (zamowienia_id_zamowienia)
            REFERENCES zamowienia (id_zamowienia)
            NOT DEFERRABLE;

ALTER TABLE stan_magazynu
    ADD CONSTRAINT stan_magazynu_towary_fk
        FOREIGN KEY (towary_id_towaru)
            REFERENCES towary (id_towaru)
            NOT DEFERRABLE;

ALTER TABLE towary
    ADD CONSTRAINT towary_kategorie_fk
        FOREIGN KEY (kategorie_id_kategori)
            REFERENCES kategorie (id_kategori)
            NOT DEFERRABLE;

ALTER TABLE towary
    ADD CONSTRAINT towary_producenci_fk
        FOREIGN KEY (producenci_id_producenta)
            REFERENCES producenci (id_producenta)
            NOT DEFERRABLE;

ALTER TABLE transakcje
    ADD CONSTRAINT transakcje_platnosci_fk
        FOREIGN KEY (platnosci_id_platnosci)
            REFERENCES platnosci (id_platnosci)
            NOT DEFERRABLE;

ALTER TABLE zamowione_towary
    ADD CONSTRAINT zamowione_towary_towary_fk
        FOREIGN KEY (towary_id_towaru)
            REFERENCES towary (id_towaru)
            NOT DEFERRABLE;

ALTER TABLE zamowione_towary
    ADD CONSTRAINT zamowione_towary_zamowienia_fk
        FOREIGN KEY (zamowienia_id_zamowienia)
            REFERENCES zamowienia (id_zamowienia)
            NOT DEFERRABLE;

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_klienci_fk
        FOREIGN KEY (klienci_id_klienta)
            REFERENCES klienci (id_klienta)
            NOT DEFERRABLE;

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_kooperanci_fk
        FOREIGN KEY (kooperanci_id_kooperanta)
            REFERENCES kooperanci (id_kooperanta)
            NOT DEFERRABLE;

ALTER TABLE zamowienia
    ADD CONSTRAINT zamowienia_transakcje_fk
        FOREIGN KEY (transakcje_id_transakcji)
            REFERENCES transakcje (id_transakcji)
            NOT DEFERRABLE;
