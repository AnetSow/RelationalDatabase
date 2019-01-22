-- by odpalić sql i stworzyc db komenda w terminialu (nie w sqlite3): cat nazwapliku.sql | sqlite3 nazwatworzonejbazy.db

DROP TABLE Oddzialy;
DROP TABLE Pracownicy;
DROP TABLE Oddzialy_Pracownicy;
DROP TABLE Rejestry_h;
DROP TABLE Oddzialowe;
DROP TABLE Lozka;
DROP TABLE Pacjenci;
DROP TABLE Srodki_med;
DROP TABLE Pacjenci_Srodki_med;
DROP TABLE Skonczone;
DROP TABLE Zabiegi;
DROP TABLE Lekarze;
DROP TABLE Lekarze_Zabiegi;
DROP TABLE Technicy;
DROP TABLE Rejestry_testow;
DROP TABLE Testy;
DROP TABLE Wizyty;

CREATE TABLE Oddzialy (
	Oddzial_ID INT PRIMARY KEY,
	Nazwa TEXT NOT NULL UNIQUE,
	Oddzialowa_ID INT,
	FOREIGN KEY (Oddzialowa_ID) REFERENCES Oddzialowe(Oddzialowa_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Pracownicy (
	Pracownik_ID INT PRIMARY KEY,
	Imie TEXT NOT NULL,
	Nazwisko TEXT NOT NULL,
	Adres TEXT NOT NULL,
	Pensja_m REAL,
	Pensja_h REAL,
	Stanowisko TEXT NOT NULL
	);

CREATE TABLE Oddzialy_Pracownicy (
 	Pracownik_ID INT,
 	Oddzial_ID INT,
 	PRIMARY KEY (Pracownik_ID, Oddzial_ID),
 	FOREIGN KEY (Pracownik_ID) REFERENCES Pracownicy(Pracownik_ID) 
 	ON DELETE CASCADE
 	FOREIGN KEY (Oddzial_ID) REFERENCES Oddzialy(Oddzial_ID) 
 	ON DELETE CASCADE
	);

CREATE TABLE Rejestry_h (
	Rejestr_h_ID INT PRIMARY KEY,
	Przepracowane_h REAL NOT NULL,
	Oddzial_ID INT,
	Pracownik_ID INT,
	FOREIGN KEY (Oddzial_ID) REFERENCES Oddzialy(Oddzial_ID)
	ON DELETE CASCADE
	FOREIGN KEY (Pracownik_ID) REFERENCES Pracownik(Pracownik_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Oddzialowe (
	Oddzialowa_ID INT PRIMARY KEY,
	Pracownik_ID INT,
	FOREIGN KEY (Pracownik_ID) REFERENCES Pracownicy(Pracownik_ID)
	ON DELETE CASCADE
	);


CREATE TABLE Lozka (
	Lozko_ID INT PRIMARY KEY,
	Nr_pokoju INT NOT NULL,
	Oddzial_ID INT,
	FOREIGN KEY (Oddzial_ID) REFERENCES Oddzialy(Oddzial_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Pacjenci (
	Pacjent_ID INT PRIMARY KEY,
	Nazwisko TEXT NOT NULL,
	Data_ur TEXT,
	Adres TEXT,
	Os_kontaktowa INT,
	Ambulatorium TEXT,
	Diagnoza TEXT NOT NULL,
	Lek TEXT,
	Lekarz_ID INT,
	Oddzial_ID INT,
	Lozko_ID INT,
	FOREIGN KEY (Lekarz_ID) REFERENCES Lekarze(Lekarz_ID)
	ON DELETE CASCADE
	FOREIGN KEY (Oddzial_ID) REFERENCES Oddzialy(Oddzial_ID)
	ON DELETE CASCADE
	FOREIGN KEY (Lozko_ID) REFERENCES  Lozka(Lozko_ID)
	);

CREATE TABLE Srodki_med (
	Srodki_med_ID INT PRIMARY KEY,
	Nazwa TEXT NOT NULL,
	Ilosc INT NOT NULL,
	Rodzaj TEXT NOT NULL
	);

CREATE TABLE Pacjenci_Srodki_med (
 	Pacjent_ID INT,
 	Srodki_med_ID INT,
	Ilosc INT NOT NULL,
	Rodzaj TEXT NOT NULL, 
 	PRIMARY KEY (Pacjent_ID, Srodki_med_ID),
 	FOREIGN KEY (Pacjent_ID) REFERENCES Pacjenci(Pacjent_ID) 
 	ON DELETE CASCADE
 	FOREIGN KEY (Srodki_med_ID) REFERENCES Srodki_med(Srodki_med_ID) 
 	ON DELETE CASCADE
	);

CREATE TABLE Skonczone (
	Skonczone_ID INT PRIMARY KEY,
	Data TEXT NOT NULL,
	Czas TEXT NOT NULL,
	Ilosc INT NOT NULL,
	Cena REAL NOT NULL,
	Srodki_med_ID INT,
	FOREIGN KEY (Srodki_med_ID) REFERENCES Srodki_med(Srodki_med_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Zabiegi (
	Zabieg_ID INT PRIMARY KEY,
	Data TEXT NOT NULL,
	Czas TEXT NOT NULL,
	Rezultat TEXT NOT NULL,
	Pacjent_ID INT,
	FOREIGN KEY (Pacjent_ID) REFERENCES Pacjenci(Pacjent_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Lekarze (
	Lekarz_ID INT PRIMARY KEY,
	Imie TEXT NOT NULL,
	Nazwisko TEXT NOT NULL,
	Specjalizacja TEXT NOT NULL,
	Nr_tel INT NOT NULL UNIQUE,
	Pracownik_ID INT,
	FOREIGN KEY (Pracownik_ID) REFERENCES Pracownicy(Pracownik_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Lekarze_Zabiegi(
 	Lekarz_ID INT,
 	Zabieg_ID INT,
 	PRIMARY KEY (Lekarz_ID, Zabieg_ID),
 	FOREIGN KEY (Lekarz_ID) REFERENCES Lekarze(Lekarz_ID) 
 	ON DELETE CASCADE
 	FOREIGN KEY (Zabieg_ID) REFERENCES Zabiegi(Zabieg_ID) 
 	ON DELETE CASCADE
	);

CREATE TABLE Technicy (
	Technik_ID INT PRIMARY KEY,
	Pracownik_ID INT,
	FOREIGN KEY (Pracownik_ID) REFERENCES Pracownicy(Pracownik_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Rejestry_testow (
	Rejestr_testow_ID INT PRIMARY KEY,
	Technik_ID INT,
	Pacjent_ID INT,
	FOREIGN KEY (Technik_ID) REFERENCES Technicy(Technik_ID)
	ON DELETE CASCADE
	FOREIGN KEY (Pacjent_ID) REFERENCES Pacjenci(Pacjent_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Testy (
	Test_ID INT PRIMARY KEY,
	Data TEXT NOT NULL,
	Rezultat TEXT NOT NULL,
	Rejestr_testow_ID INT,
	FOREIGN KEY (Rejestr_testow_ID) REFERENCES Rejestry_testow(Rejestr_testow_ID)
	ON DELETE CASCADE
	);

CREATE TABLE Wizyty (
	Wizyta_ID INT PRIMARY KEY,
	Data TEXT NOT NULL,
	Pacjent_ID INT,
	Lekarz_ID INT,
	FOREIGN KEY (Pacjent_ID) REFERENCES Pacjenci(Pacjent_ID)
	ON DELETE CASCADE
	FOREIGN KEY (Lekarz_ID) REFERENCES Lekarze(Lekarz_ID)
	ON DELETE CASCADE
	);


INSERT INTO Pracownicy VALUES (1, 'Sebastian', 'Grzyb', 'Abrahama 66/6, Wroclaw', 6500, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (2, 'Agnieszka', 'Pajak', 'most Parkowy 34, Wroclaw', 4300, NULL, 'lekarz' );
INSERT INTO Pracownicy VALUES (3, 'Natalia', 'Samuel', '9 maja 78, Wroclaw', 4400, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (4, 'Joanna', 'Gaska', 'al.Debowa 14a, Wroclaw',4400, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (5, 'Jessica', 'Podolska', 'Afganska 82, Wroclaw', 7000, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (6, 'Marcin', 'Gruszka', 'Mostowa 56/5, Wroclaw', 6000, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (7, 'Alicja', 'Krzak', 'Opolska 12/3, Wroclaw', 6200, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (8, 'Barłomiej', 'Nowakowski', 'Oltaszynska 45, Wroclaw', 8500, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (9, 'Elisabeth', 'Brown', 'Orla 75, Wroclaw', 15000, NULL, 'lekarz-ordynator');
INSERT INTO Pracownicy VALUES (10, 'Amadeusz', 'Kuc', 'Bierunska 87/9', 6500, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (11, 'Marcin', 'Flaming', 'Storczykowa 31, Wroclaw', 8300, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (12, 'Marlena', 'Tylko', 'Daliowa 2, Wroclaw', 13000, NULL, 'lekarz-ordynator');
INSERT INTO Pracownicy VALUES (13, 'Adam', 'Śledź', 'Pogodna 65/7, Wroclaw', 5500, NULL, 'lekarz');
INSERT INTO Pracownicy VALUES (14, 'Marian', 'Nocon', 'Mosiężna 23/8, Wroclaw', NULL, 17.5 , 'sprzatacz');
INSERT INTO Pracownicy VALUES (15, 'Angelika', 'Krol', '320 156, Wroclaw', NULL, 18.5, 'sprzatacz');
INSERT INTO Pracownicy VALUES (16, 'Boguslaw', 'Nowak', 'Morwowa 45/7, Wroclaw', NULL, 23.5, 'konserwator');
INSERT INTO Pracownicy VALUES (17, 'Marianna', 'Sokolov', 'Akacjowa 13, Wroclaw', NULL, 20.1, 'recepcjonista');
INSERT INTO Pracownicy VALUES (18, 'Elzbieta', 'Skok', 'Wielowiejska 56/5, Wroclaw', 3100, NULL, 'recepcjonista');
INSERT INTO Pracownicy VALUES (19, 'Robert', 'Piecyk', 'Chelmonskiego 24, Wroclaw', 4000, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (20, 'Gabriela', 'Mol', 'Pilsudskiego 22/4a, Wroclaw', 4500, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (21, 'Magdalena', 'Kogut', 'Nowowiejska 23/17, Wroclaw', 4100, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (22, 'Jakub', 'Suchodolski', 'Litewska 18/3, Wroclaw', 4300, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (23, 'Alicja', 'Krzaczynska', 'Trzebnicka 29/4, Wroclaw', 4100, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (24, 'Monika', 'Skupien', 'Czolgowa 44, Wroclaw', 4100, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (25, 'Magdalena', 'Skupien', 'Czarna 2/4, Wroclaw', 4200, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (26, 'Paulina', 'Tomczyk', '11 listopada 44/3, Wroclaw', 3900, NULL, 'pielegniarka');
INSERT INTO Pracownicy VALUES (27, 'Aleksander', 'Olgier', 'Krowia 55/1, Wroclaw', 3500, NULL, 'technik');
INSERT INTO Pracownicy VALUES (28, 'Alicja', 'Tomaszyk', 'Barycka 12, Wroclaw', 3200, NULL, 'technik');
INSERT INTO Pracownicy VALUES (29, 'Karol', 'Komorowski', 'Asfaltowa 90/1, Wroclaw', NULL, 18.5, 'technik');
INSERT INTO Pracownicy VALUES (30, 'Karolina', 'Tomczyk', 'Krotka 4/19, Wroclaw', 3300, NULL, 'technik');
INSERT INTO Pracownicy VALUES (31, 'Patryk', 'Rzepka', 'Rysia 17, Wroclaw', 3500, NULL, 'technik');


INSERT INTO Oddzialy_Pracownicy VALUES (1, 1);
INSERT INTO Oddzialy_Pracownicy VALUES (2, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (3, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (4, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (13, 1);
INSERT INTO Oddzialy_Pracownicy VALUES (5, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (7, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (10, 6);
INSERT INTO Oddzialy_Pracownicy VALUES (12, 6);
INSERT INTO Oddzialy_Pracownicy VALUES (8, 5);
INSERT INTO Oddzialy_Pracownicy VALUES (9, 5);
INSERT INTO Oddzialy_Pracownicy VALUES (11, 5);
INSERT INTO Oddzialy_Pracownicy VALUES (14, 1);
INSERT INTO Oddzialy_Pracownicy VALUES (14, 4);
INSERT INTO Oddzialy_Pracownicy VALUES (14, 5);
INSERT INTO Oddzialy_Pracownicy VALUES (15, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (15, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (15, 6);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 1);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 4);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 5);
INSERT INTO Oddzialy_Pracownicy VALUES (16, 6);
INSERT INTO Oddzialy_Pracownicy VALUES (17, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (18, 4);
INSERT INTO Oddzialy_Pracownicy VALUES (19, 1);
INSERT INTO Oddzialy_Pracownicy VALUES (20, 2);
INSERT INTO Oddzialy_Pracownicy VALUES (21, 6);
INSERT INTO Oddzialy_Pracownicy VALUES (22, 4);
INSERT INTO Oddzialy_Pracownicy VALUES (23, 4);
INSERT INTO Oddzialy_Pracownicy VALUES (24, 6); 
INSERT INTO Oddzialy_Pracownicy VALUES (25, 5); 
INSERT INTO Oddzialy_Pracownicy VALUES (26, 3); 
INSERT INTO Oddzialy_Pracownicy VALUES (27, 2); 
INSERT INTO Oddzialy_Pracownicy VALUES (28, 3);
INSERT INTO Oddzialy_Pracownicy VALUES (29, 2); 
INSERT INTO Oddzialy_Pracownicy VALUES (30, 1); 
INSERT INTO Oddzialy_Pracownicy VALUES (31, 6);


INSERT INTO Oddzialy VALUES (1, 'kardiologiczny', 1);
INSERT INTO Oddzialy VALUES (2, 'szpitalny oddzial ratunkowy', 2);
INSERT INTO Oddzialy VALUES (3, 'psychiatryczny', 3);
INSERT INTO Oddzialy VALUES (4, 'pediatryczny',4);
INSERT INTO Oddzialy VALUES (5, 'chirurgiczny', 5);
INSERT INTO Oddzialy VALUES (6, 'ginekologiczny', 6);


INSERT INTO Rejestry_h VALUES (1, 5.5, 1, 16);
INSERT INTO Rejestry_h VALUES (2, 3.5, 4, 16);
INSERT INTO Rejestry_h VALUES (3, 7.5, 3, 16);
INSERT INTO Rejestry_h VALUES (4, 95, 3, 17);
INSERT INTO Rejestry_h VALUES (5, 30, 5, 14);
INSERT INTO Rejestry_h VALUES (6, 49, 2, 15);


INSERT INTO Oddzialowe VALUES (1, 19);
INSERT INTO Oddzialowe VALUES (2, 20);
INSERT INTO Oddzialowe VALUES (3, 26);
INSERT INTO Oddzialowe VALUES (4, 22);
INSERT INTO Oddzialowe VALUES (5, 25);
INSERT INTO Oddzialowe VALUES (6, 24);


INSERT INTO Testy VALUES (1, date('2015-05-12'), 'Podwyższony cholesterol', 1);
INSERT INTO Testy VALUES (2, date('2015-05-12'), 'Szmery w leym przedsionku serca', 1);
INSERT INTO Testy VALUES (3, date('2016-06-19'), 'Guz 5mm. na szyszynce', 2);
INSERT INTO Testy VALUES (4, date('2015-08-31'), 'Torbiel w zatoce szczękowej', 3);


INSERT INTO Technicy VALUES (1, 27);
INSERT INTO Technicy VALUES (2, 28);
INSERT INTO Technicy VALUES (3, 29);
INSERT INTO Technicy VALUES (4, 30);
INSERT INTO Technicy VALUES (5, 31);


INSERT INTO Rejestry_testow VALUES (1, 1, 12);
INSERT INTO Rejestry_testow VALUES (2, 1, 12);
INSERT INTO Rejestry_testow VALUES (3, 4, 3);
INSERT INTO Rejestry_testow VALUES (4, 3, 17);


INSERT INTO Zabiegi VALUES (1, date('2015-07-30'), time('10:30'), 'angioplastyka wiencowa - zakonczona bez komplikacji', 5);
INSERT INTO Zabiegi VALUES (2, date('2017-12-10'), time('11:40'), 'usunięcie blaszki miażdżycowej - zakonczona bez komplikacji', 12);
INSERT INTO Zabiegi VALUES (3, date('2015-05-13'), time('12:00'), 'amutacja stopy cukrzycowej - zakończona bez komplikacji', 1);
INSERT INTO Zabiegi VALUES (4, date('2015-04-20'), time('14:00'),'tetniak mozgu - pacjent zmarl', 13);
INSERT INTO Zabiegi VALUES (5, date('2016-01-14'), time('17:00'), 'operacja bariatrycznej - zakonczona bez komplikacji,', 9);


INSERT INTO Lekarze_Zabiegi VALUES (8, 1);
INSERT INTO Lekarze_Zabiegi VALUES (9, 1);
INSERT INTO Lekarze_Zabiegi VALUES (9, 2);
INSERT INTO Lekarze_Zabiegi VALUES (8, 3);
INSERT INTO Lekarze_Zabiegi VALUES (8, 4);
INSERT INTO Lekarze_Zabiegi VALUES (11, 4);
INSERT INTO Lekarze_Zabiegi VALUES (11, 5);


INSERT INTO Pacjenci VALUES (1, 'Samosiuk', date('1968-01-01'), 'Polna 12, Wroclaw', 606954362, 'NIE', 'cukrzyca', 'Insulin', 3, 2, 1);
INSERT INTO Pacjenci VALUES (2, 'Andrzejewicz', date('1999-10-03'), 'Fiolkowa 2, Wroclaw', 606123362, 'TAK', 'oparzenie 2 st.',  'Argosulfan', 4, 2, NULL);
INSERT INTO Pacjenci VALUES (3, 'Nowak', date('1998-03-06'), 'Brodatego 1, Wroclaw',606952342, 'NIE', 'borderline', 'Prozak', 5, 3, 2);
INSERT INTO Pacjenci VALUES (4, 'Soltysik', date('1967-06-21'), 'Rzeznicza 9, Wroclaw', 606954352, 'NIE', 'cukrzyca', 'Cetol-2', 2, 2, 3);
INSERT INTO Pacjenci VALUES (5, 'Sowa', date('1988-05-31'), 'Piaskowa 102, Wroclaw', 606933362, 'NIE', 'zawal', 'Aspiryna, Klopidogrel, Nitrogliceryna', 1, 1, 5);
INSERT INTO Pacjenci VALUES (6, 'Piramowicz', date('1996-10-24'), 'Pretficza 51/39, Wroclaw',605952542, 'NIE', 'zaburzenia lękowe', 'Xanax', 5, 3, 4);
INSERT INTO Pacjenci VALUES (7, 'Smok', date('2003-03-06'), 'Kuźnicza 56, Wroclaw',606972342, 'TAK', 'cukrzyca', 'Cetol-2', 6, 4, NULL);
INSERT INTO Pacjenci VALUES (8, 'Brys', date('2005-08-15'), 'Krucza 21/3, Wroclaw',607552342, 'NIE', 'cukrzyca', 'Insulina', 7, 4, 5);
INSERT INTO Pacjenci VALUES (9, 'Okatawa', date('1968-04-14'), 'Tęczowa 1/2, Wroclaw',506952342, 'NIE', 'cukrzyca', 'Cetol-2', 4, 2, 6);
INSERT INTO Pacjenci VALUES (10, 'Sokol',date('2005-11-28'), 'Chrobrego 16/3, Wroclaw',536952342, 'TAK', 'cukrzyca', 'Insulina', 5, 3, NULL);
INSERT INTO Pacjenci VALUES (11, 'Bierdon', date('2003-11-04'), 'Marynarzy 64/8, Brzeg',626952342, 'TAK', 'cukrzyca', 'NULL', 7, 4, NULL);
INSERT INTO Pacjenci VALUES (12, 'Sok', date('1964-06-25'), 'Tramwajowa 2/7, Wroclaw',606952342, 'TAK', 'miazdzyca', 'Atorwastatyna', 1, 1, NULL);
INSERT INTO Pacjenci VALUES (13, 'Osioly', date('1985-02-29'), 'Kuźnicza 61/5C, Wroclaw',606322342, 'NIE', 'depresja', 'Zolof', 5, 3, 7);
INSERT INTO Pacjenci VALUES (14, 'Sokol', date('1968-10-12'), 'Krzycka 16/2C, Wroclaw',526952393, 'NIE', 'schizofrenia', 'Aripiprazol', 5, 3, 8);
INSERT INTO Pacjenci VALUES (15, 'Smith', date('1997-07-27'), 'Szczytnicka 24/4, Wroclaw',606952356, 'NIE', 'depresja', 'Prozak, Xanax', 5, 3, 9);
INSERT INTO Pacjenci VALUES (16, 'Kalamarz', date('1970-12-30'), 'Cicha 76, Oława',516952342, 'TAK', 'grypa', 'Gripex', 2, 2, NULL);
INSERT INTO Pacjenci VALUES (17, 'Ciastko', date('1989-04-07'), 'Polna 32, Wroclaw',607452342, 'TAK', 'angina', 'Zinnat', 3, 2, NULL);


INSERT INTO Srodki_med VALUES (1, 'Insulina', 15, 'ampulki');
INSERT INTO Srodki_med VALUES (2, 'Atowastatyna', 70, 'tabletki');
INSERT INTO Srodki_med VALUES (3, 'Cetol-2', 6, 'ampulki');
INSERT INTO Srodki_med VALUES (4, 'Xanax', 30, 'tabletki' );
INSERT INTO Srodki_med VALUES (5, 'Cetol-2', 4, 'ampulki');


INSERT INTO Pacjenci_Srodki_med VALUES (15, 4, 30, 'tabletki');
INSERT INTO Pacjenci_Srodki_med VALUES (7, 3, 1, ' ampulki');
INSERT INTO Pacjenci_Srodki_med VALUES (9, 5, 2, 'ampulki');
INSERT INTO Pacjenci_Srodki_med VALUES (4, 5, 2, 'ampulki');

 	
INSERT INTO Skonczone VALUES (1, date('2015-06-16'), time('17:18'), '	tabletki; 0,25 mg; 1op x 30 tabl.', 21.85, 4); 
INSERT INTO Skonczone VALUES (2, date('2016-07-02'), time('10:31'), '	tabletki; 2mg; 1op x 30 tabl.', 79.32, 5); 


INSERT INTO Wizyty VALUES (1, date('2015-05-12'), 1, 2);
INSERT INTO Wizyty VALUES (2, date('2017-11-18'), 2, 4);
INSERT INTO Wizyty VALUES (3, date('2015-10-24'), 2, 6); 
INSERT INTO Wizyty VALUES (4, date('2016-07-02'), 4, 4);
INSERT INTO Wizyty VALUES (5, date('2015-06-16'), 15, 13);
INSERT INTO Wizyty VALUES (6, date('2017-10-23'), 6, 12);
INSERT INTO Wizyty VALUES (7, date('2015-10-18'), 7, 2);
INSERT INTO Wizyty VALUES (8, date('2005-03-11'), 7, 4);
INSERT INTO Wizyty VALUES (9, date('2015-08-03'), 7, 2);
INSERT INTO Wizyty VALUES (10, date('2015-12-07'), 8, 3);
INSERT INTO Wizyty VALUES (11, date('2016-11-30'), 8, 1);
INSERT INTO Wizyty VALUES (12, date('2016-04-27'), 6, 8);
INSERT INTO Wizyty VALUES (13, date('2015-03-05'), 10, 3);
INSERT INTO Wizyty VALUES (14, date('2015-01-29'), 10, 2);
INSERT INTO Wizyty VALUES (15, date('2015-03-13'), 11, 3);
INSERT INTO Wizyty VALUES (16, date('2015-02-19'), 16, 10);
INSERT INTO Wizyty VALUES (17, date('2017-12-04'), 17, 3);
INSERT INTO Wizyty VALUES (18, date('2015-04-08'), 13, 5);
INSERT INTO Wizyty VALUES (19, date('2017-06-12'), 14, 13);
INSERT INTO Wizyty VALUES (20, date('2015-05-27'), 12, 5);
INSERT INTO Wizyty VALUES (21, date('2016-04-20'), 15, 3);
INSERT INTO Wizyty VALUES (22, date('2015-01-30'), 15, 4);
INSERT INTO Wizyty VALUES (23, date('2015-05-31'), 12, 4);
INSERT INTO Wizyty VALUES (24, date('2015-04-20'), 12, 20);
INSERT INTO Wizyty VALUES (25, date('2015-04-03'), 11, 4);
INSERT INTO Wizyty VALUES (26, date('2016-04-22'), 11, 3);
INSERT INTO Wizyty VALUES (27, date('2015-04-14'), 11, 2);
INSERT INTO Wizyty VALUES (28, date('2015-09-03'), 7, 6);
INSERT INTO Wizyty VALUES (29, date('2015-09-04'), 7, 6);


INSERT INTO Lekarze VALUES (1, 'Sebastian', 'Grzyb', 'kardiolog', 696235686, 1);
INSERT INTO Lekarze VALUES (2, 'Agnieszka', 'Pajak', 'ogolna', 696232346, 2);
INSERT INTO Lekarze VALUES (3, 'Natalia', 'Samuel', 'ogolna', 696765466, 3);
INSERT INTO Lekarze VALUES (4, 'Joanna', 'Gaska', 'ogolna', 696235666, 4);
INSERT INTO Lekarze VALUES (5, 'Jessica', 'Podolska', 'psychiatra', 696238866, 5);
INSERT INTO Lekarze VALUES (6, 'Marcin', 'Gruszka', 'pediatra', 696238567, 6);
INSERT INTO Lekarze VALUES (7, 'Alicja', 'Krzak', 'psychiatra', 54623856, 7);
INSERT INTO Lekarze VALUES (8, 'Barłomiej', 'Nowakowski', 'chirurg', 670258567, 8);
INSERT INTO Lekarze VALUES (9, 'Elisabeth', 'Brown', 'chirurg kardiolog', 540038567, 9);
INSERT INTO Lekarze VALUES (10, 'Amadeusz', 'Kuc', 'ginekolog', 506238522, 10);
INSERT INTO Lekarze VALUES (11, 'Marcin', 'Flaming', 'chirurg', 546238567, 11);
INSERT INTO Lekarze VALUES (12, 'Marlena', 'Tylko', 'ginekolog', 638238567, 12);
INSERT INTO Lekarze VALUES (13, 'Adam', 'Śledź', 'kardiolog', 506338567, 13);


INSERT INTO Lozka VALUES (2, 20, 3);
INSERT INTO Lozka VALUES (3, 10, 2);
INSERT INTO Lozka VALUES (4, 23, 3);
INSERT INTO Lozka VALUES (5, 35, 4);
INSERT INTO Lozka VALUES (6, 11, 2);
INSERT INTO Lozka VALUES (7, 24, 3);
INSERT INTO Lozka VALUES (8, 24, 3);
INSERT INTO Lozka VALUES (9, 23, 3);
