drop table PARTICIPA_LA;
drop table DEZVOLTA;
drop table GRUPEAZA;
drop table CUMPARA;
drop table EVENIMENT;
drop table ETICHETA;
drop table CONTINUT_ADITIONAL;
drop table DEZVOLTATOR;
drop table MISIUNE;
drop table UTILIZATOR;
drop table JOC;
drop table CATEGORIE;
drop table PRODUCATOR;

--CREAREA TABELELOR

CREATE TABLE CATEGORIE(
    nume_categorie VARCHAR2(25),
    apreciere CHAR(8) default null, 
    constraint categorie_pk primary key (nume_categorie),
    constraint apreciere_enum check (apreciere in ('ridicata', 'medie', 'scazuta'))
);

CREATE TABLE PRODUCATOR(
    nume_producator VARCHAR2(40),
    tara_sediu VARCHAR2(15) default NULL,
    an_infiintare NUMBER(4) default NULL,
    constraint producator_pk primary key (nume_producator),
    constraint an_infiintare_chk check (an_infiintare >= 1880)
);

CREATE TABLE JOC(
    id_joc NUMBER(7),
    data_lansarii DATE,
    nume VARCHAR2(50) constraint nume_joc_nn not null,
    varsta_minima NUMBER(3) constraint varsta_nn not null,
    pret NUMBER(5,2),
    nume_categorie VARCHAR2(25) constraint nume_categorie_fk_nn not null,
    nume_producator VARCHAR2(40),
    constraint joc_pk primary key (id_joc),
    constraint joc_categorie_fk foreign key(nume_categorie) references CATEGORIE(nume_categorie) ON DELETE CASCADE,
    constraint joc_producator_fk foreign key(nume_producator) references PRODUCATOR(nume_producator) ON DELETE SET NULL,
    constraint pret_pozitiv check (pret >= 0)
);

CREATE TABLE UTILIZATOR(
    username VARCHAR2(20),
    nume VARCHAR2(30) constraint nume_utilizator_nn not null,
    prenume VARCHAR2(30) constraint prenume_nn not null,
    adresa_mail VARCHAR2(50) constraint adresa_mail_nn not null,
    data_nasterii DATE constraint data_nasterii_nn not null,
    data_inregistrarii DATE default sysdate constraint data_inregistrarii_nn not null,
    porecla VARCHAR2(15) constraint porecla_nn not null,
    constraint utilizator_pk primary key (username),
    constraint adresa_mail_fmt check (adresa_mail like '%@%.%'),
    constraint data_nasterii_chk check (EXTRACT(YEAR FROM data_nasterii) >= 1920)
);


CREATE TABLE MISIUNE(
    id_misiune NUMBER(7),
    id_joc NUMBER(7),
    denumire_misiune VARCHAR2(30),
    dificultate CHAR(15) default NULL,
    constraint misiune_pk primary key (id_misiune, id_joc),
    constraint joc_misiune_fk foreign key (id_joc) references JOC(id_joc) ON DELETE CASCADE,
    constraint dificultate_enum check (dificultate in ('foarte usor', 'usor', 'mediu', 'dificil', 'foarte dificil'))
);

CREATE TABLE DEZVOLTATOR(
    nume_dezvoltator VARCHAR2(40),
    rating NUMBER(3,1) default NULL,
    constraint dezvoltator_pk primary key (nume_dezvoltator),
    constraint rating_pozitiv check (rating BETWEEN 1 AND 10)
);

CREATE TABLE CONTINUT_ADITIONAL(
    DLC NUMBER(7),
    nume_dlc VARCHAR2(50) constraint nume_dlc_nn not null, 
    data_lansare DATE,
    rating_dlc NUMBER(3,1) default NULL,
    id_joc NUMBER(7),
    constraint continut_aditional_pk primary key(DLC, id_joc),
    constraint nume_dlc_unique unique(nume_dlc),
    constraint joc_continut_aditional_fk foreign key(id_joc) references JOC(id_joc) ON DELETE CASCADE,
    constraint rating_dlc_pozitiv check (rating_dlc BETWEEN 1 and 10),
    constraint data_lansare_chk check (EXTRACT(YEAR FROM data_lansare) >= 2000) 
);

CREATE TABLE ETICHETA(
    id_eticheta NUMBER(6), 
    nume_eticheta VARCHAR2(50),
    constraint eticheta_pk primary key (id_eticheta),
    constraint nume_eticheta_unique unique (nume_eticheta)
);

CREATE TABLE EVENIMENT(
    denumire VARCHAR2(40),
    tip_eveniment VARCHAR2(40),
    data_inceperii DATE default NULL,
    data_incheierii DATE default NULL,
    constraint eveniment_pk primary key (denumire, tip_eveniment),
    constraint data_inceperii_chk check (data_inceperii <= data_incheierii)
);

CREATE TABLE PARTICIPA_LA(
    denumire VARCHAR2(40),
    tip_eveniment VARCHAR2(40),
    username VARCHAR2(20),
    data_participare DATE,
    constraint participa_la_pk primary key (denumire, tip_eveniment, username),
    constraint eveniment_participa_la_fk foreign key (denumire, tip_eveniment) references EVENIMENT(denumire, tip_eveniment) ON DELETE CASCADE,
    constraint utilizator_participa_la_fk foreign key (username) references UTILIZATOR(username) ON DELETE CASCADE
);

CREATE TABLE DEZVOLTA(
    nume_dezvoltator VARCHAR2(40),
    id_joc NUMBER(7),
    constraint dezvolta_pk primary key (nume_dezvoltator, id_joc),
    constraint dezvoltator_dezvolta_fk foreign key (nume_dezvoltator) references DEZVOLTATOR(nume_dezvoltator) ON DELETE CASCADE,
    constraint joc_dezvolta_fk foreign key (id_joc) references JOC(id_joc) ON DELETE CASCADE
);

CREATE TABLE GRUPEAZA(
    id_eticheta NUMBER(6),
    id_joc NUMBER(7),
    constraint grupeaza_pk primary key (id_eticheta, id_joc),
    constraint eticheta_grupeaza_fk foreign key (id_eticheta) references ETICHETA(id_eticheta) ON DELETE CASCADE,
    constraint joc_grupeaza_fk foreign key (id_joc) references JOC(id_joc) ON DELETE CASCADE
);

CREATE TABLE CUMPARA(
    username VARCHAR2(20),
    id_joc NUMBER(7),
    data_cumpararii DATE constraint data_cumpararii_nn not null,
    pret_cumparare NUMBER(5,2) default NULL,
    constraint cumpara_pk primary key (username, id_joc),
    constraint utilizator_cumpara_fk foreign key (username) references UTILIZATOR(username) ON DELETE CASCADE,
    constraint joc_cumpara_fk foreign key (id_joc) references JOC(id_joc) ON DELETE CASCADE,
    constraint pret_cumparare_pozitiv check (pret_cumparare >= 0)
);

--INSERTURI

