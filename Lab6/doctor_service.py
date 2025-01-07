from db_config import connect_db
from prettytable import PrettyTable


class DoctorService:
    def __init__(self):
        self.conn = connect_db()

    def view_schedule(self):
        with self.conn.cursor() as cur:
            print("\n=== Просмотр расписания врача ===")
            doctor_id = int(input("ID врача: "))

            try:
                query = """
                    SELECT * FROM view_doctor_schedule(%s)
                """
                cur.execute(query, (doctor_id,))
                schedules = cur.fetchall()

                if schedules:
                    for schedule in schedules:
                        print(f"День недели: {schedule[0]}")
                        print(f"Начало: {schedule[1]}")
                        print(f"Конец: {schedule[2]}")
                        print("-" * 40)
                else:
                    print("Расписание не найдено для данного врача.")
            except Exception as e:
                print(f"Ошибка при просмотре расписания: {e}")

    def view_medical_record(self):
        with self.conn.cursor() as cur:
            print("\n=== Просмотр медицинской карты пациента ===")
            patient_id = int(input("ID пациента: "))

            try:
                query = """
                    SELECT * FROM view_medical_record(%s)
                """
                cur.execute(query, (patient_id,))
                records = cur.fetchall()

                if records:
                    for record in records:
                        print(f"Диагноз: {record[0]}")
                        print(f"Прописания: {record[1]}")
                        print(f"Рекомендации: {record[2]}")
                        print(f"Дата визита: {record[3]}")
                        print("-" * 40)
                else:
                    print("Медицинская карта не найдена или пустая.")
            except Exception as e:
                print(f"Ошибка при просмотре медицинской карты: {e}")

    def display_doctors(self):
        """Вывод таблицы врачей с информацией о специализациях"""
        print("\n=== Список врачей ===")
        try:
            with self.conn.cursor() as cur:
                # Выполним запрос с объединением таблиц Doctors и DoctorSpecializations
                cur.execute("""
                    SELECT d.id, d.first_name, d.last_name, ds.name AS specialization_name, ds.description AS specialization_description
                    FROM Doctors d
                    LEFT JOIN DoctorSpecializations ds ON d.specialization_id = ds.id
                """)
                rows = cur.fetchall()

                # Создаем таблицу PrettyTable с новыми полями
                table = PrettyTable()
                table.field_names = ["ID", "Имя", "Фамилия", "Специализация", "Описание специализации"]

                # Добавляем строки в таблицу
                for row in rows:
                    table.add_row(row)

                print(table)
        except Exception as e:
            print(f"Ошибка: {e}")
