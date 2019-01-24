import os
import sqlite3

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


def add_record(cursor):
    table_name = input(">>> wybierz tabele: ")
    select_all_records(cursor, table_name)
    # insecure - sql injection
    table_columns = cursor.execute('PRAGMA table_info({})'.format(table_name))
    columns_names = [c[1] for c in table_columns]
    print(columns_names)
    values = []
    for name in columns_names:
        value = input('>>> podaj wartosc dla {} '.format(name))
        values.append(value)
    placeholders = '?,' * len(values)
    query = "INSERT INTO {} VALUES({})".format(table_name, placeholders.strip(','))
    cursor.execute(query, tuple(values))
    print('insert done')
    select_all_records(cursor, table_name)


def del_record(cursor):
    table_name = input(">>> wybierz tabele: ")
    select_all_records(cursor, table_name)
    # insecure - sql injection
    id_to_del = input(">>> podaj ID rekordu do usunięcia: ")
    table_columns = cursor.execute('PRAGMA table_info({})'.format(table_name))
    record_id = ''.join([c[1] for c in table_columns if c[5] == 1])
    cursor.execute("DELETE FROM {} WHERE {} = {}".format(table_name, record_id, id_to_del))


def main():
    print("Witaj w bazie danych szpitala.")
    connection = create_connection()
    with connection:
        database_cursor = connection.cursor()
        tables_query = database_cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        print('\nWybierz bazę do przegladania:\n {}'.format('\n'.join([result[0] for result in tables_query])))

        table_name = input('\n>>> podaj nazwę tabeli ')
        print("Wszystkie rekordy w tabeli: {}\n".format(table_name))
        select_all_records(database_cursor, table_name)

        print('\n\n| 1. Dodaj nowy rekord | 2. Usuń rekord | 3. Wyszukaj | 4. Wróć |\n\n')
        menu_choice = int(input('>>> podaj numer '))
        if menu_choice == 1:
            add_record(database_cursor)
        if menu_choice == 2:
            del_record(database_cursor)
        # if menu_choice == 3:
        #     search_record(database_cursor)
        if menu_choice == 4:
            main()


if __name__ == '__main__':
    main()
