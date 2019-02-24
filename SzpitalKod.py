import os
import sqlite3
import sys


DATABASE_NAME = 'Szpital.db'
DATABASE_PATH = os.path.abspath(DATABASE_NAME)


def create_connection(database_path=DATABASE_PATH):
    try:
        return sqlite3.connect(database_path)
    except sqlite3.Error as e:
        print(e)


def select_all_records(cursor, table_name):
    # insecure - sql injection
    cursor.execute('SELECT * FROM {}'.format(table_name))
    rows = cursor.fetchall()

    for row in rows:
        print(row)

def check_input(inputs):
    if 'DROP TABLE' in inputs:
        print('Wykryto użycie frazy DROP TABLE ')
        raise TypeError


def browse_table(cursor):
    tables_query = cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    print('\nWybierz bazę do przegladania: {}'.format('\n'.join([result[0] for result in tables_query])))
    table_name = input('\n>>> podaj nazwę tabeli ')
    print('\nWszystkie rekordy w tabeli: {}\n'.format(table_name))
    select_all_records(cursor, table_name)


def add_record(cursor):
    table_name = input('\n>>> wybierz tabele: \n')
    select_all_records(cursor, table_name)
    # insecure - sql injection
    table_columns = cursor.execute('PRAGMA table_info({})'.format(table_name))
    columns_names = [c[1] for c in table_columns]
    print(columns_names)
    values = []
    for name in columns_names:
        value = input('\n>>> podaj wartosc dla {} \n'.format(name))
        check_input(value)
        values.append(value)
    placeholders = '?,' * len(values)
    query = 'INSERT INTO {} VALUES({})'.format(table_name, placeholders.strip(','))
    cursor.execute(query, tuple(values))
    print('insert done')
    select_all_records(cursor, table_name) 


def del_record(cursor):
    table_name = input('>>> wybierz tabele: ')
    select_all_records(cursor, table_name)
    id_to_del = int(input('\n>>> podaj ID rekordu do usunięcia: \n'))
    table_columns = cursor.execute('PRAGMA table_info({})'.format(table_name))
    record_id = ''.join([c[1] for c in table_columns if c[5] == 1])
    cursor.execute('DELETE FROM {} WHERE {} = {}'.format(table_name, record_id, id_to_del))


