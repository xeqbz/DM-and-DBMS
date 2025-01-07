import psycopg2


def connect_db():
    """ Подключение к бд"""
    try:
        conn = psycopg2.connect(
            dbname="dblabs",
            user="postgres",
            password="7033",
            host="localhost",
            port="5432"
        )
        print("Подключение к базе данных успешно установлено.")
        return conn
    except Exception as e:
        print(f"Ошибка подключения к базе данных: {e}")
        exit()