--PRODUCATOR
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Ubisoft', 'France', 1986);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('EA', 'USA', 1982);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Activision', 'USA', 1979);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Nintendo', 'Japan', 1889);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Sony', 'Japan', 1946);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Microsoft', 'USA', 1975);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Square Enix', 'Japan', 2003);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Capcom', 'Japan', 1979);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Bethesda', 'USA', 1986);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Blizzard', 'USA', 1991);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Rockstar', 'USA', 1998);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Valve', 'USA', 1996);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('CD Projekt', 'Poland', 1994);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Bandai Namco', 'Japan', 2006);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Konami', 'Japan', 1969);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Sega', 'Japan', 1960);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('2K Games', 'USA', 2005);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Epic Games', 'USA', 1991);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Riot Games', 'USA', 2006);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Tencent', 'China', 1998);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('KRAFTON', 'South Korea', 2007);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Rockstar Games', 'USA', 1998);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Playdead', 'Denmark', 2006);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Behaviour Interactive', 'Canada', 1992);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Microsoft Studios', 'USA', 2002);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('ConcernedApe', 'USA', 2016);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Re-Logic', 'USA', 2011);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Motion Twin', 'France', 2001);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('miHoYo', 'China', 2012);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('EA DICE', 'Sweden', 1992);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Paradox Interactive', 'Sweden', 1999);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Respawn Entertainment', 'USA', 2010);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Digital Extremes', 'Canada', 1993);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Unknown Worlds Entertainment', 'USA', 2001);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Asobo Studio', 'France', 2002);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare)
VALUES ('Hopoo Games', 'USA', 2010);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare)
VALUES ('Irrational Games', 'USA', 1997);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare)
VALUES ('FromSoftware', 'Japan', 1986);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare)
VALUES ('Facepunch Studios', 'UK', 2004);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Eidos-Montréal', 'Canada', 2007);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Supergiant Games', 'USA', 2009);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Pearl Abyss', 'South Korea', 2010);
INSERT INTO PRODUCATOR (nume_producator, tara_sediu, an_infiintare) 
VALUES ('Iron Gate AB', 'Sweden', 2019);

--CATEGORIE
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Actiune', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Aventura', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('RPG', 'scazuta');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Simulare', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Strategie', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Sport', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Puzzle', 'scazuta');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Racing', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Shooter', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Horror', 'scazuta');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Platformer', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Fighting', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('MMO', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Sandbox', 'scazuta');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Stealth', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Supravietuire', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere) 
VALUES ('Trivia', 'scazuta');
INSERT INTO CATEGORIE (nume_categorie, apreciere)
VALUES ('Lupta', 'ridicata');
INSERT INTO CATEGORIE (nume_categorie, apreciere)
VALUES ('Roguelike', 'medie');
INSERT INTO CATEGORIE (nume_categorie, apreciere)
VALUES ('MMORPG', 'medie');