def make_queries(cursor):
    list_of_queries = ['\n1. Nazwiska i daty urodzeń pacjentów, którym przepisano lek Cetol-2, cierpiących na cukrzycę, którzy odbyli jedną lub więcej wizyt u lekarza pracującego na oddziale pediatrycznym.', '\n2. Lista pacjentów, którzy odwiedzili jednego lub więcej lekarzy ogólnych: (Dr. Pająk, Dr. Samuel i Dr.Gąska)', '\n3. Łączna liczba pacjentów, których nazwisko zaczyna się na literę "S", i którzy złożyli więcej niż 2 wizyty u lekarza ogólnego.','\n4. Nazwisko, imię lekarza, który  miał najmniej wizyt pacjentów w 2015 roku.', '\n5. Wyświetl nazwiska i stawki godzinowe powiększone o 15 prcent dla wszystkich pracowników z pensją naliczaną godzinowo i zaokrąglone  do liczb całkowitych.', '\n6. Dla każdego pracownika na zatrudnionego na stałym etacie wyświetl wartość jego płacy podstawowej, ale ukryj wartość płacy jeśli etat pracownika  to ordynator.', '\n7. Dla każdego oddziału wyświetl liczbę zatrudnionych w nim pracowników.','\n8. Wyświetl nazwiska i etaty pracowników których rzeczywiste zarobki nie przekraczają 50% zarobków ich szefów.', '\n9. Podaj nazwę oddziału oraz liczbę pacjentów, w których ilość pacjentów przekracza średnią ilość pacjentów na oddział w szpitalu.', '\n10. Wyświetl nazwę oddziału wypłacającego miesięcznie swoim pracownikom ze stałą pensją najwięcej pieniędzy.']
    print("\n".join(list_of_queries))
    num_que = int(input('\n>>> Wybierz nr zapytania (1-10): '))
    if num_que == 1:
        cursor.execute("SELECT DISTINCT P.Nazwisko, P.Data_ur FROM Wizyty as W \
        INNER JOIN Pacjenci as P ON W.Pacjent_ID = P.Pacjent_ID INNER JOIN Lekarze as L\
        ON W.Lekarz_ID = L.Lekarz_ID WHERE P.Lek = 'Cetol-2' AND P.Diagnoza = 'cukrzyca'\
        AND L.Specjalizacja = 'pediatra';")
        print(cursor.fetchall())
    if num_que == 2:
        cursor.execute("SELECT P.Nazwisko FROM Wizyty AS W\
        INNER JOIN Pacjenci AS P ON W.Pacjent_ID = P.Pacjent_ID\
        INNER JOIN Lekarze AS L ON W.Lekarz_ID = L.Lekarz_ID\
        WHERE L.Nazwisko = 'Samuel' OR L.Nazwisko = 'Pajak' OR L.Nazwisko = 'Gaska'\
        AND L.Specjalizacja = 'ogolna' GROUP BY P.Nazwisko ORDER BY P.Nazwisko ASC;")
        print(cursor.fetchall())
    if num_que == 3:
        cursor.execute("SELECT COUNT(*) FROM (SELECT count(P.Pacjent_ID) AS Ilosc_wizyt\
        FROM Wizyty AS W  INNER JOIN Pacjenci AS P ON W.Pacjent_ID = P.Pacjent_ID\
        INNER JOIN Lekarze AS L ON W.Lekarz_ID = L.Lekarz_ID WHERE P.Nazwisko LIKE 'S%'\
        AND L.Specjalizacja = 'ogolna' GROUP BY W.Pacjent_ID HAVING Ilosc_wizyt > 2);")
        print(cursor.fetchall())
    if num_que == 4:
        cursor.execute("SELECT L.Nazwisko, L.Imie, count(W.Lekarz_ID) AS Ilosc_wizyt\
        FROM Lekarze AS L INNER JOIN Wizyty AS W\
        ON L.Lekarz_ID = W.Lekarz_ID WHERE W.Data BETWEEN '2015-01-01' and '2015-12-31'\
        GROUP BY W.Lekarz_ID ORDER BY Ilosc_wizyt ASC LIMIT(1);")
        print(cursor.fetchall())
    if num_que == 5:
        cursor.execute("SELECT  Nazwisko, Pensja_h, round(Pensja_h * 1.15) as NowaPensja FROM Pracownicy\
        WHERE Pensja_h IS NOT NULL;")
        print(cursor.fetchall())
    if num_que == 6:
        cursor.execute("SELECT Nazwisko, Pensja_m AS Placa FROM Pracownicy WHERE Pensja_m IS NOT NULL\
        AND NOT Stanowisko = 'lekarz-ordynator';")
        print(cursor.fetchall())
    if num_que == 7:
        cursor.execute("SELECT O.Oddzial_ID, O.Nazwa, count(Pr.Pracownik_ID) AS Ilosc_Pracownikow\
        FROM Oddzialy_Pracownicy AS OPr\
        INNER JOIN Pracownicy AS Pr ON OPr.Pracownik_ID = Pr.Pracownik_ID\
        INNER JOIN Oddzialy AS O ON OPr.Oddzial_ID = O.Oddzial_ID\
        GROUP BY O.Oddzial_ID;")
        print(cursor.fetchall())
    if num_que == 8:
        cursor.execute("SELECT Nazwisko, Stanowisko, Pensja_m\
        FROM Pracownicy WHERE Pensja_m <= (SELECT avg(Pensja_m) from Pracownicy WHERE Stanowisko LIKE 'lekarz-ordynator') / 2;")
        print(cursor.fetchall())
    if num_que == 9:
        cursor.execute("SELECT Pacjenci.Oddzial_ID, count(Pacjenci.Pacjent_ID) as PacjenciCount, O.Nazwa\
        from Pacjenci inner join Oddzialy O on Pacjenci.Oddzial_ID = O.Oddzial_ID\
        group by Pacjenci.Oddzial_ID having PacjenciCount > (select (select count(*)\
        from Pacjenci) * 1.0 / (select count(*) from Oddzialy) * 1.0);")
        print(cursor.fetchall())
    if num_que == 10:
        cursor.execute("SELECT O.Nazwa, sum(Pr.Pensja_m) as Ilosc_Pieniedzy\
        FROM Oddzialy_Pracownicy as OPr\
        INNER JOIN Pracownicy as Pr ON OPr.Pracownik_ID = Pr.Pracownik_ID\
        INNER JOIN Oddzialy as O ON OPr.Oddzial_ID = O.Oddzial_ID\
        GROUP BY O.Oddzial_ID ORDER BY Ilosc_Pieniedzy DESC LIMIT(1);")
        print(cursor.fetchall())
    print('\n| 1. Wróć do menu | 2. Wykonaj kolejne zapytanie |')
    decision = int(input('\n>>> '))
    if decision == 1:
         main()
    if decision == 2:
        make_queries(cursor)


def main():
    print('\nWitaj w bazie danych szpitala. Co chcesz zrobić?')
    connection = create_connection()
    with connection:
        database_cursor = connection.cursor()
        while True:
            print('\n| 1. Przeglądaj | 2. Dodaj nowy rekord | 3. Usuń rekord | 4. Wyszukaj | 5. Wyjdź |\n')
            menu_choice = int(input('\n>>> podaj numer '))
            if menu_choice == 1:
                browse_table(database_cursor)
            if menu_choice == 2:
                add_record(database_cursor)
                connection.commit()
            if menu_choice == 3:
                del_record(database_cursor)
                connection.commit()
            if menu_choice == 4:
                make_queries(database_cursor)
            elif menu_choice == 5:
                sys.exit()


if __name__ == '__main__':
    main()
