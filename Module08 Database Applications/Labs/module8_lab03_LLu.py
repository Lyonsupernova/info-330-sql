import pypyodbc

db_driver='{ODBC Driver 13 for SQL Server}'
db_host = 'is-root01.ischool.uw.edu'
db_name = 'Northwind'
db_user = 'Info330'
db_password = 'sql'
connection_string = 'Driver=' + db_driver
connection_string += ';Server=' + db_host
connection_string += ';Database=' + db_name
connection_string += ';UID=' + db_user
connection_string += ';PWD=' + db_password + ';'

objCon = pypyodbc.connect(connection_string)
print('It worked!')
objCon.close
