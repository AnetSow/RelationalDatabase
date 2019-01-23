# RelationalDatabase
Final project from Data Base Engineering. The idea was to create hospital relational data base from given description, starting from
ER diagrams and ending in making of front-end menu with previously established group of inquiries.

## To run:
Install Python
```
python -m pip install SomePackage
```

Check if you have Sqlite3 by ```sqlite3```,
if not:
1. Go to SQLite download page and download sqlite-autoconf-*.tar.gz from source code section.
2. Run the following command

```
$tar xvfz sqlite-autoconf-3071502.tar.gz
$cd sqlite-autoconf-3071502
$./configure --prefix=/usr/local
$make
$make install
```
To read input of SQL file in SQLite3:
```
.read Szpital.sql
```