--UTILIZATOR
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('player1', 'Popescu', 'Andrei', 'andrei.popescu@gmail.com', TO_DATE('1995-03-15', 'YYYY-MM-DD'), TO_DATE('2010-05-12', 'YYYY-MM-DD'), 'GamerX');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('gamer_girl', 'Ionescu', 'Maria', 'maria.ionescu@yahoo.com', TO_DATE('2000-08-25', 'YYYY-MM-DD'), TO_DATE('2015-07-23', 'YYYY-MM-DD'), 'QueenBee');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pro_master', 'Vasilescu', 'Mihai', 'mihai.vasilescu@hotmail.com', TO_DATE('1992-11-02', 'YYYY-MM-DD'), TO_DATE('2012-09-14', 'YYYY-MM-DD'), 'ProM');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('arcade_champ', 'Georgescu', 'Alina', 'alina.georgescu@gmail.com', TO_DATE('1998-05-10', 'YYYY-MM-DD'), TO_DATE('2018-03-05', 'YYYY-MM-DD'), 'Ace');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('shadow99', 'Marinescu', 'Alex', 'alex.marinescu@outlook.com', TO_DATE('1994-12-17', 'YYYY-MM-DD'), TO_DATE('2011-11-22', 'YYYY-MM-DD'), 'Shadow');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('dino_hunter', 'Stefan', 'Ioana', 'ioana.stefan@gmail.com', TO_DATE('1997-04-04', 'YYYY-MM-DD'), TO_DATE('2016-06-18', 'YYYY-MM-DD'), 'Hunter');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('magic_mike', 'Pop', 'Mihnea', 'mihnea.pop@gmail.com', TO_DATE('1996-01-20', 'YYYY-MM-DD'), TO_DATE('2014-08-30', 'YYYY-MM-DD'), 'MagicM');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pixel_pro', 'Dumitrescu', 'Ana', 'ana.dumitrescu@gmail.com', TO_DATE('2001-07-13', 'YYYY-MM-DD'), TO_DATE('2019-04-12', 'YYYY-MM-DD'), 'PixelP');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('stormrider', 'Voinea', 'Paul', 'paul.voinea@gmail.com', TO_DATE('1989-09-05', 'YYYY-MM-DD'), TO_DATE('2009-12-25', 'YYYY-MM-DD'), 'Storm');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('cyberqueen', 'Avram', 'Claudia', 'claudia.avram@gmail.com', TO_DATE('1993-02-28', 'YYYY-MM-DD'), TO_DATE('2013-07-17', 'YYYY-MM-DD'), 'CyberQ');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('speedster', 'Toma', 'Adrian', 'adrian.toma@gmail.com', TO_DATE('1988-06-22', 'YYYY-MM-DD'), TO_DATE('2008-11-08', 'YYYY-MM-DD'), 'Speedy');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('ninja88', 'Radu', 'Victor', 'victor.radu@gmail.com', TO_DATE('1990-10-14', 'YYYY-MM-DD'), TO_DATE('2011-05-21', 'YYYY-MM-DD'), 'Ninja');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pixel_panda', 'Popa', 'Diana', 'diana.popa@gmail.com', TO_DATE('1999-03-30', 'YYYY-MM-DD'), TO_DATE('2018-02-03', 'YYYY-MM-DD'), 'Panda');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('game_warrior', 'Petrescu', 'Cosmin', 'cosmin.petrescu@gmail.com', TO_DATE('1985-12-12', 'YYYY-MM-DD'), TO_DATE('2007-09-14', 'YYYY-MM-DD'), 'Warrior');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('galaxy_hero', 'Stoica', 'Andreea', 'andreea.stoica@gmail.com', TO_DATE('1991-04-18', 'YYYY-MM-DD'), TO_DATE('2012-08-19', 'YYYY-MM-DD'), 'GalaxyH');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('techmaster', 'Iliescu', 'Ciprian', 'ciprian.iliescu@gmail.com', TO_DATE('1994-11-09', 'YYYY-MM-DD'), TO_DATE('2014-03-11', 'YYYY-MM-DD'), 'TechM');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('digital_duke', 'Iacob', 'Elena', 'elena.iacob@gmail.com', TO_DATE('2003-01-01', 'YYYY-MM-DD'), TO_DATE('2020-06-22', 'YYYY-MM-DD'), 'Duke');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('neon_nova', 'Dragan', 'Raluca', 'raluca.dragan@gmail.com', TO_DATE('2002-06-08', 'YYYY-MM-DD'), TO_DATE('2019-09-15', 'YYYY-MM-DD'), 'Nova');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('shadow_blade', 'Lungu', 'Florin', 'florin.lungu@gmail.com', TO_DATE('1995-08-15', 'YYYY-MM-DD'), TO_DATE('2015-04-27', 'YYYY-MM-DD'), 'Blade');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('game_maven', 'Petrea', 'Teodora', 'teodora.petrea@gmail.com', TO_DATE('1987-03-06', 'YYYY-MM-DD'), TO_DATE('2006-10-10', 'YYYY-MM-DD'), 'Maven');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('dragon_slayer', 'Ionescu', 'Dragos', 'dragos.ionescu@gmail.com', TO_DATE('1990-07-15', 'YYYY-MM-DD'), TO_DATE('2010-08-20', 'YYYY-MM-DD'), 'Slayer');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pixel_queen', 'Popa', 'Elena', 'elena.popa@gmail.com', TO_DATE('1992-11-22', 'YYYY-MM-DD'), TO_DATE('2012-05-05', 'YYYY-MM-DD'), 'Queen');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('shadow_hunter', 'Marin', 'Alexandru', 'alexandru.marin@gmail.com', TO_DATE('1985-01-30', 'YYYY-MM-DD'), TO_DATE('2008-03-15', 'YYYY-MM-DD'), 'sedau-Hunter');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('cyber_warrior', 'Dumitrescu', 'Ioana', 'ioana.dumitrescu@gmail.com', TO_DATE('1995-10-10', 'YYYY-MM-DD'), TO_DATE('2015-12-25', 'YYYY-MM-DD'), 'Cyber!Warrior');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('arcade_master', 'Georgescu', 'Mihai', 'mihai.georgescu@gmail.com', TO_DATE('1988-05-05', 'YYYY-MM-DD'), TO_DATE('2009-10-10', 'YYYY-MM-DD'), 'Master');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('storm_chaser', 'Voinea', 'Andreea', 'andreea.voinea@gmail.com', TO_DATE('1993-08-18', 'YYYY-MM-DD'), TO_DATE('2013-11-20', 'YYYY-MM-DD'), 'Chaser');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('magic_wizard', 'Iliescu', 'Ciprian', 'ciprian.iliescu@gmail.com', TO_DATE('1994-12-25', 'YYYY-MM-DD'), TO_DATE('2014-07-15', 'YYYY-MM-DD'), 'Wizard');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pixel_knight', 'Dobre', 'Ana', 'ana.dobre@gmail.com', TO_DATE('1991-04-12', 'YYYY-MM-DD'), TO_DATE('2011-10-10', 'YYYY-MM-DD'), 'Knight');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('galaxy_rider', 'Stoica', 'Paul', 'paul.stoica@gmail.com', TO_DATE('1989-06-22', 'YYYY-MM-DD'), TO_DATE('2009-05-05', 'YYYY-MM-DD'), 'Rider');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('tech_genius', 'Avram', 'Claudia', 'claudia.avram@gmail.com', TO_DATE('1993-02-14', 'YYYY-MM-DD'), TO_DATE('2013-08-20', 'YYYY-MM-DD'), 'Genius');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('speed_demon', 'Toma', 'Adrian', 'adrian.toma@gmail.com', TO_DATE('1988-09-30', 'YYYY-MM-DD'), TO_DATE('2008-03-15', 'YYYY-MM-DD'), 'Demon');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('ninja_master', 'Radu', 'Victor', 'victor.radu@gmail.com', TO_DATE('1990-10-10', 'YYYY-MM-DD'), TO_DATE('2010-12-25', 'YYYY-MM-DD'), 'Ninja420');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('pixel_pirate', 'Popa', 'Diana', 'diana.popa@gmail.com', TO_DATE('1999-03-15', 'YYYY-MM-DD'), TO_DATE('2018-10-10', 'YYYY-MM-DD'), 'Pirate');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('game_hero', 'Petrescu', 'Cosmin', 'cosmin.petrescu@gmail.com', TO_DATE('1985-12-20', 'YYYY-MM-DD'), TO_DATE('2007-07-15', 'YYYY-MM-DD'), 'Hero');
INSERT INTO UTILIZATOR (username, nume, prenume, adresa_mail, data_nasterii, data_inregistrarii, porecla) 
VALUES ('galaxy_queen', 'Stoica', 'Andreea', 'andreea.stoica@gmail.com', TO_DATE('1991-04-18', 'YYYY-MM-DD'), TO_DATE('2012-08-19', 'YYYY-MM-DD'), 'QueenOfGalaxy');

