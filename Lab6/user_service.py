from db_config import connect_db
from datetime import datetime
from prettytable import PrettyTable


class UserService:
    def __init__(self):
        self.conn = connect_db()

    def register_user(self):
        """Регистрация пользователя"""
        print("\n=== Регистрация пользователя ===")
        try:
            first_name = self._input_non_empty("Введите имя: ")
            last_name = self._input_non_empty("Введите фамилию: ")
            date_of_birth = self._input_date("Введите дату рождения (ГГГГ-ММ-ДД): ")
            address = self._input_non_empty("Введите адрес: ")
            phone = self._input_non_empty("Введите телефон: ")
            email = self._input_email("Введите email: ")
            password = self._input_non_empty("Введите пароль: ")

            with self.conn.cursor() as cur:
                cur.execute("CALL register_patient(%s, %s, %s, %s, %s, %s, %s)",
                            (first_name, last_name, date_of_birth, address, phone, email, password))
                self.conn.commit()
                print("Регистрация прошла успешно!")
        except Exception as e:
            print(f"Ошибка: {e}")

    def login_user(self):
        """Авторизация пользователя"""
        print("\n=== Вход пользователя ===")
        try:
            email = self._input_email("Введите email: ")
            password = self._input_non_empty("Введите пароль: ")

            with self.conn.cursor() as cur:
                query = """
                                SELECT * FROM login_patient(%s, %s)
                            """
                cur.execute(query, (email, password))
                result = cur.fetchone()
                if result[0]:  # Если возвращен patient_id
                    print(f"Вход выполнен успешно! ID пациента: {result[0]}")
                else:
                    print(f"Ошибка: {result[1]}")
        except Exception as e:
            print(f"Ошибка: {e}")

    def book_appointment(self):
        """Запись на прием"""
        print("\n=== Запись на прием ===")
        try:
            patient_id = int(self._input_non_empty("Введите ваш ID пациента: "))
            doctor_id = int(self._input_non_empty("Введите ID врача: "))
            appointment_date = self._input_date_time("Введите дату и время приема (ГГГГ-ММ-ДД ЧЧ:ММ): ")

            with self.conn.cursor() as cur:
                query = """
                                SELECT * FROM book_appointment(%s, %s, %s)
                            """
                cur.execute(query, (patient_id, doctor_id, appointment_date))
                result = cur.fetchone()
                if result[0]:  # appointment_id возвращен
                    print(f"Запись успешна! ID записи: {result[0]}")
                else:
                    print(f"Ошибка: {result[1]}")
        except Exception as e:
            print(f"Ошибка: {e}")

    def cancel_or_update_appointment(self):
        """Отмена или изменение записи"""
        print("\n=== Изменение записи на прием ===")
        try:
            appointment_id = int(self._input_non_empty("Введите ID записи: "))
            new_date = self._input_date_time("Введите новую дату и время (ГГГГ-ММ-ДД ЧЧ:ММ): ")
            new_status = self._input_non_empty("Введите новый статус (Отменено/Перенос): ")

            with self.conn.cursor() as cur:
                query = """
                                SELECT * FROM update_appointment(%s, %s, %s)
                            """
                cur.execute(query, (appointment_id, new_date, new_status))
                result = cur.fetchone()
                if result[0]:  # appointment_id возвращен
                    print(f"Запись обновлена! ID записи: {result[0]}")
                else:
                    print(f"Ошибка: {result[1]}")
        except Exception as e:
            print(f"Ошибка: {e}")

    def pay_for_service(self):
        with self.conn.cursor() as cur:
            print("\n=== Оплата услуги ===")
            patient_id = int(input("ID пациента: "))
            appointment_id = int(input("ID записи на прием: "))
            amount = float(input("Сумма к оплате: "))
            payment_method = input("Способ оплаты (например, Карта, Наличные): ")

            try:
                query = """
                    SELECT * FROM pay_for_service(%s, %s, %s, %s)
                """
                cur.execute(query, (patient_id, appointment_id, amount, payment_method))
                result = cur.fetchone()
                if result[0]:  # payment_id возвращен
                    print(f"Оплата успешна! ID платежа: {result[0]}")
                else:
                    print(f"Ошибка: {result[1]}")
            except Exception as e:
                print(f"Ошибка при оплате услуги: {e}")

    def update_patient_profile(self):
        with self.conn.cursor() as cur:
            print("\n=== Обновление профиля пациента ===")
            patient_id = int(input("ID пациента: "))
            first_name = input("Имя: ")
            last_name = input("Фамилия: ")
            address = input("Адрес: ")
            phone_number = input("Номер телефона: ")
            email = input("Email: ")
            password = input("Пароль: ")

            try:
                query = """
                    SELECT * FROM update_patient_profile(%s, %s, %s, %s, %s, %s, %s)
                """
                cur.execute(query, (patient_id, first_name, last_name, address, phone_number, email, password))
                result = cur.fetchone()
                if result[0]:  # patient_id возвращен
                    print(f"Профиль обновлен! ID пациента: {result[0]}")
                else:
                    print(f"Ошибка: {result[1]}")
            except Exception as e:
                print(f"Ошибка при обновлении профиля: {e}")

    def _input_non_empty(self, prompt):
        while True:
            value = input(prompt).strip()
            if value:
                return value
            print("Поле не может быть пустым!")

    def _input_date(self, prompt):
        while True:
            value = input(prompt).strip()
            try:
                return datetime.strptime(value, "%Y-%m-%d").date()
            except ValueError:
                print("Некорректный формат даты! Используйте ГГГГ-ММ-ДД.")

    def _input_date_time(self, prompt):
        while True:
            value = input(prompt).strip()
            try:
                return datetime.strptime(value, "%Y-%m-%d %H:%M")
            except ValueError:
                print("Некорректный формат! Используйте ГГГГ-ММ-ДД ЧЧ:ММ.")

    def _input_email(self, prompt):
        import re
        while True:
            email = input(prompt).strip()
            if re.match(r"^[\w\.-]+@[\w\.-]+\.\w+$", email):
                return email
            print("Некорректный формат email!")

    def display_patients(self):
        """Вывод таблицы пациентов с их записями на прием"""
        print("\n=== Список пациентов с записями на прием ===")
        try:
            with self.conn.cursor() as cur:
                # Выполним запрос с объединением таблиц Patients и Appointments
                cur.execute("""
                    SELECT p.id, p.first_name, p.last_name, p.email, p.phone_number, p.password, 
                           a.appointment_date, a.status 
                    FROM Patients p
                    LEFT JOIN Appointments a ON p.id = a.patient_id
                """)
                rows = cur.fetchall()

                # Создаем таблицу PrettyTable с новыми полями
                table = PrettyTable()
                table.field_names = ["ID", "Имя", "Фамилия", "Email", "Телефон", "Пароль", "Дата приема", "Статус"]

                # Добавляем строки в таблицу
                for row in rows:
                    table.add_row(row)

                print(table)
        except Exception as e:
            print(f"Ошибка: {e}")