-- JOC
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (730, TO_DATE('2012-08-21', 'YYYY-MM-DD'), 'Counter-Strike: Global Offensive', 16, 0.00, 'Shooter', 'Valve');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (578080, TO_DATE('2017-12-20', 'YYYY-MM-DD'), 'PUBG: Battlegrounds', 16, 29.99, 'Shooter', 'KRAFTON');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (570, TO_DATE('2013-07-09', 'YYYY-MM-DD'), 'Dota 2', 13, 0.00, 'Strategie', 'Valve');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (271590, TO_DATE('2015-04-14', 'YYYY-MM-DD'), 'Grand Theft Auto V', 18, 19.99, 'Actiune', 'Rockstar Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (292030, TO_DATE('2015-05-18', 'YYYY-MM-DD'), 'The Witcher 3: Wild Hunt', 18, 39.99, 'RPG', 'CD Projekt');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (578650, TO_DATE('2016-10-10', 'YYYY-MM-DD'), 'Inside', 12, 19.99, 'Puzzle', 'Playdead');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (812140, TO_DATE('2018-10-05', 'YYYY-MM-DD'), 'Assassin''s Creed Odyssey', 18, 59.99, 'Aventura', 'Ubisoft');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (381210, TO_DATE('2016-06-14', 'YYYY-MM-DD'), 'Dead by Daylight', 18, 19.99, 'Horror', 'Behaviour Interactive');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (289070, TO_DATE('2016-10-21', 'YYYY-MM-DD'), 'Civilization VI', 12, 59.99, 'Strategie', '2K Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (1085660, TO_DATE('2019-12-10', 'YYYY-MM-DD'), 'Halo: The Master Chief Collection', 16, 39.99, 'Shooter', 'Microsoft Studios');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (413150, TO_DATE('2016-02-26', 'YYYY-MM-DD'), 'Stardew Valley', 10, 14.99, 'Simulare', 'ConcernedApe');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (601150, TO_DATE('2017-01-24', 'YYYY-MM-DD'), 'Resident Evil 7', 18, 19.99, 'Horror', 'Capcom');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (35140, TO_DATE('2010-08-24', 'YYYY-MM-DD'), 'Mafia II', 18, 29.99, 'Actiune', '2K Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (105600, TO_DATE('2011-05-16', 'YYYY-MM-DD'), 'Terraria', 10, 9.99, 'Platformer', 'Re-Logic');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (646570, TO_DATE('2018-08-06', 'YYYY-MM-DD'), 'Dead Cells', 13, 24.99, 'Platformer', 'Motion Twin');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (1238860, TO_DATE('2020-09-30', 'YYYY-MM-DD'), 'Genshin Impact', 13, 0.00, 'RPG', 'miHoYo');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (883710, TO_DATE('2019-01-25', 'YYYY-MM-DD'), 'Resident Evil 2 Remake', 18, 39.99, 'Horror', 'Capcom');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (359550, TO_DATE('2015-12-01', 'YYYY-MM-DD'), 'Rainbow Six Siege', 18, 19.99, 'Shooter', 'Ubisoft');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (1942650, TO_DATE('2023-05-23', 'YYYY-MM-DD'), 'Street Fighter 6', 12, 59.99, 'Lupta', 'Capcom');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator) 
VALUES (1174180, TO_DATE('2018-10-26', 'YYYY-MM-DD'), 'Red Dead Redemption 2', 18, 59.99, 'Aventura', 'Rockstar Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1593500, TO_DATE('2022-02-25', 'YYYY-MM-DD'), 'Elden Ring', 18, 59.99, 'RPG', 'FromSoftware');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (632360, TO_DATE('2019-08-11', 'YYYY-MM-DD'), 'Risk of Rain 2', 12, 24.99, 'Actiune', 'Hopoo Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (976730, TO_DATE('2020-03-23', 'YYYY-MM-DD'), 'Half-Life: Alyx', 16, 59.99, 'Shooter', 'Valve');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (445070, TO_DATE('2016-09-13', 'YYYY-MM-DD'), 'BioShock Infinite', 18, 19.99, 'Actiune', 'Irrational Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1574310, TO_DATE('2021-11-19', 'YYYY-MM-DD'), 'Battlefield 2042', 18, 49.99, 'Shooter', 'EA DICE');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1343400, TO_DATE('2020-09-04', 'YYYY-MM-DD'), 'Crusader Kings III', 16, 49.99, 'Strategie', 'Paradox Interactive');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (493520, TO_DATE('2016-10-27', 'YYYY-MM-DD'), 'Titanfall 2', 16, 19.99, 'Shooter', 'Respawn Entertainment');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (230410, TO_DATE('2013-03-25', 'YYYY-MM-DD'), 'Warframe', 13, 0.00, 'Actiune', 'Digital Extremes');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (945360, TO_DATE('2018-02-27', 'YYYY-MM-DD'), 'Subnautica', 10, 29.99, 'Aventura', 'Unknown Worlds Entertainment');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (552520, TO_DATE('2018-03-27', 'YYYY-MM-DD'), 'Far Cry 5', 18, 29.99, 'Actiune', 'Ubisoft');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1250410, TO_DATE('2020-10-29', 'YYYY-MM-DD'), 'Watch Dogs: Legion', 18, 59.99, 'Aventura', 'Ubisoft');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1222670, TO_DATE('2021-02-02', 'YYYY-MM-DD'), 'Valheim', 13, 19.99, 'Supravietuire', 'Iron Gate AB');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1551360, TO_DATE('2022-10-21', 'YYYY-MM-DD'), 'A Plague Tale: Requiem', 18, 49.99, 'Aventura', 'Asobo Studio');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (440, TO_DATE('2007-10-10', 'YYYY-MM-DD'), 'Team Fortress 2', 13, 0.00, 'Shooter', 'Valve');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (582660, TO_DATE('2018-03-03', 'YYYY-MM-DD'), 'Black Desert Online', 16, 9.99, 'MMORPG', 'Pearl Abyss');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1172470, TO_DATE('2020-09-18', 'YYYY-MM-DD'), 'Hades', 16, 24.99, 'Roguelike', 'Supergiant Games');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (4000, TO_DATE('2006-11-29', 'YYYY-MM-DD'), 'Garrys Mod', 10, 9.99, 'Sandbox', 'Facepunch Studios');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (644930, TO_DATE('2018-09-14', 'YYYY-MM-DD'), 'Shadow of the Tomb Raider', 18, 29.99, 'Aventura', 'Eidos-Montréal');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (1057090, TO_DATE('2019-11-15', 'YYYY-MM-DD'), 'Star Wars Jedi: Fallen Order', 13, 39.99, 'Aventura', 'Respawn Entertainment');
INSERT INTO JOC (id_joc, data_lansarii, nume, varsta_minima, pret, nume_categorie, nume_producator)
VALUES (582010, TO_DATE('2018-01-26', 'YYYY-MM-DD'), 'Monster Hunter: World', 16, 39.99, 'Actiune', 'Capcom');

--DEZVOLTATOR

INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('RedPixel Studios', 8.5);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('BlueSky Games', 9.0);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('ShadowForge', 8.7);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('GoldenLion Interactive', 9.2);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('SilverMoon Studios', 7.8);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('StormBreak Games', 8.4);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('AquaWave Entertainment', 8.9);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('NovaTech', 8.1);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('CyberWorld Developers', 9.5);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('PixelCraft Studios', 8.2);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('NeoGames Inc.', 7.5);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('FutureVision', 8.6);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('SkyHigh Studios', 9.1);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('Earthbound Games', 7.9);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('GalaxyEdge', 8.3);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('IronClaw Interactive', 8.8);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('MysticRealm Studios', 9.0);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('ShadowCore Games', 8.6);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('FireStorm Productions', 8.7);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('RapidByte Developers', 8.0);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('Valve', 9.8);
INSERT INTO DEZVOLTATOR (nume_dezvoltator, rating)
VALUES ('Rockstar North', 9.7);


--ETICHETA
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (1, 'Indie');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (2, 'Casual');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (3, 'RPG');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (4, 'Singleplayer');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (5, 'Early Access');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (6, '2D');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (7, 'Free to Play');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (8, '3D');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (9, 'Atmospheric');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (10, 'Colorful');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (11, 'Story Rich');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (12, 'Fantasy');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (13, 'Multiplayer');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (14, 'Puzzle');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (15, 'Cute');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (16, 'Pixel Graphics');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (17, 'First-Person');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (18, 'Massively Multiplayer');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (19, 'Violent');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (20, 'Funny');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (21, 'Anime');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (22, 'Arcade');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (23, 'Character Customization');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (24, 'Visual Novel');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (25, 'Multiple Endings');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (26, 'Physics');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (27, '2D Platformer');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (28, 'Online Co-Op');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (29, 'Psychological Horror');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (30, 'FPS');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (31, 'Magic');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (32, 'Old School');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (33, 'Sandbox');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (34, 'Tactical');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (35, 'Action RPG');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (36, 'Medieval');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (37, 'Hand-drawn');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (38, 'Futuristic');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (39, 'Minimalist');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (40, 'Building');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (41, 'Roguelite');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (42, 'Point and Click');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (43, 'Crafting');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (44, 'Local Multiplayer');
INSERT INTO ETICHETA (id_eticheta, nume_eticheta) VALUES (45, 'Great Soundtrack');

--EVENIMENT
INSERT INTO EVENIMENT (denumire, tip_eveniment)
VALUES ('Winter Sale', 'Promotion');
INSERT INTO EVENIMENT (denumire, tip_eveniment)
VALUES ('Summer Fest', 'Festival');
INSERT INTO EVENIMENT (denumire, tip_eveniment)
VALUES ('Indie Showcase', 'Exhibition');
INSERT INTO EVENIMENT (denumire, tip_eveniment)
VALUES ('Halloween Bash', 'Seasonal');
INSERT INTO EVENIMENT (denumire, tip_eveniment)
VALUES ('Gaming Marathon', 'Competition');

--MISIUNE
--CS:GO
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1001, 730, 'Bomb Defusal', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1002, 730, 'Hostage Rescue', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1003, 730, 'Deathmatch', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1004, 730, 'Arms Race', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1005, 730, 'Wingman', 'foarte dificil');

--PUBG
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1006, 578080, 'Survive the Night', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1007, 578080, 'Loot and Shoot', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1008, 578080, 'Last Man Standing', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1009, 578080, 'Sniper Challenge', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1010, 578080, 'Vehicle Rampage', 'foarte dificil');

--Dota 2
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1011, 570, 'Destroy the Ancient', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1012, 570, 'Roshan Hunt', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1013, 570, 'Tower Defense', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1014, 570, 'Heroic Battle', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1015, 570, 'Epic Comeback', 'foarte dificil');

--GTAV
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1016, 271590, 'Bank Heist', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1017, 271590, 'Car Chase', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1018, 271590, 'Street Race', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1019, 271590, 'Drug Deal', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1020, 271590, 'Rescue Mission', 'foarte dificil');

--TW3
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1021, 292030, 'Monster Hunt', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1022, 292030, 'Treasure Hunt', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1023, 292030, 'Escort Mission', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1024, 292030, 'Battle Arena', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1025, 292030, 'Witcher Contract', 'foarte dificil');

--Inside
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1026, 578650, 'Escape the Facility', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1027, 578650, 'Solve the Puzzle', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1028, 578650, 'Stealth Mission', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1029, 578650, 'Underwater Escape', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1030, 578650, 'Final Confrontation', 'foarte dificil');

--AC Odyssey
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1031, 812140, 'Spartan Battle', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1032, 812140, 'Ship Combat', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1033, 812140, 'Assassination', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1034, 812140, 'Treasure Hunt', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1035, 812140, 'Arena Fight', 'foarte dificil');

--DBD
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1036, 381210, 'Survive the Night', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1037, 381210, 'Escape the Killer', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1038, 381210, 'Repair Generators', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1039, 381210, 'Rescue Teammates', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1040, 381210, 'Final Escape', 'foarte dificil');

--Civ VI
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1041, 289070, 'Build a Wonder', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1042, 289070, 'Conquer a City', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1043, 289070, 'Research Technology', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1044, 289070, 'Form an Alliance', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1045, 289070, 'Win a War', 'foarte dificil');

--Halo
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1046, 1085660, 'Defend the Base', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1047, 1085660, 'Capture the Flag', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1048, 1085660, 'Destroy the Enemy', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1049, 1085660, 'Rescue the Hostages', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1050, 1085660, 'Final Showdown', 'foarte dificil');

--Stardew Valley
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1051, 413150, 'Harvest Crops', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1052, 413150, 'Raise Animals', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1053, 413150, 'Mine for Resources', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1054, 413150, 'Build a Barn', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1055, 413150, 'Complete the Community Center', 'foarte dificil');

-- RE 7
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1056, 601150, 'Escape the Mansion', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1057, 601150, 'Find the Antidote', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1058, 601150, 'Defeat the Boss', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1059, 601150, 'Solve the Puzzle', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1060, 601150, 'Survive the Night', 'foarte dificil');

--Mafia II
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1061, 35140, 'Bank Robbery', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1062, 35140, 'Car Chase', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1063, 35140, 'Gang War', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1064, 35140, 'Rescue Mission', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1065, 35140, 'Final Showdown', 'foarte dificil');

--Terraria
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1066, 105600, 'Build a House', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1067, 105600, 'Defeat the Boss', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1068, 105600, 'Mine for Resources', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1069, 105600, 'Craft Weapons', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1070, 105600, 'Explore the World', 'foarte dificil');

--Dead Cells
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1071, 646570, 'Escape the Prison', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1072, 646570, 'Defeat the Boss', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1073, 646570, 'Collect Cells', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1074, 646570, 'Upgrade Weapons', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1075, 646570, 'Final Showdown', 'foarte dificil');

--Genshin
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1076, 1238860, 'Defeat the Dragon', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1077, 1238860, 'Collect Artifacts', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1078, 1238860, 'Complete the Dungeon', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1079, 1238860, 'Solve the Puzzle', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1080, 1238860, 'Final Battle', 'foarte dificil');

-- RE2 Remake
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1081, 883710, 'Escape the Police Station', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1082, 883710, 'Find the Antidote', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1083, 883710, 'Defeat the Boss', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1084, 883710, 'Solve the Puzzle', 'foarte usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1085, 883710, 'Survive the Night', 'foarte dificil');

-- R6 Siege
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1086, 359550, 'Defend the Hostage', 'dificil');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1087, 359550, 'Secure the Area', 'mediu');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1088, 359550, 'Bomb Defusal', 'usor');
INSERT INTO MISIUNE (id_misiune, id_joc, denumire_misiune, dificultate) VALUES (1089, 359550, 'Rescue the Hostage', 'foarte usor');


--CONTINUT_ADITIONAL
-- CS:GO
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1001, 'Operation Phoenix', TO_DATE('2014-02-20', 'YYYY-MM-DD'), 8.7, 730);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1002, 'Operation Hydra', TO_DATE('2017-05-23', 'YYYY-MM-DD'), 8.9, 730);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1003, 'Danger Zone', TO_DATE('2018-12-06', 'YYYY-MM-DD'), 8.5, 730);

-- PUBG
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1004, 'Vikendi Map', TO_DATE('2018-12-19', 'YYYY-MM-DD'), 9.1, 578080);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1005, 'Survivor Pass: Cold Front', TO_DATE('2020-04-21', 'YYYY-MM-DD'), 8.8, 578080);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1006, 'Taego Map', TO_DATE('2021-07-07', 'YYYY-MM-DD'), 9.0, 578080);

-- Dota 2
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1007, 'The International Battle Pass 2020', TO_DATE('2020-05-25', 'YYYY-MM-DD'), 9.2, 570);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1008, 'Aghanim’s Labyrinth', TO_DATE('2020-07-14', 'YYYY-MM-DD'), 9.3, 570);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1009, 'Nemestice', TO_DATE('2021-06-24', 'YYYY-MM-DD'), 8.6, 570);

-- GTA V
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1010, 'The Heists', TO_DATE('2015-03-10', 'YYYY-MM-DD'), 9.4, 271590);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1011, 'After Hours', TO_DATE('2018-07-24', 'YYYY-MM-DD'), 9.0, 271590);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1012, 'The Cayo Perico Heist', TO_DATE('2020-12-15', 'YYYY-MM-DD'), 9.5, 271590);

-- TW3
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1013, 'Hearts of Stone', TO_DATE('2015-10-13', 'YYYY-MM-DD'), 9.8, 292030);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1014, 'Blood and Wine', TO_DATE('2016-05-31', 'YYYY-MM-DD'), 9.9, 292030);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1015, 'Alternative Look for Triss', TO_DATE('2015-07-10', 'YYYY-MM-DD'), 8.5, 292030);

-- Inside
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1016, 'The Abyss', TO_DATE('2016-12-20', 'YYYY-MM-DD'), 8.9, 578650);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1017, 'Escape the Facility', TO_DATE('2017-05-10', 'YYYY-MM-DD'), 9.0, 578650);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1018, 'The Shadows', TO_DATE('2017-11-15', 'YYYY-MM-DD'), 9.2, 578650);

-- AC Odyssey
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1019, 'Legacy of the First Blade', TO_DATE('2018-12-04', 'YYYY-MM-DD'), 9.1, 812140);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1020, 'The Fate of Atlantis', TO_DATE('2019-04-23', 'YYYY-MM-DD'), 9.3, 812140);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1021, 'Lost Tales of Greece', TO_DATE('2019-06-18', 'YYYY-MM-DD'), 8.9, 812140);

-- DBD
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1022, 'Silent Hill Chapter', TO_DATE('2020-06-16', 'YYYY-MM-DD'), 9.2, 381210);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1023, 'Stranger Things Chapter', TO_DATE('2019-09-17', 'YYYY-MM-DD'), 9.0, 381210);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1024, 'Resident Evil Chapter', TO_DATE('2021-06-15', 'YYYY-MM-DD'), 9.4, 381210);

-- Civ VI
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1025, 'Rise and Fall', TO_DATE('2018-02-08', 'YYYY-MM-DD'), 9.3, 289070);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1026, 'Gathering Storm', TO_DATE('2019-02-14', 'YYYY-MM-DD'), 9.4, 289070);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1027, 'New Frontier Pass', TO_DATE('2020-05-21', 'YYYY-MM-DD'), 9.1, 289070);

-- Halo
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1028, 'Halo Reach', TO_DATE('2019-12-03', 'YYYY-MM-DD'), 9.5, 1085660);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1029, 'Halo 3: ODST', TO_DATE('2020-09-22', 'YYYY-MM-DD'), 9.4, 1085660);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1030, 'Halo 4', TO_DATE('2020-11-17', 'YYYY-MM-DD'), 9.6, 1085660);

-- Stardew Valley
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1031, 'Multiplayer Update', TO_DATE('2018-08-01', 'YYYY-MM-DD'), 9.0, 413150);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1032, 'The Beach Farm', TO_DATE('2020-12-21', 'YYYY-MM-DD'), 9.2, 413150);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1033, 'Expanded Festival Events', TO_DATE('2022-06-15', 'YYYY-MM-DD'), 8.8, 413150);

-- RE 7
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1034, 'Banned Footage Vol. 1', TO_DATE('2017-01-31', 'YYYY-MM-DD'), 9.1, 601150);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1035, 'Banned Footage Vol. 2', TO_DATE('2017-02-14', 'YYYY-MM-DD'), 9.3, 601150);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1036, 'End of Zoe', TO_DATE('2017-12-12', 'YYYY-MM-DD'), 9.5, 601150);

-- Mafia II
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1037, 'Jimmy’s Vendetta', TO_DATE('2010-09-07', 'YYYY-MM-DD'), 8.8, 35140);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1038, 'Joe’s Adventures', TO_DATE('2010-11-23', 'YYYY-MM-DD'), 9.0, 35140);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1039, 'Betrayal of Jimmy', TO_DATE('2010-08-24', 'YYYY-MM-DD'), 8.9, 35140);

-- Terraria
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1040, 'Journey’s End', TO_DATE('2020-05-16', 'YYYY-MM-DD'), 9.7, 105600);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1041, 'Don’t Starve Together Crossover', TO_DATE('2021-11-18', 'YYYY-MM-DD'), 9.4, 105600);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1042, 'Labor of Love Update', TO_DATE('2022-09-28', 'YYYY-MM-DD'), 9.6, 105600);

-- Dead Cells
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1043, 'Rise of the Giant', TO_DATE('2019-03-28', 'YYYY-MM-DD'), 9.2, 646570);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1044, 'The Bad Seed', TO_DATE('2020-02-11', 'YYYY-MM-DD'), 9.4, 646570);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1045, 'Fatal Falls', TO_DATE('2021-01-26', 'YYYY-MM-DD'), 9.5, 646570);

-- Genshin
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1046, 'Dragonspine Expansion', TO_DATE('2020-12-23', 'YYYY-MM-DD'), 9.1, 1238860);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1047, 'Inazuma Region', TO_DATE('2021-07-21', 'YYYY-MM-DD'), 9.5, 1238860);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1048, 'Sumeru Region', TO_DATE('2022-08-24', 'YYYY-MM-DD'), 9.6, 1238860);

-- RE 2 Remake
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1049, 'The Ghost Survivors', TO_DATE('2019-02-15', 'YYYY-MM-DD'), 9.0, 883710);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1050, 'Classic Costumes Pack', TO_DATE('2019-03-01', 'YYYY-MM-DD'), 8.8, 883710);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1051, 'No Time to Mourn', TO_DATE('2019-05-10', 'YYYY-MM-DD'), 9.2, 883710);

-- R6 Siege
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1052, 'Operation Black Ice', TO_DATE('2016-02-02', 'YYYY-MM-DD'), 9.3, 359550);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1053, 'Operation Blood Orchid', TO_DATE('2017-09-05', 'YYYY-MM-DD'), 9.4, 359550);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1054, 'Operation Shadow Legacy', TO_DATE('2020-09-10', 'YYYY-MM-DD'), 9.5, 359550);

-- Street Fighter 6
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1055, 'Character Pass 1', TO_DATE('2023-07-01', 'YYYY-MM-DD'), 9.2, 1942650);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1056, 'Classic Stages Pack', TO_DATE('2023-08-15', 'YYYY-MM-DD'), 9.0, 1942650);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1057, 'Ultimate Costume Pack', TO_DATE('2023-09-20', 'YYYY-MM-DD'), 9.3, 1942650);

-- RDR 2
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1058, 'Outlaw Pass 1', TO_DATE('2019-09-10', 'YYYY-MM-DD'), 9.4, 1174180);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1059, 'Outlaw Pass 2', TO_DATE('2020-03-12', 'YYYY-MM-DD'), 9.5, 1174180);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1060, 'Naturalist Role', TO_DATE('2020-07-28', 'YYYY-MM-DD'), 9.6, 1174180);

-- Elden Ring
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1061, 'The Colosseum', TO_DATE('2022-12-07', 'YYYY-MM-DD'), 9.7, 1593500);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1062, 'Shadow of the Erdtree', TO_DATE('2023-08-15', 'YYYY-MM-DD'), 9.8, 1593500);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1063, 'Forgotten Lands', TO_DATE('2024-03-10', 'YYYY-MM-DD'), 9.6, 1593500);

-- Risk of Rain 2
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1064, 'Hidden Realms', TO_DATE('2019-12-17', 'YYYY-MM-DD'), 9.1, 632360);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1065, 'Artifacts Update', TO_DATE('2020-03-31', 'YYYY-MM-DD'), 9.3, 632360);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1066, 'Survivors of the Void', TO_DATE('2022-03-01', 'YYYY-MM-DD'), 9.5, 632360);

-- Half-Life: Alyx
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1067, 'The Final Hours', TO_DATE('2020-07-09', 'YYYY-MM-DD'), 9.6, 976730);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1068, 'Workshop Tools', TO_DATE('2020-08-18', 'YYYY-MM-DD'), 9.2, 976730);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1069, 'VR Expansion Pack', TO_DATE('2021-11-01', 'YYYY-MM-DD'), 9.4, 976730);

-- BioShock Infinite
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1070, 'Clash in the Clouds', TO_DATE('2013-07-30', 'YYYY-MM-DD'), 9.0, 445070);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1071, 'Burial at Sea - Episode 1', TO_DATE('2013-11-12', 'YYYY-MM-DD'), 9.4, 445070);
INSERT INTO CONTINUT_ADITIONAL(DLC, nume_dlc, data_lansare, rating_dlc, id_joc)
VALUES (1072, 'Burial at Sea - Episode 2', TO_DATE('2014-03-25', 'YYYY-MM-DD'), 9.5, 445070);



--DEZVOLTA
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('Valve', 730);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('RedPixel Studios', 578080); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('Valve', 570);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('Rockstar North', 271590); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('CyberWorld Developers', 292030);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('PixelCraft Studios', 578650);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('NeoGames Inc.', 812140);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('FutureVision', 381210); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('SkyHigh Studios', 289070); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('Earthbound Games', 1085660); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('GalaxyEdge', 413150); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('IronClaw Interactive', 601150); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('MysticRealm Studios', 35140); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('ShadowCore Games', 105600); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('FireStorm Productions', 646570);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('RapidByte Developers', 1238860);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('BlueSky Games', 883710); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('ShadowForge', 359550); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('GoldenLion Interactive', 1942650); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('SilverMoon Studios', 1174180); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('StormBreak Games', 1593500); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('AquaWave Entertainment', 632360); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('NovaTech', 976730); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('CyberWorld Developers', 445070); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('PixelCraft Studios', 1574310); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('NeoGames Inc.', 1343400);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('FutureVision', 493520); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('SkyHigh Studios', 230410); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('Earthbound Games', 945360);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('GalaxyEdge', 552520); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('IronClaw Interactive', 1250410); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('MysticRealm Studios', 1222670); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('ShadowCore Games', 1551360); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('FireStorm Productions', 440); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('RapidByte Developers', 582660); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('BlueSky Games', 1172470); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('ShadowForge', 4000); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('GoldenLion Interactive', 644930); 
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('SilverMoon Studios', 1057090);
INSERT INTO DEZVOLTA (nume_dezvoltator, id_joc) VALUES ('StormBreak Games', 582010);


--GRUPEAZA
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (1, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (2, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (3, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (4, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (5, 570);   
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (6, 105600); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (7, 230410); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (8, 271590); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (9, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (10, 413150);
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (11, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (12, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (13, 570);    
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (14, 578650);
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (15, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (16, 105600); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (17, 883710);
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (18, 582660); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (19, 883710); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (20, 883710);
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (21, 1238860); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (22, 578080); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (23, 1238860); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (24, 578650); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (25, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (26, 578650); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (27, 105600); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (28, 570);  
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (29, 883710); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (30, 1085660); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (31, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (32, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (33, 4000);
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (34, 289070); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (35, 1593500); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (36, 292030); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (37, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (38, 1085660); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (39, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (40, 230410); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (41, 1172470); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (43, 413150); 
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (44, 570);    
INSERT INTO GRUPEAZA (id_eticheta, id_joc) VALUES (45, 570);    


--CUMPARA
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('player1', 730, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 0.00);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('player1', 570, TO_DATE('2023-02-10', 'YYYY-MM-DD'), 0.00);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('player1', 271590, TO_DATE('2023-03-05', 'YYYY-MM-DD'), 19.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('gamer_girl', 292030, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('gamer_girl', 812140, TO_DATE('2023-02-18', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('gamer_girl', 1085660, TO_DATE('2023-03-12', 'YYYY-MM-DD'), 39.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pro_master', 1238860, TO_DATE('2023-01-25', 'YYYY-MM-DD'), 0.00);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pro_master', 359550, TO_DATE('2023-02-20', 'YYYY-MM-DD'), 19.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pro_master', 1593500, TO_DATE('2023-03-18', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_champ', 578080, TO_DATE('2018-01-15', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_champ', 578650, TO_DATE('2017-12-01', 'YYYY-MM-DD'), 19.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_champ', 289070, TO_DATE('2017-01-10', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow99', 381210, TO_DATE('2017-07-01', 'YYYY-MM-DD'), 19.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow99', 413150, TO_DATE('2016-05-01', 'YYYY-MM-DD'), 14.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow99', 601150, TO_DATE('2018-02-15', 'YYYY-MM-DD'), 19.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dino_hunter', 35140, TO_DATE('2011-09-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dino_hunter', 646570, TO_DATE('2019-01-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dino_hunter', 1238860, TO_DATE('2021-01-01', 'YYYY-MM-DD'), 0.00);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('magic_mike', 883710, TO_DATE('2019-07-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('magic_mike', 1174180, TO_DATE('2019-10-26', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('magic_mike', 976730, TO_DATE('2020-05-01', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_pro', 644930, TO_DATE('2018-10-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_pro', 1343400, TO_DATE('2021-03-01', 'YYYY-MM-DD'), 49.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_pro', 582660, TO_DATE('2019-02-01', 'YYYY-MM-DD'), 9.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('stormrider', 1172470, TO_DATE('2021-10-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('stormrider', 1593500, TO_DATE('2022-06-01', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('stormrider', 1085660, TO_DATE('2020-01-01', 'YYYY-MM-DD'), 39.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyberqueen', 413150, TO_DATE('2018-04-01', 'YYYY-MM-DD'), 14.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyberqueen', 582010, TO_DATE('2019-05-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyberqueen', 552520, TO_DATE('2020-08-01', 'YYYY-MM-DD'), 29.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('speedster', 271590, TO_DATE('2018-03-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('speedster', 1551360, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 49.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('speedster', 445070, TO_DATE('2017-09-01', 'YYYY-MM-DD'), 19.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('ninja88', 1574310, TO_DATE('2022-05-01', 'YYYY-MM-DD'), 49.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('ninja88', 413150, TO_DATE('2021-06-01', 'YYYY-MM-DD'), 14.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('ninja88', 883710, TO_DATE('2023-04-01', 'YYYY-MM-DD'), 39.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_panda', 644930, TO_DATE('2019-02-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_panda', 582660, TO_DATE('2019-08-01', 'YYYY-MM-DD'), 9.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_panda', 1343400, TO_DATE('2021-11-01', 'YYYY-MM-DD'), 49.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_warrior', 1942650, TO_DATE('2023-06-01', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_warrior', 271590 , TO_DATE('2019-09-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_warrior', 1250410, TO_DATE('2020-11-01', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('galaxy_hero', 1238860, TO_DATE('2021-10-01', 'YYYY-MM-DD'), 0.00);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('galaxy_hero', 413150, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 14.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('galaxy_hero', 601150, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 19.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('techmaster', 812140, TO_DATE('2021-11-01', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('techmaster', 578080, TO_DATE('2021-12-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('techmaster', 1174180, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('digital_duke', 105600, TO_DATE('2020-05-01', 'YYYY-MM-DD'), 9.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('digital_duke', 646570, TO_DATE('2021-08-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('digital_duke', 230410, TO_DATE('2021-10-01', 'YYYY-MM-DD'), 0.00);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('neon_nova', 4000, TO_DATE('2018-05-01', 'YYYY-MM-DD'), 9.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('neon_nova', 359550, TO_DATE('2019-11-01', 'YYYY-MM-DD'), 19.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('neon_nova', 413150, TO_DATE('2020-01-01', 'YYYY-MM-DD'), 14.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_blade', 644930, TO_DATE('2019-09-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_blade', 1343400, TO_DATE('2020-10-01', 'YYYY-MM-DD'), 49.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_blade', 552520, TO_DATE('2021-03-01', 'YYYY-MM-DD'), 29.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_maven', 1172470, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_maven', 1057090, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('game_maven', 1238860, TO_DATE('2022-05-01', 'YYYY-MM-DD'), 0.00);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dragon_slayer', 578650, TO_DATE('2020-10-01', 'YYYY-MM-DD'), 24.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dragon_slayer', 359550, TO_DATE('2021-02-01', 'YYYY-MM-DD'), 19.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('dragon_slayer', 644930, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 29.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_queen', 1174180, TO_DATE('2021-06-01', 'YYYY-MM-DD'), 59.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_queen', 1057090, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('pixel_queen', 1593500, TO_DATE('2022-07-01', 'YYYY-MM-DD'), 59.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_hunter', 945360, TO_DATE('2020-01-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_hunter', 582010, TO_DATE('2021-04-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('shadow_hunter', 230410, TO_DATE('2022-05-01', 'YYYY-MM-DD'), 0.00);


INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyber_warrior', 440, TO_DATE('2019-08-01', 'YYYY-MM-DD'), 0.00);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyber_warrior', 582010, TO_DATE('2021-02-01', 'YYYY-MM-DD'), 39.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('cyber_warrior', 883710, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 39.99);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_master', 4000, TO_DATE('2019-06-01', 'YYYY-MM-DD'), 9.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_master', 644930, TO_DATE('2021-08-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('arcade_master', 230410, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 0.00);

INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('storm_chaser', 578080, TO_DATE('2021-10-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('storm_chaser', 644930, TO_DATE('2022-06-01', 'YYYY-MM-DD'), 29.99);
INSERT INTO CUMPARA (username, id_joc, data_cumpararii, pret_cumparare)
VALUES ('storm_chaser', 1593500, TO_DATE('2023-03-01', 'YYYY-MM-DD'), 59.99);


--PARTICIPA_LA
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'player1', TO_DATE('2025-01-01', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'player1', TO_DATE('2025-06-15', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'gamer_girl', TO_DATE('2025-02-10', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'gamer_girl', TO_DATE('2025-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'gamer_girl', TO_DATE('2025-07-20', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'pro_master', TO_DATE('2024-07-10', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'pro_master', TO_DATE('2023-12-20', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'arcade_champ', TO_DATE('2022-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'arcade_champ', TO_DATE('2021-07-25', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'arcade_champ', TO_DATE('2020-02-18', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'shadow99', TO_DATE('2025-01-05', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'dino_hunter', TO_DATE('2024-06-30', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'dino_hunter', TO_DATE('2023-07-22', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'magic_mike', TO_DATE('2019-02-15', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'magic_mike', TO_DATE('2020-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'magic_mike', TO_DATE('2021-12-25', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'pixel_pro', TO_DATE('2023-07-12', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'pixel_pro', TO_DATE('2022-06-20', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'stormrider', TO_DATE('2020-12-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'stormrider', TO_DATE('2018-10-29', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'stormrider', TO_DATE('2021-02-05', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'cyberqueen', TO_DATE('2019-07-10', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'cyberqueen', TO_DATE('2018-06-15', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'speedster', TO_DATE('2017-02-28', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'ninja88', TO_DATE('2024-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'ninja88', TO_DATE('2023-07-14', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'pixel_panda', TO_DATE('2025-01-03', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'pixel_panda', TO_DATE('2024-02-09', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'pixel_panda', TO_DATE('2023-06-21', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'game_warrior', TO_DATE('2023-10-30', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'game_warrior', TO_DATE('2022-12-19', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'galaxy_hero', TO_DATE('2021-07-18', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'galaxy_hero', TO_DATE('2020-02-22', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'techmaster', TO_DATE('2019-07-07', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'digital_duke', TO_DATE('2018-12-22', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'digital_duke', TO_DATE('2017-10-31', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'neon_nova', TO_DATE('2023-07-16', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'neon_nova', TO_DATE('2022-02-17', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'shadow_blade', TO_DATE('2021-06-18', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'shadow_blade', TO_DATE('2020-10-30', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'shadow_blade', TO_DATE('2019-12-31', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'game_maven', TO_DATE('2018-07-24', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'dragon_slayer', TO_DATE('2017-10-30', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'dragon_slayer', TO_DATE('2016-12-15', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'pixel_queen', TO_DATE('2019-02-12', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'shadow_hunter', TO_DATE('2024-06-22', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'shadow_hunter', TO_DATE('2025-07-14', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'cyber_warrior', TO_DATE('2021-12-26', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'cyber_warrior', TO_DATE('2020-02-08', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'cyber_warrior', TO_DATE('2019-06-17', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'arcade_master', TO_DATE('2024-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'arcade_master', TO_DATE('2023-07-20', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'storm_chaser', TO_DATE('2022-07-10', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'magic_wizard', TO_DATE('2020-02-14', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'magic_wizard', TO_DATE('2023-10-29', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'magic_wizard', TO_DATE('2021-12-18', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'pixel_knight', TO_DATE('2020-07-22', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'galaxy_rider', TO_DATE('2019-07-15', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'galaxy_rider', TO_DATE('2021-10-30', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'tech_genius', TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'tech_genius', TO_DATE('2023-02-13', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'speed_demon', TO_DATE('2022-07-16', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'ninja_master', TO_DATE('2025-06-25', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'ninja_master', TO_DATE('2023-10-30', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'ninja_master', TO_DATE('2022-02-09', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'pixel_pirate', TO_DATE('2017-12-31', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Gaming Marathon', 'Competition', 'game_hero', TO_DATE('2020-07-24', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Summer Fest', 'Festival', 'game_hero', TO_DATE('2019-06-28', 'YYYY-MM-DD'));

INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Indie Showcase', 'Exhibition', 'galaxy_queen', TO_DATE('2018-02-20', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Halloween Bash', 'Seasonal', 'galaxy_queen', TO_DATE('2022-10-31', 'YYYY-MM-DD'));
INSERT INTO PARTICIPA_LA (denumire, tip_eveniment, username, data_participare)
VALUES ('Winter Sale', 'Promotion', 'galaxy_queen', TO_DATE('2025-01-02', 'YYYY-MM-DD'));

commit;